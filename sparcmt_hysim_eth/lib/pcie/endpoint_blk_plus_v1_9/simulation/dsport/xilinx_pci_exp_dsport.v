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
// Filename: xilinx_pci_exp_dsport.v
//
// Description:  PCI Express Downstream Port
//
//------------------------------------------------------------------------------

module xilinx_pci_exp_1_lane_dsport (


// PCI Express Fabric Interface
pci_exp_txp,
pci_exp_txn,
pci_exp_rxp,
pci_exp_rxn,

// Transaction (TRN) Interface
trn_clk,
trn_reset_n,
trn_lnk_up_n,
cfg_trn_pending_n,

// Tx
trn_td,
trn_trem_n,
trn_tsof_n,
trn_teof_n,
trn_tsrc_rdy_n,
trn_tdst_rdy_n,
trn_tsrc_dsc_n,
trn_terrfwd_n,
trn_tdst_dsc_n,
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
trn_rfc_cplh_av,
trn_rfc_cpld_av,

// Host (CFG) Interface
cfg_do,
cfg_rd_wr_done_n,
cfg_di,
cfg_byte_en_n,
cfg_dwaddr,
cfg_wr_en_n,
cfg_rd_en_n,
cfg_err_cor_n,
cfg_err_ur_n,
cfg_err_ecrc_n,
cfg_err_cpl_timeout_n,
cfg_err_cpl_abort_n,
cfg_err_cpl_unexpect_n,
cfg_err_posted_n,
cfg_err_tlp_cpl_header,
cfg_interrupt_n,
cfg_interrupt_rdy_n,
cfg_turnoff_ok_n,
cfg_to_turnoff_n,
cfg_pcie_link_state_n,
cfg_pm_wake_n,
cfg_bus_number,
cfg_device_number,
cfg_function_number,
cfg_status,
cfg_command,
cfg_dstatus,
cfg_dcommand,
cfg_lstatus,
cfg_lcommand,

// System (SYS) Interface
sys_clk_p,
sys_clk_n,
sys_reset_n
); //synthesis syn_noclockbuf=1


//-------------------------------------------------------
// 1. PCI Express Fabric Interface
//-------------------------------------------------------

// Tx
output	[(1 - 1):0]			pci_exp_txp;
output	[(1 - 1):0]			pci_exp_txn;

// Rx
input	  [(1 - 1):0]			pci_exp_rxp;
input [(1 - 1):0]			pci_exp_rxn;


//-------------------------------------------------------
// 2. Transaction (TRN) Interface
//-------------------------------------------------------

// Common
output trn_clk;
output trn_reset_n;
output trn_lnk_up_n;

// Tx
input [(64 - 1):0] trn_td;
input [(8 - 1):0]  trn_trem_n;
input              trn_tsof_n;
input              trn_teof_n;
input              trn_tsrc_rdy_n;
output             trn_tdst_rdy_n;
input              trn_tsrc_dsc_n;
input              trn_terrfwd_n;
output             trn_tdst_dsc_n;
output [(5 - 1):0] trn_tbuf_av;

// Rx
output [(64 - 1):0] trn_rd;
output [(8 - 1):0]  trn_rrem_n;
output              trn_rsof_n;
output              trn_reof_n;
output              trn_rsrc_rdy_n;
output              trn_rsrc_dsc_n;
input               trn_rdst_rdy_n;
output              trn_rerrfwd_n;
input               trn_rnp_ok_n;

output [(7 - 1):0] trn_rbar_hit_n;
output [(8 - 1):0]	 trn_rfc_nph_av;
output [(12 - 1):0] trn_rfc_npd_av;
output [(8 - 1):0]	 trn_rfc_ph_av;
output [(12 - 1):0] trn_rfc_pd_av;
output [(8 - 1):0]  trn_rfc_cplh_av;
output [(12 - 1):0] trn_rfc_cpld_av;

//-------------------------------------------------------
// 3. Host (CFG) Interface
//-------------------------------------------------------

output 	[(32 - 1):0]   cfg_do;
input	[(32 - 1):0]	 cfg_di;
input 	[(32/8 - 1):0] cfg_byte_en_n;
input 	[(10 - 1):0]   cfg_dwaddr;

output cfg_rd_wr_done_n;
input  cfg_wr_en_n;
input  cfg_rd_en_n;
input  cfg_err_cor_n;
input  cfg_err_ur_n;
input  cfg_err_ecrc_n;
input  cfg_err_cpl_timeout_n;
input  cfg_err_cpl_abort_n;
input  cfg_err_cpl_unexpect_n;
input  cfg_err_posted_n;
input  cfg_interrupt_n;
output cfg_interrupt_rdy_n;
input  cfg_turnoff_ok_n;
output cfg_to_turnoff_n;
input  cfg_pm_wake_n;
input  cfg_trn_pending_n;
output [(3 - 1):0]    cfg_pcie_link_state_n;
input  [(48 - 1):0]	  cfg_err_tlp_cpl_header;
output [(8 - 1):0]   cfg_bus_number;
output [(5 - 1):0]	  cfg_device_number;
output [(3 - 1):0]	  cfg_function_number;
output [(16 - 1):0]      cfg_status;
output [(16 - 1):0]      cfg_command;
output [(16 - 1):0]      cfg_dstatus;
output [(16 - 1):0]      cfg_dcommand;
output [(16 - 1):0]      cfg_lstatus;
output [(16 - 1):0]      cfg_lcommand;


//-------------------------------------------------------
// 4. System (SYS) Interface
//-------------------------------------------------------

input sys_clk_p;
input sys_clk_n;
input sys_reset_n;

genvar i;

wire sys_clk_c;
wire [(1024 - 1):0] cfg_cfg;
wire sys_reset_n_c;
wire trn_clk_c;
wire trn_reset_n_c;
wire trn_lnk_up_n_c;
wire trn_tsof_n_c;
wire trn_teof_n_c;
wire trn_tsrc_rdy_n_c;
wire trn_tdst_rdy_n_c;
wire trn_tsrc_dsc_n_c;
wire trn_terrfwd_n_c;
wire trn_tdst_dsc_n_c;
wire [(64 - 1):0] trn_td_c;
wire [(8 - 1):0]  trn_trem_n_c;


wire [(5 - 1):0] trn_tbuf_av_c;

wire trn_rsof_n_c;
wire trn_reof_n_c;
wire trn_rsrc_rdy_n_c;
wire trn_rsrc_dsc_n_c;
wire trn_rdst_rdy_n_c;
wire trn_rerrfwd_n_c;
wire trn_rnp_ok_n_c;
wire [(64 - 1):0] trn_rd_c;
wire [(8 - 1):0]  trn_rrem_n_c;

wire	[(7 - 1):0]	trn_rbar_hit_n_c;
wire [(8 - 1):0] trn_rfc_nph_av_c;
wire [(12 - 1):0]	trn_rfc_npd_av_c;
wire [(8 - 1):0]   trn_rfc_ph_av_c;
wire [(12 - 1):0]  trn_rfc_pd_av_c;
wire [(8 - 1):0]   trn_rfc_cplh_av_c;
wire [(12 - 1):0]  trn_rfc_cpld_av_c;

wire [(32 - 1):0] cfg_do_c;
wire [(32 - 1):0] cfg_di_c;
wire [(10 - 1):0] cfg_dwaddr_c;
wire [(32/8 - 1):0] cfg_byte_en_n_c;
wire [(48 - 1):0] cfg_err_tlp_cpl_header_c;
wire cfg_wr_en_n_c;
wire cfg_rd_en_n_c;
wire cfg_rd_wr_done_n_c;
wire cfg_err_cor_n_c;
wire cfg_err_ur_n_c;
wire cfg_err_ecrc_n_c;
wire cfg_err_cpl_timeout_n_c;
wire cfg_err_cpl_abort_n_c;
wire cfg_err_cpl_unexpect_n_c;
wire cfg_err_posted_n_c;
wire cfg_interrupt_n_c;
wire cfg_interrupt_rdy_n_c;
wire cfg_turnoff_ok_n_c;
wire cfg_to_turnoff_n;
wire cfg_pm_wake_n_c;
wire cfg_trn_pending_n_c;
wire [(3 - 1):0]  cfg_pcie_link_state_n_c;
wire [(8 - 1):0]  cfg_bus_number_c;
wire [(5 - 1):0]  cfg_device_number_c;
wire [(3 - 1):0]  cfg_function_number_c;
wire [(16- 1):0] cfg_status_c;
wire [(16 - 1):0] cfg_command_c;
wire [(16 - 1):0] cfg_dstatus_c;
wire [(16 - 1):0] cfg_dcommand_c;
wire [(16 - 1):0] cfg_lstatus_c;
wire [(16 - 1):0] cfg_lcommand_c;


// Clock Pad Instance

GT11CLK_MGT sys_clk_mgt (
  .SYNCLK1OUT(sys_clk_c),
  .SYNCLK2OUT(),
  .MGTCLKP(sys_clk_p),
  .MGTCLKN(sys_clk_n)
);
// synthesis attribute SYNCLK1OUTEN of sys_clk_mgt is "ENABLE"
// synthesis attribute SYNCLK2OUTEN of sys_clk_mgt is "DISABLE"

defparam sys_clk_mgt.SYNCLK1OUTEN = "ENABLE";
defparam sys_clk_mgt.SYNCLK2OUTEN = "DISABLE";

IBUF sys_reset_n_ibuf (.O(sys_reset_n_c), .I(sys_reset_n));

generate

for (i = 0; i < (16); i = i + 1) begin : l_cfg_regs

  OBUF icfg_lcommand (.O(cfg_lcommand[i]), .I(cfg_lcommand_c[i]));
  OBUF icfg_lstatus  (.O(cfg_lstatus[i]), .I(cfg_lstatus_c[i]));
  OBUF icfg_dcommand (.O(cfg_dcommand[i]), .I(cfg_dcommand_c[i]));
  OBUF icfg_dstatus  (.O(cfg_dstatus[i]), .I(cfg_dstatus_c[i]));
  OBUF icfg_command  (.O(cfg_command[i]), .I(cfg_command_c[i]));
  OBUF icfg_status   (.O(cfg_status[i]), .I(cfg_status_c[i]));

end

endgenerate

OBUF icfg_function_number_obuf_2  (.O(cfg_function_number[2]), .I(cfg_function_number_c[2]));
OBUF icfg_function_number_obuf_1  (.O(cfg_function_number[1]), .I(cfg_function_number_c[1]));
OBUF icfg_function_number_obuf_0  (.O(cfg_function_number[0]), .I(cfg_function_number_c[0]));
OBUF icfg_device_number_obuf_4  (.O(cfg_device_number[4]), .I(cfg_device_number_c[4]));
OBUF icfg_device_number_obuf_3  (.O(cfg_device_number[3]), .I(cfg_device_number_c[3]));
OBUF icfg_device_number_obuf_2  (.O(cfg_device_number[2]), .I(cfg_device_number_c[2]));
OBUF icfg_device_number_obuf_1  (.O(cfg_device_number[1]), .I(cfg_device_number_c[1]));
OBUF icfg_device_number_obuf_0  (.O(cfg_device_number[0]), .I(cfg_device_number_c[0]));

OBUF icfg_bus_number_obuf_7  (.O(cfg_bus_number[7]), .I(cfg_bus_number_c[7]));
OBUF icfg_bus_number_obuf_6  (.O(cfg_bus_number[6]), .I(cfg_bus_number_c[6]));
OBUF icfg_bus_number_obuf_5  (.O(cfg_bus_number[5]), .I(cfg_bus_number_c[5]));
OBUF icfg_bus_number_obuf_4  (.O(cfg_bus_number[4]), .I(cfg_bus_number_c[4]));
OBUF icfg_bus_number_obuf_3  (.O(cfg_bus_number[3]), .I(cfg_bus_number_c[3]));
OBUF icfg_bus_number_obuf_2  (.O(cfg_bus_number[2]), .I(cfg_bus_number_c[2]));
OBUF icfg_bus_number_obuf_1  (.O(cfg_bus_number[1]), .I(cfg_bus_number_c[1]));
OBUF icfg_bus_number_obuf_0  (.O(cfg_bus_number[0]), .I(cfg_bus_number_c[0]));

IBUF icfg_turnoff_ok_n_ibuf (.O(cfg_turnoff_ok_n_c), .I(cfg_turnoff_ok_n));
OBUF icfg_to_turnoff_n_obuf (.O(cfg_to_turnoff_n), .I(cfg_to_turnoff_n_c));

IBUF icfg_pm_wake_n (.O(cfg_pm_wake_n_c), .I(cfg_pm_wake_n));

OBUF icfg_pcie_link_state_n_2 (.O(cfg_pcie_link_state_n[2]), .I(cfg_pcie_link_state_n_c[2]));
OBUF icfg_pcie_link_state_n_1 (.O(cfg_pcie_link_state_n[1]), .I(cfg_pcie_link_state_n_c[1]));
OBUF icfg_pcie_link_state_n_0 (.O(cfg_pcie_link_state_n[0]), .I(cfg_pcie_link_state_n_c[0]));

IBUF icfg_interrupt_n_ibuf (.O(cfg_interrupt_n_c), .I(cfg_interrupt_n));
OBUF icfg_interrupt_rdy_n_obuf (.O(cfg_interrupt_rdy_n), .I(cfg_interrupt_rdy_n_c));

generate

for (i = 0; i < (48); i = i + 1) begin : l_cfg_err_tlp_cpl
  IBUF icfg_err_tlp_cpl_header  (.O(cfg_err_tlp_cpl_header_c[i]), .I(cfg_err_tlp_cpl_header[i]));
end

endgenerate

IBUF icfg_err_posted_n_ibuf (.O(cfg_err_posted_n_c), .I(cfg_err_posted_n));
IBUF icfg_err_cpl_unexpect_n_ibuf (.O(cfg_err_cpl_unexpect_n_c), .I(cfg_err_cpl_unexpect_n));
IBUF icfg_err_cpl_abort_n_ibuf (.O(cfg_err_cpl_abort_n_c), .I(cfg_err_cpl_abort_n));
IBUF icfg_err_cpl_timeout_n_ibuf (.O(cfg_err_cpl_timeout_n_c), .I(cfg_err_cpl_timeout_n));

IBUF icfg_err_cor_n_ibuf (.O(cfg_err_cor_n_c), .I(cfg_err_cor_n));
IBUF icfg_err_ur_n_ibuf (.O(cfg_err_ur_n_c), .I(cfg_err_ur_n));
IBUF icfg_err_ecrc_n_ibuf (.O(cfg_err_ecrc_n_c), .I(cfg_err_ecrc_n));
IBUF icfg_wr_en_n_ibuf (.O(cfg_wr_en_n_c), .I(cfg_wr_en_n));

IBUF icfg_rd_en_n_ibuf (.O(cfg_rd_en_n_c), .I(cfg_rd_en_n));

generate

for (i = 0; i < (10); i = i + 1) begin : l_cfg_dwaddress

  IBUF icfg_dwaddr  (.O(cfg_dwaddr_c[i]), .I(cfg_dwaddr[i]));

end

endgenerate

IBUF icfg_byte_en_ibuf_3  (.O(cfg_byte_en_n_c[3]), .I(cfg_byte_en_n[3]));
IBUF icfg_byte_en_ibuf_2  (.O(cfg_byte_en_n_c[2]), .I(cfg_byte_en_n[2]));
IBUF icfg_byte_en_ibuf_1  (.O(cfg_byte_en_n_c[1]), .I(cfg_byte_en_n[1]));
IBUF icfg_byte_en_ibuf_0  (.O(cfg_byte_en_n_c[0]), .I(cfg_byte_en_n[0]));

generate

for (i = 0; i < (10); i = i + 1) begin : l_cfg_data

  IBUF icfg_di  (.O(cfg_di_c[i]), .I(cfg_di[i]));
  OBUF icfg_do  (.O(cfg_do[i]), .I(cfg_do_c[i]));

end

endgenerate

OBUF icfg_rd_wr_done_n_obuf (.O(cfg_rd_wr_done_n), .I(cfg_rd_wr_done_n_c));

OBUF itrn_rerrfwd_n_obuf (.O(trn_rerrfwd_n), .I(trn_rerrfwd_n_c));
IBUF itrn_rdst_rdy_n_ibuf (.O(trn_rdst_rdy_n_c), .I(trn_rdst_rdy_n));
OBUF itrn_rsrc_dsc_n_obuf (.O(trn_rsrc_dsc_n), .I(trn_rsrc_dsc_n_c));
OBUF itrn_rsrc_rdy_n_obuf (.O(trn_rsrc_rdy_n), .I(trn_rsrc_rdy_n_c));
OBUF itrn_reof_n_obuf (.O(trn_reof_n), .I(trn_reof_n_c));
OBUF itrn_rsof_n_obuf (.O(trn_rsof_n), .I(trn_rsof_n_c));

IBUF itrn_rnp_ok_n_ibuf (.O(trn_rnp_ok_n_c), .I(trn_rnp_ok_n));

generate

for (i = 0; i < (7); i = i + 1) begin : l_trn_rbar_hit

  OBUF itrn_rbar_hit_n (.O(trn_rbar_hit_n[i]), .I(trn_rbar_hit_n_c[i]));

end

for (i = 0; i < (8); i = i + 1) begin : l_trn_rfc_hdr

  OBUF itrn_rfc_nph_av (.O(trn_rfc_nph_av[i]), .I(trn_rfc_nph_av_c[i]));
  OBUF itrn_rfc_ph_av (.O(trn_rfc_ph_av[i]), .I(trn_rfc_ph_av_c[i]));
  OBUF itrn_rfc_cplh_av (.O(trn_rfc_cplh_av[i]), .I(trn_rfc_cplh_av_c[i]));

end

for (i = 0; i < (12); i = i + 1) begin : l_trn_rfc_data

  OBUF itrn_rfc_cpld_av (.O(trn_rfc_cpld_av[i]), .I(trn_rfc_cpld_av_c[i]));
  OBUF itrn_rfc_pd_av (.O(trn_rfc_pd_av[i]), .I(trn_rfc_pd_av_c[i]));
  OBUF itrn_fcr_npd_av (.O(trn_rfc_npd_av[i]), .I(trn_rfc_npd_av_c[i]));

end

for (i = 0; i < (64); i = i + 1) begin : l_trn_rdata

  OBUF itrn_rd (.O(trn_rd[i]), .I(trn_rd_c[i]));

end

for (i = 0; i < (8); i = i + 1) begin : l_trn_rrem_n

  OBUF itrn_rrem_n (.O(trn_rrem_n[i]), .I(trn_rrem_n_c[i])); 

end

endgenerate

IBUF itrn_teof_n_ibuf (.O(trn_teof_n_c), .I(trn_teof_n));
IBUF itrn_tsof_n_ibuf (.O(trn_tsof_n_c), .I(trn_tsof_n));
OBUF itrn_tdst_rdy_n_obuf (.O(trn_tdst_rdy_n), .I(trn_tdst_rdy_n_c));
IBUF itrn_tsrc_rdy_n_ibuf (.O(trn_tsrc_rdy_n_c), .I(trn_tsrc_rdy_n));
IBUF itrn_terrfwd_n_ibuf (.O(trn_terrfwd_n_c), .I(trn_terrfwd_n));
IBUF itrn_tsrc_dsc_n_ibuf (.O(trn_tsrc_dsc_n_c), .I(trn_tsrc_dsc_n));
OBUF itrn_tdst_dsc_n_obuf (.O(trn_tdst_dsc_n), .I(trn_tdst_dsc_n_c));

generate

for (i = 0; i < (5); i = i + 1) begin : l_trn_tbuf_avail

  OBUF itrn_tbuf_av (.O(trn_tbuf_av[i]), .I(trn_tbuf_av_c[i]));

end

for (i = 0; i < (64); i = i + 1) begin : l_trn_tdata

  IBUF itrn_td  (.O(trn_td_c[i]), .I(trn_td[i]));

end

for (i = 0; i < (8); i = i + 1) begin : l_trn_trem_n

  IBUF itrn_trem_n  (.O(trn_trem_n_c[i]), .I(trn_trem_n[i]));

end

endgenerate

IBUF icfg_trn_pending_n_ibuf (.O(cfg_trn_pending_n_c), .I(cfg_trn_pending_n));
OBUF itrn_lnk_up_n_obuf (.O(trn_lnk_up_n), .I(trn_lnk_up_n_c));
OBUF itrn_reset_n_obuf (.O(trn_reset_n), .I(trn_reset_n_c));
OBUF itrn_clk_obuf (.O(trn_clk), .I(trn_clk_c));


// PCI Express DSPORT Instance
//--------------------------

pci_exp_1_lane_64b_dsport pci_exp_1_lane_64b_dsport
(

  // PCI Express Fabric Interface
  .pci_exp_txp(pci_exp_txp),
  .pci_exp_txn(pci_exp_txn),
  .pci_exp_rxp(pci_exp_rxp),
  .pci_exp_rxn(pci_exp_rxn),

  // Transaction (TRN) Interface
  .trn_clk(trn_clk_c),
  .trn_reset_n(trn_reset_n_c),
  .trn_lnk_up_n(trn_lnk_up_n_c),
  .cfg_trn_pending_n(cfg_trn_pending_n_c),

  // Tx
  .trn_td(trn_td_c),
  .trn_trem_n(trn_trem_n_c),
  .trn_tsof_n(trn_tsof_n_c),
  .trn_teof_n(trn_teof_n_c),
  .trn_tsrc_rdy_n(trn_tsrc_rdy_n_c),
  .trn_tdst_rdy_n(trn_tdst_rdy_n_c),
  .trn_tdst_dsc_n(trn_tdst_dsc_n_c),
  .trn_tsrc_dsc_n(trn_tsrc_dsc_n_c),
  .trn_terrfwd_n(trn_terrfwd_n_c),
  .trn_tbuf_av(trn_tbuf_av_c),

  // Rx
  .trn_rd(trn_rd_c),
  .trn_rrem_n(trn_rrem_n_c),
  .trn_rsof_n(trn_rsof_n_c),
  .trn_reof_n(trn_reof_n_c),
  .trn_rsrc_rdy_n(trn_rsrc_rdy_n_c),
  .trn_rsrc_dsc_n(trn_rsrc_dsc_n_c),
  .trn_rdst_rdy_n(trn_rdst_rdy_n_c),
  .trn_rerrfwd_n(trn_rerrfwd_n_c),
  .trn_rnp_ok_n(trn_rnp_ok_n_c),
  .trn_rbar_hit_n(trn_rbar_hit_n_c),
  .trn_rfc_nph_av(trn_rfc_nph_av_c),
  .trn_rfc_npd_av(trn_rfc_npd_av_c),
  .trn_rfc_ph_av(trn_rfc_ph_av_c),
  .trn_rfc_pd_av(trn_rfc_pd_av_c),
  .trn_rfc_cplh_av(trn_rfc_cplh_av_c),
  .trn_rfc_cpld_av(trn_rfc_cpld_av_c),

  // Host (CFG_c) Interface
  .cfg_do(cfg_do_c),
  .cfg_rd_wr_done_n(cfg_rd_wr_done_n_c),
  .cfg_di(cfg_di_c),
  .cfg_byte_en_n(cfg_byte_en_n_c),
  .cfg_dwaddr(cfg_dwaddr_c),
  .cfg_wr_en_n(cfg_wr_en_n_c),
  .cfg_rd_en_n(cfg_rd_en_n_c),
  .cfg_err_cor_n(cfg_err_cor_n_c),
  .cfg_err_ur_n(cfg_err_ur_n_c),
  .cfg_err_ecrc_n(cfg_err_ecrc_n_c),
  .cfg_err_cpl_timeout_n(cfg_err_cpl_timeout_n_c),
  .cfg_err_cpl_abort_n(cfg_err_cpl_abort_n_c),
  .cfg_err_cpl_unexpect_n(cfg_err_cpl_unexpect_n_c),
  .cfg_err_posted_n(cfg_err_posted_n_c),
  .cfg_err_tlp_cpl_header(cfg_err_tlp_cpl_header_c),
  .cfg_interrupt_n(cfg_interrupt_n_c),
  .cfg_interrupt_rdy_n(cfg_interrupt_rdy_n_c),
  .cfg_turnoff_ok_n(cfg_turnoff_ok_n_c),
  .cfg_to_turnoff_n(cfg_to_turnoff_n_c),
  .cfg_pm_wake_n(cfg_pm_wake_n_c),
  .cfg_pcie_link_state_n(cfg_pcie_link_state_n_c),
  .cfg_bus_number(cfg_bus_number_c),
  .cfg_device_number(cfg_device_number_c),
  .cfg_function_number(cfg_function_number_c),
  .cfg_status(cfg_status_c),
  .cfg_command(cfg_command_c),
  .cfg_dstatus(cfg_dstatus_c),
  .cfg_dcommand(cfg_dcommand_c),
  .cfg_lstatus(cfg_lstatus_c),
  .cfg_lcommand(cfg_lcommand_c),
  .cfg_cfg(cfg_cfg),

  // System (SYS_c) Interface
  .sys_clk(sys_clk_c),
  .sys_reset_n(sys_reset_n_c)
);

dsport_cfg dsport_cfg_inst	(
  .cfg(cfg_cfg)
);

endmodule // xilinx_pci_exp_1_lane_dsport

