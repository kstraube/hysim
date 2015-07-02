library verilog;
use verilog.vl_types.all;
entity WriteMod is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        FPGA_data       : in     vl_logic_vector(127 downto 0);
        enable          : in     vl_logic;
        RAM_addr        : out    vl_logic_vector(10 downto 0);
        RAM_data        : out    vl_logic_vector(31 downto 0);
        write_en        : out    vl_logic;
        ready           : out    vl_logic
    );
end WriteMod;
