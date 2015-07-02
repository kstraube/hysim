onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/DO
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/DOP
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/EMPTY
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/FULL
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/RDCOUNT
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/WRCOUNT
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/DI
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/DIP
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/RDCLK
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/RDEN
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/RST
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/WRCLK
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue2/WREN
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/DO
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/DOP
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/EMPTY
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/FULL
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/RDCOUNT
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/RDERR
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/WRCOUNT
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/DI
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/DIP
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/RDCLK
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/RDEN
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/RST
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/WRCLK
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_queue1/WREN
add wave -noupdate /sim_top/sim/gen_cpu/gclk
add wave -noupdate /sim_top/sim/gen_cpu/rst
add wave -noupdate /sim_top/sim/gen_cpu/dma_rb_in
add wave -noupdate /sim_top/sim/gen_cpu/dma_rb_out
add wave -noupdate /sim_top/sim/gen_cpu/dma_wb_in
add wave -noupdate /sim_top/sim/gen_cpu/dma_cmd_in
add wave -noupdate /sim_top/sim/gen_cpu/dma_cmd_ack
add wave -noupdate /sim_top/sim/gen_cpu/dma2tm
add wave -noupdate /sim_top/sim/gen_cpu/dma_done
add wave -noupdate /sim_top/sim/gen_cpu/tm_pkt_in
add wave -noupdate /sim_top/sim/gen_cpu/tm_pkt_out
add wave -noupdate /sim_top/sim/gen_cpu/tm_pkt_valid
add wave -noupdate /sim_top/sim/gen_cpu/eth_mem_rd
add wave -noupdate /sim_top/sim/gen_cpu/valid_out
add wave -noupdate /sim_top/sim/gen_cpu/pc_count
add wave -noupdate /sim_top/sim/gen_cpu/count_state
add wave -noupdate /sim_top/sim/gen_cpu/comr
add wave -noupdate /sim_top/sim/gen_cpu/der
add wave -noupdate /sim_top/sim/gen_cpu/regr
add wave -noupdate /sim_top/sim/gen_cpu/exr
add wave -noupdate /sim_top/sim/gen_cpu/memr
add wave -noupdate /sim_top/sim/gen_cpu/xcr
add wave -noupdate /sim_top/sim/gen_cpu/immu_if_in
add wave -noupdate /sim_top/sim/gen_cpu/immu_de_out
add wave -noupdate /sim_top/sim/gen_cpu/ex2mem_dmmu
add wave -noupdate /sim_top/sim/gen_cpu/mmu2hc
add wave -noupdate /sim_top/sim/gen_cpu/mmu2hc_invalid
add wave -noupdate /sim_top/sim/gen_cpu/iu2dmmu
add wave -noupdate /sim_top/sim/gen_cpu/dmmu2iu
add wave -noupdate /sim_top/sim/gen_cpu/dmmu2immu
add wave -noupdate /sim_top/sim/gen_cpu/itlb_miss
add wave -noupdate /sim_top/sim/gen_cpu/dtlb_miss
add wave -noupdate /sim_top/sim/gen_cpu/icache_if_in
add wave -noupdate /sim_top/sim/gen_cpu/icache_if_out
add wave -noupdate /sim_top/sim/gen_cpu/icache_de_out
add wave -noupdate /sim_top/sim/gen_cpu/icache_de_in
add wave -noupdate /sim_top/sim/gen_cpu/icache_mem2iu_stat
add wave -noupdate /sim_top/sim/gen_cpu/icache_iu2mem_tid
add wave -noupdate /sim_top/sim/gen_cpu/icache_iu2mem_cmd
add wave -noupdate /sim_top/sim/gen_cpu/icache_mem2cacheram
add wave -noupdate /sim_top/sim/gen_cpu/icache_cacheram2mem
add wave -noupdate /sim_top/sim/gen_cpu/dcache_data
add wave -noupdate /sim_top/sim/gen_cpu/iu2dcache
add wave -noupdate /sim_top/sim/gen_cpu/dcache2mmu
add wave -noupdate /sim_top/sim/gen_cpu/dcache2iu
add wave -noupdate /sim_top/sim/gen_cpu/dcache_mem2iu_stat
add wave -noupdate /sim_top/sim/gen_cpu/dcache_iu2mem_tid
add wave -noupdate /sim_top/sim/gen_cpu/dcache_iu2mem_cmd
add wave -noupdate /sim_top/sim/gen_cpu/dcache_mem2cacheram
add wave -noupdate /sim_top/sim/gen_cpu/dcache_cacheram2mem
add wave -noupdate /sim_top/sim/gen_cpu/iu2dma
add wave -noupdate /sim_top/sim/gen_cpu/dma2iu
add wave -noupdate /sim_top/sim/gen_cpu/dma_rtid
add wave -noupdate /sim_top/sim/gen_cpu/cpu2tm_out
add wave -noupdate /sim_top/sim/gen_cpu/replay_out
add wave -noupdate /sim_top/sim/gen_cpu/dma2cpu
add wave -noupdate /sim_top/sim/gen_cpu/tm2cpu
add wave -noupdate /sim_top/sim/gen_cpu/tm2cpu_final
add wave -noupdate /sim_top/sim/gen_cpu/r_tm2cpu
add wave -noupdate /sim_top/sim/gen_cpu/v_tm2cpu
add wave -noupdate /sim_top/sim/gen_cpu/tm2cpu_tid_inc
add wave -noupdate /sim_top/sim/gen_cpu/running
add wave -noupdate /sim_top/sim/gen_cpu/tick
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_empty
add wave -noupdate /sim_top/sim/gen_cpu/mem_out_full
add wave -noupdate /sim_top/sim/gen_cpu/replay_out_short
add wave -noupdate /sim_top/sim/gen_cpu/tm_pkt_out_1
add wave -noupdate /sim_top/sim/gen_cpu/tm_pkt_out_2
add wave -noupdate /sim_top/sim/gen_cpu/v_tid
add wave -noupdate /sim_top/sim/gen_cpu/io_in
add wave -noupdate /sim_top/sim/gen_cpu/io_out
add wave -noupdate /sim_top/sim/gen_cpu/irq_io_out
add wave -noupdate /sim_top/sim/gen_cpu/tm_io_out
add wave -noupdate /sim_top/sim/gen_cpu/comr_r_run
add wave -noupdate /sim_top/sim/gen_cpu/comr_run
add wave -noupdate /sim_top/sim/gen_cpu/comr_r_dma
add wave -noupdate /sim_top/sim/gen_cpu/comr_dma
add wave -noupdate /sim_top/sim/gen_cpu/host_global_perf_counter
add wave -noupdate /sim_top/sim/rstin
add wave -noupdate /sim_top/sim/RxD
add wave -noupdate /sim_top/sim/TxD
add wave -noupdate /sim_top/sim/gclk
add wave -noupdate /sim_top/sim/rst
add wave -noupdate /sim_top/sim/eth_rst
add wave -noupdate /sim_top/sim/eth_rb_in
add wave -noupdate /sim_top/sim/eth_wb_in
add wave -noupdate /sim_top/sim/eth_wb_out
add wave -noupdate /sim_top/sim/dma_rb_in
add wave -noupdate /sim_top/sim/dma_rb_out
add wave -noupdate /sim_top/sim/dma_wb_in
add wave -noupdate /sim_top/sim/dma_cmd_in
add wave -noupdate /sim_top/sim/dma_done
add wave -noupdate /sim_top/sim/dma2tm
add wave -noupdate /sim_top/sim/tm_data_to_host
add wave -noupdate /sim_top/sim/tm_data_from_cpu
add wave -noupdate /sim_top/sim/tm_data_to_cpu
add wave -noupdate /sim_top/sim/mem_data_out_valid
add wave -noupdate /sim_top/sim/valid_out
add wave -noupdate /sim_top/sim/eth_tm_reset
add wave -noupdate /sim_top/sim/cpu_reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {88316108 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 376
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {7809047014 ps} {8682558347 ps}
