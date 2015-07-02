library verilog;
use verilog.vl_types.all;
entity ram_dp_ar_aw is
    generic(
        DATA_WIDTH      : integer := 8;
        ADDR_WIDTH      : integer := 8;
        RAM_DEPTH       : vl_notype
    );
    port(
        address_0       : in     vl_logic_vector;
        data_0          : in     vl_logic_vector;
        cs_0            : in     vl_logic;
        we_0            : in     vl_logic;
        oe_0            : in     vl_logic;
        address_1       : in     vl_logic_vector;
        data_1          : inout  vl_logic_vector;
        cs_1            : in     vl_logic;
        we_1            : in     vl_logic;
        oe_1            : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of RAM_DEPTH : constant is 3;
end ram_dp_ar_aw;
