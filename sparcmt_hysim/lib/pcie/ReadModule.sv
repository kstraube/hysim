`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Kramer Straube/Brent Allen
// 
// Create Date:    13:38:33 08/13/2014
// Design Name: 
// Module Name:    ReadModule 
// Project Name:   PCIE-Control
// Target Devices: XUPV5-LX110T
// Tool versions: 
// Description:    Module for control of FPGA-simulated core read operation for
//                 HySim via PCI-Express
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`timescale	1ns/1ns

`ifndef SYNP94
import libconf::*;
import libiu::*;
import libio::*;
import libstd::*;
import libdebug::*;
import libtm::*;
import libopcodes::*;
import libtm_cache::*;
`else
`include "../cpu/libiu.sv"
`include "../io/libio.sv"
`include "../tm/libtm.sv"
`include "../tm/cpu/libtm_cache.sv"
`endif

module ReadMod(
   input          clk,
   input          rst_n,
   input  [31:0]  RAM_data,
   //input          RAM_valid,
   input          enable,
   output reg [10:0]   RAM_addr,
   output reg [31:0]  FPGA_data,
   output reg        FPGA_valid,
   output reg        read_en     );

   reg    [NTHREAD-1:0] prev_lead_bit;
   reg    [NTHREADIDMSB:0]   coreID;
   reg  	FPGA_valid_rst;
   reg [31:0]   prev_data;
   reg		RAM_valid;

  assign RAM_valid = (prev_data != RAM_data);

  always @(posedge clk) begin
      if (~rst_n) begin
         RAM_addr <= 11'b0;
         FPGA_data <= 1'b0;
         read_en <= 1'b0;
         FPGA_valid <= 1'b0;
         prev_lead_bit <= 'b0;
	 coreID <= 'b0;
         prev_data <= 32'b0;
      end

      if (enable) begin
         RAM_addr <= coreID<<2;
         read_en <= 1'b1;
      end
      else begin
         RAM_addr <= 11'd0;
         read_en <= 1'b0;
      end

      if (RAM_valid) begin
	 prev_data <= RAM_data;
         FPGA_data <= RAM_data[30:0];
         FPGA_valid <= (RAM_data[31] ^ prev_lead_bit[coreID]) & FPGA_valid_rst;
	 
         prev_lead_bit[coreID] <= RAM_data[31]; //data goes out and coreID is incremented

	 if (~enable || coreID+1 >= NTHREAD) begin //reset if coreID >= NTHREAD-1
           coreID <= 'b0;
         end
         else begin
           coreID <= coreID + 1;
         end
      end
      else begin
         FPGA_data <= 31'b0;
	 FPGA_valid <= 1'b0;
      end
  end

  always@(*) begin

    if (FPGA_valid) begin
      FPGA_valid_rst = 1'b0;
    end
    else begin
      if (RAM_valid) begin
        FPGA_valid_rst = FPGA_valid_rst;
      end
      else begin
        FPGA_valid_rst = 1'b1;
      end
    end

  end

endmodule
