library verilog;
use verilog.vl_types.all;
entity PIO_64_RX_ENGINE is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        trn_rd          : in     vl_logic_vector(63 downto 0);
        trn_rrem_n      : in     vl_logic_vector(7 downto 0);
        trn_rsof_n      : in     vl_logic;
        trn_reof_n      : in     vl_logic;
        trn_rsrc_rdy_n  : in     vl_logic;
        trn_rsrc_dsc_n  : in     vl_logic;
        trn_rbar_hit_n  : in     vl_logic_vector(6 downto 0);
        trn_rdst_rdy_n  : out    vl_logic;
        req_compl_o     : out    vl_logic;
        req_compl_with_data_o: out    vl_logic;
        compl_done_i    : in     vl_logic;
        req_tc_o        : out    vl_logic_vector(2 downto 0);
        req_td_o        : out    vl_logic;
        req_ep_o        : out    vl_logic;
        req_attr_o      : out    vl_logic_vector(1 downto 0);
        req_len_o       : out    vl_logic_vector(9 downto 0);
        req_rid_o       : out    vl_logic_vector(15 downto 0);
        req_tag_o       : out    vl_logic_vector(7 downto 0);
        req_be_o        : out    vl_logic_vector(7 downto 0);
        req_addr_o      : out    vl_logic_vector(12 downto 0);
        wr_addr_o       : out    vl_logic_vector(10 downto 0);
        wr_be_o         : out    vl_logic_vector(7 downto 0);
        wr_data_o       : out    vl_logic_vector(31 downto 0);
        wr_en_o         : out    vl_logic;
        wr_busy_i       : in     vl_logic
    );
end PIO_64_RX_ENGINE;
