library verilog;
use verilog.vl_types.all;
entity ReadMod is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        RAM_data        : in     vl_logic_vector(31 downto 0);
        RAM_valid       : in     vl_logic;
        enable          : in     vl_logic;
        RAM_addr        : out    vl_logic_vector(10 downto 0);
        FPGA_data       : out    vl_logic_vector(31 downto 0);
        FPGA_valid      : out    vl_logic;
        read_en         : out    vl_logic
    );
end ReadMod;
