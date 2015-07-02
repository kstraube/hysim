library verilog;
use verilog.vl_types.all;
entity TX_SYNC_GTP is
    port(
        TXENPMAPHASEALIGN: out    vl_logic;
        TXPMASETPHASE   : out    vl_logic;
        SYNC_DONE       : out    vl_logic;
        USER_CLK        : in     vl_logic;
        RESET           : in     vl_logic
    );
end TX_SYNC_GTP;
