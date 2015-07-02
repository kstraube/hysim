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
// Filename: xilinx_pci_exp_ep.v
//
// Description:  PCI Express Endpoint Core example design top level wrapper.
//
//------------------------------------------------------------------------------
module     xilinx_pci_exp_ep (
                        // PCI Express Fabric Interface

                        pci_exp_txp,
                        pci_exp_txn,
                        pci_exp_rxp,
                        pci_exp_rxn,

                        // System (SYS) Interface

                        sys_clk_p,
                        sys_clk_n,
                        sys_reset_n,
			refclkout,

                        // FPGA interface
                        rd_addr_fpga,
                        rd_be_fpga,
                        rd_data_fpga,

                        wr_addr_fpga,
                        wr_be_fpga,
                        wr_data_fpga,
                        wr_en_fpga,
                        wr_busy_fpga
                        );//synthesis syn_noclockbuf=1

    //-------------------------------------------------------
    // 1. PCI Express Fabric Interface
    //-------------------------------------------------------

    // Tx
    output    [(1 - 1):0]           pci_exp_txp;
    output    [(1 - 1):0]           pci_exp_txn;

    // Rx
    input     [(1 - 1):0]           pci_exp_rxp;
    input     [(1 - 1):0]           pci_exp_rxn;


    //-------------------------------------------------------
    // 4. System (SYS) Interface
    //-------------------------------------------------------

    input                                             sys_clk_p;
    input                                             sys_clk_n;
    input                                             sys_reset_n;
    output					      refclkout;

    //FPGA interface
    input  [10:0]      rd_addr_fpga;
    input  [3:0]       rd_be_fpga;
    output  [31:0]      rd_data_fpga;

    input  [10:0]      wr_addr_fpga;
    input  [7:0]       wr_be_fpga;
    input  [31:0]      wr_data_fpga;
    input              wr_en_fpga;
    output              wr_busy_fpga;


    //-------------------------------------------------------
    // Local Wires
    //-------------------------------------------------------

    wire                                              sys_clk_c;
    wire                                              sys_reset_n_c; 
    wire                                              trn_clk_c;//synthesis attribute max_fanout of trn_clk_c is "100000"
    wire                                              trn_reset_n_c;
    wire                                              trn_lnk_up_n_c;
    wire                                              cfg_trn_pending_n_c;
    wire [(64 - 1):0]             cfg_dsn_n_c;
    wire                                              trn_tsof_n_c;
    wire                                              trn_teof_n_c;
    wire                                              trn_tsrc_rdy_n_c;
    wire                                              trn_tdst_rdy_n_c;
    wire                                              trn_tsrc_dsc_n_c;
    wire                                              trn_terrfwd_n_c;
    wire                                              trn_tdst_dsc_n_c;
    wire    [(64 - 1):0]         trn_td_c;
    wire    [7:0]          trn_trem_n_c;
    wire    [( 4 -1 ):0]       trn_tbuf_av_c;

    wire                                              trn_rsof_n_c;
    wire                                              trn_reof_n_c;
    wire                                              trn_rsrc_rdy_n_c;
    wire                                              trn_rsrc_dsc_n_c;
    wire                                              trn_rdst_rdy_n_c;
    wire                                              trn_rerrfwd_n_c;
    wire                                              trn_rnp_ok_n_c;

    wire    [(64 - 1):0]         trn_rd_c;
    wire    [7:0]          trn_rrem_n_c;
    wire    [6:0]      trn_rbar_hit_n_c;
    wire    [7:0]       trn_rfc_nph_av_c;
    wire    [11:0]      trn_rfc_npd_av_c;
    wire    [7:0]       trn_rfc_ph_av_c;
    wire    [11:0]      trn_rfc_pd_av_c;
    wire                                              trn_rcpl_streaming_n_c;

    wire    [31:0]         cfg_do_c;
    wire    [31:0]         cfg_di_c;
    wire    [9:0]         cfg_dwaddr_c;
    wire    [3:0]       cfg_byte_en_n_c;
    wire    [47:0]       cfg_err_tlp_cpl_header_c;

    wire                                              cfg_wr_en_n_c;
    wire                                              cfg_rd_en_n_c;
    wire                                              cfg_rd_wr_done_n_c;
    wire                                              cfg_err_cor_n_c;
    wire                                              cfg_err_ur_n_c;
    wire                                              cfg_err_cpl_rdy_n_c;
    wire                                              cfg_err_ecrc_n_c;
    wire                                              cfg_err_cpl_timeout_n_c;
    wire                                              cfg_err_cpl_abort_n_c;
    wire                                              cfg_err_cpl_unexpect_n_c;
    wire                                              cfg_err_posted_n_c;
    wire                                              cfg_err_locked_n_c;
    wire                                              cfg_interrupt_n_c;
    wire                                              cfg_interrupt_rdy_n_c;

    wire                                              cfg_interrupt_assert_n_c;
    wire [7 : 0]                                      cfg_interrupt_di_c;
    wire [7 : 0]                                      cfg_interrupt_do_c;
    wire [2 : 0]                                      cfg_interrupt_mmenable_c;
    wire                                              cfg_interrupt_msienable_c;

    wire                                              cfg_turnoff_ok_n_c;
    wire                                              cfg_to_turnoff_n;
    wire                                              cfg_pm_wake_n_c;
    wire    [2:0]        cfg_pcie_link_state_n_c;
    wire    [7:0]       cfg_bus_number_c;
    wire    [4:0]       cfg_device_number_c;
    wire    [2:0]       cfg_function_number_c;
    wire    [15:0]          cfg_status_c;
    wire    [15:0]          cfg_command_c;
    wire    [15:0]          cfg_dstatus_c;
    wire    [15:0]          cfg_dcommand_c;
    wire    [15:0]          cfg_lstatus_c;
    wire    [15:0]          cfg_lcommand_c;


//-------------------------------------------------------
// Virtex5-FX Global Clock Buffer
//-------------------------------------------------------
  IBUFDS refclk_ibuf (.O(sys_clk_c), .I(sys_clk_p), .IB(sys_clk_n));  // 100 MHz


  //-------------------------------------------------------
  // System Reset Input Pad Instance
  //-------------------------------------------------------

  IBUF sys_reset_n_ibuf (.O(sys_reset_n_c), .I(sys_reset_n));



  //-------------------------------------------------------
  // Endpoint Implementation Application
  //-------------------------------------------------------
pci_exp_64b_app app (


      //
      // Transaction ( TRN ) Interface
      //

      .trn_clk( trn_clk_c ),                   // I
      .trn_reset_n( trn_reset_n_c ),           // I
      .trn_lnk_up_n( trn_lnk_up_n_c ),         // I

      // Tx Local-Link

      .trn_td( trn_td_c ),                     // O [63/31:0]
      .trn_trem( trn_trem_n_c ),               // O [7:0]
      .trn_tsof_n( trn_tsof_n_c ),             // O
      .trn_teof_n( trn_teof_n_c ),             // O
      .trn_tsrc_rdy_n( trn_tsrc_rdy_n_c ),     // O
      .trn_tsrc_dsc_n( trn_tsrc_dsc_n_c ),     // O
      .trn_tdst_rdy_n( trn_tdst_rdy_n_c ),     // I
      .trn_tdst_dsc_n( trn_tdst_dsc_n_c ),     // I
      .trn_terrfwd_n( trn_terrfwd_n_c ),       // O
      .trn_tbuf_av( trn_tbuf_av_c ),           // I [4/3:0]


      // Rx Local-Link

      .trn_rd( trn_rd_c ),                     // I [63/31:0]
      .trn_rrem( trn_rrem_n_c ),               // I [7:0]
      .trn_rsof_n( trn_rsof_n_c ),             // I
      .trn_reof_n( trn_reof_n_c ),             // I
      .trn_rsrc_rdy_n( trn_rsrc_rdy_n_c ),     // I
      .trn_rsrc_dsc_n( trn_rsrc_dsc_n_c ),     // I
      .trn_rdst_rdy_n( trn_rdst_rdy_n_c ),     // O
      .trn_rerrfwd_n( trn_rerrfwd_n_c ),       // I
      .trn_rnp_ok_n( trn_rnp_ok_n_c ),         // O
      .trn_rbar_hit_n( trn_rbar_hit_n_c ),     // I [6:0]
      .trn_rfc_npd_av( trn_rfc_npd_av_c ),     // I [11:0]
      .trn_rfc_nph_av( trn_rfc_nph_av_c ),     // I [7:0]
      .trn_rfc_pd_av( trn_rfc_pd_av_c ),       // I [11:0]
      .trn_rfc_ph_av( trn_rfc_ph_av_c ),       // I [7:0]
      .trn_rcpl_streaming_n( trn_rcpl_streaming_n_c ),  // O

      //
      // Host ( CFG ) Interface
      //

      .cfg_do( cfg_do_c ),                                   // I [31:0]
      .cfg_rd_wr_done_n( cfg_rd_wr_done_n_c ),               // I
      .cfg_di( cfg_di_c ),                                   // O [31:0]
      .cfg_byte_en_n( cfg_byte_en_n_c ),                     // O
      .cfg_dwaddr( cfg_dwaddr_c ),                           // O
      .cfg_wr_en_n( cfg_wr_en_n_c ),                         // O
      .cfg_rd_en_n( cfg_rd_en_n_c ),                         // O
      .cfg_err_cor_n( cfg_err_cor_n_c ),                     // O
      .cfg_err_ur_n( cfg_err_ur_n_c ),                       // O
      .cfg_err_cpl_rdy_n( cfg_err_cpl_rdy_n_c ),             // I
      .cfg_err_ecrc_n( cfg_err_ecrc_n_c ),                   // O
      .cfg_err_cpl_timeout_n( cfg_err_cpl_timeout_n_c ),     // O
      .cfg_err_cpl_abort_n( cfg_err_cpl_abort_n_c ),         // O
      .cfg_err_cpl_unexpect_n( cfg_err_cpl_unexpect_n_c ),   // O
      .cfg_err_posted_n( cfg_err_posted_n_c ),               // O
      .cfg_err_tlp_cpl_header( cfg_err_tlp_cpl_header_c ),   // O [47:0]
      .cfg_interrupt_n( cfg_interrupt_n_c ),                 // O
      .cfg_interrupt_rdy_n( cfg_interrupt_rdy_n_c ),         // I

      .cfg_interrupt_assert_n(cfg_interrupt_assert_n_c),     // O
      .cfg_interrupt_di(cfg_interrupt_di_c),                 // O [7:0]
      .cfg_interrupt_do(cfg_interrupt_do_c),                 // I [7:0]
      .cfg_interrupt_mmenable(cfg_interrupt_mmenable_c),     // I [2:0]
      .cfg_interrupt_msienable(cfg_interrupt_msienable_c),   // I
      .cfg_turnoff_ok_n( cfg_turnoff_ok_n_c ),               // O
      .cfg_to_turnoff_n( cfg_to_turnoff_n_c ),               // I
      .cfg_pm_wake_n( cfg_pm_wake_n_c ),                     // O
      .cfg_pcie_link_state_n( cfg_pcie_link_state_n_c ),     // I [2:0]
      .cfg_trn_pending_n( cfg_trn_pending_n_c ),             // O
      .cfg_dsn( cfg_dsn_n_c),                                // O [63:0]

      .cfg_bus_number( cfg_bus_number_c ),                   // I [7:0]
      .cfg_device_number( cfg_device_number_c ),             // I [4:0]
      .cfg_function_number( cfg_function_number_c ),         // I [2:0]
      .cfg_status( cfg_status_c ),                           // I [15:0]
      .cfg_command( cfg_command_c ),                         // I [15:0]
      .cfg_dstatus( cfg_dstatus_c ),                         // I [15:0]
      .cfg_dcommand( cfg_dcommand_c ),                       // I [15:0]
      .cfg_lstatus( cfg_lstatus_c ),                         // I [15:0]
      .cfg_lcommand( cfg_lcommand_c ),                        // I [15:0]

      .rd_addr_fpga(rd_addr_fpga), //I [10:0]
      .rd_be_fpga(rd_be_fpga), //I [3:0]
      .rd_data_fpga(rd_data_fpga), //O [31:0]

      .wr_addr_fpga(wr_addr_fpga),  //I ]10:0]
      .wr_be_fpga(wr_be_fpga), //I [7:0]
      .wr_data_fpga(wr_data_fpga), //I [31:0]
      .wr_en_fpga(wr_en_fpga), //I
      .wr_busy_fpga(wr_busy_fpga) //O

      );


pcieblk ep  (

       //
      // PCI Express Fabric Interface
      //

      .pci_exp_txp( pci_exp_txp ),             // O [7/3/0:0]
      .pci_exp_txn( pci_exp_txn ),             // O [7/3/0:0]
      .pci_exp_rxp( pci_exp_rxp ),             // O [7/3/0:0]
      .pci_exp_rxn( pci_exp_rxn ),             // O [7/3/0:0]


      //
      // System ( SYS ) Interface
      //

      .sys_clk( sys_clk_c ),                                 // I
       .sys_reset_n( sys_reset_n_c ),                         // I
      .refclkout( refclkout ),       // O

      //
      // Transaction ( TRN ) Interface
      //

      .trn_clk( trn_clk_c ),                   // O
      .trn_reset_n( trn_reset_n_c ),           // O
      .trn_lnk_up_n( trn_lnk_up_n_c ),         // O

      // Tx Local-Link

      .trn_td( trn_td_c ),                     // I [63/31:0]
        .trn_trem_n( trn_trem_n_c ),             // I [7:0]
      .trn_tsof_n( trn_tsof_n_c ),             // I
      .trn_teof_n( trn_teof_n_c ),             // I
      .trn_tsrc_rdy_n( trn_tsrc_rdy_n_c ),     // I
      .trn_tsrc_dsc_n( trn_tsrc_dsc_n_c ),     // I
      .trn_tdst_rdy_n( trn_tdst_rdy_n_c ),     // O
      .trn_tdst_dsc_n( trn_tdst_dsc_n_c ),     // O
      .trn_terrfwd_n( trn_terrfwd_n_c ),       // I
      .trn_tbuf_av( trn_tbuf_av_c ),           // O [4/3:0]

      // Rx Local-Link

      .trn_rd( trn_rd_c ),                     // O [63/31:0]
        .trn_rrem_n( trn_rrem_n_c ),             // O [7:0]
      .trn_rsof_n( trn_rsof_n_c ),             // O
      .trn_reof_n( trn_reof_n_c ),             // O
      .trn_rsrc_rdy_n( trn_rsrc_rdy_n_c ),     // O
      .trn_rsrc_dsc_n( trn_rsrc_dsc_n_c ),     // O
      .trn_rdst_rdy_n( trn_rdst_rdy_n_c ),     // I
      .trn_rerrfwd_n( trn_rerrfwd_n_c ),       // O
      .trn_rnp_ok_n( trn_rnp_ok_n_c ),         // I
      .trn_rbar_hit_n( trn_rbar_hit_n_c ),     // O [6:0]
      .trn_rfc_nph_av( trn_rfc_nph_av_c ),     // O [11:0]
      .trn_rfc_npd_av( trn_rfc_npd_av_c ),     // O [7:0]
      .trn_rfc_ph_av( trn_rfc_ph_av_c ),       // O [11:0]
      .trn_rfc_pd_av( trn_rfc_pd_av_c ),       // O [7:0]
      .trn_rcpl_streaming_n( trn_rcpl_streaming_n_c ),       // I

      //
      // Host ( CFG ) Interface
      //

      .cfg_do( cfg_do_c ),                                    // O [31:0]
      .cfg_rd_wr_done_n( cfg_rd_wr_done_n_c ),                // O
      .cfg_di( cfg_di_c ),                                    // I [31:0]
      .cfg_byte_en_n( cfg_byte_en_n_c ),                      // I [3:0]
      .cfg_dwaddr( cfg_dwaddr_c ),                            // I [9:0]
      .cfg_wr_en_n( cfg_wr_en_n_c ),                          // I
      .cfg_rd_en_n( cfg_rd_en_n_c ),                          // I

      .cfg_err_cor_n( cfg_err_cor_n_c ),                      // I
      .cfg_err_ur_n( cfg_err_ur_n_c ),                        // I
      .cfg_err_cpl_rdy_n( cfg_err_cpl_rdy_n_c ),              // O
      .cfg_err_ecrc_n( cfg_err_ecrc_n_c ),                    // I
      .cfg_err_cpl_timeout_n( cfg_err_cpl_timeout_n_c ),      // I
      .cfg_err_cpl_abort_n( cfg_err_cpl_abort_n_c ),          // I
      .cfg_err_cpl_unexpect_n( cfg_err_cpl_unexpect_n_c ),    // I
      .cfg_err_posted_n( cfg_err_posted_n_c ),                // I
      .cfg_err_tlp_cpl_header( cfg_err_tlp_cpl_header_c ),    // I [47:0]
      .cfg_err_locked_n( 1'b1 ),                // I
      .cfg_interrupt_n( cfg_interrupt_n_c ),                  // I
      .cfg_interrupt_rdy_n( cfg_interrupt_rdy_n_c ),          // O

      .cfg_interrupt_assert_n(cfg_interrupt_assert_n_c),      // I
      .cfg_interrupt_di(cfg_interrupt_di_c),                  // I [7:0]
      .cfg_interrupt_do(cfg_interrupt_do_c),                  // O [7:0]
      .cfg_interrupt_mmenable(cfg_interrupt_mmenable_c),      // O [2:0]
      .cfg_interrupt_msienable(cfg_interrupt_msienable_c),    // O
      .cfg_to_turnoff_n( cfg_to_turnoff_n_c ),                // I
      .cfg_pm_wake_n( cfg_pm_wake_n_c ),                      // I
      .cfg_pcie_link_state_n( cfg_pcie_link_state_n_c ),      // O [2:0]
      .cfg_trn_pending_n( cfg_trn_pending_n_c ),              // I
      .cfg_bus_number( cfg_bus_number_c ),                    // O [7:0]
      .cfg_device_number( cfg_device_number_c ),              // O [4:0]
      .cfg_function_number( cfg_function_number_c ),          // O [2:0]
      .cfg_status( cfg_status_c ),                            // O [15:0]
      .cfg_command( cfg_command_c ),                          // O [15:0]
      .cfg_dstatus( cfg_dstatus_c ),                          // O [15:0]
      .cfg_dcommand( cfg_dcommand_c ),                        // O [15:0]
      .cfg_lstatus( cfg_lstatus_c ),                          // O [15:0]
      .cfg_lcommand( cfg_lcommand_c ),                        // O [15:0]
      .cfg_dsn( cfg_dsn_n_c),                                 // I [63:0]


       // The following is used for simulation only.  Setting
       // the following core input to 1 will result in a fast
       // train simulation to happen.  This bit should not be set
       // during synthesis or the core may not operate properly.
       `ifdef SIMULATION
       .fast_train_simulation_only(1'b1)
       `else
       .fast_train_simulation_only(1'b0)
       `endif

);

 

endmodule // XILINX_PCI_EXP_EP
