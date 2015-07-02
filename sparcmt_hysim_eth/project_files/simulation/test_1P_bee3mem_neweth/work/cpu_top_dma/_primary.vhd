library verilog;
use verilog.vl_types.all;
library work;
entity cpu_top_dma is
    port(
        gclk            : in     work.libiu.iu_clk_type;
        rst             : in     vl_logic;
        dma_rb_in       : out    work.libdebug.debug_dma_read_buffer_in_type;
        dma_rb_out      : in     work.libdebug.debug_dma_read_buffer_out_type;
        dma_wb_in       : out    work.libdebug.debug_dma_write_buffer_in_type;
        dma_cmd_in      : in     work.libdebug.debug_dma_cmdif_in_type;
        dma_cmd_ack     : out    vl_logic;
        dma2tm          : in     work.libtm.dma_tm_ctrl_type;
        dma_done        : out    vl_logic;
        error1_led      : out    vl_logic;
        error2_led      : out    vl_logic;
        luterr          : out    vl_logic;
        bramerr         : out    vl_logic;
        sb_ecc          : out    vl_logic;
        tm_pkt_in       : in     vl_logic_vector(31 downto 0);
        tm_pkt_out      : out    vl_logic_vector(127 downto 0);
        tm_pkt_valid    : in     vl_logic;
        eth_mem_rd      : in     vl_logic;
        valid_out       : out    vl_logic;
        speedtm_running : out    vl_logic;
        eth2speedtm     : in     vl_logic_vector(42 downto 0);
        mem_cnt_eq      : out    vl_logic;
        ldst_out        : out    work.libiu.\LDST_CTRL_TYPE\
    );
end cpu_top_dma;
