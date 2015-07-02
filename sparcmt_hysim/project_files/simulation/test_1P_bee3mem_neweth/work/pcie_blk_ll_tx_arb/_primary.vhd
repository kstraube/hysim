library verilog;
use verilog.vl_types.all;
entity pcie_blk_ll_tx_arb is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        tx_td           : out    vl_logic_vector(63 downto 0);
        tx_sof_n        : out    vl_logic;
        tx_eof_n        : out    vl_logic;
        tx_rem_n        : out    vl_logic_vector(7 downto 0);
        tx_src_dsc_n    : out    vl_logic;
        tx_src_rdy_n    : out    vl_logic;
        tx_dst_rdy_n    : in     vl_logic;
        trn_td          : in     vl_logic_vector(63 downto 0);
        trn_trem_n      : in     vl_logic_vector(7 downto 0);
        trn_tsof_n      : in     vl_logic;
        trn_teof_n      : in     vl_logic;
        trn_tsrc_rdy_n  : in     vl_logic;
        trn_tsrc_dsc_n  : in     vl_logic;
        trn_tdst_rdy_n  : out    vl_logic;
        trn_tdst_dsc_n  : out    vl_logic;
        cfg_tx_td       : in     vl_logic_vector(63 downto 0);
        cfg_tx_rem_n    : in     vl_logic;
        cfg_tx_sof_n    : in     vl_logic;
        cfg_tx_eof_n    : in     vl_logic;
        cfg_tx_src_rdy_n: in     vl_logic;
        cfg_tx_dst_rdy_n: out    vl_logic
    );
end pcie_blk_ll_tx_arb;
