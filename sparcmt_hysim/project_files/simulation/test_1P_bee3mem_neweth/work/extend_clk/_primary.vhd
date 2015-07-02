library verilog;
use verilog.vl_types.all;
entity extend_clk is
    generic(
        CLKRATIO        : integer := 1
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        l0_dll_error_vector: in     vl_logic_vector(6 downto 0);
        l0_rx_mac_link_error: in     vl_logic_vector(1 downto 0);
        l0_dll_error_vector_retime: out    vl_logic_vector(6 downto 0);
        l0_rx_mac_link_error_retime: out    vl_logic_vector(1 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLKRATIO : constant is 1;
end extend_clk;
