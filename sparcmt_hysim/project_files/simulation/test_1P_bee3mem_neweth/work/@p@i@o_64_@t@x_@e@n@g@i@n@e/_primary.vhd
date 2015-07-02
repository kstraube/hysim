library verilog;
use verilog.vl_types.all;
entity PIO_64_TX_ENGINE is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        trn_td          : out    vl_logic_vector(63 downto 0);
        trn_trem_n      : out    vl_logic_vector(7 downto 0);
        trn_tsof_n      : out    vl_logic;
        trn_teof_n      : out    vl_logic;
        trn_tsrc_rdy_n  : out    vl_logic;
        trn_tsrc_dsc_n  : out    vl_logic;
        trn_tdst_rdy_n  : in     vl_logic;
        trn_tdst_dsc_n  : in     vl_logic;
        req_compl_i     : in     vl_logic;
        req_compl_with_data_i: in     vl_logic;
        compl_done_o    : out    vl_logic;
        req_tc_i        : in     vl_logic_vector(2 downto 0);
        req_td_i        : in     vl_logic;
        req_ep_i        : in     vl_logic;
        req_attr_i      : in     vl_logic_vector(1 downto 0);
        req_len_i       : in     vl_logic_vector(9 downto 0);
        req_rid_i       : in     vl_logic_vector(15 downto 0);
        req_tag_i       : in     vl_logic_vector(7 downto 0);
        req_be_i        : in     vl_logic_vector(7 downto 0);
        req_addr_i      : in     vl_logic_vector(12 downto 0);
        rd_addr_o       : out    vl_logic_vector(10 downto 0);
        rd_be_o         : out    vl_logic_vector(3 downto 0);
        rd_data_i       : in     vl_logic_vector(31 downto 0);
        completer_id_i  : in     vl_logic_vector(15 downto 0);
        cfg_bus_mstr_enable_i: in     vl_logic
    );
end PIO_64_TX_ENGINE;
