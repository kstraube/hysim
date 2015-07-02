#define_scope_collection collection  {TMN_ETHDMAFALSE} command  {find -inst i:gen_eth_dma_master.rr_dma2tm*} 
#define_scope_collection collection  {TMN_ETHRXFALSE} command  {find -inst i:gen_eth_dma_master.gen_eth_rx_block.r_dma2tm*} 
#define_scope_collection collection  {TMN_DCACHE_TAG} command  {find -inst i:gen_cpu.gen_dcache.dc_bram.*dc_ram.dc_tag} 
#define_scope_collection collection  {TMN_DTLBRAM} command  {find -inst i:gen_cpu.gen_dmmu.*.*dtlbram*.*.*.*tlb_ram} 
#define_scope_collection collection  {TMN_DCACHE_DATA} command  {find -inst i:gen_cpu.gen_dcache.dc_bram.*dc_ram.*dc_data} 
#define_scope_collection collection  {TMN_DTLBRAM_VPN} command  {find -inst i:gen_cpu.gen_dmmu.*.*.*} 
#define_scope_collection collection  {TMN_EX_IMMU_DATA} command  {find -inst i:gen_cpu.gen_ex.delr*.*.*} 
#define_scope_collection collection  {TMN_ITLBRAM} command  {find -inst i:gen_cpu.gen_immu.*.*itlbram*.*.*.*tlb_ram} 
#define_scope_collection collection  {TMN_ICACHE_TAG} command  {find -inst i:gen_cpu.gen_icache.ic_bram.*ic_ram.ic_tag} 
#define_scope_collection collection  {TMN_DCACHE_MSHR} command  {find -inst i:gen_cpu.gen_dcache.mshr_ram.*} 
#define_scope_collection collection  {TMN_DCACHE_REG2} command  {find -inst i:gen_cpu.gen_dcache.r_we_tag*} 
#define_scope_collection collection  {TMN_DCACHE_REG1} command  {find -inst i:gen_cpu.gen_dcache.delr_xc*} 
#define_scope_collection collection  {TMN_IRQMP_IPI} command  {find -inst i:gen_cpu.gen_irqmp.ipi*} 
#define_scope_collection collection  {TMN_TM_PERFCNTER_REG} command  {find i:gen_cpu.gen_tm.*.*.*inc_read_data*} 
#define_scope_collection collection  {TMN_TM_PERFCNTER_RAM} command  {find i:gen_cpu.gen_tm.*.*ring_perf_counter*.myram*} 
#define_scope_collection collection  {TMN_DTLBREG} command  {find -inst i:gen_cpu.gen_dmmu.*.*.delr_mem1*} 
#define_scope_collection collection  {TMN_IMMUREG} command  {find -inst i:gen_cpu.gen_immu.*.*.*r_walk_stat*} 
#define_scope_collection collection  {TMN_DECODE} command  {find -inst i:gen_cpu.gen_de.*} 
#define_clock -disable  {gen_gclk_rst.gen_clk.genblk31\.genblk32\.xcv5_gen_clk.clkin_buf} -name  {gen_gclk_rst.gen_clk.genblk31®genblk32®xcv5_gen_clk.clkin_buf} -clockgroup  {default_clkgroup_0} 
#define_clock -disable  {gen_gclk_rst.gen_clk.genblk31\.genblk32\.xcv5_gen_clk.genblk0\.genblk2\.clk_dfs} -name  {gen_gclk_rst.gen_clk.genblk31®genblk32®xcv5_gen_clk.genblk0®genblk2®clk_dfs} -clockgroup  {default_clkgroup_1} 
#define_clock -disable  {gen_gclk_rst.gen_clk.genblk31\.genblk32\.xcv5_gen_clk.genblk0\.genblk4\.clk_dll} -name  {gen_gclk_rst.gen_clk.genblk31®genblk32®xcv5_gen_clk.genblk0®genblk4®clk_dll} -clockgroup  {default_clkgroup_2} 
#define_clock -disable  {gen_dcache.mem_cmd\.cmd\.D_2_sqmuxa} -name  {gen_dcache.mem_cmd®cmd®D_2_sqmuxa} -clockgroup  {default_clkgroup_3} 
#define_clock -disable [get_ports {clkin_n}] -name [get_ports {clkin_n}] -freq  {200} -clockgroup  {clkin_group} -rise  {2.5} -fall  {5} 
#define_clock -disable [get_ports {clkin_p}] -name [get_ports {clkin_p}] -freq  {200} -clockgroup  {clkin_group} -rise  {0} -fall  {2.5} 
#define_clock -disable [get_ports {clkin_p}] -name [get_ports {clkin_p}] -freq  {200} -clockgroup  {default_clkgroup_4} 
#define_clock [get_ports {clkin_p}] -name [get_ports {clkin_p}] -period  {9.5} -clockgroup  {default_clkgroup_5} 
define_clock  {p:clkin_p} -name {p:clkin_p} -period {9.5} -clockgroup {default_clkgroup_5} 

#define_clock -disable [get_nets {gen_gclk_rst.gen_dram_clk.genblk35\.genblk36\.genblk37\.xcv5_gen_dram_clk_bee3.MCLKx}] -name [get_nets {gen_gclk_rst.gen_dram_clk.genblk35®genblk36®genblk37®xcv5_gen_dram_clk_bee3.MCLKx}] -period  {4.16} -clockgroup  {ddr2_clk} -rise  {0} -fall  {2.08} 
#define_clock -disable [get_nets {gen_gclk_rst.gen_dram_clk.genblk35\.genblk36\.genblk37\.xcv5_gen_dram_clk_bee3.MCLK90x}] -name [get_nets {gen_gclk_rst.gen_dram_clk.genblk35®genblk36®genblk37®xcv5_gen_dram_clk_bee3.MCLK90x}] -period  {4.16} -clockgroup  {ddr2_clk} -rise  {1.04} -fall  {3.12} 
#define_clock -disable [get_nets {gen_gclk_rst.gen_dram_clk.genblk35\.genblk36\.genblk37\.xcv5_gen_dram_clk_bee3.Ph0x}] -name [get_nets {gen_gclk_rst.gen_dram_clk.genblk35®genblk36®genblk37®xcv5_gen_dram_clk_bee3.Ph0x}] -period  {16.64} -clockgroup  {ddr2_clk} -rise  {0} -fall  {6.24} 
#define_clock -disable [get_nets {gen_gclk_rst.gen_dram_clk.genblk35\.genblk36\.genblk37\.xcv5_gen_dram_clk_bee3.CLKx}] -name [get_nets {gen_gclk_rst.gen_dram_clk.genblk35®genblk36®genblk37®xcv5_gen_dram_clk_bee3.CLKx}] -period  {8.32} -clockgroup  {ddr2_clk} -rise  {0} -fall  {4.16} 
#define_clock -disable [get_nets {gen_eth_dma_master.tx_client_clk_0_o}] -name [get_nets {gen_eth_dma_master.tx_client_clk_0_o}] -period  {7.7} -clockgroup  {default_clkgroup_6} 
#define_clock -disable [get_nets {gen_eth_dma_master.rx_client_clk_0_o}] -name [get_nets {gen_eth_dma_master.rx_client_clk_0_o}] -period  {7.7} -clockgroup  {default_clkgroup_7} 
#define_clock -disable [get_nets {gen_eth_dma_master.gmii_rx_clk_0_delay}] -name [get_nets {gen_eth_dma_master.gmii_rx_clk_0_delay}] -period  {7.7} -clockgroup  {default_clkgroup_8} 
#define_clock -disable [get_nets {gen_eth_dma_master.tx_phy_clk_0_o}] -name [get_nets {gen_eth_dma_master.tx_phy_clk_0_o}] -period  {7.7} -clockgroup  {default_clkgroup_9} 
#define_clock [get_ports {PHY_RXCLK}] -name [get_nets {PHY_RXCLK}] -period  {7.7} -clockgroup  {default_clkgroup_10} 
define_clock  {p:PHY_RXCLK} -name {n:PHY_RXCLK} -period {7.7} -clockgroup {default_clkgroup_10} 

#define_clock [get_nets {gen_cpu.pcie_interface.ep.pcie_ep0.pcie_blk.SIO.genblk215\.genblk216\.pcie_gt_wrapper_i.gt_refclk_out[0]}] -name  {MGTCLK} -freq  {100} -clockgroup  {default_clkgroup_11} -rise  {0} -fall  {5} 
define_clock {n:gen_cpu.pcie_interface.ep.pcie_ep0.pcie_blk.SIO.genblk215\.genblk216\.pcie_gt_wrapper_i.gt_refclk_out[0]} -name {MGTCLK} -freq {100} -clockgroup {default_clkgroup_11} -rise {0} -fall {5} 

#define_clock -disable [get_nets {gen_cpu.pcie_interface.ep.pcie_ep0.pcie_blk.clocking_i.clkout1}] -name [get_nets {gen_cpu.pcie_interface.ep.pcie_ep0.pcie_blk.clocking_i.clkout1}] -clockgroup  {default_clkgroup_12} 
#define_clock [get_nets {sys_clk_c}] -name [get_nets {sys_clk_c}] -freq  {100} -clockgroup  {default_clkgroup_13} -rise  {0} -fall  {5} 
define_clock {n:sys_clk_c} -name {n:sys_clk_c} -freq {100} -clockgroup {default_clkgroup_13} -rise {0} -fall {5} 

#define_clock -disable -clockgroup  {default_clkgroup_14} 
#define_input_delay -disable  {-default} -improve  {0.00} -route  {0.00} 
#define_output_delay -disable  {-default} -improve  {0.00} -route  {0.00} 
#define_input_delay -disable  {clkin_p} -improve  {0.00} -route  {0.00} 
#define_input_delay -disable  {clkin_n} -improve  {0.00} -route  {0.00} 
#define_input_delay -disable  {rstin} -improve  {0.00} -route  {0.00} 
#define_input_delay -disable  {irl[3:0]} -improve  {0.00} -route  {0.00} 
#define_output_delay -disable  {luterr} -improve  {0.00} -route  {0.00} 
#define_output_delay -disable  {bramerr} -improve  {0.00} -route  {0.00} 
#define_output_delay -disable  {sb_ecc} -improve  {0.00} -route  {0.00} 
#define_false_path -disable -from  {$TMN_ETHRXFALSE} -to  {$TMN_ETHDMAFALSE} 
#define_multicycle_path -disable -from  {$TMN_DTLBRAM} -to  {$TMN_DCACHE_TAG} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DTLBRAM} -to  {$TMN_DCACHE_DATA} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DTLBRAM_VPN} -to  {$TMN_DCACHE_TAG} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DTLBRAM_VPN} -to  {$TMN_DCACHE_DATA} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_EX_IMMU_DATA} -to  {$TMN_DCACHE_DATA} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_EX_IMMU_DATA} -to  {$TMN_DCACHE_TAG} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_ITLBRAM} -to  {$TMN_ICACHE_TAG} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DCACHE_MSHR} -to  {$TMN_IRQMP_IPI} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DCACHE_REG} -to  {$TMN_IRQMP_IPI} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_TM_PERFCNTER_REG} -to  {$TMN_TM_PERFCNTER_RAM} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DTLBREG} -to  {$TMN_DCACHE_TAG} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DTLBREG} -to  {$TMN_DCACHE_DATA} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DCACHE_MSHR} -to  {$TMN_DCACHE_TAG} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DCACHE_MSHR} -to  {$TMN_DCACHE_DATA} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DCACHE_REG1} -to  {$TMN_DCACHE_TAG} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DCACHE_REG1} -to  {$TMN_DCACHE_DATA} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DCACHE_REG2} -to  {$TMN_DCACHE_TAG} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DCACHE_REG2} -to  {$TMN_DCACHE_DATA} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DCACHE_REG1} -to  {$TMN_IRQMP_IPI} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DCACHE_REG2} -to  {$TMN_IRQMP_IPI} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_DCACHE_MSHR} -to  {$TMN_IRQMP_IPI} -end  {2} 
#define_multicycle_path -disable -from  {$TMN_IMMUREG} -to  {$TMN_DECODE} -start  {2} 
#define_global_attribute -disable  {syn_srlstyle}  {registers} 
#define_attribute [get_cells {gen_bee3mem.ddr.WriteBurst}]  {syn_srlstyle}  {select_srl} 
define_attribute  {i:gen_bee3mem.ddr.WriteBurst_0 i:gen_bee3mem.ddr.wd4 i:gen_bee3mem.ddr.wd3 i:gen_bee3mem.ddr.wd2 i:gen_bee3mem.ddr.WriteBurst_0_1 i:gen_bee3mem.ddr.WriteBurst_0_2} syn_srlstyle select_srl 

#define_attribute [get_cells {gen_bee3mem.ddr.ReadBurst}]  {syn_srlstyle}  {select_srl} 
define_attribute  {i:gen_bee3mem.ddr.ReadBurst_0 i:gen_bee3mem.ddr.rd12 i:gen_bee3mem.ddr.rd11 i:gen_bee3mem.ddr.rd10 i:gen_bee3mem.ddr.rd9 i:gen_bee3mem.ddr.rd8 i:gen_bee3mem.ddr.rd7 i:gen_bee3mem.ddr.rd6 i:gen_bee3mem.ddr.rd5 i:gen_bee3mem.ddr.rd4 i:gen_bee3mem.ddr.rd3 i:gen_bee3mem.ddr.rd2 i:gen_bee3mem.ddr.ReadBurst_0_1 i:gen_bee3mem.ddr.ReadBurst_0_2} syn_srlstyle select_srl 

#define_attribute [get_cells {gen_bee3mem.ddr.odtd3}]  {syn_srlstyle}  {select_srl} 
define_attribute  {i:gen_bee3mem.ddr.odtd3} syn_srlstyle select_srl 

#define_attribute -disable [get_cells {gen_ex.xalu_mul_div.mul_ififo.pt®head[5:0]}]  {syn_maxfan}  {4} 
#define_attribute -disable [get_cells {gen_ex.xalu_mul_div.mul_ififo.pt®tail[5:0]}]  {syn_maxfan}  {4} 
#define_attribute -disable [get_nets {gen_ex.xalu_mul_div.mul_ififo_re}]  {syn_maxfan}  {4} 
#define_attribute -disable [get_nets {gen_ex.xalu_mul_div.gen_mul_shf.genblk43®genblk44®mul_shf.un15}]  {syn_maxfan}  {8} 
#define_attribute -disable [get_nets {gen_cpu.gen_dcache.dc_bram.genblk57®genblk58®dc_ram.t_raddr[8:0]}]  {syn_maxfan}  {4} 
#define_attribute -disable [get_cells {gen_cpu.gen_dmmu.genblk140®genblk141®gen_dmmutlb.genblk137®genblk138®dtlbram_split}]  {syn_maxfan}  {8} 
#define_attribute -disable [get_cells {gen_ex.xalu_mul_div.mul_ififo.pt®head[5:0]}]  {syn_allow_retiming}  {1} 
#define_attribute -disable  {gen_gclk_rst.reset_dly}  {syn_preserve}  {1} 
#define_attribute -disable  {gen_gclk_rst.ce}  {syn_preserve}  {1} 
#define_attribute  {rstin}  {xc_loc}  {E9} 
define_attribute  {p:rstin} {xc_loc} {E9} 

#define_attribute  {clkin_p}  {xc_loc}  {AH15} 
define_attribute  {p:clkin_p c:clkin_p} {xc_loc} {AH15} 

#define_attribute  {done_led}  {xc_loc}  {H18} 
define_attribute {done_led} {xc_loc} {H18} 

#define_attribute  {error_led}  {xc_loc}  {L18} 
define_attribute {error_led} {xc_loc} {L18} 

#define_attribute  {cpurst}  {xc_loc}  {AJ6} 
define_attribute  {p:cpurst} {xc_loc} {AJ6} 

#define_attribute  {TxD}  {xc_loc}  {AG20} 
define_attribute  {p:TxD} {xc_loc} {AG20} 

#define_attribute  {RxD}  {xc_loc}  {AG15} 
define_attribute  {p:RxD} {xc_loc} {AG15} 

#define_attribute  {ddr2_we_n}  {xc_loc}  {K29} 
define_attribute  {p:ddr2_we_n} {xc_loc} {K29} 

#define_attribute  {ddr2_cs_n[0]}  {xc_loc}  {L29} 
define_attribute  {b:ddr2_cs_n[0]} {xc_loc} {L29} 

#define_attribute  {ddr2_cs_n[1]}  {xc_loc}  {J29} 
define_attribute  {b:ddr2_cs_n[1]} {xc_loc} {J29} 

#define_attribute  {ddr2_cke[0]}  {xc_loc}  {T28} 
define_attribute  {b:ddr2_cke[0]} {xc_loc} {T28} 

#define_attribute  {ddr2_cke[1]}  {xc_loc}  {U30} 
define_attribute  {b:ddr2_cke[1]} {xc_loc} {U30} 

#define_attribute  {ddr2_ck[0]}  {xc_loc}  {AK29} 
define_attribute  {b:ddr2_ck[0]} {xc_loc} {AK29} 

#define_attribute  {ddr2_ck_n[0]}  {xc_loc}  {AJ29} 
define_attribute  {b:ddr2_ck_n[0]} {xc_loc} {AJ29} 

#define_attribute  {ddr2_ck[1]}  {xc_loc}  {E28} 
define_attribute  {b:ddr2_ck[1]} {xc_loc} {E28} 

#define_attribute  {ddr2_ck_n[1]}  {xc_loc}  {F28} 
define_attribute  {b:ddr2_ck_n[1]} {xc_loc} {F28} 

#define_attribute  {ddr2_a[0]}  {xc_loc}  {L30} 
define_attribute  {b:ddr2_a[0]} {xc_loc} {L30} 

#define_attribute  {ddr2_a[1]}  {xc_loc}  {M30} 
define_attribute  {b:ddr2_a[1]} {xc_loc} {M30} 

#define_attribute  {ddr2_a[2]}  {xc_loc}  {N29} 
define_attribute  {b:ddr2_a[2]} {xc_loc} {N29} 

#define_attribute  {ddr2_a[3]}  {xc_loc}  {P29} 
define_attribute  {b:ddr2_a[3]} {xc_loc} {P29} 

#define_attribute  {ddr2_a[4]}  {xc_loc}  {K31} 
define_attribute  {b:ddr2_a[4]} {xc_loc} {K31} 

#define_attribute  {ddr2_a[5]}  {xc_loc}  {L31} 
define_attribute  {b:ddr2_a[5]} {xc_loc} {L31} 

#define_attribute  {ddr2_a[6]}  {xc_loc}  {P31} 
define_attribute  {b:ddr2_a[6]} {xc_loc} {P31} 

#define_attribute  {ddr2_a[7]}  {xc_loc}  {P30} 
define_attribute  {b:ddr2_a[7]} {xc_loc} {P30} 

#define_attribute  {ddr2_a[8]}  {xc_loc}  {M31} 
define_attribute  {b:ddr2_a[8]} {xc_loc} {M31} 

#define_attribute  {ddr2_a[9]}  {xc_loc}  {R28} 
define_attribute  {b:ddr2_a[9]} {xc_loc} {R28} 

#define_attribute  {ddr2_a[10]}  {xc_loc}  {J31} 
define_attribute  {b:ddr2_a[10]} {xc_loc} {J31} 

#define_attribute  {ddr2_a[11]}  {xc_loc}  {R29} 
define_attribute  {b:ddr2_a[11]} {xc_loc} {R29} 

#define_attribute  {ddr2_a[12]}  {xc_loc}  {T31} 
define_attribute  {b:ddr2_a[12]} {xc_loc} {T31} 

#define_attribute  {ddr2_a[13]}  {xc_loc}  {H29} 
define_attribute  {b:ddr2_a[13]} {xc_loc} {H29} 

#define_attribute  {ddr2_ba[0]}  {xc_loc}  {G31} 
define_attribute  {b:ddr2_ba[0]} {xc_loc} {G31} 

#define_attribute  {ddr2_ba[1]}  {xc_loc}  {J30} 
define_attribute  {b:ddr2_ba[1]} {xc_loc} {J30} 

#define_attribute  {ddr2_ba[2]}  {xc_loc}  {R31} 
define_attribute  {b:ddr2_ba[2]} {xc_loc} {R31} 

#define_attribute  {ddr2_ras_n}  {xc_loc}  {H30} 
define_attribute  {p:ddr2_ras_n} {xc_loc} {H30} 

#define_attribute  {ddr2_cas_n}  {xc_loc}  {E31} 
define_attribute  {p:ddr2_cas_n} {xc_loc} {E31} 

#define_attribute  {ddr2_odt[0]}  {xc_loc}  {F31} 
define_attribute  {b:ddr2_odt[0]} {xc_loc} {F31} 

#define_attribute  {ddr2_odt[1]}  {xc_loc}  {F30} 
define_attribute  {b:ddr2_odt[1]} {xc_loc} {F30} 

#define_attribute  {ddr2_dq[0]}  {xc_loc}  {AF30} 
define_attribute  {b:ddr2_dq[0]} {xc_loc} {AF30} 

#define_attribute  {ddr2_dq[1]}  {xc_loc}  {AK31} 
define_attribute  {b:ddr2_dq[1]} {xc_loc} {AK31} 

#define_attribute  {ddr2_dq[2]}  {xc_loc}  {AF31} 
define_attribute  {b:ddr2_dq[2]} {xc_loc} {AF31} 

#define_attribute  {ddr2_dq[3]}  {xc_loc}  {AD30} 
define_attribute  {b:ddr2_dq[3]} {xc_loc} {AD30} 

#define_attribute  {ddr2_dq[4]}  {xc_loc}  {AJ30} 
define_attribute  {b:ddr2_dq[4]} {xc_loc} {AJ30} 

#define_attribute  {ddr2_dq[5]}  {xc_loc}  {AF29} 
define_attribute  {b:ddr2_dq[5]} {xc_loc} {AF29} 

#define_attribute  {ddr2_dq[6]}  {xc_loc}  {AD29} 
define_attribute  {b:ddr2_dq[6]} {xc_loc} {AD29} 

#define_attribute  {ddr2_dq[7]}  {xc_loc}  {AE29} 
define_attribute  {b:ddr2_dq[7]} {xc_loc} {AE29} 

#define_attribute  {ddr2_dqs[0]}  {xc_loc}  {AA29} 
define_attribute  {b:ddr2_dqs[0]} {xc_loc} {AA29} 

#define_attribute  {ddr2_dqs_n[0]}  {xc_loc}  {AA30} 
define_attribute  {b:ddr2_dqs_n[0]} {xc_loc} {AA30} 

#define_attribute  {ddr2_dm[0]}  {xc_loc}  {AJ31} 
define_attribute  {b:ddr2_dm[0]} {xc_loc} {AJ31} 

#define_attribute  {ddr2_dq[8]}  {xc_loc}  {AH27} 
define_attribute  {b:ddr2_dq[8]} {xc_loc} {AH27} 

#define_attribute  {ddr2_dq[9]}  {xc_loc}  {AF28} 
define_attribute  {b:ddr2_dq[9]} {xc_loc} {AF28} 

#define_attribute  {ddr2_dq[10]}  {xc_loc}  {AH28} 
define_attribute  {b:ddr2_dq[10]} {xc_loc} {AH28} 

#define_attribute  {ddr2_dq[11]}  {xc_loc}  {AA28} 
define_attribute  {b:ddr2_dq[11]} {xc_loc} {AA28} 

#define_attribute  {ddr2_dq[12]}  {xc_loc}  {AG25} 
define_attribute  {b:ddr2_dq[12]} {xc_loc} {AG25} 

#define_attribute  {ddr2_dq[13]}  {xc_loc}  {AJ26} 
define_attribute  {b:ddr2_dq[13]} {xc_loc} {AJ26} 

#define_attribute  {ddr2_dq[14]}  {xc_loc}  {AG28} 
define_attribute  {b:ddr2_dq[14]} {xc_loc} {AG28} 

#define_attribute  {ddr2_dq[15]}  {xc_loc}  {AB28} 
define_attribute  {b:ddr2_dq[15]} {xc_loc} {AB28} 

#define_attribute  {ddr2_dqs[1]}  {xc_loc}  {AK28} 
define_attribute  {b:ddr2_dqs[1]} {xc_loc} {AK28} 

#define_attribute  {ddr2_dqs_n[1]}  {xc_loc}  {AK27} 
define_attribute  {b:ddr2_dqs_n[1]} {xc_loc} {AK27} 

#define_attribute  {ddr2_dm[1]}  {xc_loc}  {AE28} 
define_attribute  {b:ddr2_dm[1]} {xc_loc} {AE28} 

#define_attribute  {ddr2_dq[16]}  {xc_loc}  {AC28} 
define_attribute  {b:ddr2_dq[16]} {xc_loc} {AC28} 

#define_attribute  {ddr2_dq[17]}  {xc_loc}  {AB25} 
define_attribute  {b:ddr2_dq[17]} {xc_loc} {AB25} 

#define_attribute  {ddr2_dq[18]}  {xc_loc}  {AC27} 
define_attribute  {b:ddr2_dq[18]} {xc_loc} {AC27} 

#define_attribute  {ddr2_dq[19]}  {xc_loc}  {AA26} 
define_attribute  {b:ddr2_dq[19]} {xc_loc} {AA26} 

#define_attribute  {ddr2_dq[20]}  {xc_loc}  {AB26} 
define_attribute  {b:ddr2_dq[20]} {xc_loc} {AB26} 

#define_attribute  {ddr2_dq[21]}  {xc_loc}  {AA24} 
define_attribute  {b:ddr2_dq[21]} {xc_loc} {AA24} 

#define_attribute  {ddr2_dq[22]}  {xc_loc}  {AB27} 
define_attribute  {b:ddr2_dq[22]} {xc_loc} {AB27} 

#define_attribute  {ddr2_dq[23]}  {xc_loc}  {AA25} 
define_attribute  {b:ddr2_dq[23]} {xc_loc} {AA25} 

#define_attribute  {ddr2_dqs[2]}  {xc_loc}  {AK26} 
define_attribute  {b:ddr2_dqs[2]} {xc_loc} {AK26} 

#define_attribute  {ddr2_dqs_n[2]}  {xc_loc}  {AJ27} 
define_attribute  {b:ddr2_dqs_n[2]} {xc_loc} {AJ27} 

#define_attribute  {ddr2_dm[2]}  {xc_loc}  {Y24} 
define_attribute  {b:ddr2_dm[2]} {xc_loc} {Y24} 

#define_attribute  {ddr2_dq[24]}  {xc_loc}  {AC29} 
define_attribute  {b:ddr2_dq[24]} {xc_loc} {AC29} 

#define_attribute  {ddr2_dq[25]}  {xc_loc}  {AB30} 
define_attribute  {b:ddr2_dq[25]} {xc_loc} {AB30} 

#define_attribute  {ddr2_dq[26]}  {xc_loc}  {W31} 
define_attribute  {b:ddr2_dq[26]} {xc_loc} {W31} 

#define_attribute  {ddr2_dq[27]}  {xc_loc}  {V30} 
define_attribute  {b:ddr2_dq[27]} {xc_loc} {V30} 

#define_attribute  {ddr2_dq[28]}  {xc_loc}  {AC30} 
define_attribute  {b:ddr2_dq[28]} {xc_loc} {AC30} 

#define_attribute  {ddr2_dq[29]}  {xc_loc}  {W29} 
define_attribute  {b:ddr2_dq[29]} {xc_loc} {W29} 

#define_attribute  {ddr2_dq[30]}  {xc_loc}  {V27} 
define_attribute  {b:ddr2_dq[30]} {xc_loc} {V27} 

#define_attribute  {ddr2_dq[31]}  {xc_loc}  {W27} 
define_attribute  {b:ddr2_dq[31]} {xc_loc} {W27} 

#define_attribute  {ddr2_dqs[3]}  {xc_loc}  {AB31} 
define_attribute  {b:ddr2_dqs[3]} {xc_loc} {AB31} 

#define_attribute  {ddr2_dqs_n[3]}  {xc_loc}  {AA31} 
define_attribute  {b:ddr2_dqs_n[3]} {xc_loc} {AA31} 

#define_attribute  {ddr2_dm[3]}  {xc_loc}  {Y31} 
define_attribute  {b:ddr2_dm[3]} {xc_loc} {Y31} 

#define_attribute  {ddr2_dq[32]}  {xc_loc}  {V29} 
define_attribute  {b:ddr2_dq[32]} {xc_loc} {V29} 

#define_attribute  {ddr2_dq[33]}  {xc_loc}  {Y27} 
define_attribute  {b:ddr2_dq[33]} {xc_loc} {Y27} 

#define_attribute  {ddr2_dq[34]}  {xc_loc}  {Y26} 
define_attribute  {b:ddr2_dq[34]} {xc_loc} {Y26} 

#define_attribute  {ddr2_dq[35]}  {xc_loc}  {W24} 
define_attribute  {b:ddr2_dq[35]} {xc_loc} {W24} 

#define_attribute  {ddr2_dq[36]}  {xc_loc}  {V28} 
define_attribute  {b:ddr2_dq[36]} {xc_loc} {V28} 

#define_attribute  {ddr2_dq[37]}  {xc_loc}  {W25} 
define_attribute  {b:ddr2_dq[37]} {xc_loc} {W25} 

#define_attribute  {ddr2_dq[38]}  {xc_loc}  {W26} 
define_attribute  {b:ddr2_dq[38]} {xc_loc} {W26} 

#define_attribute  {ddr2_dq[39]}  {xc_loc}  {V24} 
define_attribute  {b:ddr2_dq[39]} {xc_loc} {V24} 

#define_attribute  {ddr2_dqs[4]}  {xc_loc}  {Y28} 
define_attribute  {b:ddr2_dqs[4]} {xc_loc} {Y28} 

#define_attribute  {ddr2_dqs_n[4]}  {xc_loc}  {Y29} 
define_attribute  {b:ddr2_dqs_n[4]} {xc_loc} {Y29} 

#define_attribute  {ddr2_dm[4]}  {xc_loc}  {V25} 
define_attribute  {b:ddr2_dm[4]} {xc_loc} {V25} 

#define_attribute  {ddr2_dq[40]}  {xc_loc}  {R24} 
define_attribute  {b:ddr2_dq[40]} {xc_loc} {R24} 

#define_attribute  {ddr2_dq[41]}  {xc_loc}  {P25} 
define_attribute  {b:ddr2_dq[41]} {xc_loc} {P25} 

#define_attribute  {ddr2_dq[42]}  {xc_loc}  {N24} 
define_attribute  {b:ddr2_dq[42]} {xc_loc} {N24} 

#define_attribute  {ddr2_dq[43]}  {xc_loc}  {P26} 
define_attribute  {b:ddr2_dq[43]} {xc_loc} {P26} 

#define_attribute  {ddr2_dq[44]}  {xc_loc}  {T24} 
define_attribute  {b:ddr2_dq[44]} {xc_loc} {T24} 

#define_attribute  {ddr2_dq[45]}  {xc_loc}  {N25} 
define_attribute  {b:ddr2_dq[45]} {xc_loc} {N25} 

#define_attribute  {ddr2_dq[46]}  {xc_loc}  {P27} 
define_attribute  {b:ddr2_dq[46]} {xc_loc} {P27} 

#define_attribute  {ddr2_dq[47]}  {xc_loc}  {N28} 
define_attribute  {b:ddr2_dq[47]} {xc_loc} {N28} 

#define_attribute  {ddr2_dqs[5]}  {xc_loc}  {E26} 
define_attribute  {b:ddr2_dqs[5]} {xc_loc} {E26} 

#define_attribute  {ddr2_dqs_n[5]}  {xc_loc}  {E27} 
define_attribute  {b:ddr2_dqs_n[5]} {xc_loc} {E27} 

#define_attribute  {ddr2_dm[5]}  {xc_loc}  {P24} 
define_attribute  {b:ddr2_dm[5]} {xc_loc} {P24} 

#define_attribute  {ddr2_dq[48]}  {xc_loc}  {M28} 
define_attribute  {b:ddr2_dq[48]} {xc_loc} {M28} 

#define_attribute  {ddr2_dq[49]}  {xc_loc}  {L28} 
define_attribute  {b:ddr2_dq[49]} {xc_loc} {L28} 

#define_attribute  {ddr2_dq[50]}  {xc_loc}  {F25} 
define_attribute  {b:ddr2_dq[50]} {xc_loc} {F25} 

#define_attribute  {ddr2_dq[51]}  {xc_loc}  {H25} 
define_attribute  {b:ddr2_dq[51]} {xc_loc} {H25} 

#define_attribute  {ddr2_dq[52]}  {xc_loc}  {K27} 
define_attribute  {b:ddr2_dq[52]} {xc_loc} {K27} 

#define_attribute  {ddr2_dq[53]}  {xc_loc}  {K28} 
define_attribute  {b:ddr2_dq[53]} {xc_loc} {K28} 

#define_attribute  {ddr2_dq[54]}  {xc_loc}  {H24} 
define_attribute  {b:ddr2_dq[54]} {xc_loc} {H24} 

#define_attribute  {ddr2_dq[55]}  {xc_loc}  {G26} 
define_attribute  {b:ddr2_dq[55]} {xc_loc} {G26} 

#define_attribute  {ddr2_dqs[6]}  {xc_loc}  {H28} 
define_attribute  {b:ddr2_dqs[6]} {xc_loc} {H28} 

#define_attribute  {ddr2_dqs_n[6]}  {xc_loc}  {G28} 
define_attribute  {b:ddr2_dqs_n[6]} {xc_loc} {G28} 

#define_attribute  {ddr2_dm[6]}  {xc_loc}  {F26} 
define_attribute  {b:ddr2_dm[6]} {xc_loc} {F26} 

#define_attribute  {ddr2_dq[56]}  {xc_loc}  {G25} 
define_attribute  {b:ddr2_dq[56]} {xc_loc} {G25} 

#define_attribute  {ddr2_dq[57]}  {xc_loc}  {M26} 
define_attribute  {b:ddr2_dq[57]} {xc_loc} {M26} 

#define_attribute  {ddr2_dq[58]}  {xc_loc}  {J24} 
define_attribute  {b:ddr2_dq[58]} {xc_loc} {J24} 

#define_attribute  {ddr2_dq[59]}  {xc_loc}  {L26} 
define_attribute  {b:ddr2_dq[59]} {xc_loc} {L26} 

#define_attribute  {ddr2_dq[60]}  {xc_loc}  {J27} 
define_attribute  {b:ddr2_dq[60]} {xc_loc} {J27} 

#define_attribute  {ddr2_dq[61]}  {xc_loc}  {M25} 
define_attribute  {b:ddr2_dq[61]} {xc_loc} {M25} 

#define_attribute  {ddr2_dq[62]}  {xc_loc}  {L25} 
define_attribute  {b:ddr2_dq[62]} {xc_loc} {L25} 

#define_attribute  {ddr2_dq[63]}  {xc_loc}  {L24} 
define_attribute  {b:ddr2_dq[63]} {xc_loc} {L24} 

#define_attribute  {ddr2_dqs[7]}  {xc_loc}  {G27} 
define_attribute  {b:ddr2_dqs[7]} {xc_loc} {G27} 

#define_attribute  {ddr2_dqs_n[7]}  {xc_loc}  {H27} 
define_attribute  {b:ddr2_dqs_n[7]} {xc_loc} {H27} 

#define_attribute  {ddr2_dm[7]}  {xc_loc}  {J25} 
define_attribute  {b:ddr2_dm[7]} {xc_loc} {J25} 

#define_attribute [get_cells {gen_eth_dma_master.EMac0_block.gmii0.RXD_TO_MAC[7:0]}]  {syn_useioff}  {1} 
define_attribute {i:gen_eth_dma_master.EMac0_block.gmii0.RXD_TO_MAC[7:0]} syn_useioff {1} 

#define_attribute [get_cells {gen_eth_dma_master.EMac0_block.gmii0.RX_DV_TO_MAC}]  {syn_useioff}  {1} 
define_attribute {i:gen_eth_dma_master.EMac0_block.gmii0.RX_DV_TO_MAC} syn_useioff {1} 

#define_attribute [get_cells {gen_eth_dma_master.EMac0_block.gmii0.RX_ER_TO_MAC}]  {syn_useioff}  {1} 
define_attribute {i:gen_eth_dma_master.EMac0_block.gmii0.RX_ER_TO_MAC} syn_useioff {1} 

#define_attribute [get_cells {gen_eth_dma_master.EMac0_block.gmii0.GMII_TXD[7:0]}]  {syn_useioff}  {1} 
define_attribute {i:gen_eth_dma_master.EMac0_block.gmii0.GMII_TXD[7:0]} syn_useioff {1} 

#define_attribute [get_cells {gen_eth_dma_master.EMac0_block.gmii0.GMII_TX_EN}]  {syn_useioff}  {1} 
define_attribute {i:gen_eth_dma_master.EMac0_block.gmii0.GMII_TX_EN} syn_useioff {1} 

#define_attribute [get_cells {gen_eth_dma_master.EMac0_block.gmii0.GMII_TX_ER}]  {syn_useioff}  {1} 
define_attribute {i:gen_eth_dma_master.EMac0_block.gmii0.GMII_TX_ER} syn_useioff {1} 

#define_attribute  {PHY_RXD[0]}  {xc_loc}  {A33} 
define_attribute  {b:PHY_RXD[0]} {xc_loc} {A33} 

#define_attribute  {PHY_RXD[1]}  {xc_loc}  {B33} 
define_attribute  {b:PHY_RXD[1]} {xc_loc} {B33} 

#define_attribute  {PHY_RXD[2]}  {xc_loc}  {C33} 
define_attribute  {b:PHY_RXD[2]} {xc_loc} {C33} 

#define_attribute  {PHY_RXD[3]}  {xc_loc}  {C32} 
define_attribute  {b:PHY_RXD[3]} {xc_loc} {C32} 

#define_attribute  {PHY_RXD[4]}  {xc_loc}  {D32} 
define_attribute  {b:PHY_RXD[4]} {xc_loc} {D32} 

#define_attribute  {PHY_RXD[5]}  {xc_loc}  {C34} 
define_attribute  {b:PHY_RXD[5]} {xc_loc} {C34} 

#define_attribute  {PHY_RXD[6]}  {xc_loc}  {D34} 
define_attribute  {b:PHY_RXD[6]} {xc_loc} {D34} 

#define_attribute  {PHY_RXD[7]}  {xc_loc}  {F33} 
define_attribute  {b:PHY_RXD[7]} {xc_loc} {F33} 

#define_attribute  {PHY_RXDV}  {xc_loc}  {E32} 
define_attribute  {p:PHY_RXDV} {xc_loc} {E32} 

#define_attribute  {PHY_RXER}  {xc_loc}  {E33} 
define_attribute  {p:PHY_RXER} {xc_loc} {E33} 

#define_attribute  {PHY_RXCLK}  {xc_loc}  {H17} 
define_attribute  {p:PHY_RXCLK c:PHY_RXCLK} {xc_loc} {H17} 

#define_attribute  {PHY_TXD[0]}  {xc_loc}  {AF11} 
define_attribute  {b:PHY_TXD[0]} {xc_loc} {AF11} 

#define_attribute  {PHY_TXD[1]}  {xc_loc}  {AE11} 
define_attribute  {b:PHY_TXD[1]} {xc_loc} {AE11} 

#define_attribute  {PHY_TXD[2]}  {xc_loc}  {AH9} 
define_attribute  {b:PHY_TXD[2]} {xc_loc} {AH9} 

#define_attribute  {PHY_TXD[3]}  {xc_loc}  {AH10} 
define_attribute  {b:PHY_TXD[3]} {xc_loc} {AH10} 

#define_attribute  {PHY_TXD[4]}  {xc_loc}  {AG8} 
define_attribute  {b:PHY_TXD[4]} {xc_loc} {AG8} 

#define_attribute  {PHY_TXD[5]}  {xc_loc}  {AH8} 
define_attribute  {b:PHY_TXD[5]} {xc_loc} {AH8} 

#define_attribute  {PHY_TXD[6]}  {xc_loc}  {AG10} 
define_attribute  {b:PHY_TXD[6]} {xc_loc} {AG10} 

#define_attribute  {PHY_TXD[7]}  {xc_loc}  {AG11} 
define_attribute  {b:PHY_TXD[7]} {xc_loc} {AG11} 

#define_attribute  {PHY_TXEN}  {xc_loc}  {AJ10} 
define_attribute  {p:PHY_TXEN} {xc_loc} {AJ10} 

#define_attribute  {PHY_TXER}  {xc_loc}  {AJ9} 
define_attribute  {p:PHY_TXER} {xc_loc} {AJ9} 

#define_attribute  {PHY_GTXCLK}  {xc_loc}  {J16} 
define_attribute  {p:PHY_GTXCLK} {xc_loc} {J16} 

#define_attribute -disable  {PHY_TXCLK}  {xc_loc}  {K17} 
#define_attribute -disable  {PHY_COL}  {xc_loc}  {B32} 
#define_attribute -disable  {PHY_CRS}  {xc_loc}  {E34} 
#define_attribute  {PHY_RESET}  {xc_loc}  {J14} 
define_attribute  {p:PHY_RESET} {xc_loc} {J14} 

#define_attribute  {error1_led}  {xc_loc}  {F6} 
define_attribute  {p:error1_led} {xc_loc} {F6} 

#define_attribute  {error2_led}  {xc_loc}  {T10} 
define_attribute  {p:error2_led} {xc_loc} {T10} 

#define_attribute  {clk200_p}  {xc_loc}  {L19} 
define_attribute  {p:clk200_p} {xc_loc} {L19} 

#define_attribute  {clk200_n}  {xc_loc}  {K19} 
define_attribute  {p:clk200_n} {xc_loc} {K19} 

#define_attribute -disable  {mac_lsn[0]}  {xc_loc}  {AC24} 
#define_attribute -disable  {mac_lsn[1]}  {xc_loc}  {AC25} 
#define_attribute -disable  {mac_lsn[2]}  {xc_loc}  {AE26} 
#define_attribute -disable  {mac_lsn[3]}  {xc_loc}  {AE27} 
#define_attribute -disable [get_cells {gen_cpu.gen_dmmu.genblk140®genblk141®gen_dmmutlb.genblk137®genblk138®dtlbram_split.lru_ram_1}]  {syn_ramstyle}  {select_ram} 
#define_attribute -disable [get_cells {gen_cpu.gen_dmmu.genblk140®genblk141®gen_dmmutlb.genblk137®genblk138®dtlbram_split.lru_ram}]  {syn_ramstyle}  {select_ram} 
#define_attribute -disable [get_cells {gen_cpu.gen_immu.genblk127®genblk128®gen_immutlb.genblk121®genblk122®itlbram_split.lru_ram}]  {syn_ramstyle}  {select_ram} 
#define_attribute -disable [get_cells {gen_cpu.gen_immu.genblk127®genblk128®gen_immutlb.genblk121®genblk122®itlbram_split.lru_ram_1}]  {syn_ramstyle}  {select_ram} 
#define_global_attribute  {syn_useioff}  {1} 
define_global_attribute syn_useioff {1} 

#define_global_attribute  {syn_ramstyle}  {select_ram} 
define_global_attribute syn_ramstyle select_ram 

#define_attribute [get_ports {sys_reset_n}]  {xc_loc}  {AE14} 
define_attribute  {p:sys_reset_n} {xc_loc} {AE14} 

#define_attribute [get_ports {sys_clk_p}]  {xc_loc}  {P4} 
define_attribute  {p:sys_clk_p} {xc_loc} {P4} 

#define_attribute [get_ports {sys_clk_n}]  {xc_loc}  {P3} 
define_attribute  {p:sys_clk_n} {xc_loc} {P3} 

#define_attribute -disable [get_cells {gen_cpu.pcie_interface.ep.pcie_ep0.pcie_blk.pcie_mim_wrapper_i.bram_retry.genblk197®generate_sdp®ram_sdp_inst}]  {xc_rloc}  {RAMB36_X3Y12} 
#define_attribute -disable [get_cells {gen_cpu.pcie_interface.ep.pcie_ep0.pcie_blk.pcie_mim_wrapper_i.bram_tl_tx.genblk197®genblk198®genblk199®generate_tdp2Û1Ý®ram_tdp2_inst}]  {xc_rloc}  {RAMB36_X3Y11} 
#define_attribute -disable [get_cells {gen_cpu.pcie_interface.ep.pcie_ep0.pcie_blk.pcie_mim_wrapper_i.bram_tl_rx.genblk197®genblk198®genblk199®generate_tdp2Û1Ý®ram_tdp2_inst}]  {xc_rloc}  {RAMB36_X3Y10} 
#define_attribute -disable [get_cells {gen_cpu.pcie_interface.ep.pcie_ep0.pcie_blk.pcie_mim_wrapper_i.bram_tl_tx.genblk197®genblk198®genblk199®generate_tdp2Û0Ý®ram_tdp2_inst}]  {xc_rloc}  {RAMB36_X3Y9} 
#define_attribute -disable [get_cells {gen_cpu.pcie_interface.ep.pcie_ep0.pcie_blk.pcie_mim_wrapper_i.bram_tl_rx.genblk197®genblk198®genblk199®generate_tdp2Û0Ý®ram_tdp2_inst}]  {xc_rloc}  {RAMB36_X3Y8} 
#define_attribute -disable [get_cells {gen_cpu.pcie_interface.ep.pcie_ep0.pcie_blk.SIO.genblk207®genblk208®pcie_gt_wrapper_i.genblk213®GTDÛ0Ý®GT_i}]  {xc_loc}  {GTP_DUAL_X0Y2} 
#define_attribute [get_ports {sys_reset_n}]  {xc_pullup}  {1} 
define_attribute  {p:sys_reset_n} {xc_pullup} {1} 

#define_attribute [get_ports {sys_reset_n}]  {xc_padtype}  {LVCMOS25} 
define_attribute  {p:sys_reset_n} {xc_padtype} {LVCMOS25} 

#define_attribute -disable  {xc_loc}  {GTP_DUAL_X0Y2} 
#define_attribute [get_cells {gen_cpu.pcie_interface.ep.pcie_ep0.pcie_blk.SIO.genblk215®genblk216®pcie_gt_wrapper_i.genblk210®GTDÛ0Ý®GT_i}]  {xc_rloc}  {GTP_DUAL_X0Y2} 
define_attribute {i:gen_cpu.pcie_interface.ep.pcie_ep0.pcie_blk.SIO.genblk215®genblk216®pcie_gt_wrapper_i.genblk210®GTDÛ0Ý®GT_i} {xc_rloc} {GTP_DUAL_X0Y2} 

#define_io_standard -disable -default_input -delay_type  {input} 
#define_io_standard -disable -default_output -delay_type  {output} 
#define_io_standard -disable -default_bidir -delay_type  {bidir} 
#define_io_standard  {clkin_p} -delay_type  {input}  {syn_pad_type}  {LVCMOS_33} 
define_io_standard {clkin_p} -delay_type {input} syn_pad_type {LVCMOS_33} 

#define_io_standard  {clk200_n} -delay_type  {input}  {syn_pad_type}  {LVDS_25} 
define_io_standard {clk200_n} -delay_type {input} syn_pad_type {LVDS_25} 

#define_io_standard  {clk200_p} -delay_type  {input}  {syn_pad_type}  {LVDS_25} 
define_io_standard {clk200_p} -delay_type {input} syn_pad_type {LVDS_25} 

#define_io_standard -disable  {clkin_n} -delay_type  {input} 
#define_io_standard  {rstin} -delay_type  {input}  {syn_pad_type}  {LVCMOS_33} 
define_io_standard {rstin} -delay_type {input} syn_pad_type {LVCMOS_33} 

#define_io_standard -disable  {irl[3:0]} -delay_type  {input} 
#define_io_standard -disable  {luterr} -delay_type  {output} 
#define_io_standard -disable  {bramerr} -delay_type  {output} 
#define_io_standard -disable  {sb_ecc} -delay_type  {output} 
#define_io_standard -disable  {done_led}  {syn_pad_type}  {LVCMOS_25} 
#define_io_standard -disable  {error_led}  {syn_pad_type}  {LVCMOS_25} 
#define_io_standard  {cpurst}  {syn_pad_type}  {LVCMOS_33} 
define_io_standard {cpurst} syn_pad_type {LVCMOS_33} 

#define_io_standard  {TxD}  {syn_pad_type}  {LVCMOS33} 
define_io_standard {TxD} syn_pad_type {LVCMOS33} 

#define_io_standard  {RxD}  {syn_pad_type}  {LVCMOS33} 
define_io_standard {RxD} syn_pad_type {LVCMOS33} 

#define_io_standard  {ddr2_we_n}  {syn_pad_type}  {SSTL18_II} 
define_io_standard {ddr2_we_n} syn_pad_type {SSTL18_II} 

#define_io_standard  {ddr2_dq[63:0]}  {syn_pad_type}  {SSTL18_II_DCI} 
define_io_standard {ddr2_dq[63:0]} syn_pad_type {SSTL18_II_DCI} 

#define_io_standard  {ddr2_dm[7:0]}  {syn_pad_type}  {SSTL18_II} 
define_io_standard {ddr2_dm[7:0]} syn_pad_type {SSTL18_II} 

#define_io_standard  {ddr2_dqs[7:0]}  {syn_pad_type}  {DIFF_SSTL18_II_DCI} 
define_io_standard {ddr2_dqs[7:0]} syn_pad_type {DIFF_SSTL18_II_DCI} 

#define_io_standard  {ddr2_dqs_n[7:0]}  {syn_pad_type}  {DIFF_SSTL18_II_DCI} 
define_io_standard {ddr2_dqs_n[7:0]} syn_pad_type {DIFF_SSTL18_II_DCI} 

#define_io_standard  {ddr2_ck[1:0]}  {syn_pad_type}  {DIFF_SSTL18_II} 
define_io_standard {ddr2_ck[1:0]} syn_pad_type {DIFF_SSTL18_II} 

#define_io_standard  {ddr2_ck_n[1:0]}  {syn_pad_type}  {DIFF_SSTL18_II} 
define_io_standard {ddr2_ck_n[1:0]} syn_pad_type {DIFF_SSTL18_II} 

#define_io_standard  {ddr2_a[13:0]}  {syn_pad_type}  {SSTL18_II} 
define_io_standard {ddr2_a[13:0]} syn_pad_type {SSTL18_II} 

#define_io_standard  {ddr2_ras_n}  {syn_pad_type}  {SSTL18_II} 
define_io_standard {ddr2_ras_n} syn_pad_type {SSTL18_II} 

#define_io_standard  {ddr2_cas_n}  {syn_pad_type}  {SSTL18_II} 
define_io_standard {ddr2_cas_n} syn_pad_type {SSTL18_II} 

#define_io_standard  {ddr2_ba[2:0]}  {syn_pad_type}  {SSTL18_II} 
define_io_standard {ddr2_ba[2:0]} syn_pad_type {SSTL18_II} 

#define_io_standard  {ddr2_odt[1:0]}  {syn_pad_type}  {SSTL18_II} 
define_io_standard {ddr2_odt[1:0]} syn_pad_type {SSTL18_II} 

#define_io_standard  {ddr2_cs_n[1:0]}  {syn_pad_type}  {SSTL18_II} 
define_io_standard {ddr2_cs_n[1:0]} syn_pad_type {SSTL18_II} 

#define_io_standard  {ddr2_cke[1:0]}  {syn_pad_type}  {SSTL18_II} 
define_io_standard {ddr2_cke[1:0]} syn_pad_type {SSTL18_II} 

#define_io_standard  {PHY_TXD[7:0]}  {syn_pad_type}  {LVCMOS33} 
define_io_standard {PHY_TXD[7:0]} syn_pad_type {LVCMOS33} 

#define_io_standard  {PHY_TXEN}  {syn_pad_type}  {LVCMOS33} 
define_io_standard {PHY_TXEN} syn_pad_type {LVCMOS33} 

#define_io_standard  {PHY_TXER}  {syn_pad_type}  {LVCMOS33} 
define_io_standard {PHY_TXER} syn_pad_type {LVCMOS33} 

#define_io_standard  {PHY_RXD[7:0]}  {syn_pad_type}  {LVCMOS33} 
define_io_standard {PHY_RXD[7:0]} syn_pad_type {LVCMOS33} 

#define_io_standard  {PHY_RXDV}  {syn_pad_type}  {LVCMOS33} 
define_io_standard {PHY_RXDV} syn_pad_type {LVCMOS33} 

#define_io_standard  {PHY_RXER}  {syn_pad_type}  {LVCMOS33} 
define_io_standard {PHY_RXER} syn_pad_type {LVCMOS33} 

#define_io_standard  {PHY_GTXCLK}  {syn_pad_type}  {LVCMOS25} 
define_io_standard {PHY_GTXCLK} syn_pad_type {LVCMOS25} 

#define_io_standard  {PHY_RXCLK}  {syn_pad_type}  {LVCMOS25} 
define_io_standard {PHY_RXCLK} syn_pad_type {LVCMOS25} 

#define_io_standard -disable  {PHY_TXCLK}  {syn_pad_type}  {LVCMOS25} 
#define_io_standard -disable  {PHY_COL}  {syn_pad_type}  {LVCMOS33} 
#define_io_standard -disable  {PHY_CRS}  {syn_pad_type}  {LVCMOS33} 
#define_io_standard  {PHY_RESET}  {syn_pad_type}  {LVCMOS25} 
define_io_standard {PHY_RESET} syn_pad_type {LVCMOS25} 

#define_io_standard  {error1_led}  {syn_pad_type}  {LVCMOS_33} 
define_io_standard {error1_led} syn_pad_type {LVCMOS_33} 

#define_io_standard  {error2_led}  {syn_pad_type}  {LVCMOS_33} 
define_io_standard {error2_led} syn_pad_type {LVCMOS_33} 

#define_io_standard -disable  {mac_lsn[3:0]}  {syn_pad_type}  {LVCMOS_18} 
#define_attribute [get_cells {State[6:0]}]  {syn_encoding}  {onehot} 
define_attribute {i:State[6:0]} syn_encoding {onehot} 

#define_attribute [get_cells {rstate®state[17:0]}]  {syn_encoding}  {onehot} 
define_attribute {i:rstate®state[17:0]} syn_encoding {onehot} 

#define_clock -internal  {4} [get_nets {gen_eth_dma_master.gigaeth.genblk87.genblk88.macgmii.dfs_clkfx}] -name  {xcv5_mac_gmii_5s_4s_10_000000_1s_31s|dfs_clkfx_derived_clock} -ref_rise  {0.000000} -ref_fall  {3.800000} -uncertainty  {0.000000} -period  {7.600000} -clockgroup  {default_clkgroup_5} -rise  {0.000000} -fall  {3.800000} 
#define_clock -internal  {4} [get_nets {gen_gclk_rst.gen_clk.genblk47.genblk48.xcv5_gen_clk.dfs_clk0}] -name  {xcv5_cpu_clkgen_9_000000_10_000000_9_500000|dfs_clk0_derived_clock} -ref_rise  {0.000000} -ref_fall  {4.750000} -uncertainty  {0.000000} -period  {9.500000} -clockgroup  {default_clkgroup_5} -rise  {0.000000} -fall  {4.750000} 
#define_clock -internal  {4} [get_nets {gen_gclk_rst.gen_clk.genblk47.genblk48.xcv5_gen_clk.dfs_clkfx}] -name  {xcv5_cpu_clkgen_9_000000_10_000000_9_500000|dfs_clkfx_derived_clock} -ref_rise  {0.000000} -ref_fall  {5.277778} -uncertainty  {0.000000} -period  {10.555556} -clockgroup  {default_clkgroup_5} -rise  {0.000000} -fall  {5.277778} 
#define_clock -internal  {4} [get_nets {gen_gclk_rst.gen_dram_clk.genblk49.genblk50.genblk51.xcv5_gen_dram_clk_bee3.MCLKx}] -name  {xcv5_dram_clkgen_bee3_9_000000_4_000000_1_000000_10_000000_0s_25s_3_layer0|MCLKx_derived_clock_CLKIN} -ref_rise  {0.000000} -ref_fall  {2.111111} -uncertainty  {0.000000} -period  {4.222222} -clockgroup  {default_clkgroup_5} -rise  {0.000000} -fall  {2.111111} 
#define_clock -internal  {4} [get_nets {gen_gclk_rst.gen_dram_clk.genblk49.genblk50.genblk51.xcv5_gen_dram_clk_bee3.PLLBfb}] -name  {xcv5_dram_clkgen_bee3_9_000000_4_000000_1_000000_10_000000_0s_25s_3_layer0|PLLBfb_derived_clock_CLKIN} -ref_rise  {0.000000} -ref_fall  {4.750000} -uncertainty  {0.000000} -period  {9.500000} -clockgroup  {default_clkgroup_5} -rise  {0.000000} -fall  {4.750000} 
#define_clock -internal  {4} [get_nets {gen_gclk_rst.gen_dram_clk.genblk49.genblk50.genblk51.xcv5_gen_dram_clk_bee3.MCLK90x}] -name  {xcv5_dram_clkgen_bee3_9_000000_4_000000_1_000000_10_000000_0s_25s_3_layer0|MCLK90x_derived_clock_CLKIN} -ref_rise  {1.055556} -ref_fall  {3.166667} -uncertainty  {0.000000} -period  {4.222222} -clockgroup  {default_clkgroup_5} -rise  {1.055556} -fall  {3.166667} 
#define_clock -internal  {4} [get_nets {gen_gclk_rst.gen_dram_clk.genblk49.genblk50.genblk51.xcv5_gen_dram_clk_bee3.Ph0x}] -name  {xcv5_dram_clkgen_bee3_9_000000_4_000000_1_000000_10_000000_0s_25s_3_layer0|Ph0x_derived_clock_CLKIN} -ref_rise  {0.000000} -ref_fall  {6.333333} -uncertainty  {0.000000} -period  {16.888889} -clockgroup  {default_clkgroup_5} -rise  {0.000000} -fall  {6.333333} 
#define_clock -internal  {4} [get_nets {gen_gclk_rst.gen_dram_clk.genblk49.genblk50.genblk51.xcv5_gen_dram_clk_bee3.CLKx}] -name  {xcv5_dram_clkgen_bee3_9_000000_4_000000_1_000000_10_000000_0s_25s_3_layer0|CLKx_derived_clock_CLKIN} -ref_rise  {0.000000} -ref_fall  {4.222222} -uncertainty  {0.000000} -period  {8.444444} -clockgroup  {default_clkgroup_5} -rise  {0.000000} -fall  {4.222222} 
#define_clock -internal  {4} [get_nets {gen_gclk_rst.gen_clk.genblk47.genblk48.xcv5_gen_clk.dll_clk0}] -name  {xcv5_cpu_clkgen_9_000000_10_000000_9_500000|dll_clk0_derived_clock} -ref_rise  {0.000000} -ref_fall  {5.277750} -uncertainty  {0.000000} -period  {10.555500} -clockgroup  {default_clkgroup_5} -rise  {0.000000} -fall  {5.277750} 
#define_clock -internal  {4} [get_nets {gen_gclk_rst.gen_clk.genblk47.genblk48.xcv5_gen_clk.dll_clk2x}] -name  {xcv5_cpu_clkgen_9_000000_10_000000_9_500000|dll_clk2x_derived_clock} -ref_rise  {0.000000} -ref_fall  {2.638875} -uncertainty  {0.000000} -period  {5.277750} -clockgroup  {default_clkgroup_5} -rise  {0.000000} -fall  {2.638875} 
