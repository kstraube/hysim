library verilog;
use verilog.vl_types.all;
entity pcie_interface is
    port(
        pci_exp_txp     : out    vl_logic;
        pci_exp_txn     : out    vl_logic;
        pci_exp_rxp     : in     vl_logic;
        pci_exp_rxn     : in     vl_logic;
        sys_clk_p       : in     vl_logic;
        sys_clk_n       : in     vl_logic;
        sys_reset_n     : in     vl_logic;
        clk             : in     vl_logic;
        pcie_data_in    : out    vl_logic_vector(31 downto 0);
        pcie_data_in_valid: out    vl_logic;
        pcie_data_out   : in     vl_logic_vector(127 downto 0);
        mem_cnt_eq      : in     vl_logic;
        mem_out_empty   : in     vl_logic
    );
end pcie_interface;
