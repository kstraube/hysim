library verilog;
use verilog.vl_types.all;
entity pcie_clocking is
    generic(
        G_DIVIDE_VAL    : integer := 2;
        REF_CLK_FREQ    : integer := 1
    );
    port(
        clkin_pll       : in     vl_logic;
        clkin_dcm       : in     vl_logic;
        rst             : in     vl_logic;
        coreclk         : out    vl_logic;
        userclk         : out    vl_logic;
        gtx_usrclk      : out    vl_logic;
        txsync_clk      : out    vl_logic;
        locked          : out    vl_logic;
        fast_train_simulation_only: in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of G_DIVIDE_VAL : constant is 1;
    attribute mti_svvh_generic_type of REF_CLK_FREQ : constant is 1;
end pcie_clocking;
