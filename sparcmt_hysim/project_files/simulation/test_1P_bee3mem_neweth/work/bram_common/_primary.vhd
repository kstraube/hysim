library verilog;
use verilog.vl_types.all;
entity bram_common is
    generic(
        NUM_BRAMS       : integer := 16;
        ADDR_WIDTH      : integer := 13;
        READ_LATENCY    : integer := 3;
        WRITE_LATENCY   : integer := 1;
        WRITE_PIPE      : integer := 0;
        READ_ADDR_PIPE  : integer := 0;
        READ_DATA_PIPE  : integer := 0;
        BRAM_OREG       : integer := 1
    );
    port(
        clka            : in     vl_logic;
        ena             : in     vl_logic;
        wena            : in     vl_logic;
        dina            : in     vl_logic_vector(63 downto 0);
        douta           : out    vl_logic_vector(63 downto 0);
        addra           : in     vl_logic_vector;
        clkb            : in     vl_logic;
        enb             : in     vl_logic;
        wenb            : in     vl_logic;
        dinb            : in     vl_logic_vector(63 downto 0);
        doutb           : out    vl_logic_vector(63 downto 0);
        addrb           : in     vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_BRAMS : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of READ_LATENCY : constant is 1;
    attribute mti_svvh_generic_type of WRITE_LATENCY : constant is 1;
    attribute mti_svvh_generic_type of WRITE_PIPE : constant is 1;
    attribute mti_svvh_generic_type of READ_ADDR_PIPE : constant is 1;
    attribute mti_svvh_generic_type of READ_DATA_PIPE : constant is 1;
    attribute mti_svvh_generic_type of BRAM_OREG : constant is 1;
end bram_common;
