library verilog;
use verilog.vl_types.all;
entity cmm_errman_cpl is
    generic(
        FFD             : integer := 1
    );
    port(
        cpl_num         : out    vl_logic_vector(2 downto 0);
        inc_dec_b       : out    vl_logic;
        cmm_err_tlp_posted: in     vl_logic;
        decr_cpl        : in     vl_logic;
        rst             : in     vl_logic;
        clk             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FFD : constant is 1;
end cmm_errman_cpl;
