library verilog;
use verilog.vl_types.all;
entity EP_MEM is
    port(
        clk_i           : in     vl_logic;
        a_rd_a_i_0      : in     vl_logic_vector(8 downto 0);
        a_rd_d_o_0      : out    vl_logic_vector(31 downto 0);
        a_rd_en_i_0     : in     vl_logic;
        b_wr_a_i_0      : in     vl_logic_vector(8 downto 0);
        b_wr_d_i_0      : in     vl_logic_vector(31 downto 0);
        b_wr_en_i_0     : in     vl_logic;
        b_rd_d_o_0      : out    vl_logic_vector(31 downto 0);
        b_rd_en_i_0     : in     vl_logic;
        a_rd_a_i_1      : in     vl_logic_vector(8 downto 0);
        a_rd_d_o_1      : out    vl_logic_vector(31 downto 0);
        a_rd_en_i_1     : in     vl_logic;
        b_wr_a_i_1      : in     vl_logic_vector(8 downto 0);
        b_wr_d_i_1      : in     vl_logic_vector(31 downto 0);
        b_wr_en_i_1     : in     vl_logic;
        b_rd_d_o_1      : out    vl_logic_vector(31 downto 0);
        b_rd_en_i_1     : in     vl_logic;
        a_rd_a_i_2      : in     vl_logic_vector(8 downto 0);
        a_rd_d_o_2      : out    vl_logic_vector(31 downto 0);
        a_rd_en_i_2     : in     vl_logic;
        b_wr_a_i_2      : in     vl_logic_vector(8 downto 0);
        b_wr_d_i_2      : in     vl_logic_vector(31 downto 0);
        b_wr_en_i_2     : in     vl_logic;
        b_rd_d_o_2      : out    vl_logic_vector(31 downto 0);
        b_rd_en_i_2     : in     vl_logic;
        a_rd_a_i_3      : in     vl_logic_vector(8 downto 0);
        a_rd_d_o_3      : out    vl_logic_vector(31 downto 0);
        a_rd_en_i_3     : in     vl_logic;
        b_wr_a_i_3      : in     vl_logic_vector(8 downto 0);
        b_wr_d_i_3      : in     vl_logic_vector(31 downto 0);
        b_wr_en_i_3     : in     vl_logic;
        b_rd_d_o_3      : out    vl_logic_vector(31 downto 0);
        b_rd_en_i_3     : in     vl_logic
    );
end EP_MEM;
