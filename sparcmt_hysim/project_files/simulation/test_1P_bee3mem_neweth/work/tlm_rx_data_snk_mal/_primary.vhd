library verilog;
use verilog.vl_types.all;
entity tlm_rx_data_snk_mal is
    generic(
        DW              : integer := 32;
        FCW             : integer := 6;
        LENW            : integer := 10;
        DOWNSTREAM_PORT : integer := 0;
        MPS             : integer := 512;
        TYPE1_UR        : integer := 0
    );
    port(
        clk_i           : in     vl_logic;
        reset_i         : in     vl_logic;
        data_credits_o  : out    vl_logic_vector;
        data_credits_vld_o: out    vl_logic;
        cfg_o           : out    vl_logic;
        malformed_o     : out    vl_logic;
        tlp_ur_o        : out    vl_logic;
        tlp_ur_lock_o   : out    vl_logic;
        tlp_uc_o        : out    vl_logic;
        tlp_filt_o      : out    vl_logic;
        aperture_i      : in     vl_logic_vector(3 downto 0);
        load_aperture_i : in     vl_logic;
        eval_fulltype_i : in     vl_logic;
        fulltype_i      : in     vl_logic_vector(6 downto 0);
        eval_msgcode_i  : in     vl_logic;
        msgcode_i       : in     vl_logic_vector(7 downto 0);
        tc0_i           : in     vl_logic;
        hit_src_rdy_i   : in     vl_logic;
        hit_ack_i       : in     vl_logic;
        hit_lock_i      : in     vl_logic;
        hit_i           : in     vl_logic;
        hit_lat3_i      : in     vl_logic;
        pwr_mgmt_on_i   : in     vl_logic;
        legacy_mode_i   : in     vl_logic;
        legacy_cfg_access_i: in     vl_logic;
        ext_cfg_access_i: in     vl_logic;
        offset_i        : in     vl_logic_vector(7 downto 0);
        hp_msg_detect_o : out    vl_logic;
        eval_formats_i  : in     vl_logic;
        length_i        : in     vl_logic_vector(9 downto 0);
        length_1dw_i    : in     vl_logic;
        sof_i           : in     vl_logic;
        eof_i           : in     vl_logic;
        rem_i           : in     vl_logic;
        td_i            : in     vl_logic;
        max_payload_i   : in     vl_logic_vector(2 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DW : constant is 1;
    attribute mti_svvh_generic_type of FCW : constant is 1;
    attribute mti_svvh_generic_type of LENW : constant is 1;
    attribute mti_svvh_generic_type of DOWNSTREAM_PORT : constant is 1;
    attribute mti_svvh_generic_type of MPS : constant is 1;
    attribute mti_svvh_generic_type of TYPE1_UR : constant is 1;
end tlm_rx_data_snk_mal;
