library verilog;
use verilog.vl_types.all;
entity cmm_errman_cor is
    generic(
        FFD             : integer := 1
    );
    port(
        cor_num         : out    vl_logic_vector(2 downto 0);
        inc_dec_b       : out    vl_logic;
        reg_decr_cor    : out    vl_logic;
        add_input_one   : in     vl_logic;
        add_input_two_n : in     vl_logic;
        add_input_three_n: in     vl_logic;
        add_input_four_n: in     vl_logic;
        add_input_five_n: in     vl_logic;
        add_input_six_n : in     vl_logic;
        decr_cor        : in     vl_logic;
        rst             : in     vl_logic;
        clk             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FFD : constant is 1;
end cmm_errman_cor;
