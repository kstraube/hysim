//-- Copyright(C) 2008 by Xilinx, Inc. All rights reserved.
//-- This text contains proprietary, confidential
//-- information of Xilinx, Inc., is distributed
//-- under license from Xilinx, Inc., and may be used,
//-- copied and/or disclosed only pursuant to the terms
//-- of a valid license agreement with Xilinx, Inc. This copyright
//-- notice must be retained as part of this text at all times.

`timescale 1ps/1ps

module sys_clk_gen_ds (sys_clk_p, sys_clk_n);

output	sys_clk_p;
output	sys_clk_n;

parameter        offset = 0;
parameter        halfcycle = 500;

defparam 	clk_gen.offset = offset;
defparam 	clk_gen.halfcycle = halfcycle;

sys_clk_gen 	clk_gen (

			.sys_clk(sys_clk_p)

			);

assign sys_clk_n = !sys_clk_p;

endmodule // sys_clk_gen_ds
