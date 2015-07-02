library verilog;
use verilog.vl_types.all;
entity xilinx_pci_exp_ep is
    port(
        pci_exp_txp     : out    vl_logic_vector(0 downto 0);
        pci_exp_txn     : out    vl_logic_vector(0 downto 0);
        pci_exp_rxp     : in     vl_logic_vector(0 downto 0);
        pci_exp_rxn     : in     vl_logic_vector(0 downto 0);
        sys_clk_p       : in     vl_logic;
        sys_clk_n       : in     vl_logic;
        sys_reset_n     : in     vl_logic;
        refclkout       : out    vl_logic;
        rd_addr_fpga    : in     vl_logic_vector(10 downto 0);
        rd_be_fpga      : in     vl_logic_vector(3 downto 0);
        rd_data_fpga    : out    vl_logic_vector(31 downto 0);
        wr_addr_fpga    : in     vl_logic_vector(10 downto 0);
        wr_be_fpga      : in     vl_logic_vector(7 downto 0);
        wr_data_fpga    : in     vl_logic_vector(31 downto 0);
        wr_en_fpga      : in     vl_logic;
        wr_busy_fpga    : out    vl_logic
    );
end xilinx_pci_exp_ep;
