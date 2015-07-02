//--------------------------------------------------------------------------------
//--
//-- This file is owned and controlled by Xilinx and must be used solely
//-- for design, simulation, implementation and creation of design files
//-- limited to Xilinx devices or technologies. Use with non-Xilinx
//-- devices or technologies is expressly prohibited and immediately
//-- terminates your license.
//--
//-- Xilinx products are not intended for use in life support
//-- appliances, devices, or systems. Use in such applications is
//-- expressly prohibited.
//--
//--            **************************************
//--            ** Copyright (C) 2008, Xilinx, Inc. **
//--            ** All Rights Reserved.             **
//--            **************************************
//--
//--------------------------------------------------------------------------------
//-- Filename: PIO_EP.v
//--
//-- Description: Endpoint Programmed I/O module.
//--
//--------------------------------------------------------------------------------

`timescale 1ns/1ns
`define PIO_64           1

module PIO_EP (
                        clk,
                        rst_n,

                        // LocalLink Tx

                        trn_td,
`ifdef PIO_64
                        trn_trem_n,
`endif // PIO_64
                        trn_tsof_n,
                        trn_teof_n,
                        trn_tsrc_dsc_n,
                        trn_tsrc_rdy_n,
                        trn_tdst_dsc_n,
                        trn_tdst_rdy_n,

                        // LocalLink Rx

                        trn_rd,
`ifdef PIO_64
                        trn_rrem_n,
`endif // PIO_64
                        trn_rsof_n,
                        trn_reof_n,
                        trn_rsrc_rdy_n,
                        trn_rsrc_dsc_n,
                        trn_rbar_hit_n,
                        trn_rdst_rdy_n,

                        // Turnoff access

                        req_compl_o,
                        compl_done_o,

                        // Configuration access

                        cfg_completer_id,
                        cfg_bus_mstr_enable,

                        // FPGA interface
                        rd_addr_fpga,
                        rd_be_fpga,
                        rd_data_fpga,

                        wr_addr_fpga,
                        wr_be_fpga,
                        wr_data_fpga,
                        wr_en_fpga,
                        wr_busy_fpga

                       );

    input              clk;
    input              rst_n;

    // LocalLink Tx


    output [( 64 - 1):0]     trn_td;
`ifdef PIO_64
    output [7:0]      trn_trem_n;
`endif // PIO_64
    output            trn_tsof_n;
    output            trn_teof_n;
    output            trn_tsrc_dsc_n;
    output            trn_tsrc_rdy_n;
    input             trn_tdst_dsc_n;
    input             trn_tdst_rdy_n;

    // LocalLink Rx

    input [( 64 - 1):0]      trn_rd;
`ifdef PIO_64
    input [7:0]       trn_rrem_n;
`endif // PIO_64
    input             trn_rsof_n;
    input             trn_reof_n;
    input             trn_rsrc_rdy_n;
    input [6:0]       trn_rbar_hit_n;
    input             trn_rsrc_dsc_n;
    output            trn_rdst_rdy_n;

    output            req_compl_o;
    output            compl_done_o;
    
    input [15:0]      cfg_completer_id;
    input             cfg_bus_mstr_enable;

    input  [10:0]      rd_addr_fpga;
    input  [3:0]       rd_be_fpga;
    output  [31:0]      rd_data_fpga;

    input  [10:0]      wr_addr_fpga;
    input  [7:0]       wr_be_fpga;
    input  [31:0]      wr_data_fpga;
    input              wr_en_fpga;
    output              wr_busy_fpga;


    // Local wires

    wire  [10:0]      rd_addr;
    wire  [3:0]       rd_be;
    wire  [31:0]      rd_data;

    wire  [10:0]      wr_addr;
    wire  [7:0]       wr_be;
    wire  [31:0]      wr_data;
    wire              wr_en;
    wire              wr_busy;

    wire              req_compl;
    wire              req_compl_with_data;
    wire              compl_done;

    wire  [2:0]       req_tc;
    wire              req_td;
    wire              req_ep;
    wire  [1:0]       req_attr;
    wire  [9:0]       req_len;
    wire  [15:0]      req_rid;
    wire  [7:0]       req_tag;
    wire  [7:0]       req_be;
    wire  [12:0]      req_addr;


    //
    // ENDPOINT MEMORY : 8KB memory aperture implemented in FPGA BlockRAM(*)
    //

    PIO_EP_MEM_ACCESS EP_MEM (

                   .clk(clk),                           // I
                   .rst_n(rst_n),                       // I

                   // Read Port

                   .rd_addr_i(rd_addr),                 // I [10:0]
                   .rd_be_i(rd_be),                     // I [3:0]
                   .rd_data_o(rd_data),                 // O [31:0]

                   // Write Port

                   .wr_addr_i(wr_addr_fpga),                 // I [10:0]
                   .wr_be_i(wr_be_fpga),                     // I [7:0]
                   .wr_data_i(wr_data_fpga),                 // I [31:0]
                   .wr_en_i(wr_en_fpga),                     // I
                   .wr_busy_o(wr_busy_fpga)                  // O

                   );

    PIO_EP_MEM_ACCESS EP_MEM2 (

                   .clk(clk),                           // I
                   .rst_n(rst_n),                       // I

                   // Read Port

                   .rd_addr_i(rd_addr_fpga),                 // I [10:0]
                   .rd_be_i(rd_be_fpga),                     // I [3:0]
                   .rd_data_o(rd_data_fpga),                 // O [31:0]

                   // Write Port

                   .wr_addr_i(wr_addr),                 // I [10:0]
                   .wr_be_i(wr_be),                     // I [7:0]
                   .wr_data_i(wr_data),                 // I [31:0]
                   .wr_en_i(wr_en),                     // I
                   .wr_busy_o(wr_busy)                  // O

                   );


    //
    // Local-Link Receive Controller
    //

PIO_64_RX_ENGINE EP_RX (

                   .clk(clk),                           // I
                   .rst_n(rst_n),                       // I

                   // LocalLink Rx
                   .trn_rd(trn_rd),                     // I [63/31:0]
                   .trn_rrem_n(trn_rrem_n),             // I [7:0]
                   .trn_rsof_n(trn_rsof_n),             // I
                   .trn_reof_n(trn_reof_n),             // I
                   .trn_rsrc_rdy_n(trn_rsrc_rdy_n),     // I
                   .trn_rsrc_dsc_n(trn_rsrc_dsc_n),     // I
                   .trn_rbar_hit_n(trn_rbar_hit_n),     // I [6:0]
                   .trn_rdst_rdy_n(trn_rdst_rdy_n),     // O

                   // Handshake with Tx engine

                   .req_compl_o(req_compl),             // O
                   .req_compl_with_data_o(req_compl_with_data), // O
                   .compl_done_i(compl_done),           // I

                   .req_tc_o(req_tc),                   // O [2:0]
                   .req_td_o(req_td),                   // O
                   .req_ep_o(req_ep),                   // O
                   .req_attr_o(req_attr),               // O [1:0]
                   .req_len_o(req_len),                 // O [9:0]
                   .req_rid_o(req_rid),                 // O [15:0]
                   .req_tag_o(req_tag),                 // O [7:0]
                   .req_be_o(req_be),                   // O [7:0]
                   .req_addr_o(req_addr),               // O [12:0]

                   // Memory Write Port

                   .wr_addr_o(wr_addr),                 // O [10:0]
                   .wr_be_o(wr_be),                     // O [7:0]
                   .wr_data_o(wr_data),                 // O [31:0]
                   .wr_en_o(wr_en),                     // O
                   .wr_busy_i(wr_busy)                  // I

                   );

    //
    // Local-Link Transmit Controller
    //

PIO_64_TX_ENGINE EP_TX (

                   .clk(clk),                         // I
                   .rst_n(rst_n),                     // I

                   // LocalLink Tx
                   .trn_td(trn_td),                   // O [63/31:0]
                   .trn_trem_n(trn_trem_n),           // O [7:0]
                   .trn_tsof_n(trn_tsof_n),           // O
                   .trn_teof_n(trn_teof_n),           // O
                   .trn_tsrc_dsc_n(trn_tsrc_dsc_n),   // O
                   .trn_tsrc_rdy_n(trn_tsrc_rdy_n),   // O
                   .trn_tdst_dsc_n(trn_tdst_dsc_n),   // I
                   .trn_tdst_rdy_n(trn_tdst_rdy_n),   // I


                   // Handshake with Rx engine
                   .req_compl_i(req_compl),           // I
                   .req_compl_with_data_i(req_compl_with_data), // I
                   .compl_done_o(compl_done),         // 0

                   .req_tc_i(req_tc),                 // I [2:0]
                   .req_td_i(req_td),                 // I
                   .req_ep_i(req_ep),                 // I
                   .req_attr_i(req_attr),             // I [1:0]
                   .req_len_i(req_len),               // I [9:0]
                   .req_rid_i(req_rid),               // I [15:0]
                   .req_tag_i(req_tag),               // I [7:0]
                   .req_be_i(req_be),                 // I [7:0]
                   .req_addr_i(req_addr),             // I [12:0]

                   // Read Port

                   .rd_addr_o(rd_addr),              // O [10:0]
                   .rd_be_o(rd_be),                  // O [3:0]
                   .rd_data_i(rd_data),              // I [31:0]

                   .completer_id_i(cfg_completer_id),          // I [15:0]
                   .cfg_bus_mstr_enable_i(cfg_bus_mstr_enable) // I

                   );

  assign req_compl_o  = req_compl;
  assign compl_done_o = compl_done;

endmodule // PIO_EP

