library verilog;
use verilog.vl_types.all;
entity TX_SYNC is
    generic(
        PLL_DIVSEL_OUT  : integer := 1
    );
    port(
        USER_DO         : out    vl_logic_vector(15 downto 0);
        USER_DI         : in     vl_logic_vector(15 downto 0);
        USER_DADDR      : in     vl_logic_vector(6 downto 0);
        USER_DEN        : in     vl_logic;
        USER_DWE        : in     vl_logic;
        USER_DRDY       : out    vl_logic;
        GT_DO           : out    vl_logic_vector(15 downto 0);
        GT_DI           : in     vl_logic_vector(15 downto 0);
        GT_DADDR        : out    vl_logic_vector(6 downto 0);
        GT_DEN          : out    vl_logic;
        GT_DWE          : out    vl_logic;
        GT_DRDY         : in     vl_logic;
        USER_CLK        : in     vl_logic;
        DCLK            : in     vl_logic;
        RESET           : in     vl_logic;
        RESETDONE       : in     vl_logic;
        TXENPMAPHASEALIGN: out    vl_logic;
        TXPMASETPHASE   : out    vl_logic;
        TXRESET         : out    vl_logic;
        SYNC_DONE       : out    vl_logic;
        RESTART_SYNC    : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PLL_DIVSEL_OUT : constant is 1;
end TX_SYNC;
