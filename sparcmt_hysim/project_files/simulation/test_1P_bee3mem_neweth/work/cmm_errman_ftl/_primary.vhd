library verilog;
use verilog.vl_types.all;
entity cmm_errman_ftl is
    generic(
        FFD             : integer := 1
    );
    port(
        ftl_num         : out    vl_logic_vector(2 downto 0);
        inc_dec_b       : out    vl_logic;
        cmmp_training_err: in     vl_logic;
        cmml_protocol_err_n: in     vl_logic;
        cmmt_err_rbuf_overflow: in     vl_logic;
        cmmt_err_fc     : in     vl_logic;
        cmmt_err_tlp_malformed: in     vl_logic;
        decr_ftl        : in     vl_logic;
        rst             : in     vl_logic;
        clk             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FFD : constant is 1;
end cmm_errman_ftl;
