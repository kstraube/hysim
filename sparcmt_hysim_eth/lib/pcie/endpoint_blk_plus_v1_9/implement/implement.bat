rem Clean up the results directory
rmdir /S /Q results
mkdir results

echo 'Synthesizing HDL example design with XST';
xst -ifn xst.scr
move xilinx_pci_exp_ep.ngc .\results\endpoint_blk_plus_v1_9_top.ngc

cd results

echo 'Running ngdbuild'
rem  ngdbuild -verbose -uc ..\..\example_design\xilinx_pci_exp_blk_plus_1_lane_ep_xc5vlx110t-ff1136-1.ucf endpoint_blk_plus_v1_9_top.ngc -sd ..\..\..\
  ngdbuild -verbose -uc ..\..\example_design\xupv5-lx110t_pcie_x1_plus.ucf endpoint_blk_plus_v1_9_top.ngc -sd ..\..\..\

echo 'Running map'
map -timing -ol high -xe c -pr b -o mapped.ncd endpoint_blk_plus_v1_9_top.ngd mapped.pcf

echo 'Running par'
par -ol high -xe c -w mapped.ncd routed.ncd mapped.pcf

echo 'Running trce'
trce -u -v 100 routed.ncd mapped.pcf

echo 'Running design through netgen'
netgen -sim -ofmt verilog -ne -w -tm xilinx_pci_exp_ep -sdf_path ..\..\implement\results routed.ncd

echo 'Running design through bitgen'
bitgen -w routed.ncd
