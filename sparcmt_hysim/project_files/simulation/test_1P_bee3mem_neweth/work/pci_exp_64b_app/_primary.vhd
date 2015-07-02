library verilog;
use verilog.vl_types.all;
entity pci_exp_64b_app is
    port(
        trn_clk         : in     vl_logic;
        trn_reset_n     : in     vl_logic;
        trn_lnk_up_n    : in     vl_logic;
        trn_td          : out    vl_logic_vector(63 downto 0);
        trn_trem        : out    vl_logic_vector(7 downto 0);
        trn_tsof_n      : out    vl_logic;
        trn_teof_n      : out    vl_logic;
        trn_tsrc_rdy_n  : out    vl_logic;
        trn_tdst_rdy_n  : in     vl_logic;
        trn_tsrc_dsc_n  : out    vl_logic;
        trn_tdst_dsc_n  : in     vl_logic;
        trn_terrfwd_n   : out    vl_logic;
        trn_tbuf_av     : in     vl_logic_vector(3 downto 0);
        trn_rd          : in     vl_logic_vector(63 downto 0);
        trn_rrem        : in     vl_logic_vector(7 downto 0);
        trn_rsof_n      : in     vl_logic;
        trn_reof_n      : in     vl_logic;
        trn_rsrc_rdy_n  : in     vl_logic;
        trn_rsrc_dsc_n  : in     vl_logic;
        trn_rdst_rdy_n  : out    vl_logic;
        trn_rerrfwd_n   : in     vl_logic;
        trn_rnp_ok_n    : out    vl_logic;
        trn_rbar_hit_n  : in     vl_logic_vector(6 downto 0);
        trn_rfc_nph_av  : in     vl_logic_vector(7 downto 0);
        trn_rfc_npd_av  : in     vl_logic_vector(11 downto 0);
        trn_rfc_ph_av   : in     vl_logic_vector(7 downto 0);
        trn_rfc_pd_av   : in     vl_logic_vector(11 downto 0);
        trn_rcpl_streaming_n: out    vl_logic;
        cfg_do          : in     vl_logic_vector(31 downto 0);
        cfg_rd_wr_done_n: in     vl_logic;
        cfg_di          : out    vl_logic_vector(31 downto 0);
        cfg_byte_en_n   : out    vl_logic_vector(3 downto 0);
        cfg_dwaddr      : out    vl_logic_vector(9 downto 0);
        cfg_wr_en_n     : out    vl_logic;
        cfg_rd_en_n     : out    vl_logic;
        cfg_err_cor_n   : out    vl_logic;
        cfg_err_ur_n    : out    vl_logic;
        cfg_err_cpl_rdy_n: in     vl_logic;
        cfg_err_ecrc_n  : out    vl_logic;
        cfg_err_cpl_timeout_n: out    vl_logic;
        cfg_err_cpl_abort_n: out    vl_logic;
        cfg_err_cpl_unexpect_n: out    vl_logic;
        cfg_err_posted_n: out    vl_logic;
        cfg_err_tlp_cpl_header: out    vl_logic_vector(47 downto 0);
        cfg_interrupt_n : out    vl_logic;
        cfg_interrupt_rdy_n: in     vl_logic;
        cfg_interrupt_assert_n: out    vl_logic;
        cfg_interrupt_di: out    vl_logic_vector(7 downto 0);
        cfg_interrupt_do: in     vl_logic_vector(7 downto 0);
        cfg_interrupt_mmenable: in     vl_logic_vector(2 downto 0);
        cfg_interrupt_msienable: in     vl_logic;
        cfg_turnoff_ok_n: out    vl_logic;
        cfg_to_turnoff_n: in     vl_logic;
        cfg_pm_wake_n   : out    vl_logic;
        cfg_status      : in     vl_logic_vector(15 downto 0);
        cfg_command     : in     vl_logic_vector(15 downto 0);
        cfg_dstatus     : in     vl_logic_vector(15 downto 0);
        cfg_dcommand    : in     vl_logic_vector(15 downto 0);
        cfg_lstatus     : in     vl_logic_vector(15 downto 0);
        cfg_lcommand    : in     vl_logic_vector(15 downto 0);
        cfg_bus_number  : in     vl_logic_vector(7 downto 0);
        cfg_device_number: in     vl_logic_vector(4 downto 0);
        cfg_function_number: in     vl_logic_vector(2 downto 0);
        cfg_pcie_link_state_n: in     vl_logic_vector(2 downto 0);
        cfg_dsn         : out    vl_logic_vector(63 downto 0);
        cfg_trn_pending_n: out    vl_logic;
        rd_addr_fpga    : in     vl_logic_vector(10 downto 0);
        rd_be_fpga      : in     vl_logic_vector(3 downto 0);
        rd_data_fpga    : out    vl_logic_vector(31 downto 0);
        wr_addr_fpga    : in     vl_logic_vector(10 downto 0);
        wr_be_fpga      : in     vl_logic_vector(7 downto 0);
        wr_data_fpga    : in     vl_logic_vector(31 downto 0);
        wr_en_fpga      : in     vl_logic;
        wr_busy_fpga    : out    vl_logic
    );
end pci_exp_64b_app;
