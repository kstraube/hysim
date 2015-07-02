module pcie_ctrl (
    input clk,
    input rst,

    //pcie interface
    output pcie_we,
    output [31:0] pcie_wdata,
    output [10:0] pcie_waddr,
    input pcie_wr_busy,

    output reg pcie_re,
    output reg [10:0] pcie_raddr,
    input  [31:0] pcie_rdata,

    //processor model interface
    output tm2cpu_token_type      tm2cpu,
    input  tm_cpu_ctrl_token_type cpu2tm,
    output bit                    tm2cpu_good,
    input  bit                    proc_busy //set when replays are occurring
);

bit [NTHREADS-1:0] ABstore;
bit [9:0] v_pcie_raddr;

//rememebr that read and write go to different memories so they can hit the same address

//READ: iterate reading through addresses and check for a/b encoding changing
//   if it is good then pass the new values onto tm2cpu and 1 to tm2cpu_good
always_ff @(posedge clk) begin
  if (rst) begin
    pcie_raddr <= 10'b0;
    pcie_re <= 1'b0;
  end
  else begin
    if (v_pcie_raddr >= NTHREADS) begin
      pcie_raddr <= 10'b0;
      pcie_re = 1'b1;
    end
    else if (proc_busy) begin //THINK MORE ABOUT THIS WITH TIMING OF DATA OUT OF REPLAY QUEUE AND ACCESS RAM
      pcie_raddr <= pcie_raddr;
      pcie_re <= 1'b0;
    end
    else begin
      pcie_raddr <= v_pcie_raddr;
      pcie_re = 1'b1;
    end
  end
end

always_comb begin
  v_pcie_raddr = pcie_raddr + 1;
  if (pcie_rdata[31] != ABstore[pcie_raddr[NTHREADIDMSB:0]] && ~proc_busy) begin
    //new data is good so send to tm2cpu
    tm2cpu.valid = pcie_rdata[0]; //figure all of these out
    tm2cpu_good = 1'b1;
  end
  else begin
    tm2cpu_good = 1'b0;
  end
end

//WRITE: monitor cpu2tm and write the value if the cpu2tm is valid and retired (otherwise it will get replayed through the replay queue)
//     writes take 4 cycles so need a FIFO to store all of the data for each TID and then for other TIDs as they arrive
//     every 4 - need to read the TID to know the address to write to


endmodule
