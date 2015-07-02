library verilog;
use verilog.vl_types.all;
entity cmm_errman_nfl is
    generic(
        FFD             : integer := 1
    );
    port(
        nfl_num         : out    vl_logic;
        inc_dec_b       : out    vl_logic;
        cfg_err_cpl_timeout_n: in     vl_logic;
        decr_nfl        : in     vl_logic;
        rst             : in     vl_logic;
        clk             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FFD : constant is 1;
end cmm_errman_nfl;
