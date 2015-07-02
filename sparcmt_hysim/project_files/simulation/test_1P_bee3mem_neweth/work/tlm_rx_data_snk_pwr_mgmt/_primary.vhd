library verilog;
use verilog.vl_types.all;
entity tlm_rx_data_snk_pwr_mgmt is
    port(
        clk_i           : in     vl_logic;
        reset_i         : in     vl_logic;
        pm_as_nak_l1_o  : out    vl_logic;
        pm_turn_off_o   : out    vl_logic;
        pm_set_slot_pwr_o: out    vl_logic;
        pm_set_slot_pwr_data_o: out    vl_logic_vector(9 downto 0);
        pm_msg_detect_o : out    vl_logic;
        ismsg_i         : in     vl_logic;
        msgcode_i       : in     vl_logic_vector(7 downto 0);
        pwr_data_i      : in     vl_logic_vector(9 downto 0);
        eval_pwr_mgmt_i : in     vl_logic;
        eval_pwr_mgmt_data_i: in     vl_logic;
        act_pwr_mgmt_i  : in     vl_logic
    );
end tlm_rx_data_snk_pwr_mgmt;
