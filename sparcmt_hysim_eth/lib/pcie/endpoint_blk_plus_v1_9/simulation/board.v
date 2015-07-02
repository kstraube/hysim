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
// Filename: board.v
//
// Description:  Top level testbench
//
//------------------------------------------------------------------------------


`include "board_common.v"

module board;


integer             i;

//
// System reset
//

reg                cor_sys_reset_n;

//
// System clock
//

wire               dsport_sys_clk_p;
wire               dsport_sys_clk_n;
wire               cor_sys_clk_p;
wire               cor_sys_clk_n;

//
// PCI-Express facric interface
//
wire  [(1 - 1):0]  cor_pci_exp_txn;
wire  [(1 - 1):0]  cor_pci_exp_txp;
wire  [(1 - 1):0]  cor_pci_exp_rxn;
wire  [(1 - 1):0]  cor_pci_exp_rxp;








    defparam xilinx_pci_exp_ep.ep.\BU2/U0/pcie_ep0/pcie_blk/SIO/.pcie_gt_wrapper_i/GTD[0].GT_i .SIM_GTPRESET_SPEEDUP = 1;



//
// PCI-Express End Point Instance
//
xilinx_pci_exp_ep xilinx_pci_exp_ep(


        // SYS Inteface
        .sys_clk_p(cor_sys_clk_p),
        .sys_clk_n(cor_sys_clk_n),

        // PCI-Express Interface
        .pci_exp_txn(cor_pci_exp_txn),
        .pci_exp_txp(cor_pci_exp_txp),
        .pci_exp_rxn(cor_pci_exp_rxn),
        .pci_exp_rxp(cor_pci_exp_rxp),


        .sys_reset_n(cor_sys_reset_n)
);

xilinx_pci_exp_1_lane_downstream_port xilinx_pci_exp_1_lane_downstream_port (

        // SYS Inteface
        .sys_clk_p(dsport_sys_clk_p),
        .sys_clk_n(dsport_sys_clk_n),
        .sys_reset_n(cor_sys_reset_n),

        // PCI-Express Interface
        .pci_exp_txn(cor_pci_exp_rxn),
        .pci_exp_txp(cor_pci_exp_rxp),

// The following muxing logic is a work-around due to the fact that the GTP Transceiver models
// output X values which propagate to the downstream port which in turn causes prohibitively
// long simulation times for link up. Refer to CR# 442695.
        .pci_exp_rxn( ((cor_pci_exp_txn[0] === 1'b1) && (cor_pci_exp_txp[0] === 1'b1)) ? 1'bx : cor_pci_exp_txn[0]),
        .pci_exp_rxp( ((cor_pci_exp_txn[0] === 1'b1) && (cor_pci_exp_txp[0] === 1'b1)) ? 1'bx : cor_pci_exp_txp[0])

);


sys_clk_gen_ds     SYS_CLK_GEN_DSPORT (

          .sys_clk_p(dsport_sys_clk_p),
          .sys_clk_n(dsport_sys_clk_n)

          );

  defparam     SYS_CLK_GEN_DSPORT.halfcycle = 2000; // 250 MHz
  defparam     SYS_CLK_GEN_DSPORT.offset = 0;


sys_clk_gen_ds     SYS_CLK_GEN_COR (

          .sys_clk_p(cor_sys_clk_p),
          .sys_clk_n(cor_sys_clk_n)

          );


  defparam     SYS_CLK_GEN_COR.halfcycle = 5000; // 100 MHz
  defparam     SYS_CLK_GEN_COR.offset = 0;



initial begin
  if ($test$plusargs ("dump_all")) begin
`ifdef NCV //Cadence TRN dump
    $recordsetup(
  `ifdef BOARDx01
                   "design=boardx01",
  `endif
  `ifdef BOARDx04
                   "design=boardx04",
  `endif
  `ifdef BOARDx08
                   "design=boardx08",
  `endif

                   "compress",
                   "wrapsize=1G",
                   "version=1",
                   "run=1");
    $recordvars();
`else
  `ifdef VCS //Synopsys VPD dump
    `ifdef BOARDx01
      $vcdplusfile("boardx01.vpd");
    `endif
    `ifdef BOARDx04
      $vcdplusfile("boardx04.vpd");
    `endif
    `ifdef BOARDx08
      $vcdplusfile("boardx08.vpd");
    `endif
    $vcdpluson;
    $vcdplusglitchon;
    $vcdplusflush;
  `else
    // VCD dump
    `ifdef BOARDx01
      $dumpfile("boardx01.vcd");
    `endif
    `ifdef BOARDx04
      $dumpfile("boardx04.vcd");
    `endif
    `ifdef BOARDx08
      $dumpfile("boardx08.vcd");
    `endif

    $dumpvars(0, board);
  `endif
`endif
  end

  $display("[%t] : System Reset Asserted...", $realtime);
  cor_sys_reset_n = 1'b0;

         for (i = 0; i < 500; i = i + 1) begin

                 @(posedge cor_sys_clk_p);

         end

  $display("[%t] : System Reset De-asserted...", $realtime);

         cor_sys_reset_n = 1'b1;

end

endmodule // BOARD


