`timescale 1ns / 1ps
module     pcie_interface
(
	// PCI Express Fabric Interface
    output pci_exp_txp,
	output pci_exp_txn,
	input pci_exp_rxp,
	input pci_exp_rxn,

	// System (SYS) Interface
	input sys_clk_p,
	input sys_clk_n,
	input sys_reset_n,

	input bit clk, //gclk.clk

	//TM2CPU interface
	output [31:0] pcie_data_in,
	output bit pcie_data_in_valid,

	input [127:0] pcie_data_out,
	input bit mem_cnt_eq, //count diff between in and out queues - enable for read module / valid
	input bit mem_out_empty,
	output wr_ready
	);

	bit [10:0] rd_addr_fpga; //change to wires
    bit [3:0]  rd_be_fpga; //constant
    bit [31:0] rd_data_fpga;

    bit [10:0] wr_addr_fpga, wr_addr_fpga2;
    bit [7:0]  wr_be_fpga, wr_be_fpga2; //constant
    bit [31:0] wr_data_fpga, wr_data_fpga2;
    bit        wr_en_fpga, wr_en_fpga2;
    bit        wr_busy_fpga;
    bit        trn_clk_c;

	bit ready;

ReadMod pcie_rd_ctrl( //change to instatiation
   .clk(clk),			//
   .rst_n(sys_reset_n),			//
   .RAM_data(rd_data_fpga),		//[31:0]
   .enable(1'b1),//wr_ready),//(mem_cnt_eq),			//
   .RAM_addr(rd_addr_fpga),		//[10:0]
   .FPGA_data(pcie_data_in),		//[31:0]
   .FPGA_valid(pcie_data_in_valid),	//
   .read_en()			//
   );

WriteMod pcie_wr_ctrl( //change to instatiation
   .clk(trn_clk_c),//refclkout),//clk),			//
   .rst_n(sys_reset_n),			//
   .FPGA_data({128'h11110020333344445555666677778888}),//{96'b0,pcie_data_in}),//(pcie_data_out),		//[127:0]
   .enable(wr_ready),//pcie_data_in_valid),//(~mem_out_empty&wr_ready),			//check for deadlock here in simulation/code inspection
   .RAM_busy(wr_busy_fpga),
   .RAM_addr(wr_addr_fpga),		//[10:0]
   .RAM_data(wr_data_fpga),		//[31:0]
   .write_en(wr_en_fpga),		//
   .ready(wr_ready)				//
   );


assign wr_addr_fpga2 = 11'b01000000000;//{2'b01,wr_addr_fpga[8:0]};//11'b01000000000;
assign wr_data_fpga2 = 32'h33333333;
assign wr_en_fpga2 = 1'b1;
assign wr_be_fpga2 = 8'hFF;


	xilinx_pci_exp_ep pcie_hw (
                        // PCI Express Fabric Interface

                        .pci_exp_txp(pci_exp_txp),
                        .pci_exp_txn(pci_exp_txn),
                        .pci_exp_rxp(pci_exp_rxp),
                        .pci_exp_rxn(pci_exp_rxn),

                        // System (SYS) Interface

                        .sys_clk_p(sys_clk_p),
                        .sys_clk_n(sys_clk_n),

                        .sys_reset_n(sys_reset_n),
			.refclkout(refclkout),

			.rd_addr_fpga(rd_addr_fpga),
                        .rd_be_fpga(rd_be_fpga),
                        .rd_data_fpga(rd_data_fpga),

                        .wr_addr_fpga(wr_addr_fpga),
                        .wr_be_fpga(wr_be_fpga2),
                        .wr_data_fpga(wr_data_fpga),
                        .wr_en_fpga(wr_en_fpga),
                        .wr_busy_fpga(wr_busy_fpga),
			.trn_clk_c(trn_clk_c)

                        );//synthesis syn_noclockbuf=1

/** REFERENCE
mem in queue
     .DI(tm_pkt_in), //data in - port from eth_cpu_control
     .WREN(tm_pkt_valid&tm_pkt_in[1]), //wr en - tm_pkt_valid & valid bit set in the pkt


FIFO36_72 mem_out_queue1
  (
     .DO(tm_pkt_out_1), //data out
     //.DOP(), //data out parity
     .FULL(mem_out_full), //full
     .EMPTY(mem_out_empty), //empty
     .DI({19'b0,cpu2tm_out.tid, cpu2tm_out.valid, cpu2tm_out.run, cpu2tm_out.replay, cpu2tm_out.retired, ldst_out, cpu2tm_out.inst}), //data in
     .DIP(8'b0), //data in parity
     .WREN((cpu2tm_out.valid)&~speedtm_running), //wr en - |cpu2tm_out.replay
     .RDEN(eth_mem_rd), //rd en  (eth_mem_rd&~mem_out_empty)
     .RDCLK(gclk.clk),
     .WRCLK(gclk.clk),
     .RST(rst), //reset
     .WRCOUNT(wrcount_memout)
  );

FIFO36_72 mem_out_queue2
  (
     .DO(tm_pkt_out_2), //data out
     //.DOP(), //data out parity
     //.FULL(replay_full), //full
     //.EMPTY(replay_empty), //empty
     .DI({cpu2tm_out.paddr, cpu2tm_out.npc}), //data in
     .DIP(8'b0), //data in parity
     .WREN((cpu2tm_out.valid)&~speedtm_running), //wr en - |cpu2tm_out.replay
     .RDEN(eth_mem_rd), //rd en (eth_mem_rd&~mem_out_empty)
     .RDCLK(gclk.clk),
     .WRCLK(gclk.clk),
     .RST(rst) //reset
  );
  assign tm_pkt_out = {tm_pkt_out_1, tm_pkt_out_2};**/
endmodule
