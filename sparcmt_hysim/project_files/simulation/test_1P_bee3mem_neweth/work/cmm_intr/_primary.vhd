library verilog;
use verilog.vl_types.all;
entity cmm_intr is
    generic(
        IDLE            : vl_logic_vector(1 downto 0) := (Hi0, Hi0);
        SEND_MSI        : vl_logic_vector(1 downto 0) := (Hi0, Hi1);
        SEND_ASSERT     : vl_logic_vector(1 downto 0) := (Hi1, Hi0);
        SEND_DEASSERT   : vl_logic_vector(1 downto 0) := (Hi1, Hi1)
    );
    port(
        signaledint     : out    vl_logic;
        intr_req_valid  : out    vl_logic;
        intr_req_type   : out    vl_logic_vector(1 downto 0);
        intr_rdy        : out    vl_logic;
        cfg_interrupt_n : in     vl_logic;
        cfg_interrupt_assert_n: in     vl_logic;
        cfg_interrupt_di: in     vl_logic_vector(7 downto 0);
        cfg_interrupt_mmenable: in     vl_logic_vector(2 downto 0);
        msi_data        : in     vl_logic_vector(15 downto 0);
        intr_vector     : out    vl_logic_vector(7 downto 0);
        command         : in     vl_logic_vector(15 downto 0);
        msi_control     : in     vl_logic_vector(15 downto 0);
        msi_laddr       : in     vl_logic_vector(31 downto 0);
        msi_haddr       : in     vl_logic_vector(31 downto 0);
        intr_grant      : in     vl_logic;
        cfg             : in     vl_logic_vector(1023 downto 0);
        rst             : in     vl_logic;
        clk             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 2;
    attribute mti_svvh_generic_type of SEND_MSI : constant is 2;
    attribute mti_svvh_generic_type of SEND_ASSERT : constant is 2;
    attribute mti_svvh_generic_type of SEND_DEASSERT : constant is 2;
end cmm_intr;
