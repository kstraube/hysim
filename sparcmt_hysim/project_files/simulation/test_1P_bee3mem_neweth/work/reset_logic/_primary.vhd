library verilog;
use verilog.vl_types.all;
entity reset_logic is
    generic(
        G_RESETMODE     : string  := "FALSE";
        G_RESETSUBMODE  : integer := 1;
        G_USE_EXTRA_REG : integer := 1
    );
    port(
        L0DLUPDOWN      : in     vl_logic;
        GSR             : in     vl_logic;
        CRMCORECLK      : in     vl_logic;
        USERCLK         : in     vl_logic;
        L0LTSSMSTATE    : in     vl_logic_vector(3 downto 0);
        L0STATSCFGTRANSMITTED: in     vl_logic;
        CRMDOHOTRESETN  : in     vl_logic;
        CRMPWRSOFTRESETN: in     vl_logic;
        CRMMGMTRSTN     : out    vl_logic;
        CRMNVRSTN       : out    vl_logic;
        CRMMACRSTN      : out    vl_logic;
        CRMLINKRSTN     : out    vl_logic;
        CRMURSTN        : out    vl_logic;
        CRMUSERCFGRSTN  : out    vl_logic;
        user_master_reset_n: in     vl_logic;
        clock_ready     : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of G_RESETMODE : constant is 1;
    attribute mti_svvh_generic_type of G_RESETSUBMODE : constant is 1;
    attribute mti_svvh_generic_type of G_USE_EXTRA_REG : constant is 1;
end reset_logic;
