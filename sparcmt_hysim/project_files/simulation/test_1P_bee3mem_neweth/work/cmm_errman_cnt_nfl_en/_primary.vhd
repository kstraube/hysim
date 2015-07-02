library verilog;
use verilog.vl_types.all;
entity cmm_errman_cnt_nfl_en is
    generic(
        FFD             : integer := 1
    );
    port(
        count           : out    vl_logic;
        index           : in     vl_logic;
        inc_dec_b       : in     vl_logic;
        enable          : in     vl_logic;
        rst             : in     vl_logic;
        clk             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FFD : constant is 1;
end cmm_errman_cnt_nfl_en;
