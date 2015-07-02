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
`timescale    1ns/1ns

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
   input          enable,
   input          RAM_busy,
   output reg [10:0]   RAM_addr,
   output reg [31:0]  RAM_data,
   output reg        write_en,
   output reg         ready   );

   reg    [(NTHREAD-1):0] prev_lead_bit;
   reg    [NTHREADIDMSB:0]   coreID;
   reg   [2:0]   write_ctr;
   reg [127:0] FPGA_data_store;

   assign coreID = 'b0;//FPGA_data[108:102];//figure this out

   always @(posedge clk) begin
      if (!rst_n) begin
           RAM_addr <= 1'b0;
           FPGA_data_store <= 1'b0;
           //FPGA_valid <= 1'b0;
           prev_lead_bit <= 'b0;
           write_en <= 1'b0;
           ready <= 1'b0;
	   write_ctr <= 3'b0;
      end

      if (1'b0) begin//RAM_busy) begin
         write_en <= 1'b0;
         ready <= 1'b0;
      end
      else begin 
        if (enable & ready & (write_ctr == 0)) begin
	     //FPGA_data_store <= FPGA_data;
             //RAM_addr <= ((coreID+1) << 2);
             FPGA_data_store <= {(~prev_lead_bit[coreID]),FPGA_data[126:0]};
             prev_lead_bit[coreID] <= ~prev_lead_bit[coreID];
             write_ctr <= 3'h2;//worried about timing of the RAM writes…
             write_en <= 1'b0;
             ready <= 1'b0;
          end
        else begin
               if (write_ctr != 0) begin
                 
                 case(write_ctr)
                   3'h1: RAM_data <= FPGA_data_store[31:0];
                   3'h2: RAM_data <= FPGA_data_store[63:32];
                   3'h3: RAM_data <= FPGA_data_store[95:64];
                   3'h4: RAM_data <= FPGA_data_store[127:96];
                   default: RAM_data <= 32'b0;
                 endcase
                 RAM_addr <= ((coreID <<2) + write_ctr);
                 write_en <= 1'b1;
                 ready <= 1'b0;
  		 write_ctr <= write_ctr -1;
               end
               else begin
                 RAM_data <= 32'd0;
             	 write_en <= 1'b0;
                 ready <= 1'b1;
               end
        end
      end
           
   end

endmodule
