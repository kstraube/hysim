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
   reg    [NTHREADIDMSB:0]   coreID, coreID_store;
   reg   [2:0]   write_ctr;
   reg [127:0] FPGA_data_store;

   reg v_ready, v_write_en;
   reg [2:0] v_write_ctr;
   reg [10:0] v_RAM_addr;
   reg [31:0] v_RAM_data;
   reg RAM_rdy;
   reg write_en_prev;

   assign RAM_rdy = ~RAM_busy;
   assign coreID = 'b0;//FPGA_data[104:102]; //size shrunk for simplicity
   assign coreID_store = 'b0;//FPGA_data_store[104:102]; //size shrunk for simplicity
   assign ready = (write_ctr == 0);
   assign write_en = (write_ctr >0)&~write_en_prev;
   assign RAM_addr = rst_n ? (coreID_store <<5) + write_ctr : 32'b0;

   always@(posedge clk) begin
      if (!rst_n) begin
         FPGA_data_store <= 128'b0;
	 prev_lead_bit <= 3'b0;
      end
      else if (enable) begin
         FPGA_data_store[126:0] <= FPGA_data[126:0];
         FPGA_data_store[127] <= ~prev_lead_bit[coreID];
         prev_lead_bit[coreID] <= ~prev_lead_bit[coreID];
      end
   end

   always@(posedge clk) begin
      if (!rst_n) begin
         write_ctr <= 3'b0;
	 write_en_prev <= 1'b0;
      end
      else begin
         write_ctr <= v_write_ctr;
	 write_en_prev <= write_en;
      end
   end
   
   always@(*) begin
      if(enable) begin
         v_write_ctr = 3'h4;
      end
      else if (write_ctr == 0) begin
         v_write_ctr = 3'b0;
      end
      else begin
	 if (write_en_prev) begin
            v_write_ctr = write_ctr -1;
         end
         else begin
            v_write_ctr = write_ctr;
         end
      end

      case(write_ctr)
        3'h1: RAM_data = 32'h11111111;//FPGA_data_store[31:0];
        3'h2: RAM_data = 32'h22222222;//FPGA_data_store[63:32];
        3'h3: RAM_data = 32'h33333333;//FPGA_data_store[95:64];
        3'h4: RAM_data = 32'h44444444;//FPGA_data_store[127:96];//32'h44444444;//{prev_lead_bit[coreID_store],FPGA_data_store[126:96]};
        default: v_RAM_data = 32'hFFFFFFFF;
      endcase
   end

endmodule
