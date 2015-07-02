library verilog;
use verilog.vl_types.all;
library work;
entity speed_tm is
    port(
        gclk            : in     work.libiu.iu_clk_type;
        rst             : in     vl_logic;
        eth2speedtm     : in     vl_logic_vector(42 downto 0);
        cpu2tm          : in     work.libtm.tm_cpu_ctrl_token_type;
        tm2cpu          : out    work.libtm.tm2cpu_token_type;
        running         : out    vl_logic;
        done            : out    vl_logic
    );
end speed_tm;
