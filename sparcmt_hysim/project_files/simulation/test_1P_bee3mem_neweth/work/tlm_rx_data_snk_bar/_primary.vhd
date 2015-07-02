library verilog;
use verilog.vl_types.all;
entity tlm_rx_data_snk_bar is
    generic(
        DW              : integer := 32;
        BARW            : integer := 7
    );
    port(
        clk_i           : in     vl_logic;
        reset_i         : in     vl_logic;
        check_raddr_o   : out    vl_logic_vector(63 downto 0);
        check_rmem32_o  : out    vl_logic;
        check_rmem64_o  : out    vl_logic;
        check_rio_o     : out    vl_logic;
        check_rdev_id_o : out    vl_logic;
        check_rbus_id_o : out    vl_logic;
        check_rfun_id_o : out    vl_logic;
        check_rhit_bar_i: in     vl_logic_vector;
        check_rhit_i    : in     vl_logic;
        check_rhit_bar_o: out    vl_logic_vector;
        check_rhit_o    : out    vl_logic;
        check_rhit_src_rdy_o: out    vl_logic;
        check_rhit_ack_o: out    vl_logic;
        check_rhit_lock_o: out    vl_logic;
        addr_lo_i       : in     vl_logic_vector(31 downto 0);
        addr_hi_i       : in     vl_logic_vector(31 downto 0);
        fulltype_oh_i   : in     vl_logic_vector(8 downto 0);
        routing_i       : in     vl_logic_vector(2 downto 0);
        mem64_i         : in     vl_logic;
        req_id_i        : in     vl_logic_vector(15 downto 0);
        req_id_cpl_i    : in     vl_logic_vector(15 downto 0);
        eval_check_i    : in     vl_logic;
        rhit_lat3_i     : in     vl_logic;
        legacy_mode_i   : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DW : constant is 1;
    attribute mti_svvh_generic_type of BARW : constant is 1;
end tlm_rx_data_snk_bar;
