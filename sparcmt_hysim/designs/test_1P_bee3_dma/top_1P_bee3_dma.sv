//-------------------------------------------------------------------------------------------------  
// File:        top_1P_bee3_dma.sv
// Author:      Zhangxi Tan 
// Description: Top level design for one pipeline and BEE3 dram controller 
//-------------------------------------------------------------------------------------------------

`timescale 1ns / 1ps

`ifndef SYNP94
import libconf::*;
import libiu::*;
import libxalu::*;
import libmmu::*;
import libcache::*;
import libmemif::*;
import libio::*;
import libdebug::*;
import libtm::*;
import libtech::*;
`else
`include "../../lib/cpu/libiu.sv"
`include "../../lib/cpu/libmmu.sv"
`include "../../lib/cpu/libcache.sv"
`include "../../lib/cpu/libxalu.sv"
`include "../../lib/mem/libmemif.sv"
`include "../../lib/io/libio.sv"
`include "../../lib/tm/libtm.sv"
`endif



module flight_recorder #(parameter DWIDTH=72) (input bit clk, input bit rst, 				
						 input bit  [DWIDTH-1:0] din, 
						 output bit [DWIDTH-1:0] dout) /* synthesis syn_hier="hard" */;

	bit 						start_read;
	bit [DWIDTH/36 :0]			full;
	bit [(DWIDTH/36+1)*36-1 :0]	din_fx, dout_fx;
	
	always_comb begin
		din_fx = '0;
		din_fx[DWIDTH-1:0] = din;
		dout = dout_fx[DWIDTH-1:0];
	end
	
	always_ff @(posedge clk) begin
		if (rst)
			start_read <= '0;
		else 			
			start_read <= (start_read == 0) ? full[0] : '1; 
	end
	
	generate 
		genvar i;
		
		for (i=0;i<DWIDTH/36 + 1;i++) begin
		    	FIFO36 #(
		    .ALMOST_FULL_OFFSET(1022),
		    .DATA_WIDTH(36),
    		.DO_REG(1),
	    	.EN_SYN("TRUE"),
    		.FIRST_WORD_FALL_THROUGH("FALSE")
	    ) fr_fifo (
		    .ALMOSTEMPTY(),
    		.ALMOSTFULL(full[i]),
	    	.DO(dout_fx[i*36 +: 32]),
	    	.DOP(dout_fx[i*36+32 +: 4]),
		    .EMPTY(),
    		.FULL(),
		    .RDCOUNT(),
    		.RDERR(),
	    	.WRCOUNT(),
	    	.WRERR(),
		    .DI(din_fx[i*36 +: 32]),
    		.DIP(din_fx[i*36+32 +: 4]),
		    .RDCLK(clk),
    		.RDEN(start_read),
		    .RST(rst),
    		.WRCLK(clk),
	    	.WREN(~rst)
    	);			
		end		
	endgenerate
	
endmodule

module fpga_top(input bit clkin_p, input bit clkin_n, input bit rstin, input bit cpurst, //output bit done_led, output bit error_led,
  //rs232 signals
  input 		bit     RxD,
  output		bit     TxD,
  //SODIMM signals
  inout  [63:0]              ddr2_dq,
  output [13:0]              ddr2_a,
  output [2:0]               ddr2_ba,
  output                     ddr2_ras_n,
  output                     ddr2_cas_n,
  output                     ddr2_we_n,
  output [1:0]               ddr2_cs_n,
  output [1:0]               ddr2_odt,
  output [1:0]               ddr2_cke,
  output [7:0]               ddr2_dm,
  inout  [7:0]               ddr2_dqs,
  inout  [7:0]               ddr2_dqs_n,
  output [1:0]               ddr2_ck,
  output [1:0]               ddr2_ck_n,
  // Error LEDs
  output bit error1_led,
  output bit error2_led,
  //Ethernet signals
  output bit [7:0] PHY_TXD,
  output bit PHY_TXEN,
  output bit PHY_TXER,
  output bit PHY_GTXCLK,
  input bit [7:0] PHY_RXD,
  input bit PHY_RXDV,
  input bit PHY_RXER,
  input bit PHY_RXCLK,
  input bit PHY_TXCLK,
  input bit PHY_COL,
  input bit PHY_CRS,
  output bit PHY_RESET 
);
	iu_clk_type	gclk;            //global clock and clock enable
	bit		       rst;             //reset
	
//	io_bus_out_type	io_in;

  //dma buffer master interface
  debug_dma_read_buffer_in_type   eth_rb_in;
  debug_dma_write_buffer_in_type  eth_wb_in;		//no use currently
  debug_dma_write_buffer_out_type eth_wb_out;		//no use currently				

	//dma buffer slave interface
  debug_dma_read_buffer_in_type   dma_rb_in;
  debug_dma_read_buffer_out_type  dma_rb_out;
  debug_dma_write_buffer_in_type  dma_wb_in;

	//dma command interface 
  debug_dma_cmdif_in_type         dma_cmd_in;     //cmd input 
  bit                             dma_cmd_ack;    //cmd has been accepted
	//dma status from IU
  bit                             dma_done;
  
  //dma timing model interface
  dma_tm_ctrl_type                dma2tm;
  
  //ethernet
  bit eth_tx_clk, eth_rx_clk;
  bit eth_reset, cpu_reset;
  bit clk_p;  
  
  //dram clk related signals
  dram_clk_type                   ram_clk;
  bit                             dramrst;

  //memory controller interface
  mem_controller_interface        mcif(gclk);
  
  assign cpu_reset = eth_reset | cpurst;

//	assign io_in = '{default:0};
	
	//------------------generate clock and reset---------------------- 
	
	clk_inb #(.differential(0)) gen_clkin (.clk_p(clkin_p), .clk_n(clkin_n),.clk(clk_p));
	
	clkrst_gen_2 #(.differential(0), .IMPL_IBUFG(0), .BOARDSEL(0), .nocebuf(1))	gen_gclk_rst(.*, .rstin(~rstin), .dramrst(~dramrst), .clkin_p(clk_p), .cpurst(cpu_reset), .clkin_b());


	//generate cpu 
	cpu_top_dma		gen_cpu(.gclk, .rst, 
//				.io_in,
//				.io_out(),
				.luterr(),
				.bramerr(),
				.sb_ecc(),
    				.dma_rb_in,
    				.dma_rb_out,
				.dma_wb_in,
  				.dma_cmd_in,     //cmd input 
				.dma_cmd_ack,    //cmd has been accepted
    				.dma_done,
      		.dma2tm,
      		.mcif,
     		.error1_led,
      		.error2_led
				);

  dramctrl_bee3_ml505 gen_bee3mem(
                         .ram_clk,   //dram clock
                         .user_if(mcif),
                         //Signals to SODIMM
                  	      .DQ(ddr2_dq), 	//the 64 DQ pins
                			      .DQS(ddr2_dqs),	//the 8  DQS pins
                 		      .DQS_L(ddr2_dqs_n),
                			      .DIMMCK(ddr2_ck),  //differential clock to the DIMM
                  	      .DIMMCKL(ddr2_ck_n),
                			      .A(ddr2_a), 	//addresses to DIMMs
                			      .BA(ddr2_ba), 	//bank address to DIMMs
                			      .RAS(ddr2_ras_n),
                			      .CAS(ddr2_cas_n),
                			      .WE(ddr2_we_n),
                			      .ODT(ddr2_odt),
                			      .ClkEn(ddr2_cke), //common clock enable for both DIMMs. SSTL1_8
                			      .RS(ddr2_cs_n),
                			      .DM(ddr2_dm),
 
                			      .TxD(TxD),                //RS232 transmit data
                			      .RxD(RxD),                //RS232 received data
                			      .SingleError(),       	//Unconnected right now
                			      .DoubleError()         	//Double errors

			 );	

  	eth_dma_master 		gen_eth_dma_master(.gclk, .clkin(clk_p), .rst, .rstin(~rstin), .rstout(eth_reset),
				.PHY_TXD,
				.PHY_TXEN,
				.PHY_TXER,
				.PHY_GTXCLK,
				.PHY_RXD,
				.PHY_RXDV,
				.PHY_RXER,
				.PHY_RXCLK,
				.PHY_TXCLK,
				.PHY_COL,
				.PHY_CRS,
				.PHY_RESET,
				.eth_txclk(eth_tx_clk),
				.eth_rxclk(eth_rx_clk),
				.eth_rb_in,
				.eth_wb_in,
				.eth_wb_out,
				.dma_cmd_in,
				.dma_cmd_ack,
				.dma_done,
				.dma2tm);

  //generate generate the dual-port DMA buffer
  debug_dma_buf   gen_dma_buf(.*, .eth_rx_clk(eth_rx_clk), .eth_tx_clk(eth_tx_clk), .dberr(), .sberr());  
endmodule

module cpu_top_dma(input iu_clk_type gclk, input bit rst,
    //IO interface
//    input  io_bus_out_type      io_in,
//    output io_bus_in_type       io_out,
   
    //dma buffer interface
    output debug_dma_read_buffer_in_type   dma_rb_in,
    input  debug_dma_read_buffer_out_type  dma_rb_out,
    output debug_dma_write_buffer_in_type  dma_wb_in,
    //dma command interface 
    input  debug_dma_cmdif_in_type         dma_cmd_in,     //cmd input 
    output bit                             dma_cmd_ack,    //cmd has been accepted
    //dma timing model interface
    input  dma_tm_ctrl_type                dma2tm,

    //memory controller interface
    mem_controller_interface.cpu           mcif,

    //dma status
    output bit                             dma_done,
    output bit				   error1_led,
    output bit				   error2_led,
//    output bit                             done_led,  
//    output bit                             error_led,
		output	bit 			                         luterr, 
		output	bit 			                         bramerr, 
		output	bit			                          sb_ecc  //interface to xalu
    );

  bit [15:0]      pc_count;
  bit             count_state;          
  bit 		  xc_error_mode, xc_error_r, xc_error_out;
  
  
  const bit [31:0]    stopct_pc = 32'h2734;
  const bit [31:0]    error_pc  = 32'h1220;

  
	//----------wires----------
	//pipeline registers
	commit_reg_type		comr;		//WB -> IF, WB -> REG
	decode_reg_type		der;			//IF -> DE
	reg_reg_type		   regr;		//DE -> REG
	ex_reg_type		    exr;			//REG -> EX
	mem_reg_type		   memr;		//EX -> MEM
	xc_reg_type 		   xcr;			//MEM -> XC

	//immu
	immu_iu_in_type		immu_if_in;		 //IF -> IMMU
	immu_iu_out_type	immu_de_out;		//IMMU -> DE
	
	//dmmu
	dmmu_iu_in_type		iu2dmmu;		//IU -> DMMU
	dmmu_iu_out_type	dmmu2iu;		//DMMU -> IU

	//I$
	icache_if_in_type	   icache_if_in;		      //IF -> I$
	icache_data_out_type	icache_if_out;		     //I$ -> IF
	cache2iu_ctrl_type	  icache_de_out;		     //I$ -> DE
	icache_de_in_type	   icache_de_in;		      //IMMU->I$

	mem_stat_out_type	   icache_mem2iu_stat;  //memory status -> I$
	bit [NTHREADIDMSB:0]	icache_iu2mem_tid;	  //I$ -> memory ctrl
	mem_cmd_in_type		    icache_iu2mem_cmd;	  //I$ -> memory ctrl 
	
	cache_ram_in_type	   icache_mem2cacheram;	//mem -> I$ ram
	cache_ram_out_type	  icache_cacheram2mem;	//I$ ram -> mem
	
	//D$
	dcache_data_out_type	dcache_data;	       	//D$ -> IU
	dcache_iu_in_type	   iu2dcache;		         //IU -> D$ 
	dcache_mmu_in_type	  dmmu2cache;		        //DMMU->D$
	cache2iu_ctrl_type  	dcache2iu;		         //D$ -> IU control

	mem_stat_out_type	   dcache_mem2iu_stat;	 //memory status -> D$
	bit [NTHREADIDMSB:0]	dcache_iu2mem_tid;  	//D$ -> memory ctrl
	mem_cmd_in_type		    dcache_iu2mem_cmd;	  //D$ -> memory ctrl

	cache_ram_in_type	   dcache_mem2cacheram;	//mem -> D$ ram
	cache_ram_out_type	  dcache_cacheram2mem;	//D$ ram -> mem

	//mem interface
	mem_ctrl_in_type	    imem_in[0:0];
	mem_ctrl_in_type	    dmem_in[0:0];
	mem_ctrl_out_type	   imem_out[0:0];
	mem_ctrl_out_type	   dmem_out[0:0];

	//dma_interface
	debug_dma_in_type     iu2dma;
  debug_dma_out_type    dma2iu;
	bit [NTHREADIDMSB:0]		dma_rtid;		//(IU) read DMA register
	
	//timing model interface
	tm_cpu_ctrl_token_type cpu2tm;
  tm_dbg_ctrl_type       dma2cpu;     //start and stop everything right now
  tm2cpu_token_type      tm2cpu;
  
  //io bus connected to timing model
  io_bus_out_type      io_in;
  io_bus_in_type       io_out;
  bit				   running;

	//-------------------------SEU errors---------------------------
	//lutram errors
	bit [5:0]	luterr_r;
	bit		if_lutram_err;			    //IF lutram error
	bit		de_lutram_err;			    //DE lutram error
	bit		ex_lutram_err;			    //EX lutram error
	bit		xc_lutram_err;			    //XC lutram error
	bit		imem_if_lutram_err;		//imem if lutram error
	bit		dmem_if_lutram_err;		//imem if lutram error
	bit		dma_luterr;			       //DMA register lutram error
	bit  dramctrl_lutram_err; //DRAM controller lut error

	//bram errors
	bit [6:0]	bramerr_r;
	bit		     de_bram_err;			//DE bram error
	bit		     ex_bram_err;			//EX bram error
	bit		     xc_bram_err;			//XC bram error

	tlb_error_type	itlb_error, dtlb_error;		//TLB bram parity errors

	//single bit errors corrected by ECC
	bit [1:0]	sb_ecc_r;
	bit		     de_sb_ecc;			  //DE sb error
	bit		     xc_sb_ecc;			  //XC sb error

	//output registers
	bit		     luterr_out;
	bit		     bramerr_out;
	bit		     sb_ecc_out;

	
	//flight recorder signals
	typedef struct packed {
		bit [31:0] inst;
		bit [31:0] ex_res;
		bit [29:0] pc;
		bit [5:0]  tid;
		bit 	   ucmode;
		bit		   replay;
		bit		   run;
		bit		   dma_mode;
		bit 	   error_mode;
		bit		   icmiss;
		bit		   annul;
		bit		   mem_valid;
		bit		   mem_wb;
		bit [255:0] ic_wdata;
		bit			ic_we;
		bit [5:0]   ic_tid;
		bit [31:0]  host_count;
	}flight_recorder_data_type;
	bit [127:0]   ic_wdata;
	bit [127:0]	  icacheram_dbg_out;
	bit [8:0]	  icacheram_read_addr;
	    
    localparam FDRWIDTH = $bits(flight_recorder_data_type);
    
//	(* syn_preserve=1 *) flight_recorder_data_type fr_din;
//	flight_recorder_data_type fr_dout;
//	(* syn_noprune=1 *) flight_recorder_data_type  fr_dout_r;

	//------------------generate integer pipeline---------------------
	
	//fetch
	fetch_stage_dma	#(.newsch(1'b1))	gen_if(.*, .luterr(if_lutram_err));
	//decode stage
	decode_stage		gen_de(.*, .immu2iu(immu_de_out), .luterr(de_lutram_err), .bramerr(de_bram_err), .sb_ecc(de_sb_ecc));
	//regacc stage
	regacc_stage_dma	gen_regacc(.*);
	//execuation stage
	execution_stage		gen_ex(.*, .luterr(ex_lutram_err), .bramerr(ex_bram_err));
	//memory stage
	memory_stage		gen_mem(.*);
	//exception stage
	exception_stage_dma	gen_xc(.*, .luterr(xc_lutram_err), .bramerr(xc_bram_err), .sb_ecc(xc_sb_ecc), .errmode(xc_error_mode));
		
	//------------------generate dummy mmu---------------------
	immu		#(.DUMMYMMU(0))	gen_immu(.gclk, .rst, .immu_if_in, .immu_de_out, .icache_de_in, .parity_error(itlb_error), .iu2itlb(), .itlb2iu(), .mem2itlb(), .itlb2mem());		//TLB interface are not connected
	dmmu		#(.DUMMYMMU(0))	gen_dmmu(.gclk, .rst, .iu2dmmu, .dmmu2iu, .dmmu2cache, .parity_error(dtlb_error), .iu2dtlb(), .dtlb2iu(), .mem2dtlb(), .dtlb2mem());

	//------------------generate cache---------------------
	icache		#(.read2x(1), .write2x(1))	gen_icache(.gclk, .rst, 
					.mem2iu_stat(icache_mem2iu_stat), 
					.iu2mem_tid(icache_iu2mem_tid),
					.iu2mem_cmd(icache_iu2mem_cmd),
					.mem2cacheram(icache_mem2cacheram), 
					.cacheram2mem(icache_cacheram2mem),
					.iu2cache(icache_if_in),
					.immu2cache(icache_de_in),
//					.cacheram_dbg_out(icacheram_dbg_out),
//					.cacheram_read_addr(icacheram_read_addr),
					.if_out(icache_if_out),
					.de_out(icache_de_out));

	//dcache		#(.read2x(1), .write2x(1))	gen_dcache(.gclk, .rst, 
	dcache_udc		#(.read2x(1), .write2x(1))	gen_dcache(.gclk, .rst, 
					.mem2iu_stat(dcache_mem2iu_stat), 
					.iu2mem_tid(dcache_iu2mem_tid),
					.iu2mem_cmd(dcache_iu2mem_cmd),
					.mem2cacheram(dcache_mem2cacheram), 
					.cacheram2mem(dcache_cacheram2mem),
					.iu2cache(iu2dcache),
					.dmmu2cache(dmmu2cache),
					.data_out(dcache_data),
					.dcache2iu);

	//------------------generate memory IF-------------------
	imem_if		#(.read2x(1), .write2x(1))	gen_imem_if(.gclk, .rst,
					.iu2mem_tid(icache_iu2mem_tid),
					.iu2mem_cmd(icache_iu2mem_cmd),
					.mem2iu_stat(icache_mem2iu_stat),
					.cacheram2mem(icache_cacheram2mem),
					.mem2cacheram(icache_mem2cacheram),
					.from_mem(imem_out[0]),
					.to_mem(imem_in[0]),
					.luterr(imem_if_lutram_err));

	dmem_if		#(.read2x(1), .write2x(1), .nonblocking(1))	gen_dmem_if(.gclk, .rst,
					.iu2mem_tid(dcache_iu2mem_tid),
					.iu2mem_cmd(dcache_iu2mem_cmd),
					.mem2iu_stat(dcache_mem2iu_stat),
					.cacheram2mem(dcache_cacheram2mem),
					.mem2cacheram(dcache_mem2cacheram),
					.from_mem(dmem_out[0]),
					.to_mem(dmem_in[0]),
					.luterr(dmem_if_lutram_err));

	//------------------generate memory controller----------------
  dramctrl_fast  gen_memctrl(.*,
                  .imem_in,
                  .dmem_in,
                  .imem_out,
                  .dmem_out,
                  .mcif,
                  .luterr(dramctrl_lutram_err));      


	//------------------generate memory controller----------------
	debug_dma		gen_iu_dma(.*, .luterr(dma_luterr));

  //------------------generate timing model---------------------
  //tm_cpu_none gen_tm(.*);
  //tm_cpu_1ipc gen_tm(.*);
  //assign io_in = '{default:0};
  tm_cpu_l1 gen_tm(.*, .io_in(io_out), .io_out(io_in));



    //------------------generate a flight recorder---------------------
/*	always_ff @(posedge gclk.clk) begin
     fr_din.inst       <= xcr.ts.inst;
     fr_din.ex_res     <= xcr.ex_res;
	 fr_din.pc         <= xcr.ts.pc;
	 fr_din.tid        <= xcr.ts.tid;
	 fr_din.ucmode     <= xcr.ts.ucmode;
	 fr_din.replay     <= dcache2iu.replay;
	 fr_din.run	       <= xcr.ts.run;
	 fr_din.dma_mode   <= xcr.ts.dma_mode;
	 fr_din.error_mode <= xc_error_mode;
	 fr_din.icmiss	   <= xcr.ts.icmiss;
	 fr_din.annul      <= xcr.ts.annul;
	 fr_din.mem_valid  <= dcache_iu2mem_cmd.valid;
	 fr_din.mem_wb     <= (dcache_iu2mem_cmd.cmd.D  == DCACHE_WB) ? '1 : '0;
	 
//	 fr_din.ic_wdata   <= {icache_mem2cacheram.write.data.data.I, ic_wdata};
	 fr_din.ic_wdata   <= unsigned'({icacheram_read_addr ,4'b0,ldst_big_endian(icache_if_out), icacheram_dbg_out});
	 fr_din.ic_we 	   <= icache_mem2cacheram.write.we_data.I[0];
//	 fr_din.ic_tid	   <= icache_mem2cacheram.write.tid;
	 fr_din.ic_tid 	   <= der.ts.tid;
	 
	 if (rst) 
	 	fr_din.host_count <= '0;
	 else 
	 	fr_din.host_count  <= fr_din.host_count + 1;
	 
	 fr_dout_r <= fr_dout;
   end
 	
	always_ff @(negedge gclk.clk) ic_wdata[127:0] <= icache_mem2cacheram.write.data.data.I; 
*/
//   flight_recorder #(.DWIDTH(FDRWIDTH)) fdr( .clk(gclk.clk), .rst, .din(fr_din), .dout(fr_dout)) /* synthesis syn_noprune=1 */;

	//------------------SEU Error detection logic-----------------
	always_ff @(posedge gclk.clk2x) begin
		if (rst) begin 
			luterr_r <= '0;
			bramerr_r <= '0;
			sb_ecc_r <= '0;

			luterr_out <= '0;
			bramerr_out <= '0;
			sb_ecc_out <= '0;
		end
		else begin
			luterr_r <= {if_lutram_err, de_lutram_err, ex_lutram_err, xc_lutram_err, imem_if_lutram_err, dmem_if_lutram_err, dma_luterr, dramctrl_lutram_err};
			bramerr_r <= {de_bram_err, ex_bram_err, xc_bram_err, itlb_error.tag_parity, itlb_error.data_parity,  dtlb_error.tag_parity, dtlb_error.data_parity};
			sb_ecc_r <= {de_sb_ecc, xc_sb_ecc};

			luterr_out <= (luterr_out == 1'b0) ? |luterr_r : 1'b1;
			bramerr_out <= (bramerr_out == 1'b0) ? |bramerr_r : 1'b1;
			sb_ecc_out <= (sb_ecc_out == 1'b0) ? | sb_ecc_r : 1'b1;
			
		end		
	end
	
	always_ff @(posedge gclk.clk) begin
		if (rst)
			xc_error_out <= '0;
		else begin
			xc_error_r <= xc_error_mode;
			xc_error_out <= (xc_error_out == 1'b0) ? xc_error_r : 1'b1;
		end
	end
			

	assign luterr = luterr_out;
	assign bramerr = bramerr_out;
	assign sb_ecc = sb_ecc_out; 

	assign error1_led = xc_error_out;
        assign error2_led = luterr_out | bramerr_out | sb_ecc_out;
	
	
	//connect to disassembler
	
	//synthesis translate_off
	disassembler gen_disasm(.gclk, .rst, .xcr, .dcache_replay(dcache2iu.replay));
  //synthesis translate_on	
	
 /* always_ff @(posedge gclk.clk) begin
      if (rst) begin
        pc_count    <= '0;
        count_state <= '0;
        error_led   <= '0;
      end
      else begin
        if (xcr.ts.run == 1 && xcr.ts.icmiss == 0 && ~(xcr.ts.replay | dcache2iu.replay) && count_state == 0)      //count excuted instructions (including annulled)
          pc_count <= pc_count + 1;      
      
        if ({xcr.ts.pc, 2'b0} == stopct_pc) 
          count_state <= '1;
        
        if ({xcr.ts.pc, 2'b0} == stopct_pc)
          error_led <= '1;
      end
   end 

  assign done_led = count_state; */

endmodule

//synthesis translate_off
module sim_top;

parameter clkperiod = 5;

bit clk=0;
bit rst;
bit cpurst;

bit phy_rxclk, phy_gtxclk, phy_txen, phy_rxdv;
bit [7:0] phy_txd, phy_rxd;

//IO interface
//io_bus_out_type      io_in;
//io_bus_in_type       io_out;

wire [63:0]              ddr2_dq;
wire [13:0]              ddr2_a;
wire [2:0]               ddr2_ba;
wire                     ddr2_ras_n;
wire                     ddr2_cas_n;
wire                     ddr2_we_n;
wire [1:0]               ddr2_cs_n;
wire [1:0]               ddr2_odt;
wire [1:0]               ddr2_cke;
wire [7:0]               ddr2_dm;
wire [7:0]               ddr2_dqs;
wire [7:0]               ddr2_dqs_n;
wire [1:0]               ddr2_ck;
wire [1:0]               ddr2_ck_n;



default clocking main_clk @(posedge clk);
endclocking

initial begin
  forever #clkperiod clk = ~clk;
end

initial begin
  forever #4 phy_rxclk = ~phy_rxclk;
end

initial begin

  rst 	 = '0;
  cpurst = '0;
//  io_in.retry = '0;
//  io_in.irl   = '0;
//  io_in.rdata = '0;

//  ##10;
//  rst = '0;
  
  ##200;
  rst = '0;
  
  ##10;
  rst = '1;
  
  ##200;
  cpurst = '1;
  
  ##10;
  cpurst = '0;
end

mt16htf25664hy  gen_sodimm(
                         .dq(ddr2_dq),
                         .addr(ddr2_a),           //COL/ROW addr
                         .ba(ddr2_ba),            //bank addr
                         .ras_n(ddr2_ras_n),
                         .cas_n(ddr2_cas_n),
                         .we_n(ddr2_we_n),
                         .cs_n(ddr2_cs_n),
                         .odt(ddr2_odt),
                         .cke(ddr2_cke),
                         .dm(ddr2_dm),
                         .dqs(ddr2_dqs),
                         .dqs_n(ddr2_dqs_n),
                         .ck(ddr2_ck),
                         .ck_n(ddr2_ck_n)
                          );

mac_fedriver mac(
            .rxclk(phy_rxclk),
            .txclk(phy_gtxclk),
            .rst(cpurst),
            .rxdv(phy_rxdv),
            .rxd(phy_rxd),
            .txd(phy_txd),
            .txen(phy_txen));

fpga_top sim(.clkin_p(clk), 
            .clkin_n(~clk),
            .rstin(rst),
            .cpurst,         
            .ddr2_dq,
            .ddr2_a,
            .ddr2_ba,
            .ddr2_ras_n,
            .ddr2_cas_n,
            .ddr2_we_n,
            .ddr2_cs_n,
            .ddr2_odt,
            .ddr2_cke,
            .ddr2_dm,
            .ddr2_dqs,
            .ddr2_dqs_n,
            .ddr2_ck,
            .ddr2_ck_n,
            .PHY_TXD(phy_txd),
            .PHY_TXEN(phy_txen),
            .PHY_TXER(),
            .PHY_GTXCLK(phy_gtxclk),
            .PHY_RXD(phy_rxd),
            .PHY_RXDV(phy_rxdv),
            .PHY_RXER(1'b0),
            .PHY_RXCLK(phy_rxclk),
            .PHY_TXCLK(1'b0),
            .PHY_COL(1'b0),
            .PHY_CRS(1'b0),
            .PHY_RESET(),
            .TxD(),
            .error1_led(),
            .error2_led(),
            .RxD(1'b0)
            );



endmodule
//synthesis translate_on