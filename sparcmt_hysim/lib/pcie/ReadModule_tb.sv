‘timescale 1ns/1ns

module ReadMod_tb;

  reg clk, rst_n;
  reg [31:0] RAM_data;
  reg RAM_valid, enable;

  wire [10:0] RAM_addr;
  wire [31:0] FPGA_data;
  wire FPGA_valid, read_en;

ReadMod dut (
   .clk(clk),
   .rst_n(rst_n),
   .RAM_data(RAM_data), //32 bits
   .RAM_valid(RAM_valid),
   .enable(enable),
   .RAM_addr(RAM_addr),//11 bit output
   .FPGA_data(FPGA_data)//32bits,
   .FPGA_valid(FPGA_valid),
   .read_en(read_en)     
   );

initial 
  begin
    clk = 1'b0;
    rst_n = 1'b0;
    RAM_Data = 32'b0;
    RAM_valid = 1'b0;
    enable = 1'b0;
    #200
    rst_n = 1'b1;
    enable = 1'b1;
    #40
    RAM_data = 32'hfeadbeef;
    RAM_valid2 = 1'b1;
    #100
    RAM_data = 32'hffffffff;
    RAM_valid2 = 1'b1;
    
  end

//still need to add stimulus
always  
      begin
        #20 clk = ~clk;
      end
