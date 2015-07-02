// DISCLAIMER OF LIABILITY
//
// This text/file contains proprietary, confidential
// information of Xilinx, Inc., is distributed under license
// from Xilinx, Inc., and may be used, copied and/or
// disclosed only pursuant to the terms of a valid license
// agreement with Xilinx, Inc. Xilinx hereby grants you
// a license to use this text/file solely for design, simulation,
// implementation and creation of design files limited
// to Xilinx devices or technologies. Use with non-Xilinx
// devices or technologies is expressly prohibited and
// immediately terminates your license unless covered by
// a separate agreement.
//
// Xilinx is providing this design, code, or information
// "as is" solely for use in developing programs and
// solutions for Xilinx devices. By providing this design,
// code, or information as one possible implementation of
// this feature, application or standard, Xilinx is making no
// representation that this implementation is free from any
// claims of infringement. You are responsible for
// obtaining any rights you may require for your implementation.
// Xilinx expressly disclaims any warranty whatsoever with
// respect to the adequacy of the implementation, including
// but not limited to any warranties or representations that this
// implementation is free from claims of infringement, implied
// warranties of merchantability or fitness for a particular
// purpose.
//
// Xilinx products are not intended for use in life support
// appliances, devices, or systems. Use in such applications are
// expressly prohibited.
//
//
// Copyright (c) 2001, 2002, 2003, 2004, 2005, 2007, 2008 Xilinx, Inc. All rights reserved.
//
// This copyright and support notice must be retained as part
// of this text at all times.
//
// Filename: pci_exp_64b_app.v
//
// Description:  PCI Express Endpoint Core 64 bit interface sample application
//              design.
//
//------------------------------------------------------------------------------

module  pci_exp_64b_app (

                        trn_clk,
                        trn_reset_n,
                        trn_lnk_up_n,

                        trn_td,
                        trn_trem,
                        trn_tsof_n,
                        trn_teof_n,
                        trn_tsrc_rdy_n,
                        trn_tdst_rdy_n,
                        trn_tsrc_dsc_n,
                        trn_tdst_dsc_n,
                        trn_terrfwd_n,
                        trn_tbuf_av,

                        trn_rd,
                        trn_rrem,
                        trn_rsof_n,
                        trn_reof_n,
                        trn_rsrc_rdy_n,
                        trn_rsrc_dsc_n,
                        trn_rdst_rdy_n,
                        trn_rerrfwd_n,
                        trn_rnp_ok_n,
                        trn_rbar_hit_n,
                        trn_rfc_nph_av,
                        trn_rfc_npd_av,
                        trn_rfc_ph_av,
                        trn_rfc_pd_av,
                        trn_rcpl_streaming_n,
                        cfg_do,
                        cfg_rd_wr_done_n,
                        cfg_di,
                        cfg_byte_en_n,
                        cfg_dwaddr,
                        cfg_wr_en_n,
                        cfg_rd_en_n,
                        cfg_err_cor_n,
                        cfg_err_ur_n,
                        cfg_err_cpl_rdy_n,
                        cfg_err_ecrc_n,
                        cfg_err_cpl_timeout_n,
                        cfg_err_cpl_abort_n,
                        cfg_err_cpl_unexpect_n,
                        cfg_err_posted_n,
                        cfg_err_tlp_cpl_header,
                        cfg_interrupt_n,
                        cfg_interrupt_rdy_n,
                        cfg_interrupt_assert_n,
                        cfg_interrupt_di,
                        cfg_interrupt_do,
                        cfg_interrupt_mmenable,
                        cfg_interrupt_msienable,
                        cfg_turnoff_ok_n,
                        cfg_to_turnoff_n,
                        cfg_pm_wake_n,
                        cfg_status,
                        cfg_command,
                        cfg_dstatus,
                        cfg_dcommand,
                        cfg_lstatus,
                        cfg_lcommand,

                        cfg_bus_number,
                        cfg_device_number,
                        cfg_function_number,
                        cfg_pcie_link_state_n,
                        cfg_dsn,
                        cfg_trn_pending_n,

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


 // Common

input                                             trn_clk;
input                                             trn_reset_n;
input                                             trn_lnk_up_n;

  // Tx


output [63:0]          trn_td;
output [7:0]           trn_trem;
output                                            trn_tsof_n;
output                                            trn_teof_n;
output                                            trn_tsrc_rdy_n;
input                                             trn_tdst_rdy_n;
output                                            trn_tsrc_dsc_n;
input                                             trn_tdst_dsc_n;
output                                            trn_terrfwd_n;
input  [(4 - 1):0]        trn_tbuf_av;

  // Rx

input  [63:0]          trn_rd;
input  [7:0]           trn_rrem;
input                                             trn_rsof_n;
input                                             trn_reof_n;
input                                             trn_rsrc_rdy_n;
input                                             trn_rsrc_dsc_n;
output                                            trn_rdst_rdy_n;
input                                             trn_rerrfwd_n;
output                                            trn_rnp_ok_n;

input  [6:0]       trn_rbar_hit_n;
input  [7:0]        trn_rfc_nph_av;
input  [11:0]       trn_rfc_npd_av;
input  [7:0]        trn_rfc_ph_av;
input  [11:0]       trn_rfc_pd_av;



output                                            trn_rcpl_streaming_n;


  // Host (CFG) Interface


input  [31:0]          cfg_do;
output [31:0]          cfg_di;
output [3:0]        cfg_byte_en_n;
output [9:0]          cfg_dwaddr;

input                                             cfg_rd_wr_done_n;
output                                            cfg_wr_en_n;
output                                            cfg_rd_en_n;
output                                            cfg_err_cor_n;
output                                            cfg_err_ur_n;
input                                             cfg_err_cpl_rdy_n;
output                                            cfg_err_ecrc_n;
output                                            cfg_err_cpl_timeout_n;
output                                            cfg_err_cpl_abort_n;
output                                            cfg_err_cpl_unexpect_n;
output                                            cfg_err_posted_n;
output                                            cfg_interrupt_n;
input                                             cfg_interrupt_rdy_n;
output                                            cfg_interrupt_assert_n;
output [7:0]                                      cfg_interrupt_di;
input  [7:0]                                      cfg_interrupt_do;
input  [2:0]                                      cfg_interrupt_mmenable;
input                                             cfg_interrupt_msienable;
output                                            cfg_turnoff_ok_n;
input                                             cfg_to_turnoff_n;
output                                            cfg_pm_wake_n;

output [47:0]        cfg_err_tlp_cpl_header;
input  [15:0]           cfg_status;
input  [15:0]           cfg_command;
input  [15:0]           cfg_dstatus;
input  [15:0]           cfg_dcommand;
input  [15:0]           cfg_lstatus;
input  [15:0]           cfg_lcommand;
input  [7:0]        cfg_bus_number;
input  [4:0]        cfg_device_number;
input  [2:0]        cfg_function_number;
input  [2:0]         cfg_pcie_link_state_n;
output                                            cfg_trn_pending_n;
output [(64 - 1):0]           cfg_dsn;

input  [10:0]      rd_addr_fpga;
input  [3:0]       rd_be_fpga;
output  [31:0]      rd_data_fpga;

input  [10:0]      wr_addr_fpga;
input  [7:0]       wr_be_fpga;
input  [31:0]      wr_data_fpga;
input              wr_en_fpga;
output              wr_busy_fpga;


// Local wires and registers
//wire   [15:0]                                     cfg_completer_id;
//wire                                              cfg_bus_mstr_enable;
wire                                              cfg_ext_tag_en;
wire   [2:0]                                      cfg_max_rd_req_size;
wire   [2:0]                                      cfg_max_payload_size;

//
// Core input tie-offs
//

assign trn_rnp_ok_n = 1'b0;
assign trn_rcpl_streaming_n = 1'b1;
assign trn_terrfwd_n = 1'b1;

assign cfg_err_cor_n = 1'b1;
assign cfg_err_ur_n = 1'b1;
assign cfg_err_ecrc_n = 1'b1;
assign cfg_err_cpl_timeout_n = 1'b1;
assign cfg_err_cpl_abort_n = 1'b1;
assign cfg_err_cpl_unexpect_n = 1'b1;
assign cfg_err_posted_n = 1'b0;
assign cfg_pm_wake_n = 1'b1;
assign cfg_trn_pending_n = 1'b1;
assign cfg_interrupt_n = 1'b1;
assign cfg_interrupt_assert_n = 1'b0;
assign cfg_interrupt_di = 8'b0;
assign cfg_dwaddr = 0;
assign cfg_rd_en_n = 1;

assign cfg_err_tlp_cpl_header = 0;
assign cfg_di = 0;
assign cfg_byte_en_n = 4'hf;
assign cfg_wr_en_n = 1;
assign cfg_dsn = {32'h00000001,  {{8'h1},24'h000A35}};


//
// Programmable I/O Module
//

wire [15:0] cfg_completer_id = {cfg_bus_number,
                                cfg_device_number,
                                cfg_function_number};

wire cfg_bus_mstr_enable = cfg_command[2];

assign cfg_ext_tag_en = cfg_dcommand[8];
assign cfg_max_rd_req_size = cfg_dcommand[14:12];
assign cfg_max_payload_size = cfg_dcommand[7:5];

  PIO PIO (
        .trn_clk ( trn_clk ),                       // I
        .trn_reset_n ( trn_reset_n ),               // I
        .trn_lnk_up_n ( trn_lnk_up_n ),             // I

        .trn_td ( trn_td ),                         // O [63:0]
        .trn_trem_n ( trn_trem ),                   // O [7:0]
        .trn_tsof_n ( trn_tsof_n ),                 // O
        .trn_teof_n ( trn_teof_n ),                 // O
        .trn_tsrc_rdy_n ( trn_tsrc_rdy_n ),         // O
        .trn_tsrc_dsc_n ( trn_tsrc_dsc_n ),         // O
        .trn_tdst_rdy_n ( trn_tdst_rdy_n ),         // I
        .trn_tdst_dsc_n ( trn_tdst_dsc_n ),         // I

        .trn_rd ( trn_rd ),                         // I [63:0]
        .trn_rrem_n ( trn_rrem ),                   // I [7:0]
        .trn_rsof_n ( trn_rsof_n ),                 // I
        .trn_reof_n ( trn_reof_n ),                 // I
        .trn_rsrc_rdy_n ( trn_rsrc_rdy_n ),         // I
        .trn_rsrc_dsc_n ( trn_rsrc_dsc_n ),         // I

        .trn_rbar_hit_n ( trn_rbar_hit_n ),         // I [6:0]
        .trn_rdst_rdy_n ( trn_rdst_rdy_n ),         // O

        .cfg_to_turnoff_n ( cfg_to_turnoff_n ),     // I
        .cfg_turnoff_ok_n ( cfg_turnoff_ok_n ),     // O

        .cfg_completer_id ( cfg_completer_id ),     // I [15:0]
        .cfg_bus_mstr_enable (cfg_bus_mstr_enable ), // I

        .rd_addr_fpga(rd_addr_fpga), //I [10:0]
        .rd_be_fpga(rd_be_fpga), //I [3:0]
        .rd_data_fpga(rd_data_fpga), //O [31:0]

        .wr_addr_fpga(wr_addr_fpga),  //I ]10:0]
        .wr_be_fpga(wr_be_fpga), //I [7:0]
        .wr_data_fpga(wr_data_fpga), //I [31:0]
        .wr_en_fpga(wr_en_fpga), //I
        .wr_busy_fpga(wr_busy_fpga) //O

        );


endmodule // pci_exp_64b_app
