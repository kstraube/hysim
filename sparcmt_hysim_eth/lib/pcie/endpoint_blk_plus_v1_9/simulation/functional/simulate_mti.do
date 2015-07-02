
vlib work
vmap work
vlog -work work +incdir+../.+../../example_design \
      -f board_rtl_x01.f 

vsim +notimingchecks +TESTNAME=sample_smoke_test0 -L work -L secureip -L unisims_ver \
    work.board glbl

run -all
