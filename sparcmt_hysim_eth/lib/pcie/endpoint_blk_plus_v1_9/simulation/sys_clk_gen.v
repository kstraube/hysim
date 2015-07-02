//-- Copyright(C) 2008 by Xilinx, Inc. All rights reserved.
//-- This text contains proprietary, confidential
//-- information of Xilinx, Inc., is distributed
//-- under license from Xilinx, Inc., and may be used,
//-- copied and/or disclosed only pursuant to the terms
//-- of a valid license agreement with Xilinx, Inc. This copyright
//-- notice must be retained as part of this text at all times.

`timescale 1ps/1ps

module sys_clk_gen (sys_clk);

output	sys_clk;

reg		sys_clk;

parameter        offset = 0;
parameter        halfcycle = 500;

initial begin

	sys_clk = 0;
	#(offset);

	forever #(halfcycle) sys_clk = ~sys_clk;

end

endmodule // sys_clk_gen
