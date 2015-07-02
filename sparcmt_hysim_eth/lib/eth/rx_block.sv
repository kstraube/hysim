`timescale 1ns / 1ps

`ifndef SYNP94
import libdebug::*;
import libtm::*;
import libconf::*;
`else
`include "../cpu/libiu.sv"
`include "../tm/libtm.sv"
`endif

module eth_rx_block #(
  parameter mac_addr = 48'h112233445566)
( input	bit		clk,
	input	bit		reset,
	input	bit [7:0]	rxd,
	input	bit		rxdv,
	input	bit		packetvalid,
	input	bit		packetinvalid,
	
	output bit [31:0] rx_dout,
	output debug_dma_read_buffer_in_type eth_rb_in,
	output bit tx_len_we,
	output bit [15:0] tx_len,
	output bit		fifo_we,
	output	bit		ack_we,
	output	bit		ack_data,
	output bit  start_dma,
	output 	dma_tm_ctrl_type	dma2tm,
	output bit dma2tm_we,
	output bit rst_out,
	input bit [3:0] mac_lsn,
	output bit mem_ack,
	output bit [127:0] mem_data,
	output bit mem_data_we
);

//  typedef enum bit [2:0] {rx_idle, rx_header, rx_datapacket, rx_cmdpacket, rx_framecheck_data, rx_framecheck_cmd, rx_start_tm, rx_waiting } rx_block_state_type;
  typedef enum {rx_idle, rx_header, rx_datapacket, rx_cmdpacket, rx_tmpacket, rx_framecheck_data, rx_framecheck_cmd, rx_framecheck_rst, rx_framecheck_tm, rx_mempacket, rx_mem_startpacket, rx_waiting } rx_block_state_type;//added new states

  rx_block_state_type state, nstate;
  dhsajkfhsdgfusdkhfldsuhfsuekhk

  bit [127:0] rx_data;
  bit [13:0] bytecount; 
  bit [13:0] n_bytecount;
  bit [9:0] addrcount;
  bit [15:0] rx_len;

  bit addrcount_reset, bytecount_reset;
  bit rx_len_we, bram_we;
  bit [3:0] rst_out_reg;
  bit rst_out_i;
  bit rx_en;
  bit [47:0] my_mac;

  const bit [13:0] DestAddrLoc = 5;
  const bit [13:0] ProtocolTypeLoc = 13;
  const bit [13:0] LengthLoc = 15;
  const bit [13:0] OpCodeLoc = 19;
   
  const bit [15:0] protocolTypeRAMP = 16'h8888;
  const bit [7:0] dataPacketType = 8'h00;
  const bit [7:0] cmdPacketType = 8'h01;
  const bit [7:0] TMPacketType = 8'h02;
  const bit [7:0] rstPacketType = 8'h03;
  const bit [7:0] memPacketType = 8'h04; //new mem packet type
  const bit [7:0] memStartPacketType = 8'h05; //new mem packet type
  
  assign eth_rb_in.inst = rx_data[31:0];
  assign eth_rb_in.data = rx_data[63:32];
  assign eth_rb_in.addr = addrcount;
  assign eth_rb_in.we = bram_we;
  assign rx_dout = rx_data[31:0];
  assign mem_data = rx_data[127:0]; //output the whole rx data but only store it if the we is enabled

  assign rst_out = |rst_out_reg;
  assign tx_len = rx_data[15:0];

  always_comb begin
     nstate = state;
     bram_we = '0;
     fifo_we = '0;
     mem_data_we = '0; //new we for mem structure
     ack_we = '0;
     ack_data = '0;
     mem_ack = '0;
     start_dma = '0;
     dma2tm_we = '0;
     tx_len_we = '0;
     rx_len_we = '0;
     addrcount_reset = '1;
     bytecount_reset = '0;
     n_bytecount = bytecount + 1;
     rx_en = '1;
     rst_out_i = '0;
	 
	   dma2tm.threads_total = rx_data[NTHREADIDMSB:0];
     dma2tm.threads_active = rx_data[NTHREADIDMSB+8:8];
     dma2tm.tm_dbg_ctrl = rx_data[15] ? tm_dbg_start : tm_dbg_stop;  
     
     my_mac = mac_addr;
     my_mac[3:0] = mac_lsn;

    unique case (state)
    
      rx_idle: begin
        bytecount_reset = '1;
        if (rxdv)
          nstate = rx_header;
      end
      
      rx_header: begin
	if  ((bytecount == DestAddrLoc && rx_data[47:0] != my_mac) ||
	(bytecount == ProtocolTypeLoc && rx_data[15:0] != protocolTypeRAMP)) // not a packet we are interested in
		nstate = rx_waiting;
	if (bytecount == LengthLoc)  //length based pkts
		rx_len_we = '1;
	if (bytecount == LengthLoc+2)
		tx_len_we = '1;
	if (bytecount == OpCodeLoc && rx_data[15:0] == dataPacketType) begin //otherwise match pkt and change state based on header value
		nstate = rx_datapacket;
		bytecount_reset = '1;
	end
	if (bytecount == OpCodeLoc && rx_data[15:0] == cmdPacketType) begin
		nstate = rx_cmdpacket;
		bytecount_reset = '1;
	end
	if (bytecount == OpCodeLoc && rx_data[15:0] == TMPacketType) begin
		nstate = rx_tmpacket;
		bytecount_reset = '1;
	end
	if (bytecount == OpCodeLoc && rx_data[15:0] == rstPacketType) begin
		nstate = rx_framecheck_rst;
		bytecount_reset = '1;
        end
	if (bytecount == OpCodeLoc && rx_data[15:0] == memPacketType) begin //check that bytecount is right - It is for finding the header - payload is next
		nstate = rx_mempacket; //new state for handling mem pkt return
		bytecount_reset = '1;
        end
        if (bytecount == OpCodeLoc && rx_data[15:0] == memStartPacketType) begin //check that bytecount is right - It is for finding the header - payload is next
		nstate = rx_mem_startpacket; //new state for the simple start packet
		bytecount_reset = '1;
        end
        else if (!rxdv)
		nstate = rx_idle;
    end
        
    rx_datapacket: begin
        addrcount_reset = '0;
        if (bytecount[2:0] == 3'b111)
          bram_we = '1;
        if (rx_len == n_bytecount)
          nstate = rx_framecheck_data;
        else if (!rxdv) begin
          ack_we = '1;
          ack_data = '0;
          nstate = rx_idle;
        end
     end
     
     rx_cmdpacket: begin
        if (bytecount[1:0] == 2'b11)
          fifo_we = '1;
        if (rx_len == n_bytecount)
          nstate = rx_framecheck_cmd;
        else if (!rxdv) begin
          ack_we = '1;
          ack_data = '0;
          nstate = rx_idle;
        end
     end
     
     rx_tmpacket: begin
        if (rx_len == n_bytecount) begin
          nstate = rx_framecheck_tm;   
          rx_en = '0;
        end
        else if (!rxdv) begin
          ack_we = '1;
          ack_data = '0;
          nstate = rx_idle;
        end
     end    
     
     rx_framecheck_data: begin
        if (packetvalid) begin
          ack_we = '1;
          ack_data = '1;
          nstate = rx_idle;
        end
        else if (packetinvalid) begin
          ack_we = '1;
          ack_data = '0;
	  nstate = rx_idle;
	  end
     end
     
     rx_framecheck_cmd: begin
	     if (packetvalid) begin
	         start_dma = '1;
           nstate = rx_idle;
	     end
	     if (packetinvalid) begin
	        ack_we = '1;
	        ack_data = '0;
	       	nstate = rx_idle;
	     end
     end
  
  rx_framecheck_tm: begin
     rx_en = '0;   
     if (packetvalid) begin
       dma2tm_we = '1;
       ack_we = '1;
       ack_data = '1;
       nstate = rx_idle;
     end
     if (packetinvalid) begin
       ack_we = '1;
       ack_data = '0;
       nstate = rx_idle;
     end
   end
   
  rx_framecheck_rst: begin
	   if (packetvalid) begin
	  	  rst_out_i = '1;
	  	  dma2tm.threads_total = NTHREAD-1;
       dma2tm.threads_active = NTHREAD-1;
       dma2tm.tm_dbg_ctrl = tm_dbg_stop;
	  	  dma2tm_we = '1;
	  	  ack_we = '1;
	  	  ack_data = '1;
		   nstate = rx_idle;
	   end
	   if (packetinvalid) begin
	     ack_we = '1;
	     ack_data = '0;
		   nstate = rx_idle;
	   end
	 end
  rx_mempacket: begin //update this - KSTODO
        addrcount_reset = '0;
        if (bytecount[3:0] == 4'b1111) //mempacket is 16 bytes long (0 counts)
          mem_data_we = '1;//change this to write out to sync fifo structure - KSTODO
        if (rx_len == n_bytecount) //checks for end of frame correct termination
          nstate = rx_framecheck_data;
        else if (!rxdv) begin //invalid data check
          ack_we = '1; //mem NACK is same as normal NACK so we are ok - reuse this we for the mem ack too since both should be written together
          ack_data = '0;
	  mem_ack = '0;
          nstate = rx_idle;
        end
     end  

  rx_mem_startpacket: begin //update this - KSTODO  
	if (packetvalid) begin
		ack_we = '1; //we need to assign ack and mem_ack properly and then funnel the data
		ack_data = '1;
		mem_ack = '1;
		nstate = rx_idle;
	end
	if (packetinvalid) begin
		ack_we = '1;//send mem NACK
		ack_data = '0;
		mem_ack = '0;
		nstate = rx_idle;
	end
     end  
  
  rx_waiting:
	   if (!rxdv) nstate = rx_idle;
  endcase
end
		
  always_ff @(posedge clk) begin
     if (reset)
       state <= rx_idle;
     else 
       state <= nstate;

     if (rx_en)
	     rx_data <= {rx_data[119:0], rxd};//increased to match new 128 bit size

     if (bytecount_reset)
	      bytecount <= '0;
     else 
	      bytecount <= n_bytecount;

     if (addrcount_reset)
	    addrcount <= '0;
     else if (bram_we)
	    addrcount <= addrcount + 1;

	if (rx_len_we)
	  rx_len <= rx_data[15:0];
	    
	 if (reset) begin
      rst_out_reg <= '0;
  end
  else begin
      rst_out_reg <= {rst_out_reg[2:0], rst_out_i}; 	    
  end 
  
end

endmodule
     
	
