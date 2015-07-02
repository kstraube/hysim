// DISCLAIMER OF LIABILITY
//
// This text/file contains proprietary, confidential
// information of Xilinx, Inc., is distributed under license
// from Xilinx, Inc., and may be used, copied and/or
// disclosed only pursuant to the terms of a valid license
// agreement with Xilinx, Inc. Xilinx hereby grants you
// a license to use this text/file solely for design, simulation,
// implementation and creation of design files limited
// to Xilinx devices or technologies. Use with non-Xilinx
// devices or technologies is expressly prohibited and
// immediately terminates your license unless covered by
// a separate agreement.
//
// Xilinx is providing this design, code, or information
// "as is" solely for use in developing programs and
// solutions for Xilinx devices. By providing this design,
// code, or information as one possible implementation of
// this feature, application or standard, Xilinx is making no
// representation that this implementation is free from any
// claims of infringement. You are responsible for
// obtaining any rights you may require for your implementation.
// Xilinx expressly disclaims any warranty whatsoever with
// respect to the adequacy of the implementation, including
// but not limited to any warranties or representations that this
// implementation is free from claims of infringement, implied
// warranties of merchantability or fitness for a particular
// purpose.
//
// Xilinx products are not intended for use in life support
// appliances, devices, or systems. Use in such applications are
// expressly prohibited.
//
//
// Copyright (c) 2001, 2002, 2003, 2004, 2005, 2007, 2008 Xilinx, Inc. All rights reserved.
//
// This copyright and support notice must be retained as part
// of this text at all times.


`include "board_common.v"

`define EXPECT_FINISH_CHECK board.xilinx_pci_exp_1_lane_downstream_port.tx_usrapp.expect_finish_check
module pci_exp_usrapp_rx                   (
                     
                                           trn_rdst_rdy_n,
                                           trn_rnp_ok_n,
              
                                           trn_rd,
                                           trn_rrem_n,
                                           trn_rsof_n,
                                           trn_reof_n,
                                           trn_rsrc_rdy_n,
                                           trn_rsrc_dsc_n,
                                           trn_rerrfwd_n,
                                           trn_rbar_hit_n,
                                           trn_rfc_nph_av,
                                           trn_rfc_npd_av,
                                           trn_rfc_ph_av,
                                           trn_rfc_pd_av,
                                           trn_rfc_cplh_av,
                                           trn_rfc_cpld_av,
              
                                           trn_clk,
                                           trn_reset_n,
                                           trn_lnk_up_n
              
                                           );

output                                     trn_rdst_rdy_n;
output                                     trn_rnp_ok_n;

input    [(64 - 1):0]  trn_rd;
input    [(8 - 1):0]   trn_rrem_n;
input                                       trn_rsof_n;
input                                       trn_reof_n;
input                                       trn_rsrc_rdy_n;
input                                       trn_rsrc_dsc_n;
input                                       trn_rerrfwd_n;
input  [(7 - 1):0] trn_rbar_hit_n;
input   [(8 - 1):0] trn_rfc_nph_av;
input  [(12 - 1):0] trn_rfc_npd_av;
input  [(8 - 1):0]  trn_rfc_ph_av;
input  [(12- 1):0] trn_rfc_pd_av;
input  [(8 - 1):0]  trn_rfc_cplh_av;
input  [(12 - 1):0] trn_rfc_cpld_av;


input                                       trn_clk;
input                                       trn_reset_n;
input                                       trn_lnk_up_n;

parameter                                   Tcq = 1;

/* Output variables */

reg               trn_rdst_rdy_n, next_trn_rdst_rdy_n;
reg               trn_rnp_ok_n, next_trn_rnp_ok_n;

/* Local variables */

reg     [4:0]     trn_rx_state, next_trn_rx_state;
reg               trn_rx_in_frame, next_trn_rx_in_frame;
reg               trn_rx_in_channel, next_trn_rx_in_channel;

reg     [31:0]    next_trn_rx_timeout;

/* State variables */

`define           TRN_RX_RESET    5'b00001
`define           TRN_RX_DOWN     5'b00010
`define           TRN_RX_IDLE     5'b00100
`define           TRN_RX_ACTIVE   5'b01000
`define           TRN_RX_SRC_DSC  5'b10000


/* Transaction Receive User Interface State Machine */


always @(posedge trn_clk or negedge trn_reset_n) begin

  if (trn_reset_n == 1'b0) begin

    trn_rx_state     <= #(Tcq)  `TRN_RX_RESET;

  end else begin

  case (trn_rx_state)

    `TRN_RX_RESET :  begin
      
      if (trn_reset_n == 1'b0)
        
        trn_rx_state <= #(Tcq) `TRN_RX_RESET;

      else

        trn_rx_state <= #(Tcq) `TRN_RX_DOWN;
    end

    `TRN_RX_DOWN : begin

      if (trn_lnk_up_n == 1'b1)

        trn_rx_state <= #(Tcq) `TRN_RX_DOWN;

      else begin
        
        trn_rx_state <= #(Tcq) `TRN_RX_IDLE;
      end

    end

    `TRN_RX_IDLE : begin

      if (trn_reset_n == 1'b0)
        
        trn_rx_state <= #(Tcq) `TRN_RX_RESET;

      else if (trn_lnk_up_n == 1'b1)

        trn_rx_state <= #(Tcq) `TRN_RX_DOWN;

      else begin

        if (  (trn_rsof_n == 1'b0) &&
              (trn_rsrc_rdy_n == 1'b0) &&
               (trn_rdst_rdy_n == 1'b0)  ) begin

          board.xilinx_pci_exp_1_lane_downstream_port.com_usrapp.TSK_READ_DATA(0, `RX_LOG, trn_rd, trn_rrem_n);

          trn_rx_state <= #(Tcq) `TRN_RX_ACTIVE;

        end else begin

          trn_rx_state <= #(Tcq) `TRN_RX_IDLE;

        end
      end

    end

    `TRN_RX_ACTIVE : begin

      if (trn_reset_n == 1'b0)
        
        trn_rx_state <= #(Tcq) `TRN_RX_RESET;

      else if (trn_lnk_up_n == 1'b1)

        trn_rx_state <= #(Tcq) `TRN_RX_DOWN;

      else if (  (trn_rsrc_rdy_n == 1'b0) && 
                (trn_reof_n == 1'b0) &&
                 (trn_rdst_rdy_n == 1'b0)  ) begin

        board.xilinx_pci_exp_1_lane_downstream_port.com_usrapp.TSK_READ_DATA(1, `RX_LOG, trn_rd, trn_rrem_n);
        board.xilinx_pci_exp_1_lane_downstream_port.com_usrapp.TSK_PARSE_FRAME(`RX_LOG);

        trn_rx_state <= #(Tcq) `TRN_RX_IDLE;

      end else if (  (trn_rsrc_rdy_n == 1'b0) &&
                     (trn_rdst_rdy_n == 1'b0)  ) begin

        board.xilinx_pci_exp_1_lane_downstream_port.com_usrapp.TSK_READ_DATA(0, `RX_LOG, trn_rd, trn_rrem_n);

        trn_rx_state <= #(Tcq) `TRN_RX_ACTIVE;

      end else if (  (trn_rsrc_rdy_n == 1'b0) &&
          (trn_reof_n == 1'b0) &&
          (trn_rsrc_dsc_n == 1'b0)  ) begin

        board.xilinx_pci_exp_1_lane_downstream_port.com_usrapp.TSK_READ_DATA(1, `RX_LOG, trn_rd, trn_rrem_n);
        board.xilinx_pci_exp_1_lane_downstream_port.com_usrapp.TSK_PARSE_FRAME(`RX_LOG);

        trn_rx_state <= #(Tcq) `TRN_RX_SRC_DSC;

      end else begin

        trn_rx_state <= #(Tcq) `TRN_RX_ACTIVE;
      end

    end

    `TRN_RX_SRC_DSC : begin

      if (trn_reset_n == 1'b0)

        trn_rx_state <= #(Tcq) `TRN_RX_RESET;

      else if (trn_lnk_up_n == 1'b1)

        trn_rx_state <= #(Tcq) `TRN_RX_DOWN;

      else begin

        trn_rx_state <= #(Tcq) `TRN_RX_IDLE;

      end
    end

  endcase

   end

end

reg [1:0]   trn_rdst_rdy_toggle_count;
reg [8:0]   trn_rnp_ok_toggle_count;

always @(posedge trn_clk or negedge trn_reset_n) begin

   if (trn_reset_n == 1'b0) begin

    trn_rnp_ok_n        <= #(Tcq)   1'b0;
    trn_rdst_rdy_n      <= #(Tcq)       1'b0;
    trn_rdst_rdy_toggle_count <= #(Tcq) $random;
    trn_rnp_ok_toggle_count <=  #(Tcq)     $random;

   end else begin

    if (trn_rnp_ok_toggle_count == 0) begin

        trn_rnp_ok_n        <= #(Tcq)   !trn_rnp_ok_n;
        trn_rnp_ok_toggle_count <=  #(Tcq)     $random;

    end else begin

        //trn_rnp_ok_toggle_count   <=  #(Tcq)     trn_rnp_ok_toggle_count - 1;
                
    end         

    if (trn_rdst_rdy_toggle_count == 0) begin

        //trn_rdst_rdy_n      <= #(Tcq)       !trn_rdst_rdy_n;
        trn_rdst_rdy_toggle_count <= #(Tcq) $random;
                
    end else begin

        //trn_rdst_rdy_toggle_count <= trn_rdst_rdy_toggle_count - 1;
    end
        
   end
            
end
                
reg [31:0] sim_timeout;
initial
begin
  sim_timeout = `TRN_RX_TIMEOUT;
end

/* Transaction Receive Timeout */
            
always @(trn_clk or trn_rsof_n or trn_rsrc_rdy_n) begin
                
    if (next_trn_rx_timeout == 0) begin
        if(!`EXPECT_FINISH_CHECK)
          $display("[%t] : TEST FAILED --- Haven't Received All Expected TLPs", $realtime);

        $finish(2);
    end
                
    if ((trn_rsof_n == 1'b0) && (trn_rsrc_rdy_n == 1'b0)) begin
            
        next_trn_rx_timeout = sim_timeout;

    end else begin

        if (trn_lnk_up_n == 1'b0)

            next_trn_rx_timeout = next_trn_rx_timeout - 1'b1;

    end

end

endmodule // pci_exp_usrapp_rx

