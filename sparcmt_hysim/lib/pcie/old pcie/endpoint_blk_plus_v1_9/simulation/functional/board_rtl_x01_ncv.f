// PCI-Express Test Bench
//---------------------------------

../board.v
../sys_clk_gen.v
../sys_clk_gen_ds.v

// PCI-Express 1 Lane Endpoint Reference Design
//----------------------------------------------

../../example_design/xilinx_pci_exp_ep.v
../../../endpoint_blk_plus_v1_9.v
../../example_design/pci_exp_64b_app.v
../../example_design/PIO_EP.v
../../example_design/PIO_EP_MEM_ACCESS.v
../../example_design/EP_MEM.v
../../example_design/PIO_64_RX_ENGINE.v
../../example_design/PIO_64_TX_ENGINE.v
../../example_design/PIO_TO_CTRL.v
../../example_design/PIO.v


//Xilinx PCI Express Root Complex Model
//--------------------------------------------

../dsport/xilinx_pci_exp_downstream_port.v
../dsport/xilinx_pci_exp_dsport.v
../dsport/dsport_cfg.v
../dsport/pci_exp_usrapp_rx.v
../dsport/pci_exp_usrapp_tx.v
../dsport/pci_exp_usrapp_com.v
../dsport/pci_exp_usrapp_cfg.v
../dsport/pci_exp_1_lane_64b_dsport.v
