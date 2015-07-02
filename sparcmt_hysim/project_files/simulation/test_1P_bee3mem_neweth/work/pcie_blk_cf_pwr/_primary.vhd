library verilog;
use verilog.vl_types.all;
entity pcie_blk_cf_pwr is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        cfg_turnoff_ok_n: in     vl_logic;
        cfg_to_turnoff_n: out    vl_logic;
        cfg_pm_wake_n   : in     vl_logic;
        l0_pwr_turn_off_req: in     vl_logic;
        l0_pme_req_in   : out    vl_logic;
        l0_pme_ack      : in     vl_logic;
        send_pmeack     : out    vl_logic;
        cs_is_pm        : in     vl_logic;
        grant           : in     vl_logic
    );
end pcie_blk_cf_pwr;
