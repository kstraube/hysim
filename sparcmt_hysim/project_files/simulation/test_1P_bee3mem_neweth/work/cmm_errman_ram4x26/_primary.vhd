library verilog;
use verilog.vl_types.all;
entity cmm_errman_ram4x26 is
    port(
        rddata          : out    vl_logic_vector(49 downto 0);
        wrdata          : in     vl_logic_vector(49 downto 0);
        wr_ptr          : in     vl_logic_vector(1 downto 0);
        rd_ptr          : in     vl_logic_vector(1 downto 0);
        we              : in     vl_logic;
        rst             : in     vl_logic;
        clk             : in     vl_logic
    );
end cmm_errman_ram4x26;
