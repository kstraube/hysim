`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Kramer Straube/Brent Allen
// 
// Create Date:    14:16:26 08/13/2014 
// Design Name: 
// Module Name:    WriteModule 
// Project Name:   PCIE-Control
// Target Devices: XUPV5-LX110T
// Tool versions: 
// Description:    Module for control of FPGA-simulated core write operation for
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

module WriteMod(
   input          clk,
   input          rst_n,
   input  [127:0]  FPGA_data,
   input  [NTHREADIDMSB:0]   RAM_addr,
   input          enable,
   output [31:0]  RAM_data,
   output         write_en   );

   reg    [(NTHREAD-1):0] prev_lead_bit;
   bit    [NTHREADIDMSB:0]   coreID;

   always @(posedge clk) begin
      if (!rst_n) begin
         RAM_addr <= 1'b0;
         FPGA_data <= 1'b0;
         read_en <= 1'b0;
         FPGA_valid <= 1'b0;
         prev_lead_bit[coreID] <= `numCores'b0;
      end

      if (enable) begin
         RAM_data <= {(!prev_lead_bit[coreID]),FPGA_data[30:0]};
         prev_lead_bit[coreID] <= !prev_lead_bit[coreID];
         write_en <= 1'b1;
      end
      else begin
         RAM_data <= 32'd0;
         write_en <= 1'b0;
      end
   end
endmodule
