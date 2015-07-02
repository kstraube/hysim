library verilog;
use verilog.vl_types.all;
entity pcie_blk_ll_oqbqfifo is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        trn_rsrc_rdy    : out    vl_logic;
        trn_rd          : out    vl_logic_vector(63 downto 0);
        trn_rrem        : out    vl_logic_vector(7 downto 0);
        trn_rsof        : out    vl_logic;
        trn_reof        : out    vl_logic;
        trn_rerrfwd     : out    vl_logic;
        trn_rbar_hit    : out    vl_logic_vector(6 downto 0);
        fifo_np_ok      : out    vl_logic;
        fifo_pcpl_ok    : out    vl_logic;
        trn_rdst_rdy    : in     vl_logic;
        trn_rnp_ok      : in     vl_logic;
        fifo_wren       : in     vl_logic;
        fifo_data       : in     vl_logic_vector(63 downto 0);
        fifo_rem        : in     vl_logic;
        fifo_sof        : in     vl_logic;
        fifo_preeof     : in     vl_logic;
        fifo_eof        : in     vl_logic;
        fifo_dsc        : in     vl_logic;
        fifo_np         : in     vl_logic;
        fifo_barenc     : in     vl_logic_vector(3 downto 0);
        fifo_np_req     : in     vl_logic;
        fifo_pcpl_req   : in     vl_logic;
        fifo_np_abort   : in     vl_logic;
        fifo_pcpl_abort : in     vl_logic
    );
end pcie_blk_ll_oqbqfifo;
