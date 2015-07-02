library verilog;
use verilog.vl_types.all;
entity sync_fifo is
    generic(
        WIDTH           : integer := 32;
        DEPTH           : integer := 16;
        STYLE           : string  := "SRL";
        AFASSERT        : vl_notype;
        AEASSERT        : integer := 1;
        FWFT            : integer := 0;
        SUP_REWIND      : integer := 0;
        INIT_OUTREG     : integer := 0;
        ADDRW           : vl_notype
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        din             : in     vl_logic_vector;
        dout            : out    vl_logic_vector;
        wr_en           : in     vl_logic;
        rd_en           : in     vl_logic;
        full            : out    vl_logic;
        afull           : out    vl_logic;
        empty           : out    vl_logic;
        aempty          : out    vl_logic;
        data_count      : out    vl_logic_vector;
        mark_addr       : in     vl_logic;
        clear_addr      : in     vl_logic;
        rewind          : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DEPTH : constant is 1;
    attribute mti_svvh_generic_type of STYLE : constant is 1;
    attribute mti_svvh_generic_type of AFASSERT : constant is 3;
    attribute mti_svvh_generic_type of AEASSERT : constant is 1;
    attribute mti_svvh_generic_type of FWFT : constant is 1;
    attribute mti_svvh_generic_type of SUP_REWIND : constant is 1;
    attribute mti_svvh_generic_type of INIT_OUTREG : constant is 1;
    attribute mti_svvh_generic_type of ADDRW : constant is 3;
end sync_fifo;
