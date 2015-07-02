//-------------------------------------------------------------------------------------------------  
// File:        eth_cpu_control.sv
// Author:      Zhangxi Tan 
// Description: DMA cpu controls for ramp gold. RX and TX works in a lock-step mode because 
//              no double buffering
//-------------------------------------------------------------------------------------------------

`timescale 1ns / 1ps

`ifndef SYNP94
import libstd::*;
import libiu::*;
import libconf::*;
import libdebug::*;
import libeth::*;
`else
`include "../cpu/libiu.sv"
`include "libeth.sv"

`endif


module eth_cpu_control #(parameter bit [7:0] mypid=8'b0)(
        input bit clk,
        input bit reset,
        input iu_clk_type gclk,
        //rx pipe
        input  eth_rx_pipe_data_type   rx_pipe_in,                                                
        output eth_rx_pipe_data_type   rx_pipe_out,
        //tx ring interface
        input  eth_tx_ring_data_type   tx_ring_in,
        output eth_tx_ring_data_type   tx_ring_out,                        

        //cpu dma interface
        output  debug_dma_cmdif_in_type         dma_cmd_in,     //cmd input 
        input 	 bit                             dma_done,		//dma status      
        
        //cpu dma buffer interface
        input  debug_dma_read_buffer_in_type   dma_rb_in,
        output debug_dma_read_buffer_out_type  dma_rb_out,
        input  debug_dma_write_buffer_in_type  dma_wb_in,
        output bit                             sberr,
        output bit                             dberr,
        output bit                             luterr,
        input  bit [127:0]		       mem_data_in,
        output bit [31:0]		       mem_data_out,
	output bit			       mem_data_out_valid,
	input  bit			       poll_not_ready,
	output bit			       eth_mem_rd,
	input  bit			       valid_out,
	output bit [42:0]              	       eth2speedtm,
	input bit			       speedtm_running,
	input bit			       mem_cnt_eq
        ) /* synthesis syn_sharing = on*/;
  typedef enum bit [4:0] {eth_cpu_idle, eth_cpu_buf_addr, eth_cpu_cmd, eth_cpu_data, eth_cpu_drop, eth_cpu_dma_op, eth_cpu_ack_wait_token, eth_cpu_ack_wait_append, eth_cpu_ack_send, eth_cpu_mem_data, eth_cpu_mem_ack,eth_mem_send,
eth_mem_send_wait, eth_poll_delay,eth_mem_data_get, eth_speedtm_start, eth_tmpoll, eth_speedtm_ack, eth_speedtm_ack_append, eth_mem_timer_send, eth_ping_1000} eth_cpu_state_type;
        
  typedef struct {
    eth_cpu_state_type    state;
    bit [DMABUFMSB:0]     buf_addr;         
    bit [DMABUFMSB:0]     tx_count;         
    bit [NTHREADIDMSB+1:0]  active_count;
    bit                   isodd;
    bit                   dma_cmd_we;
    bit                   nack;
    bit [15:0]            seqnum;
    bit [31:0]            tmpdata;
    bit [15:0]            tmpseq;
  }eth_cpu_control_reg_type;
  
  eth_cpu_control_reg_type vstate, rstate; 

  eth_rx_pipe_data_type   v_rx_pipe_out;
  eth_tx_ring_data_type   v_tx_ring_out;

  bit                     isRetry;
  bit [DMABUFMSB:0]       next_addr, next_count;         
  
  typedef struct packed{
    bit [DMABUFMSB:0]           buf_addr;  //support up to 1024*4 buffer 
    bit [DMABUFMSB:0]           count;     //dma counter
    bit [NTHREADIDMSB:0]        tid;       //thread id
    bit                         parity;    
  }eth_cmd_fifo_type;     //buffered command fifo
  
  eth_cmd_fifo_type       cmd_fifo_din, cmd_fifo_dout;
  bit                     cmd_fifo_we, cmd_fifo_re, cmd_fifo_empty, cmd_fifo_rst;

  bit [31:0]              le_data;
  
  bit                     r_dma_done;
  bit [127:0]		  mem_data_send;

  bit 			  mem_data_en;    //enable for mem data shift reg

  //bit                     r_mem_sel,v_mem_sel; //outputting mem data not normal data
  bit [31:0]		  mem_data_in_seg; //segmented data of the mem_data_in to fix into the output box
  bit [4:0]               poll_delay_count, v_poll_delay_count;
  bit 			  mem_rd_store;

  bit			  eth2speedtm_valid, speedtm_shift_en;
  bit [42:0]		  eth2speedtm_shift;
  bit [31:0]		  new_eth2speedtm;

  bit			  v_mem_data_out_valid;

  bit 	                  mem_timer_rst;
  bit [31:0]		  mem_timer, mem_timer_out;

  bit [9:0]               ping_count;
  bit 			  ping_inc;

  bit [9:0]		  time_ctr;
  bit			  timeout_en, v_timeout_en, time_ctr_reset;
  
  //dma buffer interface
  debug_dma_read_buffer_in_type   eth_rb_in;
  debug_dma_write_buffer_in_type  eth_wb_in;
  debug_dma_write_buffer_out_type eth_wb_out;		
  
 always_comb begin   
   le_data = ldst_big_endian(rx_pipe_in.msg.data); //received data from RX
   vstate = rstate;
   
   v_rx_pipe_out = rx_pipe_in;
   v_tx_ring_out = tx_ring_in;
   
   isRetry = isRetransmit(rstate.seqnum, rstate.tmpseq);        
   
   eth_wb_in = '{default:0};
   eth_wb_in.addr = rstate.buf_addr;
   
   eth_rb_in.inst = rstate.tmpdata;
   eth_rb_in.data = le_data;
   eth_rb_in.we   = '0;
   eth_rb_in.addr = rstate.buf_addr;
   
   next_addr = rstate.buf_addr + 1;   //adders
   next_count = rstate.tx_count - 1;

   v_mem_data_out_valid = '0; //be default data is not valid
   mem_data_en ='0;
   eth_mem_rd = 1'b0;
   mem_rd_store = 1'b0;
   speedtm_shift_en = 1'b0;
   eth2speedtm_valid = 1'b0;

   time_ctr_reset = 1'b0;
   
   if (r_dma_done)
     vstate.active_count =  rstate.active_count - 1;

     
   dma_cmd_in.tid = (rstate.dma_cmd_we) ? cmd_fifo_dout.tid : le_data[DMABUFMSB*2+2 +: NTHREADIDMSB+1];
   dma_cmd_in.addr_reg.addr = rstate.tmpdata[29:0];        //target virtual address
   dma_cmd_in.addr_reg.parity = (LUTRAMPROT) ? rstate.tmpdata[30] : '0;
   dma_cmd_in.addr_we = '0;

   cmd_fifo_din.buf_addr = le_data[DMABUFMSB+1 +: DMABUFMSB+1];         //control register
   cmd_fifo_din.count    = le_data[0 +: DMABUFMSB+1];
   cmd_fifo_din.tid      = le_data[DMABUFMSB*2+2 +: NTHREADIDMSB+1];
   cmd_fifo_din.parity   = (LUTRAMPROT) ? le_data[31] : '0;
   cmd_fifo_we = '0;
   cmd_fifo_re = '0;   
   cmd_fifo_rst = reset;
   
   dma_cmd_in.ctrl_reg.buf_addr = cmd_fifo_dout.buf_addr;
   dma_cmd_in.ctrl_reg.count    = cmd_fifo_dout.count;
   dma_cmd_in.ctrl_reg.cmd      = dma_OP;          //this will help synthesis to optimize unused ram.
   dma_cmd_in.ctrl_reg.parity   = (LUTRAMPROT) ? ^{cmd_fifo_dout.parity, cmd_fifo_dout.tid, dma_OP} : '0;
   dma_cmd_in.ctrl_we  = rstate.dma_cmd_we;

   luterr = (LUTRAMPROT & rstate.dma_cmd_we) ? ^cmd_fifo_dout : '0;

   mem_timer_rst = 1'b0;

   ping_inc = 1'b0;

   v_timeout_en = timeout_en;
   
   
   unique case(rstate.state)
   eth_cpu_idle: begin
                	   vstate.buf_addr = '0;
                	   vstate.active_count = '0;
                    vstate.nack = '0;
                    vstate.tx_count = '0;
		    //v_mem_sel = 1'b0;

                    if (rx_pipe_in.stype == rx_start && (rx_pipe_in.msg.header.pid == mypid || rx_pipe_in.msg.header.pid == BCASTPID)) begin
                      vstate.isodd = '1;
                      if (rx_pipe_in.msg.header.ptype == dataPacketType) begin
                        vstate.state =  eth_cpu_data; vstate.tmpseq = rx_pipe_in.msg.header.seqnum;                        
                      end
                      else if (rx_pipe_in.msg.header.ptype == cmdPacketType) begin
                        vstate.state =  eth_cpu_buf_addr; vstate.tmpseq = rx_pipe_in.msg.header.seqnum;  
                      end
		      else if (rx_pipe_in.msg.header.ptype == memStartPacketType) begin //detect mem start packet and jump to send ack with data
				vstate.state = eth_cpu_mem_ack; vstate.seqnum = rx_pipe_in.msg.header.seqnum; //vstate.tmpseq = rx_pipe_in.msg.header.seqnum;
		      end
		      else if (rx_pipe_in.msg.header.ptype == memPacketType) begin //detect mem data packet, read data, then jump to send ack with data
				vstate.state = eth_cpu_mem_data; vstate.tmpseq = rx_pipe_in.msg.header.seqnum;
			  	mem_timer_rst = 1'b1;
		      end
		      else if (rx_pipe_in.msg.header.ptype == speedtmPacketType) begin //detect mem data packet, read data, then jump to send ack with data
				vstate.state = eth_speedtm_start; vstate.seqnum = rx_pipe_in.msg.header.seqnum; //ack and set speedtm to start
		      end
		      else if (rx_pipe_in.msg.header.ptype == tmPollReqPacketType) begin //detect mem data packet, read data, then jump to send ack with data
				vstate.state = eth_tmpoll; vstate.seqnum = rx_pipe_in.msg.header.seqnum; //ack if done otherwise send some other header
		      end
		      else if (rx_pipe_in.msg.header.ptype == pingPacketType) begin //detect mem data packet, read data, then jump to send ack with data
				//v_timeout_en = 1'b1;
				//time_ctr_reset = 1'b1;
				vstate.state = eth_cpu_ack_wait_token; vstate.seqnum = rx_pipe_in.msg.header.seqnum; // eth_ping_1000;
		      end
		      else if (timeout_en & time_ctr == 10'd100) begin
			        vstate.state = eth_cpu_ack_wait_token; vstate.seqnum = rx_pipe_in.msg.header.seqnum;
				time_ctr_reset = 1'b1;
		      end
                    end
               end
   eth_ping_1000: begin
		  ping_inc = 1'b1;
		  if (ping_count == 10'd1000) begin
		     v_tx_ring_out.stype = tx_start;
                     v_tx_ring_out.msg.header.pid = mypid;
                     v_tx_ring_out.msg.header.seqnum = ldsts_big_endian(rstate.seqnum);
		     v_tx_ring_out.msg.header.ptype = ackPacketType;
		     vstate.state = eth_cpu_idle;
		  end
		  else begin
		     vstate.state = eth_cpu_idle;
		  end
	       end
   eth_cpu_buf_addr: begin
		      if (rx_pipe_in.stype == rx_data) begin
                    			if (!isRetry)
	                        vstate.active_count = le_data[16 +: NTHREADIDMSB+2];
	                        
                        vstate.tx_count = le_data[0 +: DMABUFMSB+1];
                        vstate.state = (isRetry) ? eth_cpu_drop : eth_cpu_cmd;
                      end
                      else if (rx_pipe_in.stype == rx_end) begin //corrupted packet
                        vstate.nack = '1;
                        vstate.state = eth_cpu_ack_wait_token;
                      end
                    end
   eth_cpu_data: begin
                  if (rx_pipe_in.stype == rx_data) begin
                    vstate.tmpdata = le_data;
                    if (!rstate.isodd) begin 
                      eth_rb_in.we = '1;//accumulates data in read buffer 
                      vstate.buf_addr = next_addr;
                    end
                    vstate.isodd = ~rstate.isodd;
                  end
                  else if (rx_pipe_in.stype == rx_end) begin
                    vstate.nack  = rx_pipe_in.msg.data[0];
                    vstate.state = eth_cpu_ack_wait_token;

                    if (!rx_pipe_in.msg.data[0])
                      vstate.seqnum = rstate.tmpseq;      //update sequenc number
                  end
                end
   eth_cpu_cmd: begin
                if (rx_pipe_in.stype == rx_data) begin
                  vstate.tmpdata = le_data;
                  if (!rstate.isodd) begin
                    dma_cmd_in.addr_we = '1;    //write address but not command
                    cmd_fifo_we = '1;           //queue the command till we receive all
                  end
                  
                  vstate.isodd = ~rstate.isodd;
                end
                else if (rx_pipe_in.stype == rx_end) begin
                  if (rx_pipe_in.msg.data[0]) begin  //corrupted packet
                    cmd_fifo_rst = '1;
                    vstate.nack = '1;
                    vstate.state = eth_cpu_ack_wait_token;
                  end  
                  else begin    //finish the packet 
 		    //vstate.nack = '1; // added to see if this is the issue - KS
                    vstate.state = eth_cpu_dma_op;
                    vstate.seqnum = rstate.tmpseq;      //update sequenc number                    
                  end
                end                  
              end
   eth_cpu_dma_op : begin                               //issue to dma from FIFO
                      if (!cmd_fifo_empty)
                        cmd_fifo_re = '1;
                      else 
                        vstate.state = eth_cpu_ack_wait_token;                    
                    end
   eth_speedtm_start : begin

		      if (rx_pipe_in.stype == rx_data) begin //good data so take in data and send ack	                        
                        new_eth2speedtm = ldst_big_endian(rx_pipe_in.msg.data);
			speedtm_shift_en = 1'b1;
		        /**if (tx_ring_in.stype == tx_start_empty) begin   //empty token
                          v_tx_ring_out.stype = tx_start;
                          v_tx_ring_out.msg.header.pid = mypid;
                          v_tx_ring_out.msg.header.seqnum = ldsts_big_endian(rstate.seqnum);
                          v_tx_ring_out.msg.header.ptype = ackPacketType;
                          vstate.state = eth_cpu_idle;
                        end**/
		      end
                      else if (rx_pipe_in.stype == rx_end) begin //finished receiving data so send ACK
        		eth2speedtm_valid = 1'b1;
			vstate.state = eth_speedtm_ack;
                      end
		    end
   eth_speedtm_ack: begin
                      if (tx_ring_in.stype == tx_start_empty) begin
		        v_tx_ring_out.stype = tx_start;
                        v_tx_ring_out.msg.header.pid = mypid;
                        v_tx_ring_out.msg.header.seqnum = ldsts_big_endian(rstate.seqnum);
			if (rstate.nack) begin
			  v_tx_ring_out.msg.header.ptype = tmPollResPacketType;
			end
		        else begin
                          v_tx_ring_out.msg.header.ptype = ackPacketType;
                        end
                        vstate.state = eth_cpu_idle;//eth_cpu_ack_wait_token;
		      end
		      else if (tx_ring_in.stype == tx_start) begin    //token with something (this should never happen if mac_ram is the first unit on the tx ring
                       vstate.state = eth_speedtm_ack_append;
		      end
		    end
   eth_speedtm_ack_append: begin
		      if (tx_ring_in.stype == tx_none) begin
                         v_tx_ring_out.stype = slot_start;
                         v_tx_ring_out.msg.header.pid = mypid;
                         v_tx_ring_out.msg.header.seqnum = ldsts_big_endian(rstate.seqnum);
                         v_tx_ring_out.msg.header.ptype = (rstate.nack)? tmPollResPacketType : ackPacketType;                  
                         //r_mem_sel = 1'b0;                         
                         vstate.state = (rstate.nack || rstate.tx_count == 0) ? eth_cpu_idle : eth_cpu_ack_send;                   
                     end
		    end
   eth_tmpoll :     begin
		      //put stuff here - if speedtm_running is 1 then send some special header, otherwise send ack to indicate that speedtm has finished
		      if (speedtm_running) begin
		        //send different header - define in libeth
			vstate.nack = 1'b1;
			vstate.state = eth_speedtm_ack;
			/**v_tx_ring_out.stype = tx_start;
                        v_tx_ring_out.msg.header.pid = mypid;
                        v_tx_ring_out.msg.header.seqnum = ldsts_big_endian(rstate.seqnum);
                        v_tx_ring_out.msg.header.ptype = tmPollResPacketType; //assign proper header type
			vstate.state = eth_cpu_idle;**/
		      end
		      else begin
			vstate.state = eth_speedtm_ack;
			vstate.nack = 1'b0;
			/**v_tx_ring_out.stype = tx_start;
                        v_tx_ring_out.msg.header.pid = mypid;
                        v_tx_ring_out.msg.header.seqnum = ldsts_big_endian(rstate.seqnum);
                        v_tx_ring_out.msg.header.ptype = ackPacketType; //assign proper header type
			vstate.state = eth_cpu_idle;**/
		      end
		    end
   eth_cpu_mem_data:begin//how to receive mem data
                  if (rx_pipe_in.stype == rx_data) begin
                      mem_data_en = 1'b1;//start mem shift register
		      v_mem_data_out_valid = '1;
                  end
                  else if (rx_pipe_in.stype == rx_end) begin
		    //mem_data_en = 1'b1;
                    vstate.nack  = 1'b0;//~mem_data_out[0];//assiv_mem_data_out_validgn ~valid bit (may need to flip this)
                    vstate.state = eth_cpu_mem_ack; //send the data and ack at the end
		    //v_mem_data_out_valid = '1; //mem data out valid now
	  	    //eth_mem_rd = ~vstate.nack;//going to enter send state so set read on queue  

                    vstate.seqnum = rstate.tmpseq;
                end
               end

   eth_cpu_mem_ack:begin //ack with data and ack header for mem interface with host
                    if ((rstate.nack || rstate.active_count ==0)) begin   //wait till write is finished to prevent dma overrun
                      if (tx_ring_in.stype == tx_start_empty) begin   //empty token
			
			if (rstate.nack) begin
                           v_tx_ring_out.stype = tx_start;
                           v_tx_ring_out.msg.header.pid = mypid;
                           v_tx_ring_out.msg.header.seqnum = ldsts_big_endian(rstate.seqnum);
                           v_tx_ring_out.msg.header.ptype = nackPacketType; //assign proper header type
			   vstate.tx_count = 3'd1;
			   vstate.state = eth_cpu_idle;
			end
			else begin
			   vstate.state = eth_mem_data_get;//eth_mem_send;
			   vstate.seqnum = rstate.seqnum;
			end
			//v_mem_sel = 1'b1;                        
                      end
                      else if (tx_ring_in.stype == tx_start)     //token with something (this should never happen if mac_ram is the first unit on the tx ring
                       vstate.state = eth_cpu_ack_wait_append;  //may need to change this          
                    end
		    /**if (~valid_out) begin
			eth_mem_rd = 1'b1; //stay 1 until I get a valid result
		    end**/
                  end  
   eth_cpu_ack_wait_token: begin
		    //mem_sel = 1'b0;
                    if (rstate.nack || rstate.active_count ==0) begin   //wait till write is finished to prevent dma overrun
                      if (tx_ring_in.stype == tx_start_empty) begin   //empty token
                        v_tx_ring_out.stype = tx_start;
                        v_tx_ring_out.msg.header.pid = mypid;
                        v_tx_ring_out.msg.header.seqnum = ldsts_big_endian(rstate.seqnum);
                        v_tx_ring_out.msg.header.ptype = (rstate.nack)? nackPacketType : ackPacketType;
			//v_mem_sel = 1'b0;
			//mem_sel_en = 1'b0;
			//mem_sel_clr = 1'b1;
                        vstate.state = (rstate.nack || rstate.tx_count == 0) ? eth_cpu_idle : eth_cpu_ack_send;
                        vstate.buf_addr = next_addr;                        
                        
                        eth_wb_in.addr = next_addr;

                      end
                      else if (tx_ring_in.stype == tx_start)     //token with something (this should never happen if mac_ram is the first unit on the tx ring
                       vstate.state = eth_cpu_ack_wait_append;            
                    end
                  end      
   eth_cpu_ack_wait_append: begin
		      //mem_sel = 1'b0;
                      if (tx_ring_in.stype == tx_none) begin
                         v_tx_ring_out.stype = slot_start;
                         v_tx_ring_out.msg.header.pid = mypid;
                         v_tx_ring_out.msg.header.seqnum = ldsts_big_endian(rstate.seqnum);
                         v_tx_ring_out.msg.header.ptype = (rstate.nack)? nackPacketType : ackPacketType;                  
                         //r_mem_sel = 1'b0;                         
                         vstate.state = (rstate.nack || rstate.tx_count == 0) ? eth_cpu_idle : eth_cpu_ack_send;
                         //mem_sel_clr = 1'b1;
			 //mem_sel_en = 1'b0;
                         vstate.buf_addr = next_addr;                                                                         
                         eth_wb_in.addr = next_addr;                         
                     end
                  end
   eth_cpu_drop : begin //drop retry packet, but don't drop corrupted retry
                    if (rx_pipe_in.stype == rx_end) begin
                      vstate.state = eth_cpu_ack_wait_token;
                      vstate.nack = rx_pipe_in.msg.data[0];
                    end
                  end
   eth_mem_data_get : begin
		    if (valid_out) begin
		       vstate.state = eth_mem_send_wait;
		       /**eth_mem_rd = 1'b1;//going to enter send state so set read on queue
		       mem_rd_store = 1'b1;
		       vstate.state = eth_mem_send_wait;
		       v_tx_ring_out.stype = tx_start;
                       v_tx_ring_out.msg.header.pid = mypid;
                       v_tx_ring_out.msg.header.seqnum = ldsts_big_endian(rstate.seqnum);
                       v_tx_ring_out.msg.header.ptype = memAckPacketType; //assign proper header type
		       vstate.tx_count = 3'd4; //requires 128 total bits sent = 4 iterations of 32 bits**/
		    end
		    else begin
			vstate.seqnum = rstate.seqnum; //keep seqnum correct
			vstate.state = eth_mem_data_get; //stay in this state until I can get valid data
		    end
		    /**else begin
			vstate.state = eth_mem_send; //should be removed eventually
		    end**/  
		end
   eth_mem_send_wait : begin
		  if (mem_cnt_eq) begin
		     eth_mem_rd = 1'b1;//going to enter send state so set read on queue
		     mem_rd_store = 1'b1;
		     vstate.state = eth_mem_send;//eth_mem_timer_send;
		     v_tx_ring_out.stype = tx_start;
                     v_tx_ring_out.msg.header.pid = mypid;
                     v_tx_ring_out.msg.header.seqnum = ldsts_big_endian(rstate.seqnum);
                     v_tx_ring_out.msg.header.ptype = memAckPacketType; //assign proper header type
		     vstate.tx_count = 3'd4; //requires 128 total bits sent = 4 iterations of 32 bits
		     mem_timer_out = mem_timer; //store timer value
		  end
		end
   eth_mem_timer_send: begin
		v_tx_ring_out.stype = slot_data;
		v_tx_ring_out.msg.data = mem_timer_out;
                vstate.state = eth_mem_send;
           end
   eth_mem_send : begin //send out data            
                vstate.tx_count = next_count;
                
                v_tx_ring_out.stype = slot_data;
		//if (mem_reply)
		case(rstate.tx_count)
		  3'd4: mem_data_in_seg = ldst_big_endian(mem_data_send[127:96]);//32'h11111111;
		  3'd3: mem_data_in_seg = ldst_big_endian(mem_data_send[95:64]);//32'h33333333;
		  3'd2: mem_data_in_seg = ldst_big_endian(mem_data_send[63:32]);//32'h80808080;
		  3'd1: mem_data_in_seg = ldst_big_endian(mem_data_send[31:0]);//32'hFFFFFFFF;
		  default: mem_data_in_seg = 32'h33333333;//22222222;
		endcase
		
		v_tx_ring_out.msg.data = mem_data_in_seg;//{31'h11111111,rstate.mem_sel};//mem_data_in_seg;
		
                if ((rstate.tx_count == 1) && ~valid_out) begin //read out all contents of mem_out to load into payload
                  vstate.state = eth_cpu_idle;
		end
		else if ((rstate.tx_count == 1) && valid_out) begin
		  vstate.tx_count = 3'd4; //reset tx_count for next thread output
		  eth_mem_rd = 1'b1; //read next entry since mem_out is not empty
		end
            end

   eth_poll_delay: begin
                      if (tx_ring_in.stype == tx_start_empty) begin   //empty token
                        v_tx_ring_out.stype = tx_start;
                        v_tx_ring_out.msg.header.pid = mypid;
                        v_tx_ring_out.msg.header.seqnum = ldsts_big_endian(rstate.seqnum);
                        v_tx_ring_out.msg.header.ptype = pollDelayType;//poll_delay_count + 8'd200;//pollDelayType;

                        vstate.state = eth_cpu_idle;
                        //vstate.buf_addr = next_addr;                        
                        
                        //eth_wb_in.addr = next_addr;

                      end
                      /**else if (tx_ring_in.stype == tx_start)     //token with something (this should never happen if mac_ram is the first unit on the tx ring
                       vstate.state = eth_cpu_ack_wait_append; **/           
                    end

   default : begin //send out data
                vstate.buf_addr = next_addr;
                eth_wb_in.addr = next_addr;              
                vstate.tx_count = next_count;
		//v_mem_sel = r_mem_sel;
                
                v_tx_ring_out.stype = slot_data;
		//if (mem_reply)
		/**case(rstate.tx_count)
		  3'd4: mem_data_in_seg = ldst_big_endian(mem_data_in[127:96]);//32'h11111111;
		  3'd3: mem_data_in_seg = ldst_big_endian(mem_data_in[95:64]);//32'h33333333;
		  3'd2: mem_data_in_seg = ldst_big_endian(mem_data_in[63:32]);//32'h80808080;
		  3'd1: mem_data_in_seg = ldst_big_endian(mem_data_in[31:0]);//32'hFFFFFFFF;
		  default: mem_data_in_seg = {31'h33333333,mem_sel};//22222222;
		endcase
		if (r_mem_sel) begin
		    v_tx_ring_out.msg.data = mem_data_in_seg;//{31'h11111111,rstate.mem_sel};//mem_data_in_seg;
		end
		else begin**/
		v_tx_ring_out.msg.data = ldst_big_endian(eth_wb_out.data);//{31'h44444444,rstate.mem_sel};//ldst_big_endian(eth_wb_out.data);
		//end
                //v_tx_ring_out.msg.data = (mem_sel) ? mem_data_in_seg : ldst_big_endian(eth_wb_out.data); //{31'h44444444,mem_sel};   //ignore the parity check here - add going through the mem data based on a counter

                if (rstate.tx_count == 1) begin
                  vstate.state = eth_cpu_idle;
		  //mem_sel = 1'b0;
		end
            end
   endcase

  vstate.dma_cmd_we = cmd_fifo_re;  //we use the "free" output register from the LUTRAM fifo   
  
  if (reset) begin
  	vstate.state = eth_cpu_idle;
  	vstate.seqnum = '0;
	//poll_delay_count = '0;
	v_poll_delay_count = '0;
	//mem_sel = 1'b0;
  	
  	v_tx_ring_out.stype = tx_none;
  	v_rx_pipe_out.stype = rx_none;
  end
 end

 //synthesis translate_off
 /**property guard_active_count;
  @(posedge(gclk.clk))
     disable iff (reset)
      dma_done |-> (rstate.active_count > 0);
 endproperty

 assert property (guard_active_count) else $display ("Error: %t dma_done overflow in eth_cpu_control!", $time);**/
 
 //synthesis translate_on

 assign mem_data_send = mem_data_in;        
 always_ff @(posedge clk) begin
   rstate <= vstate;
   //r_mem_sel <= v_mem_sel;
   //mem_sel <= (mem_sel | mem_sel_en) & ~mem_sel_clr; 
   poll_delay_count <= v_poll_delay_count;

   mem_data_out_valid <= v_mem_data_out_valid;

   rx_pipe_out <= v_rx_pipe_out;
   tx_ring_out <= v_tx_ring_out;
   if (mem_timer_rst) begin
      mem_timer <= 32'b0;
   end
   else begin
      mem_timer <= mem_timer + 1;
   end

   if (mem_data_en) begin
	     mem_data_out <= ldst_big_endian(rx_pipe_in.msg.data);//changed to 32 bit size   
   end
   if (speedtm_shift_en) begin
	eth2speedtm_shift <= {eth2speedtm_shift[10:0], new_eth2speedtm};
   end
   if (eth2speedtm_valid) begin
	eth2speedtm <= eth2speedtm_shift;
   end
   else begin
 	eth2speedtm <= 43'b0;
   end
   if (reset) begin
	ping_count <= 10'b0;
   end
   else if (ping_inc) begin
	ping_count <= ping_count + 1'b1;
   end

   if (reset) begin
	timeout_en <= 1'b0;
   end
   else if (v_timeout_en) begin
	timeout_en <= 1'b1;
   end
   else begin
	timeout_en <= timeout_en;
   end
   if (reset|time_ctr_reset) begin
	time_ctr <= 10'b0;
   end
   else if (timeout_en) begin
	time_ctr <= time_ctr + 1'b1;
   end
   /**if (mem_rd_store) begin
	mem_data_send <= mem_data_in;
   end**/
   
   r_dma_done <= dma_done;
 end      
 
 //instantiate cmdfifo
 sync_lutram_fifo #(.DWIDTH($bits(eth_cmd_fifo_type)), .DEPTH(NTHREAD)) cmdfifo(.clk,
                                              .rst(reset),
                                              .din(cmd_fifo_din),
                                              .we(cmd_fifo_we),
                                              .re(cmd_fifo_re),
                                              .empty(cmd_fifo_empty),
                                              .full(),
                                              .dout(cmd_fifo_dout));
//generate the dual-port DMA buffer
debug_dma_buf   gen_dma_buf(.*, .rst(reset), .eth_rx_clk(clk), .eth_tx_clk(clk));  
   
endmodule
