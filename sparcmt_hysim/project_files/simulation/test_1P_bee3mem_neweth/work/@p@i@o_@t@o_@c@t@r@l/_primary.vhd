library verilog;
use verilog.vl_types.all;
entity PIO_TO_CTRL is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        req_compl_i     : in     vl_logic;
        compl_done_i    : in     vl_logic;
        cfg_to_turnoff_n: in     vl_logic;
        cfg_turnoff_ok_n: out    vl_logic
    );
end PIO_TO_CTRL;
