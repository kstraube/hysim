//------------------------------------------------------------------------------ 
// File:        speed_tm.sv
// Author:      Kramer Straube
// Description: simple timing model to speed up OS loading
//------------------------------------------------------------------------------  


`timescale 1ns / 1ps


`ifndef SYNP94
import libconf::*;
import libiu::*;
import libio::*;
import libstd::*;
import libdebug::*;
import libtm::*;
import libopcodes::*;
import libtm_cache::*;
`else
`include "../cpu/libiu.sv"
`include "../io/libio.sv"
`include "libtm.sv"
`endif

module speed_tm(input iu_clk_type gclk, input bit rst,
	input bit [42:0] eth2speedtm,//input from eth that has [num cores(10b),valid(1b), instruction address to run to(32b)]
	input tm_cpu_ctrl_token_type cpu2tm,
	output tm2cpu_token_type tm2cpu,
	output bit running,
	output bit done
        );
	
	bit [9:0] v_tid_out, v_ncores;
	reg [9:0] tid_out, ncores;
	bit v_running, v_done, v_valid, v_run, run, valid;
	bit [31:0] v_instr_store;
	reg [31:0] instr_store;
	reg [9:0] v_tid_dma,tid_dma, tid_out_store;

	always_comb begin
		v_running = ~done & (running | eth2speedtm[32]) & ~(cpu2tm.npc == instr_store);
		v_done = (cpu2tm.npc == instr_store); //send one pulse of done signal when I hit the instruction I should stop at
		v_instr_store = eth2speedtm[32] ? eth2speedtm[31:0] : instr_store;
		v_ncores = eth2speedtm[32] ? eth2speedtm[42:33] : ncores;
		if (valid) begin
		   v_tid_dma = tid_dma;
		end
		else if ((tid_dma+1) >= ncores) begin
			v_tid_dma = 10'b0; //reset to first core
		end
		else begin
			v_tid_dma = tid_dma + 1'b1; //increase TID number
		end

		if (~cpu2tm.valid) begin
			v_tid_out = tid_out_store;
		end
		else if ((tid_out_store+1) >= ncores) begin
			v_tid_out = 10'b0; //reset to first core
		end
		else begin
			v_tid_out = tid_out + 1'b1; //increase TID number
		end
		v_valid = cpu2tm.valid|(v_running&~running)|cpu2tm.replay;
		v_run = cpu2tm.valid|(v_running&~running)|cpu2tm.replay;
		tm2cpu.valid = valid&running;
		tm2cpu.run = run&running;
		tm2cpu.running = running;
		tm2cpu.tid = tid_out;
	end

	always_ff @(posedge gclk.clk) begin
		if (rst) begin
			running <= 1'b0;
			done <= 1'b0;
			tid_out <= 10'd0;
			instr_store <= 32'b0;
			ncores <= 10'b0;
			tid_dma <= 10'd0;
			tid_out_store <= 10'd0;
		end
		else begin
			valid <= v_valid&~v_done;
		        run <= v_run&~v_done;
			running <= v_running;
			done <= v_done;
			instr_store <= v_instr_store;
			tid_out_store <= v_tid_out;
			if (v_valid & ~v_done) begin
			   tid_out <= v_tid_out;
			end
			else begin
			   tid_out <= v_tid_dma;
			end
	
			tid_dma <= v_tid_dma;			
			ncores <= v_ncores;
		end
	end
endmodule
