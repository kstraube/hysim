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
`define		numCores	1

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
`include "../../cpu/libiu.sv"
`include "../../io/libio.sv"
`include "../libtm.sv"
`include "libtm_cache.sv"
`endif

module ReadMod(
   input          clk,
   input          rst_n,
   input  [NTHREADIDMSB:0]   coreID,
   input  [31:0]  RAM_data,
   input          RAM_valid,
   input          enable,
   output [x:x]   RAM_addr,
   output [31:0]  FPGA_data,
   output         FPGA_valid,
   output         read_en     );

   reg    [(`numCores-1):0] prev_lead_bit;
   reg    [31:0]		i;

	always @(posedge clk) begin
      if (!rst_n) begin
         RAM_addr <= 1'b0;
         FPGA_data <= 1'b0;
         read_en <= 1'b0;
         FPGA_valid <= 1'b0;
         prev_lead_bit <= `numCores'b0;
      end

      if (enable) begin
         RAM_addr <= x;
         read_en <= 1'b1;
      end
      else begin
         RAM_addr <= 32'd0;
         read_en <= 1'b0;
      end

      if (RAM_valid) begin
         FPGA_data <= RAM_data[30:0];
         FPGA_valid <= RAM_data[31] ^ prev_lead_bit[coreID];
         prev_lead_bit[coreID] <= RAM_data[31];
      end
      end
endmodule
