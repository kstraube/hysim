library verilog;
use verilog.vl_types.all;
entity syn_fifo is
    generic(
        DATA_WIDTH      : integer := 8;
        ADDR_WIDTH      : integer := 8;
        RAM_DEPTH       : vl_notype
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        wr_cs           : in     vl_logic;
        rd_cs           : in     vl_logic;
        data_in         : in     vl_logic_vector;
        rd_en           : in     vl_logic;
        wr_en           : in     vl_logic;
        data_out        : out    vl_logic_vector;
        empty           : out    vl_logic;
        full            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of RAM_DEPTH : constant is 3;
end syn_fifo;
