library verilog;
use verilog.vl_types.all;
entity pcie_soft_cf_int is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        cs_is_intr      : in     vl_logic;
        grant           : in     vl_logic;
        cfg_msguaddr    : in     vl_logic_vector(31 downto 0);
        msi_enable      : in     vl_logic;
        msi_request     : out    vl_logic_vector(3 downto 0);
        legacy_int_request: out    vl_logic;
        cfg_interrupt_n : in     vl_logic;
        cfg_interrupt_rdy_n: out    vl_logic;
        msi_8bit_en     : in     vl_logic;
        cfg_interrupt_assert_n: in     vl_logic;
        cfg_interrupt_di: in     vl_logic_vector(7 downto 0);
        cfg_interrupt_mmenable: out    vl_logic_vector(2 downto 0);
        cfg_interrupt_do: out    vl_logic_vector(7 downto 0);
        cfg_interrupt_msienable: out    vl_logic;
        msi_laddr       : in     vl_logic_vector(31 downto 0);
        msi_haddr       : in     vl_logic_vector(31 downto 0);
        cfg_command     : in     vl_logic_vector(15 downto 0);
        cfg_msgctrl     : in     vl_logic_vector(15 downto 0);
        cfg_msgdata     : in     vl_logic_vector(15 downto 0);
        signaledint     : out    vl_logic;
        intr_req_valid  : out    vl_logic;
        intr_req_type   : out    vl_logic_vector(1 downto 0);
        intr_vector     : out    vl_logic_vector(7 downto 0)
    );
end pcie_soft_cf_int;
