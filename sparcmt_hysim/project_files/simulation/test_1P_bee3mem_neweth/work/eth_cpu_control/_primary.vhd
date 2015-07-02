library verilog;
use verilog.vl_types.all;
library work;
entity eth_cpu_control is
    generic(
        mypid           : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        gclk            : in     work.libiu.iu_clk_type;
        rx_pipe_in      : in     work.libeth.eth_rx_pipe_data_type;
        rx_pipe_out     : out    work.libeth.eth_rx_pipe_data_type;
        tx_ring_in      : in     work.libeth.eth_tx_ring_data_type;
        tx_ring_out     : out    work.libeth.eth_tx_ring_data_type;
        dma_cmd_in      : out    work.libdebug.debug_dma_cmdif_in_type;
        dma_done        : in     vl_logic;
        dma_rb_in       : in     work.libdebug.debug_dma_read_buffer_in_type;
        dma_rb_out      : out    work.libdebug.debug_dma_read_buffer_out_type;
        dma_wb_in       : in     work.libdebug.debug_dma_write_buffer_in_type;
        sberr           : out    vl_logic;
        dberr           : out    vl_logic;
        luterr          : out    vl_logic;
        mem_data_in     : in     vl_logic_vector(127 downto 0);
        mem_data_out    : out    vl_logic_vector(31 downto 0);
        mem_data_out_valid: out    vl_logic;
        poll_not_ready  : in     vl_logic;
        eth_mem_rd      : out    vl_logic;
        valid_out       : in     vl_logic;
        eth2speedtm     : out    vl_logic_vector(42 downto 0);
        speedtm_running : in     vl_logic;
        mem_cnt_eq      : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of mypid : constant is 2;
end eth_cpu_control;
