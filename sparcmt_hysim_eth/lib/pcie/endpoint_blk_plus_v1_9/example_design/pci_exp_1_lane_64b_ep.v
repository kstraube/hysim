

/******************************************************************************

    COPYRIGHT 2008, XILINX, INC.
    ALL RIGHTS RESERVED

    File name:     endpoint_blk_plus_v1_9.v 


******************************************************************************/

module   endpoint_blk_plus_v1_9 (

            // PCI Express Fabric Interface
            //------------------------------

            pci_exp_txp,
            pci_exp_txn,
            pci_exp_rxp,
            pci_exp_rxn,

            // Transaction (TRN) Interface
            //----------------------------

            trn_clk,
            trn_reset_n,
            trn_lnk_up_n,

            // Tx
            trn_td,
            trn_trem_n,
            trn_tsof_n,
            trn_teof_n,
            trn_tsrc_rdy_n,
            trn_tdst_rdy_n,
            trn_tdst_dsc_n,
            trn_tsrc_dsc_n,
            trn_terrfwd_n,
            trn_tbuf_av,

            // Rx
            trn_rd,
            trn_rrem_n,
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

            // Host (CFG) Interface
            //---------------------

            cfg_do,
            cfg_rd_wr_done_n,
            cfg_di,
            cfg_byte_en_n,
            cfg_dwaddr,
            cfg_wr_en_n,
            cfg_rd_en_n,

            cfg_err_ur_n,
            cfg_err_cpl_rdy_n,
            cfg_err_cor_n,
            cfg_err_ecrc_n,
            cfg_err_cpl_timeout_n,
            cfg_err_cpl_abort_n,
            cfg_err_cpl_unexpect_n,
            cfg_err_posted_n,
            cfg_err_tlp_cpl_header,
            cfg_err_locked_n,
            cfg_interrupt_n,
            cfg_interrupt_rdy_n,

            cfg_interrupt_assert_n,
            cfg_interrupt_di,
            cfg_interrupt_do,
            cfg_interrupt_mmenable,
            cfg_interrupt_msienable,

            cfg_to_turnoff_n,
            cfg_pm_wake_n,
            cfg_pcie_link_state_n,
            cfg_trn_pending_n,
            cfg_dsn,

            cfg_bus_number,
            cfg_device_number,
            cfg_function_number,
            cfg_status,
            cfg_command,
            cfg_dstatus,
            cfg_dcommand,
            cfg_lstatus,
            cfg_lcommand,    

            //cfg_cfg,
            fast_train_simulation_only,

            // System (SYS) Interface
            //-----------------------
            sys_clk,
            sys_reset_n,
            refclkout

            ); //synthesis syn_black_box

    //-------------------------------------------------------
    // 1. PCI-Express (PCI_EXP) Interface
    //-------------------------------------------------------

    // Tx
    output  [(1 - 1):0]          pci_exp_txp;
    output  [(1 - 1):0]          pci_exp_txn;

    // Rx
    input   [(1 - 1):0]          pci_exp_rxp;
    input   [(1 - 1):0]          pci_exp_rxn;

    //-------------------------------------------------------
    // 2. Transaction (TRN) Interface
    //-------------------------------------------------------

    // Common
    output                                         trn_clk;
    output                                         trn_reset_n;
    output                                         trn_lnk_up_n;

    // Tx
    input   [(64 - 1):0]      trn_td;
    input   [(8 - 1):0]       trn_trem_n;
    input                                          trn_tsof_n;
    input                                          trn_teof_n;
    input                                          trn_tsrc_rdy_n;
    output                                         trn_tdst_rdy_n;
    output                                         trn_tdst_dsc_n;
    input                                          trn_tsrc_dsc_n;
    input                                          trn_terrfwd_n;
    output  [(4 - 1):0]    trn_tbuf_av;
    
    // Rx
    output  [(64 - 1):0]      trn_rd;
    output  [(8 - 1):0]       trn_rrem_n;
    output                                         trn_rsof_n;
    output                                         trn_reof_n;
    output                                         trn_rsrc_rdy_n;
    output                                         trn_rsrc_dsc_n;
    input                                          trn_rdst_rdy_n;
    output                                         trn_rerrfwd_n;
    input                                          trn_rnp_ok_n;
    output  [(7 - 1):0]   trn_rbar_hit_n;
    output  [(8 - 1):0]    trn_rfc_nph_av;
    output  [(12 - 1):0]   trn_rfc_npd_av;
    output  [(8 - 1):0]    trn_rfc_ph_av;
    output  [(12 - 1):0]   trn_rfc_pd_av;
    input                                          trn_rcpl_streaming_n;

    //-------------------------------------------------------
    // 3. Host (CFG) Interface
    //-------------------------------------------------------

    output  [(32 - 1):0]      cfg_do;
    output                                         cfg_rd_wr_done_n;
    input   [(32 - 1):0]      cfg_di;
    input   [(32/8 - 1):0]    cfg_byte_en_n;
    input   [(10 - 1):0]      cfg_dwaddr;
    input                                          cfg_wr_en_n;
    input                                          cfg_rd_en_n;

    input                                          cfg_err_ur_n;
    output                                         cfg_err_cpl_rdy_n;
    input                                          cfg_err_cor_n;
    input                                          cfg_err_ecrc_n;
    input                                          cfg_err_cpl_timeout_n;
    input                                          cfg_err_cpl_abort_n;
    input                                          cfg_err_cpl_unexpect_n;
    input                                          cfg_err_posted_n;
    input                                          cfg_err_locked_n;
    input   [(48 - 1):0]    cfg_err_tlp_cpl_header;
    input                                          cfg_interrupt_n;
    output                                         cfg_interrupt_rdy_n;

    input                                          cfg_interrupt_assert_n;
    input   [7:0]                                  cfg_interrupt_di;
    output  [7:0]                                  cfg_interrupt_do;
    output  [2:0]                                  cfg_interrupt_mmenable;
    output                                         cfg_interrupt_msienable;

    output                                         cfg_to_turnoff_n;
    input                                          cfg_pm_wake_n;
    output  [(3 - 1):0]     cfg_pcie_link_state_n;
    input                                          cfg_trn_pending_n;
    input   [(64 - 1):0]       cfg_dsn;
    output  [(8 - 1):0]    cfg_bus_number;
    output  [(5 - 1):0]    cfg_device_number;
    output  [(3 - 1):0]    cfg_function_number;
    output  [(16 - 1):0]       cfg_status;
    output  [(16 - 1):0]       cfg_command;
    output  [(16 - 1):0]       cfg_dstatus;
    output  [(16 - 1):0]       cfg_dcommand;
    output  [(16 - 1):0]       cfg_lstatus;
    output  [(16 - 1):0]       cfg_lcommand;

    //input   [(1024 - 1):0]       cfg_cfg;
    input                                          fast_train_simulation_only; 

    //-------------------------------------------------------
    // 4. System (SYS) Interface
    //-------------------------------------------------------

    input                                          sys_clk;
    input                                          sys_reset_n;
    output                                         refclkout;

endmodule // endpoint_blk_plus_v1_9
