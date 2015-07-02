/* Author: Yunsup Lee, Andrew S. Waterman
 *         Parallel Computing Laboratory
 *         Electrical Engineering and Computer Sciences
 *         University of California, Berkeley
 *
 * Copyright (c) 2008, The Regents of the University of California.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the University of California, Berkeley nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS ''AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE REGENTS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <Functional/cache.h>
#include "appserver.h"
#include "tohost.h"
#include "perfctr.h"
#include <errno.h>
#include <string.h>
#include <assert.h>
#include <signal.h>
#include <unistd.h>
#include <Common/htif.h>
#include <Common/memif.h>
#include <Common/util.h>
#include <Common/elf.h>
#include <termios.h>
#include <signal.h>
#include <stdarg.h>
#include <sys/stat.h>

#include "htif_sparc_dma.h"
#include "htif_x86_dma.h"
#include <Functional/sim.h>

#include "CacheTag.h"
#include "decode.h"

#define debug(str,...) do { } while(0)
#ifdef DEBUG_MODE
  #undef debug
  #define debug printf
#endif

static bool do_mem = true;
mem_response_packet previous;
bool poll_delay;

void sigint_handler(int sig)
{
  // die gracefully, calling destructors
  exit(0);
}

void appserver_t::sig_handler(int signo)
{
  if (signo == SIGTSTP) {
    printf("received SIGSTP\n");
    printf("Starting memory loopback test!\n");
    do_mem = 1;
  }
}

appserver_t::appserver_t()
{
  seteuid(getuid());
  // register the signal handler
  if (signal(SIGTSTP, sig_handler) == SIG_ERR)
    printf("\ncan't catch SIGTSTP\n");

  htif = NULL;
  print_stats = false;
  do_exit = false;
  do_mem = true;
  poll_delay = false;
  exit_code = 0;
  noecho = 0;
  nsyscalls = 0;
  no_poll = 1;
  make_trace = 0;
  trace_start = 0;
  max_cycles = 0;
}

appserver_t::~appserver_t()
{
  int i;
  if(noecho)
  {
    tcsetattr(1,0,&old_termios);
    noecho = 0;
  }

  if(print_stats)
    stats();
  for(i = 0; i < nprocs; ++i)
  {
    delete L1DCaches[i];
    delete L1ICaches[i];
  }
  delete [] L1DCaches;
  delete [] L1ICaches;
  delete L2Cache;
}

void appserver_t::noecho_init()
{
  noecho = 1;

  tcgetattr(1,&old_termios);
  struct termios termios = old_termios;
  termios.c_lflag &= ~ECHO;
  termios.c_lflag &= ~ICANON;
  tcsetattr(1,0,&termios);
}

std::string appserver_t::get_filename(const char* fn, const char* path)
{
  if(strchr(fn,'/') != NULL || path == NULL)
    return fn;

  int len = strlen(fn);
  const char* end;

  do
  {
    end = strchr(path,':');
    if(end == NULL) end = path+strlen(path);

    char* new_fn = (char*)alloca(end-path+len+2);
    memcpy(new_fn,path,end-path);
    new_fn[end-path] = '/';
    memcpy(new_fn+(end-path)+1,fn,len+1);

    //printf(path);
    struct stat buf;
    if(stat(new_fn,&buf) == 0)
      return new_fn;
  }
  while((path = strchr(path,':')) && ++path);

  return fn;
}

void appserver_t::configure_cache(const std::string& name, uint32_t* buf, int max_tags, int max_assoc, int min_offset_bits, int max_offset_bits, int max_banks, int cacheprivate)
{
  int cachesize = properties.get_int((name+".size").c_str());
  int linesize = properties.get_int((name+".linesize").c_str());
  int assoc = properties.get_int((name+".assoc").c_str());
  int access_time = properties.get_int((name+".access_time").c_str());
  int banks = properties.get_int((name+".banks").c_str());

  // cachesize is really the size of each cache bank.
  assert(ispow2(cachesize) && ispow2(linesize) && ispow2(assoc));
  assert(banks <= max_banks && ispow2(banks));
  cachesize /= banks;

  // num_caches is the number of private caches that this cache represents
  int num_caches = cacheprivate ? nprocs : 1;

  int num_sets = cachesize/linesize;
  int num_ways = num_sets/assoc;
  int max_sets = max_tags/assoc;
  max_tags /= max_banks;

  assert(num_ways*num_caches <= max_tags);
  assert(assoc <= max_assoc && assoc <= num_sets);
  assert(min_offset_bits <= log2i(linesize) && log2i(linesize) <= max_offset_bits);

  int target_index_mask = num_ways-1;

  int offset_bits = log2i(linesize);
  int tag_mask = ~(linesize-1);
  int tag_ram_index_mask = (max_tags/max_assoc/num_caches-1) & target_index_mask;
  int bank_mux = bit_reverse(assoc-1,log2i(max_assoc));
  int bank_shift = log2i(max_tags/max_assoc/num_caches);

  #if DEBUG_LEVEL > 0

  printf("  CACHE %s\n",name.c_str());
  printf("------------------------\n");
  printf("SIZE          %10d\n",cachesize);
  printf("ASSOCIATIVITY %10d\n",assoc);
  printf("LINE SIZE     %10d\n",linesize);
  printf("ACCESS TIME   %10d\n",access_time);
  printf("OFFSET BITS   %10d\n",offset_bits);
  printf("TAG MASK      %10x\n",tag_mask);
  printf("TAG RAM MASK  %10x\n",tag_ram_index_mask);
  printf("INDEX MASK    %10x\n",target_index_mask);
  printf("BANK MUX      %10x\n",bank_mux);
  printf("BANK SHIFT    %10x\n",bank_shift);
  printf("\n");

  #endif

  buf[0] = log2i(banks);
  buf[1] = offset_bits-min_offset_bits;
  buf[2] = tag_mask;
  buf[3] = target_index_mask;
  buf[4] = tag_ram_index_mask;
  buf[5] = bank_mux;
  buf[6] = bank_shift;
  buf[7] = access_time;
}

void appserver_t::configure_timing_model()
{
  nprocs = roundup_pow2(nprocs);

  uint32_t buf[128];
  memset(buf,0,sizeof(buf));
  // L1d and L1i are private
  configure_cache("l1d",&buf[0],simple_cache_t::L1D_MAX_TAGS,simple_cache_t::L1D_MAX_ASSOC,simple_cache_t::L1D_MIN_OFFSET_BITS,simple_cache_t::L1D_MAX_OFFSET_BITS,1,1);
  configure_cache("l1i",&buf[8],simple_cache_t::L1I_MAX_TAGS,simple_cache_t::L1I_MAX_ASSOC,simple_cache_t::L1I_MIN_OFFSET_BITS,simple_cache_t::L1I_MAX_OFFSET_BITS,1,1);
  // L2 is shared
  configure_cache("l2",&buf[16],simple_cache_t::L2_MAX_TAGS,simple_cache_t::L2_MAX_ASSOC,simple_cache_t::L2_MIN_OFFSET_BITS,simple_cache_t::L2_MAX_OFFSET_BITS,simple_cache_t::L2_MAX_NUM_BANKS,0);

  buf[24] = properties.get_int("dram.access_time");
  buf[25] = properties.get_int("dram.cycle_time");
  buf[26] = properties.get_int("gsf.cycles_per_frame");

  // initial GSF credits
  for(int i = 0; i < simple_cache_t::MAX_PARTITIONS; i++)
    buf[32+i] = buf[26];

  // initial partition IDs
  for(int i = 0; i < simple_cache_t::MAX_CORES; i++)
    buf[64+i] = 0;

  for(int i = 0; i < sizeof(buf)/sizeof(uint32_t); i++)
    buf[i] = htobe32(buf[i]);
  
  if(properties.get_int("appserver.hysim"))
    configure_host_timing_model(buf);
  else
    htif->lmem().write(0,sizeof(buf),(uint8_t*)buf,2);
}

void appserver_t::configure_host_timing_model(uint32_t* buf)
{
	// Assume that L1d and L1i are private, L2 cache shared
	int i, cachesize, linesize, assoc, access_time, sets;
	printf("Configuring host side timing model...\n");
	cachesize = properties.get_int("l2.size");
  	linesize = properties.get_int("l2.linesize");
  	assoc = properties.get_int("l2.assoc");
  	access_time = properties.get_int("l2.access_time");
  	sets = cachesize / (linesize * assoc);
  	printf("Create host side L2 Cache model with linesize = %d, #ways = %d, #sets = %d, access_time = %d\n", linesize, assoc, sets, access_time);
  	L2Cache = new CCacheTag(linesize, assoc, sets);
  	L2Cache->MissDelay(access_time);
  	
	L1DCaches = new CCacheTag* [nprocs];
	cachesize = properties.get_int("l1d.size");
  	linesize = properties.get_int("l1d.linesize");
  	assoc = properties.get_int("l1d.assoc");
  	access_time = properties.get_int("l1d.access_time");
  	sets = cachesize / (linesize * assoc);
	for(i = 0; i < nprocs; ++i)
	{
		printf("Create host side L1D Cache %d model with linesize = %d, #ways = %d, #sets = %d, access_time = %d\n", i, linesize, assoc, sets, access_time);
		L1DCaches[i] = new CCacheTag(linesize, assoc, sets);
		L1DCaches[i]->MissDelay(access_time);
		L1DCaches[i]->SetNextLevel(*L2Cache);
	}
	
	L1ICaches = new CCacheTag* [nprocs];
	cachesize = properties.get_int("l1i.size");
  	linesize = properties.get_int("l1i.linesize");
  	assoc = properties.get_int("l1i.assoc");
  	access_time = properties.get_int("l1i.access_time");
  	sets = cachesize / (linesize * assoc);
	for(i = 0; i < nprocs; ++i)
	{
		printf("Create host side L1I Cache %d model with linesize = %d, #ways = %d, #sets = %d, access_time = %d\n", i, linesize, assoc, sets, access_time);
		L1ICaches[i] = new CCacheTag(linesize, assoc, sets);
		L1ICaches[i]->MissDelay(access_time);
		L1ICaches[i]->SetNextLevel(*L2Cache);
	}
}

void appserver_t::set_htif(htif_t* foo)
{
  htif = foo;
}

void appserver_t::make_htif(const char* s)
{
  if(!strcmp(s,"hw"))
    set_htif(new htif_sparchw_dma_t(properties));
  else if(!strcmp(s,"vs"))
    set_htif(new htif_sparcvs_dma_t(properties));
  else if(!strcmp(s,"fs"))
  {
    sim_t* sim = new sim_t;
    sim->trace = make_trace;
    sim->trace_start = trace_start;
    set_htif(sim);
  }
  else if(!strcmp(s,"x86"))
    set_htif(new htif_x86_dma_t(properties));
  else
    throw std::runtime_error("Unknown HTIF! Use [hw,vs,fs]");
}

void usage()
{
  printf("Usage: appserver [-f<conf>] [-p<nprocs>] [-s] <htif> <kernel> [binary] [args]\n");
}

int appserver_t::load_program(int argc, char* argv[], char* envp[])
{
    const char* path = NULL;
    for(char** p = envp; *p; p++)
    {
        if(strncmp(*p,"PATH=",5) == 0)
        {
            path = *p+5;
            break;
        }
    }

    nprocs = 1;
    const char* configfile = "appserver.conf";
    const char* eth_if = NULL;
    int nargs = parse_args(argc,argv,"pdfstdudsbiscl",&nprocs,&configfile,&make_trace,&trace_start,&print_stats,&eth_if,&max_cycles);
    argc -= nargs; argv += nargs;

    if(properties.read_file(get_filename(configfile,path).c_str()) < 0)
      throw std::runtime_error(std::string("Could not open properties file ")+configfile+"!");
    properties.read_file(get_filename("appserver.conf.local",path).c_str());

    if(eth_if != NULL)
      properties.set_string("htif_sparchw_dma.eth_if",eth_if);

    if(argc < 4)
    {
      usage();
      return -1;
    }
    if(htif == NULL)
      make_htif(argv[1]);
   
    htif->set_memsize(properties.get_int("dram.size"));
    htif->set_num_cores(nprocs);
    debug("board reset...\n");
    htif->set_reset(1);
    htif->set_reset(0);

    if(properties.get_int("appserver.noecho"))
        noecho_init();
    debug("configuring timing model...\n");
    configure_timing_model();

    if(strcmp(argv[2],"memtest") == 0)
    {
      memtest();
      return 0;
    }

    if(strcmp(argv[2],"none") != 0)
    {
      memimage_t kernel_memimage(properties.get_int("ipl.kernel_offset"));
      memimage_t user_memimage(properties.get_int("ipl.user_offset"));
      std::map<std::string,vaddr> kernel_symtab;
      int ksize,usize;
      uint8_t* kbytes,*ubytes;
      vaddr uentry;

      if(readfile(get_filename(argv[2],path).c_str(),(char**)&kbytes,&ksize))
      {
        warn("Couldn't open kernel image %s!\n",argv[2]);
        return -1;
      }
      load_elf(kbytes,ksize,htif->big_endian(),&kernel_memimage,properties.get_int("ipl.zero_kernel_bss"),NULL,&kernel_symtab);
      free(kbytes); kbytes = 0;

      if(strcmp(argv[3],"none") != 0)
      {
        if(readfile(get_filename(argv[3],path).c_str(),(char**)&ubytes,&usize))
        {
          warn("Couldn't open user image %s!\n",argv[3]);
          return -1;
        }
        load_elf(ubytes,usize,htif->big_endian(),&user_memimage,true,&uentry);
        uentry += properties.get_int("ipl.user_offset");
        free(ubytes); ubytes = 0;

        if(kernel_symtab.count("user_entryp") == 0)
          warn("I don't know where to write the user-code entry point!");
        else
        {
          uint32_t foo = htif->htotl(uentry);
          kernel_memimage.write(kernel_symtab["user_entryp"],4,(uint8_t*)&foo);
        }
      }

      if(kernel_symtab.count("__args"))
      {
        uint8_t args[ARGS_SIZE+8];
        int args_size = pack_argc_argv(args+8,0,argc-3,argv+3);
        *(uint32_t*)args = htif->htotl(args_size);
        kernel_memimage.write(kernel_symtab["__args"],args_size+8,args);
      }

      if(kernel_symtab.count("magic_mem") == 0)
      {
        warn("I don't know the magic memory address!");
        htif->set_magicmemaddr(0);
      }
      else
      {
        no_poll = 0;
        htif->set_magicmemaddr(kernel_symtab["magic_mem"]+properties.get_int("ipl.kernel_offset"));
      }

      kernel_memimage.copy_to_memif(htif->lmem());
      user_memimage.copy_to_memif(htif->lmem());

      if(properties.get_int("ipl.verify"))
      {
        kernel_memimage.check_memif(htif->lmem());
        user_memimage.check_memif(htif->lmem());
      }
    }

    syscall_init();

    if(print_stats)
      stats();

    signal(SIGINT,sigint_handler);
    signal(SIGABRT,sigint_handler);

    return 0;
}

void appserver_t::stats()
{
  int use_host_counters = properties.get_int("appserver.host_counters");
  int global_stats_only = properties.get_int("appserver.global_stats_only");

  const char** global_counters = use_host_counters ? host_global_counters : target_global_counters;
  int num_global_counters = (use_host_counters ? sizeof(host_global_counters) : sizeof(target_global_counters))/sizeof(char*);
  int num_per_proc_counters = sizeof(per_proc_counters)/sizeof(char*);

  struct timeval t;
  gettimeofday(&t,0);
  double wall_time = (t.tv_sec-t0.tv_sec)+(t.tv_usec-t0.tv_usec)/1e6;

  static bool silent = true;
  if(!silent)
    printf("wall time: %.2f s\n",wall_time);

  int counters_per_proc = PERFCTR_CORE_ADDR_OFFSET/sizeof(uint64_t);
  static uint64_t* counters = 0, *counters2 = 0;
  // at the first time of the function call:
  if(counters == 0)
  {
    counters = new uint64_t[nprocs*counters_per_proc];
    counters2 = new uint64_t[nprocs*counters_per_proc];
    memset(counters2,0,nprocs*PERFCTR_CORE_ADDR_OFFSET);
  }

  memcpy(counters,counters2,nprocs*PERFCTR_CORE_ADDR_OFFSET);
  // memif_t::read(uint32_t addr, uint32_t len, uint8_t* bytes, uint8_t asi)
  // ASI = 2 --> statistics memory
  htif->lmem().read(0,nprocs*PERFCTR_CORE_ADDR_OFFSET,(uint8_t*)counters2,2);

  if(silent)
  {
    silent = false;
    return;
  }
  // new value - last (initial) value
  #define READ_COUNTER(i) (be64toh(counters2[(i)])-be64toh(counters[(i)]))

  long long total_insn = 0;
  if(!use_host_counters) for(int p = 0; p < nprocs; p++) 
  {
    if(!global_stats_only)
      printf("\ncore %d\n",p);
    for(int i = 0; i < num_per_proc_counters; i++)
    {
      if(!global_stats_only)
        printf("  %s: %lld\n",per_proc_counters[i],READ_COUNTER(i+num_global_counters+p*counters_per_proc));
      if(!strcmp(per_proc_counters[i],"instructions retired"))
        total_insn += READ_COUNTER(i+num_global_counters+p*counters_per_proc);
    }
  }

  for(int i = 0; i < num_global_counters; i++)
    if(use_host_counters || strncmp(global_counters[i],"host ",5) != 0)
      printf("%s: %lld\n",global_counters[i],READ_COUNTER(i));

  if(use_host_counters)
  {
    printf("Aggregate simulator MIPS: %.3f\n",READ_COUNTER(4)/(wall_time*1e6));
    return;
  }

  printf("Number of system calls: %d\n",nsyscalls);
  printf("Aggregate simulator MIPS: %.3f\n",total_insn/(wall_time*1e6));

  fflush(stdout);
}

int appserver_t::poll_once(int tohost)
{
  uint8_t magicmem[40];

  for(int i = 0, tries = 10; ; i++)
  {
    try
    {
      // magic memory contains current IO status
      htif->lmem().read(htif->get_magicmemaddr(),sizeof(magicmem),magicmem);
      break;
    }
    catch(illegal_packet_exception& e)
    {
      if(i == tries-1)
        throw e;
    }
  }
  bool poll_delay_bool;
  if (poll_delay_bool) 
  {
     return tohost;
  }

  if(noecho)
  {
    if(magicmem[35] != 0)
    {
      //printf("magic_mem part\n");
      // putchar() in Akaros
      if(write(1,magicmem+35,1) == 1)
      {
        magicmem[35] = 0;
        // write response
        htif->lmem().write(htif->get_magicmemaddr()+32,4,magicmem+32);
      }
    }
    if(magicmem[39] == 0 && kbhit())
    {
      magicmem[39] = getchar();
      // getchar() in Akaros
      if(magicmem[39] == 0x7F)
        magicmem[39] = 0x08;
      htif->lmem().write(htif->get_magicmemaddr()+36,4,magicmem+36);
    }
  }

  int new_tohost = htif->htotl(*(uint32_t*)magicmem);
  if(new_tohost == tohost)
    return tohost;
  // there are syscall to proceed!
  tohost = new_tohost;

  switch (tohost)
  {
    case TOHOST_SYSREQ:
      syscall((uint8_t*)magicmem);
      // after syscall, fromhost == 1 and tohost == 0
      tohost = 0;
      break;

    case TOHOST_FAIL:
      exit_code = tohost;
      printf("fail (code %d)",tohost);
      do_exit = 1;
      break;

    case TOHOST_OK:
      exit_code = 0;
      do_exit = 1;
      break;

    default:
      printf("Unknown tohost value %X!\n",tohost);
      exit_code = -1;
      do_exit = 1;
      break;
  }

  return tohost;
}

std::string appserver_t::parse_memory_transaction(const uint8_t* payload)
{
	if(payload[3] & 0x10) // Valid bit
	{
		unsigned int tid1 = payload[3] >> 5;
		char tid_char [200];//define new char* to hold TID
                char mem_addr_str [132];
		char inst_addr_str [100];
		//char* result = new char[200];
		//result = std::string(" ");
		//char result [200] = " ";
		unsigned int tid = ((unsigned int)(payload[2]));// << 3);
		tid = (tid << 3) | tid1;
		//printf("%d:tid:%X\n",__LINE__, tid); 
		tid |= (((unsigned int)(payload[1])) << 11);//11);
		//printf("%d:tid:%X\n",__LINE__, tid);
		tid |= (((unsigned int)(payload[0])) << 19);//19);
		//printf("%d:tid:%X\n",__LINE__, tid);
		//tid |= (tid1 << 24);
		//printf("%d:tid:%X\n",__LINE__, tid);
	   	itoa(tid,tid_char,10);
		strcat(tid_char," ");//space delimiter
		//printf("%d:tid_char:%s\n",__LINE__, tid_char);
		// tid >>= 3;
		unsigned int flag = be32toh(*(unsigned int *)(payload));
		unsigned int mem_addr = be32toh(*(unsigned int *)(payload+8));
		unsigned int inst_addr = be32toh(*(unsigned int *)(payload+12));
		unsigned int opcode = (*(unsigned int *)(payload+4));//be32toh(*(unsigned int *)(payload+4));//(*(unsigned int *)(payload+4));
		printf("Core %02d FLAG %08x OP %08x MEM %08x at %08x \n", tid, flag, opcode, mem_addr, inst_addr);
		char* dec = decodeInstruction((char *)&opcode, inst_addr - 4);
		//printf("%s", dec);
                itoa(mem_addr, mem_addr_str,10);
		//printf("mem_addr:%s\n", mem_addr_str);
		strcat(mem_addr_str, " ");
		itoa(inst_addr,inst_addr_str,10);
                strcat(mem_addr_str,inst_addr_str);
		strcat(mem_addr_str, " ");
                strcat(mem_addr_str,dec);
		//printf("%s\n", mem_addr_str);
		//strcat(tid_char, " ");
                strcat(tid_char,mem_addr_str);//combine the 2
		//strcat(result,tid_char);
		//result.insert(result.end(),std::string(tid_char));
		free(dec);
		return tid_char;//result;
		//printf("%d:tid_char:%s\n",__LINE__, tid_char);
	}
	else
	{
		printf("Invalid packet received.\n");
		return " ";
	}
}



void appserver_t::initialize_stalls(int* stall_ctr) //set stall ctr initial values to 0 - all can run
{
  for (int i = 0; i<nprocs; i++)
	stall_ctr[i] = 0;	
}

int appserver_t::run()
{
  int poll_delay = 0;
  int tohost = 0;
  int first_mem = 1;
  int replay = 0;
  int stall_ctr[128];
  uint8_t *tid_ptr=0;
  uint8_t *recv_tid[1] = {0};
  
  std::string opcode;
  initialize_stalls(stall_ctr);
  //printf("past stall init\n");
  uint8_t recv_new[RAMP_MEM_PACKET_LEN] = {0};  //#define RAMP_MEM_PACKET_LEN 16
  uint8_t recv_old[RAMP_MEM_PACKET_LEN] = {0};
  uint16_t recv_len = 0;
  htif->set_run(1);
  //printf("set_run successfully.\n");
  while(!do_exit)
  {
    //printf("loop.\n");
    if(!do_mem)
    {
    	htif->run_for_a_while();
    }
    else
    {
      if(first_mem) //first memory access
      {
	printf("first_mem\n");
        // recv_len = ((memif_sparc_dma_t*)(&htif->lmem()))->start_memory_transactions(recv_new);
        // for the host side timing model, the first packet is a normal MEM packet with TID 0, run 1, valid 1, running 1
        mem_response_packet p = {0}; // this will be sent as 00 00 00 07
	p.tid = 0;//tid;
        p.valid = 1;
        p.run = 1;
        p.running = 1;
	//previous = p;
	*((uint32_t*)recv_new) = htonl(p.payload);
        recv_len = ((memif_sparc_dma_t*)(&htif->lmem()))->send_memory_transactions(recv_new, recv_new, RAMP_MEM_RESPONSE_LEN, RAMP_MEM_PACKET_LEN); //send pkt and recv_new = new rx
	previous.payload = p.payload;
        first_mem = 0; //sent the first mem pkt
      }
      else if(!(((recv_new[3] & 0x8)&&(recv_new[3] & 0x4))|| ((recv_new[3] & 0x10)&&(recv_new[3] & 0x8)&&(recv_new[3] & 0x2)))) //poll for new mem req, !0xc or 0x1a
      {
	//replay++;
	//printf("poll mem\n");
	mem_response_packet pa;
	previous.valid = 0;
	pa.payload = previous.payload;
	printf("previous mem:%X\n",previous.payload);
	*((uint32_t*)recv_new) = htonl(pa.payload);
	printf("previous mem_mid:%X\n",previous.payload);
	recv_len = ((memif_sparc_dma_t*)(&htif->lmem()))->send_memory_transactions(recv_new, recv_new, RAMP_MEM_RESPONSE_LEN, RAMP_MEM_PACKET_LEN); //send pkt and recv_new = new rx
	printf("previous mem2:%X\n",previous.payload);
      }
      else if ((recv_new[3] & 0x8) && (recv_new[3] & 0x4)) //replay  0xc
      {
	printf("replay\n");
	mem_response_packet p = {0};
	p.tid = previous.tid;//tid;
        p.valid = 1;
        p.run = 1;
        p.running = 1;
	
        memcpy(recv_old, recv_new, RAMP_MEM_PACKET_LEN); //store the previous rx into recv_old
        *((uint32_t*)recv_new) = htonl(p.payload);

        recv_len = ((memif_sparc_dma_t*)(&htif->lmem()))->send_memory_transactions(recv_new, recv_new, RAMP_MEM_RESPONSE_LEN, RAMP_MEM_PACKET_LEN); //send recv_new and rx into recv_new
	printf("%d:recv_new[3]:%X\n",__LINE__, recv_new[3]); 	
	previous.payload = p.payload;
	
      }
      // loopback test
      int dup_counter = 0;
      //printf("before while\n");
      //printf("nprocs: %i\n",nprocs);
      if((recv_new[3] & 0x10) && (recv_new[3] & 0x8) && (recv_new[3] & 0x2))//valid message received 0x1a
      {
	//printf("valid\n");
        no_poll = 0;
	replay = 0;
	//printf("%d:recv_new[3]:%X\n",__LINE__, recv_new[3]); 
	fflush(stdout); 
	//printf("%d:recv_new[0]:%X\n",__LINE__, recv_new[0]);
	//printf("%d:recv_new[1]:%X\n",__LINE__, recv_new[1]);
	//printf("%d:recv_new[2]:%X\n",__LINE__, recv_new[2]);
        std::string parsed_instruction = parse_memory_transaction(recv_new);//change to parse apart
	//printf("instr return:%s\n",parsed_instruction.c_str());
	//char* temp = strtok(parsed_instruction, " ");
	//printf("strtok res:%s\n",temp);

	size_t found = parsed_instruction.find(" ");
	//size_t next = parsed_instruction.find(" ",found+1);
        //int tid = atoi(strtok(parsed_instruction, " "));//TID is first value
	//int tid = atoi(parsed_instruction.substr(found+1, next-found-1).c_str());
	int tid = atoi(parsed_instruction.substr(0, found).c_str());
	parsed_instruction = parsed_instruction.substr(found+1);
	//printf("parsed2:%s\n",parsed_instruction.c_str());
	//printf("got TID:%i\n",tid);
	fflush(stdout);

	found = parsed_instruction.find(" ");
	//char* temp = strtok(NULL, " ");
	//char* temp2 = strtok(NULL, " ");
	//printf("strtok res:%s  %s\n",temp, temp2);
  	int mem_addr = atoi(parsed_instruction.substr(0,found).c_str());
	parsed_instruction = parsed_instruction.substr(found+1);
	//printf("parsed3:%s\n",parsed_instruction.c_str());
	//printf("got mem_addr:%i\n",mem_addr);
        //char* opcode = strtok(NULL, " "); //need to scan opcode string to determine if mem_addr is valid

	found = parsed_instruction.find(" ");
	int address = atoi(parsed_instruction.substr(0,found).c_str());
	parsed_instruction = parsed_instruction.substr(found+1);
	//printf("parsed4:%s\n",parsed_instruction.c_str());
	//printf("got instr_addr:%i\n",address);

	found = parsed_instruction.find(" ");
	opcode = parsed_instruction.substr(0,found);
	parsed_instruction = parsed_instruction.substr(found+1);
	//printf("parsed5:%s\n",parsed_instruction.c_str());
	//printf("parsed instr: %s\n", opcode.c_str());
        //if(memcmp(recv_old, recv_new, RAMP_MEM_PACKET_LEN) || dup_counter > 50)
        if(1)
        {
          /**
          mem_response_packet p = {0};
	  int stall_cycles = stall_ctr[tid];
          if (stall_cycles <= 0) //-1 means it is the first time seeing the next instruction, 0 means I saw the instruction and AT is 0 (or stalled to that)
	  {
	      //advance to next instruction if stall_cycles = 0
	      if (stall_cycles == 0)
	      {
		  p.tid = tid;
		  p.valid = 1;
		  p.run = 1;
		  p.running =  1;
		  stall_ctr[tid] = -1; //to the next instruction for parsing
              }
              else //do access analysis and update stall_ctr if stall_cycles = -1
              {
		  int instr_delay = L1ICaches[tid]->Access(address); //instruction delay
	          int mem_delay = 0;
		  if (opcode.find("ld") != string::npos|| opcode.find("st") != string::npos|| opcode.find("swap")!= string::npos)
                      mem_delay = L1DCache[tid]->Access(mem_addr); //mem delay
		  int new_stall_cycles = max(instr_delay,mem_delay);
		  stall_ctr[tid] = new_stall_cycles - 1; //add new stall cycle counter value
		  if (new_stall_cycles == 0)
		  {
		      //send run packet and continue
		      p.tid = tid;
		      p.valid = 1;
		      p.run = 1;
		      p.running =  1;
		  }
		  else
		  {
		      //send don't run packet and continue
		      p.tid = tid;
		      p.valid = 1;
		      p.run = 0;
		      p.running =  1;
		  }
              } 
          }
          else
	  {
	      stall_ctr[tid] = stall_cycles-1;
              p.tid = tid;
              p.valid = 1;
              p.run = 0;
	      p.running = 1;
          }

	  //still need TODO perf counters
          **/
          // it is a different packet
	  //printf("TID in: %i\n", tid);
	  fflush(stdout);
          mem_response_packet p = {0};
	  /**if (tid > nprocs)
		{tid = 0;}
	  else
		{tid++;}
	  printf("TID out: %i\n", tid);**/

	  if(tid<nprocs-1)
	  	p.tid = tid+1;//tid;
	  else p.tid = 0;
	  //printf("TID next: %i\n", p.tid);


          //p.tid = 0;//tid;
          p.valid = 1;
          p.run = 1;
          p.running = 1;
	  
          memcpy(recv_old, recv_new, RAMP_MEM_PACKET_LEN); //store the previous rx into recv_old
          *((uint32_t*)recv_new) = htonl(p.payload);
	  //printf("mem_out:%X\n",p.payload);

          recv_len = ((memif_sparc_dma_t*)(&htif->lmem()))->send_memory_transactions(recv_new, recv_new, RAMP_MEM_RESPONSE_LEN, RAMP_MEM_PACKET_LEN); //send recv_new and rx into recv_new
	  previous.payload = p.payload;
	  
	  //tid_ptr=&recv_new[1];
	  //memcpy(recv_tid,tid_ptr,7);
          dup_counter = 0;
	  //printf("%d:recv_new[3]:%X\n",__LINE__, recv_new[3]);
	  //printf("%d:recvlen:%d\n",__LINE__, recv_len);  
	  //printf("%d\n",*recv_tid);
	  fflush(stdout);
	  
        }
        else
        {
          // it is the same as the old one. Just read.
          recv_len = ((memif_sparc_dma_t*)(&htif->lmem()))->start_memory_transactions(recv_new);
          printf(" (dup) ");
          ++dup_counter;
        }
        //putchar('\n');
	printf("%d:recv_new[3]:%X\n",__LINE__, recv_new[3]); 
	fflush(stdout);
      } //end while recv_new[3]
    } //end if do mem

    /**printf("%d:recv_new[3]:%X\n",__LINE__, recv_new[3]);
    printf("%d:recv_new[4]:%X\n",__LINE__, recv_new[4]);
    printf("%d:recv_new[5]:%X\n",__LINE__, recv_new[5]);    
    printf("%d:recv_new[6]:%X\n",__LINE__, recv_new[6]);
    fflush(stdout);**/
    if ((recv_new[3] & 0x8) && (recv_new[3] & 0x4))  //0xc
    {
	no_poll = 1;
    }
    if(!no_poll&&opcode.find("sethi")!=0)//&(poll_delay>3))
    {
      //printf("poll\n");
      tohost = poll_once(tohost);
      poll_delay = 0;
    }
    /**else
    {
      poll_delay++;
    }**/
    if(max_cycles && htif->get_cycle() > max_cycles)
    {
    
      do_exit = true;
      exit_code = 0;
    }
    //poll_delay++;
  }

  return exit_code;
}
