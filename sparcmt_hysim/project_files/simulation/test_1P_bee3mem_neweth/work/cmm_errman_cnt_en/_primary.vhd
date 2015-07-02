library verilog;
use verilog.vl_types.all;
entity cmm_errman_cnt_en is
    generic(
        FFD             : integer := 1
    );
    port(
        count           : out    vl_logic_vector(3 downto 0);
        index           : in     vl_logic_vector(2 downto 0);
        inc_dec_b       : in     vl_logic;
        enable          : in     vl_logic;
        rst             : in     vl_logic;
        clk             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FFD : constant is 1;
end cmm_errman_cnt_en;
