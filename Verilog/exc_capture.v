 `timescale 1ns/100ps
// Author:  Jerry D. Harthcock
// Version:  1.03  January 18, 2016
// Copyright (C) 2016.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
//             SYMPL 32-BIT RISC, COARSE-GRAINED SCHEDULER (CGS) and GP-GPU SHADER IP CORES                       //
//                              Evaluation and Product Development License                                        //
//                                                                                                                //
// Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"),  //
// the original author and exclusive copyright owner of these SYMPL 32-BIT RISC, COARSE-GRAINED SCHEDULER (CGS)   //
// and GP-GPU SHADER Verilog RTL IP cores and related development software ("this IP")  hereby grants             //
// to recipient of this IP ("licensee"), a world-wide, paid-up, non-exclusive license to implement this IP in     //
// Xilinx, Altera, MicroSemi or Lattice Semiconductor brand FPGAs only and used for the purposes of evaluation,   //
// education, and development of end products and related development tools only.  Furthermore, limited to the    //
// the purposes of prototyping, evaluation, characterization and testing of their implementation in a hard,       //
// custom or semi-custom ASIC, any university or institution of higher education may have their implementation of //
// this IP produced for said limited purposes at any foundary of their choosing provided that such prototypes do  //
// not ever wind up in commercial circulation with such license extending to said foundary and is in connection   //
// with said academic pursuit and under the supervision of said university or institution of higher education.    //
//                                                                                                                //
// Any customization, modification, or derivative work of this IP must include an exact copy of this license      //
// and original copyright notice at the very top of each source file and derived netlist, and, in the case of     //
// binaries, a printed copy of this license and/or a text format copy in a separate file distributed with said    //
// netlists or binary files having the file name, "LICENSE.txt".  You, the licensee, also agree not to remove     //
// any copyright notices from any source file covered under this Evaluation and Product Development License.      //
//                                                                                                                //
// LICENSOR DOES NOT WARRANT OR GUARANTEE THAT YOUR USE OF THIS IP WILL NOT INFRINGE THE RIGHTS OF OTHERS OR      //
// THAT IT IS SUITABLE OR FIT FOR ANY PURPOSE AND THAT YOU, THE LICENSEE, AGREE TO HOLD LICENSOR HARMLESS FROM    //
// ANY CLAIM BROUGHT BY YOU OR ANY THIRD PARTY FOR YOUR SUCH USE.                                                 //
//                                                                                                                //
// Licensor reserves all his rights without prejudice, including, but in no way limited to, the right to change   //
// or modify the terms and conditions of this Evaluation and Product Development License anytime without notice   //
// of any kind to anyone. By using this IP for any purpose, you agree to all the terms and conditions set forth   //
// in this Evaluation and Product Development License.                                                            //
//                                                                                                                //
// This Evaluation and Product Development License does not include the right to sell products that incorporate   //
// this IP, any IP derived from this IP.  If you would like to obtain such a license, please contact Licensor.    //
//                                                                                                                //
// Licensor can be contacted at:  SYMPL.gpu@gmail.com                                                             //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module exc_capture (     // quasi-trace buffer
    CLK,
    RESET,
    srcA_q1,
    srcB_q1,
    addrsMode_q1,
    dest_q2,
    pc_q1,
    rdSrcAdata,
    rdSrcBdata,
    exc_codeA,
    exc_codeB,
    rdenA,
    rdenB,
    thread_q1,
    round_mode_q1,
    ready_in,
    alt_nxact_handl,
    alt_unfl_handl,
    alt_ovfl_handl,
    alt_div0_handl,
    alt_inv_handl,
    invalid,
    divby0,
    overflow,
    underflow,
    inexact,
    capt_dataA,
    capt_dataB,
    thread_sel
);

input  CLK;
input  RESET;
input  [13:0] srcA_q1;
input  [13:0] srcB_q1;
input  [1:0]  addrsMode_q1;
input  [13:0] dest_q2;
input  [11:0] pc_q1;
input  [31:0] rdSrcAdata;
input  [31:0] rdSrcBdata;
input  [3:0]  exc_codeA;
input  [3:0]  exc_codeB;
input  rdenA;
input  rdenB;
input  [1:0] thread_q1;
input  [1:0] thread_sel;
input  [1:0] round_mode_q1;
input  ready_in;

input  alt_nxact_handl;
input  alt_unfl_handl ;
input  alt_ovfl_handl ;
input  alt_div0_handl ;
input  alt_inv_handl;

output invalid;
output divby0;
output overflow;
output underflow;
output inexact;

output [31:0] capt_dataA;
output [31:0] capt_dataB;
              
// encoded backend exception codes (prioritized)
parameter _no_excpt_   = 3'b000; // no back-end exception
parameter _div_by_0_   = 3'b001; // divide by zero
parameter _overflow_   = 3'b010; // operation resulted in overflow (inexact is implied)
parameter _underflow_  = 3'b011; // operation resulted in underflow (inexact is implied)
parameter _inexact_    = 3'b100; // inexact result due to rounding

reg [31:0] rdSrcAdata_capt;
reg [31:0] rdSrcBdata_capt;
reg [13:0] srcA_q1_capt;
reg [13:0] srcB_q1_capt;
reg [1:0]  addrsMode_q1_capt;
reg [13:0] dest_q2_capt;
reg [11:0] pc_q1_capt;
reg [1:0]  thread_q1_capt;
reg [1:0]  round_mode_q1_capt;
reg [1:0]  exc_codeA_capt;
reg [1:0]  exc_codeB_capt;
reg [1:0]  state;

reg rdenA_q1, rdenB_q1;

reg [31:0] capt_dataA;
reg [31:0] capt_dataB;

wire invalid;
wire divby0;
wire overflow;
wire underflow;
wire inexact;

wire capture_enable;

wire [1:0] selA;
wire [1:0] selB;

assign selA = srcA_q1[1:0]; 
assign selB = srcB_q1[1:0]; 

assign invalid = ready_in & (thread_q1==thread_sel) & (exc_codeA[3] | exc_codeB[3]);
assign divby0 = ready_in & (thread_q1==thread_sel) & ((exc_codeA[2:0]==_div_by_0_) | (exc_codeB[2:0]==_div_by_0_));
assign overflow = ready_in & (thread_q1==thread_sel) & (exc_codeA[2:0]==_overflow_) | (exc_codeB[2:0]==_overflow_);
assign underflow = ready_in & (thread_q1==thread_sel) & (exc_codeA[2:0]==_underflow_) | (exc_codeB[2:0]==_underflow_);
assign inexact = ready_in & (thread_q1==thread_sel) & (exc_codeA[2:0]==_inexact_) | (exc_codeB[2:0]==_inexact_);

assign capture_enable = (invalid & alt_inv_handl)    |
                        (divby0 & alt_div0_handl)    | 
                        (overflow & alt_ovfl_handl)  |
                        (underflow & alt_unfl_handl) |
                        (inexact & alt_nxact_handl);
always@(*) begin
    if (rdenA_q1) 
        case (selA)
            2'b00 : capt_dataA = rdSrcAdata_capt;
            2'b01 : capt_dataA = rdSrcBdata_capt;
            2'b10 : capt_dataA = {exc_codeB_capt, srcB_q1_capt, exc_codeA_capt, srcA_q1_capt};
            2'b11 : capt_dataA = {round_mode_q1_capt, thread_q1_capt, pc_q1_capt, addrsMode_q1_capt, dest_q2_capt};
        endcase
    else capt_dataA = 32'h0000_0000;    
end

always@(*) begin
    if (rdenB_q1) 
        case (selB)
            2'b00 : capt_dataB = rdSrcAdata_capt;
            2'b01 : capt_dataB = rdSrcBdata_capt;
            2'b10 : capt_dataB = {exc_codeB_capt, srcB_q1_capt, exc_codeA_capt, srcA_q1_capt};
            2'b11 : capt_dataB = {round_mode_q1_capt, thread_q1_capt, pc_q1_capt, addrsMode_q1_capt, dest_q2_capt};
        endcase
    else capt_dataB = 32'h0000_0000;    
end

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        rdenA_q1 <= 1'b0;
        rdenB_q1 <= 1'b0;
    end
    else begin
        rdenA_q1 <= rdenA;
        rdenB_q1 <= rdenB;
    end
end    
    
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        rdSrcAdata_capt <= 31'h0000_0000;
        rdSrcBdata_capt <= 31'h0000_0000;
        srcA_q1_capt    <= 14'h0000;
        srcB_q1_capt    <= 14'h0000;
        addrsMode_q1_capt <= 2'b00;
        dest_q2_capt    <= 14'h0000;
        pc_q1_capt      <= 12'h000;
        exc_codeA_capt  <= 2'b00;
        exc_codeB_capt  <= 2'b00;
        round_mode_q1_capt <= 2'b00;
        thread_q1_capt <= 2'b00;
        state <= 2'b00;
    end
    else begin
        case (state)
            2'b00 : if (capture_enable) begin
                        rdSrcAdata_capt <= rdSrcAdata;
                        rdSrcBdata_capt <= rdSrcBdata;
                        {exc_codeA_capt, srcA_q1_capt} <= {exc_codeA[1:0], srcA_q1};
                        {exc_codeB_capt, srcB_q1_capt} <= {exc_codeB[1:0], srcB_q1};
                        {round_mode_q1_capt, thread_q1_capt, pc_q1_capt, addrsMode_q1_capt} <= {round_mode_q1, thread_q1, pc_q1, addrsMode_q1}; 
                        state <= 2'b01;
                    end
            2'b01 : begin
                        dest_q2_capt <= dest_q2;
                        state <= 2'b10;
                    end
            2'b10,            
            2'b11 : if (rdenA_q1 || rdenB_q1) state <= 2'b00;
        endcase             
    end
end    
    
endmodule