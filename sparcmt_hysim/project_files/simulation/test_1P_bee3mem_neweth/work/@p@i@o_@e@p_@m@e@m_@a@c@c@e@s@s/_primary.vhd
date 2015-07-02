library verilog;
use verilog.vl_types.all;
entity PIO_EP_MEM_ACCESS is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        rd_addr_i       : in     vl_logic_vector(10 downto 0);
        rd_be_i         : in     vl_logic_vector(3 downto 0);
        rd_data_o       : out    vl_logic_vector(31 downto 0);
        wr_addr_i       : in     vl_logic_vector(10 downto 0);
        wr_be_i         : in     vl_logic_vector(7 downto 0);
        wr_data_i       : in     vl_logic_vector(31 downto 0);
        wr_en_i         : in     vl_logic;
        wr_busy_o       : out    vl_logic
    );
end PIO_EP_MEM_ACCESS;
