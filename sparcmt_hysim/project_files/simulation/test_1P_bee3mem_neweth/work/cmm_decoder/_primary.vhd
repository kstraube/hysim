library verilog;
use verilog.vl_types.all;
entity cmm_decoder is
    generic(
        Tcq             : integer := 1
    );
    port(
        raddr           : in     vl_logic_vector(63 downto 0);
        rmem32          : in     vl_logic;
        rmem64          : in     vl_logic;
        rio             : in     vl_logic;
        rcheck_bus_id   : in     vl_logic;
        rcheck_dev_id   : in     vl_logic;
        rcheck_fun_id   : in     vl_logic;
        rhit            : out    vl_logic;
        bar_hit         : out    vl_logic_vector(6 downto 0);
        cmmt_rbar_hit_lat2_n: out    vl_logic;
        command         : in     vl_logic_vector(15 downto 0);
        bar0_reg        : in     vl_logic_vector(31 downto 0);
        bar1_reg        : in     vl_logic_vector(31 downto 0);
        bar2_reg        : in     vl_logic_vector(31 downto 0);
        bar3_reg        : in     vl_logic_vector(31 downto 0);
        bar4_reg        : in     vl_logic_vector(31 downto 0);
        bar5_reg        : in     vl_logic_vector(31 downto 0);
        xrom_reg        : in     vl_logic_vector(31 downto 0);
        pme_pmcsr       : in     vl_logic_vector(15 downto 0);
        bus_num         : in     vl_logic_vector(7 downto 0);
        device_num      : in     vl_logic_vector(4 downto 0);
        function_num    : in     vl_logic_vector(2 downto 0);
        phantom_functions_supported: in     vl_logic_vector(1 downto 0);
        phantom_functions_enabled: in     vl_logic;
        cfg             : in     vl_logic_vector(671 downto 0);
        rst             : in     vl_logic;
        clk             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Tcq : constant is 1;
end cmm_decoder;
