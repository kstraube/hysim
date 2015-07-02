library verilog;
use verilog.vl_types.all;
entity pcie_blk_ll_arb is
    generic(
        C_STREAMING     : integer := 0;
        CPL_STREAMING_PRIORITIZE_P_NP: integer := 0
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        llk_rx_dst_req_n: out    vl_logic;
        llk_rx_ch_tc    : out    vl_logic_vector(2 downto 0);
        llk_rx_ch_fifo  : out    vl_logic_vector(1 downto 0);
        fifo_np_req     : out    vl_logic;
        fifo_pcpl_req   : out    vl_logic;
        fifo_np_ok      : in     vl_logic;
        fifo_pcpl_ok    : in     vl_logic;
        trn_rnp_ok_n    : in     vl_logic;
        llk_rx_src_last_req_n: in     vl_logic;
        llk_rx_ch_posted_available_n: in     vl_logic_vector(7 downto 0);
        llk_rx_ch_non_posted_available_n: in     vl_logic_vector(7 downto 0);
        llk_rx_ch_completion_available_n: in     vl_logic_vector(7 downto 0);
        llk_rx_preferred_type: in     vl_logic_vector(15 downto 0);
        llk_rx_dst_cont_req_n: out    vl_logic;
        trn_rcpl_streaming_n: in     vl_logic;
        cpl_tlp_cntr    : in     vl_logic_vector(7 downto 0);
        cpl_tlp_cntr_inc: in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of C_STREAMING : constant is 1;
    attribute mti_svvh_generic_type of CPL_STREAMING_PRIORITIZE_P_NP : constant is 1;
end pcie_blk_ll_arb;
