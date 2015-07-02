library verilog;
use verilog.vl_types.all;
entity PIO is
    port(
        trn_clk         : in     vl_logic;
        trn_reset_n     : in     vl_logic;
        trn_lnk_up_n    : in     vl_logic;
        trn_td          : out    vl_logic_vector(63 downto 0);
        trn_trem_n      : out    vl_logic_vector(7 downto 0);
        trn_tsof_n      : out    vl_logic;
        trn_teof_n      : out    vl_logic;
        trn_tsrc_rdy_n  : out    vl_logic;
        trn_tsrc_dsc_n  : out    vl_logic;
        trn_tdst_rdy_n  : in     vl_logic;
        trn_tdst_dsc_n  : in     vl_logic;
        trn_rd          : in     vl_logic_vector(63 downto 0);
        trn_rrem_n      : in     vl_logic_vector(7 downto 0);
        trn_rsof_n      : in     vl_logic;
        trn_reof_n      : in     vl_logic;
        trn_rsrc_rdy_n  : in     vl_logic;
        trn_rsrc_dsc_n  : in     vl_logic;
        trn_rbar_hit_n  : in     vl_logic_vector(6 downto 0);
        trn_rdst_rdy_n  : out    vl_logic;
        cfg_to_turnoff_n: in     vl_logic;
        cfg_turnoff_ok_n: out    vl_logic;
        cfg_completer_id: in     vl_logic_vector(15 downto 0);
        cfg_bus_mstr_enable: in     vl_logic;
        rd_addr_fpga    : in     vl_logic_vector(10 downto 0);
        rd_be_fpga      : in     vl_logic_vector(3 downto 0);
        rd_data_fpga    : out    vl_logic_vector(31 downto 0);
        wr_addr_fpga    : in     vl_logic_vector(10 downto 0);
        wr_be_fpga      : in     vl_logic_vector(7 downto 0);
        wr_data_fpga    : in     vl_logic_vector(31 downto 0);
        wr_en_fpga      : in     vl_logic;
        wr_busy_fpga    : out    vl_logic
    );
end PIO;
