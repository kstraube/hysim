// PCI-Express Test Bench
//---------------------------------
+define+BOARDx01
+define+SIM_USERTB
+define+SIMULATION
+incdir+../+../tests+../dsport

../board.v
../sys_clk_gen.v
../sys_clk_gen_ds.v

// PCI-Express 1 Lane Endpoint Reference Design
//----------------------------------------------
-f ../xilinx_pci_exp_cor_ep.f

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
