/*******************************************************************************
*     This file is owned and controlled by Xilinx and must be used             *
*     solely for design, simulation, implementation and creation of            *
*     design files limited to Xilinx devices or technologies. Use              *
*     with non-Xilinx devices or technologies is expressly prohibited          *
*     and immediately terminates your license.                                 *
*                                                                              *
*     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"            *
*     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                  *
*     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION          *
*     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION              *
*     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS                *
*     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                  *
*     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE         *
*     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY                 *
*     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                  *
*     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR           *
*     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF          *
*     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS          *
*     FOR A PARTICULAR PURPOSE.                                                *
*                                                                              *
*     Xilinx products are not intended for use in life support                 *
*     appliances, devices, or systems. Use in such applications are            *
*     expressly prohibited.                                                    *
*                                                                              *
*     (c) Copyright 1995-2007 Xilinx, Inc.                                     *
*     All rights reserved.                                                     *
*******************************************************************************/
// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
endpoint_blk_plus_v1_9 YourInstanceName (
	.pci_exp_txp(pci_exp_txp), // Bus [0 : 0] 
	.pci_exp_txn(pci_exp_txn), // Bus [0 : 0] 
	.pci_exp_rxp(pci_exp_rxp), // Bus [0 : 0] 
	.pci_exp_rxn(pci_exp_rxn), // Bus [0 : 0] 
	.trn_clk(trn_clk),
	.trn_reset_n(trn_reset_n),
	.trn_lnk_up_n(trn_lnk_up_n),
	.trn_td(trn_td), // Bus [63 : 0] 
	.trn_trem_n(trn_trem_n), // Bus [7 : 0] 
	.trn_tsof_n(trn_tsof_n),
	.trn_teof_n(trn_teof_n),
	.trn_tsrc_rdy_n(trn_tsrc_rdy_n),
	.trn_tdst_rdy_n(trn_tdst_rdy_n),
	.trn_tdst_dsc_n(trn_tdst_dsc_n),
	.trn_tsrc_dsc_n(trn_tsrc_dsc_n),
	.trn_terrfwd_n(trn_terrfwd_n),
	.trn_tbuf_av(trn_tbuf_av), // Bus [3 : 0] 
	.trn_rd(trn_rd), // Bus [63 : 0] 
	.trn_rrem_n(trn_rrem_n), // Bus [7 : 0] 
	.trn_rsof_n(trn_rsof_n),
	.trn_reof_n(trn_reof_n),
	.trn_rsrc_rdy_n(trn_rsrc_rdy_n),
	.trn_rsrc_dsc_n(trn_rsrc_dsc_n),
	.trn_rdst_rdy_n(trn_rdst_rdy_n),
	.trn_rerrfwd_n(trn_rerrfwd_n),
	.trn_rnp_ok_n(trn_rnp_ok_n),
	.trn_rbar_hit_n(trn_rbar_hit_n), // Bus [6 : 0] 
	.trn_rfc_nph_av(trn_rfc_nph_av), // Bus [7 : 0] 
	.trn_rfc_npd_av(trn_rfc_npd_av), // Bus [11 : 0] 
	.trn_rfc_ph_av(trn_rfc_ph_av), // Bus [7 : 0] 
	.trn_rfc_pd_av(trn_rfc_pd_av), // Bus [11 : 0] 
	.trn_rcpl_streaming_n(trn_rcpl_streaming_n),
	.cfg_do(cfg_do), // Bus [31 : 0] 
	.cfg_rd_wr_done_n(cfg_rd_wr_done_n),
	.cfg_di(cfg_di), // Bus [31 : 0] 
	.cfg_byte_en_n(cfg_byte_en_n), // Bus [3 : 0] 
	.cfg_dwaddr(cfg_dwaddr), // Bus [9 : 0] 
	.cfg_wr_en_n(cfg_wr_en_n),
	.cfg_rd_en_n(cfg_rd_en_n),
	.cfg_err_cor_n(cfg_err_cor_n),
	.cfg_err_ur_n(cfg_err_ur_n),
	.cfg_err_ecrc_n(cfg_err_ecrc_n),
	.cfg_err_cpl_timeout_n(cfg_err_cpl_timeout_n),
	.cfg_err_cpl_abort_n(cfg_err_cpl_abort_n),
	.cfg_err_cpl_unexpect_n(cfg_err_cpl_unexpect_n),
	.cfg_err_posted_n(cfg_err_posted_n),
	.cfg_err_locked_n(cfg_err_locked_n),
	.cfg_err_tlp_cpl_header(cfg_err_tlp_cpl_header), // Bus [47 : 0] 
	.cfg_err_cpl_rdy_n(cfg_err_cpl_rdy_n),
	.cfg_interrupt_n(cfg_interrupt_n),
	.cfg_interrupt_rdy_n(cfg_interrupt_rdy_n),
	.cfg_interrupt_assert_n(cfg_interrupt_assert_n),
	.cfg_interrupt_di(cfg_interrupt_di), // Bus [7 : 0] 
	.cfg_interrupt_do(cfg_interrupt_do), // Bus [7 : 0] 
	.cfg_interrupt_mmenable(cfg_interrupt_mmenable), // Bus [2 : 0] 
	.cfg_interrupt_msienable(cfg_interrupt_msienable),
	.cfg_to_turnoff_n(cfg_to_turnoff_n),
	.cfg_pm_wake_n(cfg_pm_wake_n),
	.cfg_pcie_link_state_n(cfg_pcie_link_state_n), // Bus [2 : 0] 
	.cfg_trn_pending_n(cfg_trn_pending_n),
	.cfg_bus_number(cfg_bus_number), // Bus [7 : 0] 
	.cfg_device_number(cfg_device_number), // Bus [4 : 0] 
	.cfg_function_number(cfg_function_number), // Bus [2 : 0] 
	.cfg_dsn(cfg_dsn), // Bus [63 : 0] 
	.cfg_status(cfg_status), // Bus [15 : 0] 
	.cfg_command(cfg_command), // Bus [15 : 0] 
	.cfg_dstatus(cfg_dstatus), // Bus [15 : 0] 
	.cfg_dcommand(cfg_dcommand), // Bus [15 : 0] 
	.cfg_lstatus(cfg_lstatus), // Bus [15 : 0] 
	.cfg_lcommand(cfg_lcommand), // Bus [15 : 0] 
	.fast_train_simulation_only(fast_train_simulation_only),
	.sys_clk(sys_clk),
	.refclkout(refclkout),
	.sys_reset_n(sys_reset_n));

// INST_TAG_END ------ End INSTANTIATION Template ---------
