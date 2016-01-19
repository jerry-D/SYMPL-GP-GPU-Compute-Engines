 `timescale 1ns/100ps
// Author:  Jerry D. Harthcock
// Version:  1.07  January 18, 2016
// Copyright (C) 2015-2016.  All rights reserved.
//
// latency for DOT is 8 clocks
//
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
module Fma_Clk (
    CLK,
    RESET,
    X,
    Y,    
    C,
    R,
    
    wren,
    wraddrs,
        
    tr3_CREG_wr,
    tr2_CREG_wr,
    tr1_CREG_wr,
    tr0_CREG_wr,
    
    Invalid_Add_Op,
    round,
    sign,
    roundit, 
    supress_Ovfl_sig,
    Round_del    
    );
    
input CLK, RESET;
input [34:0] X, Y, C;
output [34:0] R;

input wren;
input [5:0] wraddrs;

input tr3_CREG_wr;
input tr2_CREG_wr;
input tr1_CREG_wr;
input tr0_CREG_wr;

output Invalid_Add_Op;
output round;
output sign;
input  roundit;
output supress_Ovfl_sig;
output Round_del;

reg delay0, delay1, delay2, delay3, delay4, delay5;
reg Round_del;

reg [49:0] dot_accum[63:0];
reg [49:0] C_accum;

reg [6:0] wren_wraddrs_del0;
reg [6:0] wren_wraddrs_del1;
reg [6:0] wren_wraddrs_del2;
reg [6:0] wren_wraddrs_del3;
reg [6:0] wren_wraddrs_del4;
reg [6:0] wren_wraddrs_del5;
reg [6:0] wren_wraddrs_del6;

reg tr3_CREG_wr_q0;
reg tr2_CREG_wr_q0;
reg tr1_CREG_wr_q0;
reg tr0_CREG_wr_q0;

wire [5:0] wraddrsA;
wire       wrenA;
wire       rdenB;
wire [3:0] CREG_sel;
wire [49:0] Cq;

wire [5:0] rdaddrsB;

wire Rmult_is_infinite;
wire C_is_infinite;
wire Invalid_Add_Op;

wire [49:0] Rmult;
wire [49:0] Radd;
wire [34:0] R;
wire round;
wire sign;
wire rnd;
wire supress_Ovfl_sig;


assign wraddrsA = wren_wraddrs_del6[5:0];
assign wrenA = wren_wraddrs_del6[6];
assign rdenB = wren_wraddrs_del0[6];
assign rdaddrsB = wren_wraddrs_del0[5:0];
assign Cq = |CREG_sel ? {C, 15'h0000} : C_accum;

assign CREG_sel = {(tr3_CREG_wr_q0 & (wren_wraddrs_del1[6:4]==3'b111)), 
                   (tr2_CREG_wr_q0 & (wren_wraddrs_del1[6:4]==3'b110)), 
                   (tr1_CREG_wr_q0 & (wren_wraddrs_del1[6:4]==3'b101)), 
                   (tr0_CREG_wr_q0 & (wren_wraddrs_del1[6:4]==3'b100))};


assign supress_Ovfl_sig = delay5;    

assign Rmult_is_infinite = (Rmult[49:48]==2'b10);
assign C_is_infinite = (C[34:33]==2'b10);    //C has overflowed if true
assign Invalid_Add_Op =  Rmult_is_infinite & C_is_infinite & (Rmult[47] ^ C[32]);

//mult pipe is 1 stages            9 23 23 9 38
//FPMult_8_23_8_23_8_38_uid2 fatMUL(
FPMult_9_23_9_23_9_38_uid2 fatMUL(
    .clk (CLK  ),
    .rst (RESET),
    .X   (X    ),
    .Y   (Y    ),
    .R   (Rmult)   // modified internally so result is not rounded
    );

// add pipe is 5 stages       9 38 38 9 38
fusedADD38 fatADD(
    .clk (CLK  ),
    .rst (RESET),
    .X   ((Rmult[49:48]==2'b01) ? Rmult : 50'h0_0000_0000_0000),
    .Y   (Cq),
    .R   (Radd ),
    .rnd (rnd  )    // modified internally so result is not rounded, thus this bit simply detects if the result is inexact
    );    

// (1 * C) this mult pipe is 1 stage deep used to convert back to 8 23
//FPMult_8_1_8_38_8_23_uid2 thinMUL(
FPMult_9_1_9_38_9_23_uid2 thinMUL(     // 9 1 9 38 9 23
    .clk (CLK  ),
    .rst (RESET), 
    .X   (13'b01_0_0111_1111_10),      // +1.0 
    .Y   (Radd  ),
    .R   (R    ),
    .round  (round  ),
    .sign   (sign   ),
    .roundit(roundit)
    );

    
//----------- true dual-ported SRAM block ----------------------------------------
//A-side of DP_RAM saves accumulated result of each FMA/DOT operation
// even though an accumulation may not be needed (ie, pure FMA and not DOT operation) 
always @(posedge CLK)
    if (wrenA) dot_accum[wraddrsA] <= Radd;

//B-side of DP RAM always immediately read anytime FMA operator is written to
// but first read from a given result slot/bin/buffer is ignored and actual C_reg 
// value is used instead (for pure/non-accumulated FMA operations) 
always @(posedge CLK) 
    if (rdenB) C_accum <= dot_accum[rdaddrsB];
//--------------------------------------------------------------------------------

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        tr3_CREG_wr_q0 <= 1'b0;
        tr2_CREG_wr_q0 <= 1'b0;
        tr1_CREG_wr_q0 <= 1'b0;
        tr0_CREG_wr_q0 <= 1'b0;               
    end
    else begin
        if (tr3_CREG_wr) tr3_CREG_wr_q0 <= 1'b1;
        else if (tr3_CREG_wr_q0 && (wren_wraddrs_del1[6:4]==3'b111)) tr3_CREG_wr_q0 <= 1'b0;
        if (tr2_CREG_wr) tr2_CREG_wr_q0 <= 1'b1;
        else if (tr2_CREG_wr_q0 && (wren_wraddrs_del1[6:4]==3'b110)) tr2_CREG_wr_q0 <= 1'b0;
        if (tr1_CREG_wr) tr1_CREG_wr_q0 <= 1'b1;
        else if (tr1_CREG_wr_q0 && (wren_wraddrs_del1[6:4]==3'b101)) tr1_CREG_wr_q0 <= 1'b0;
        if (tr0_CREG_wr) tr0_CREG_wr_q0 <= 1'b1;
        else if (tr0_CREG_wr_q0 && (wren_wraddrs_del1[6:4]==3'b100)) tr0_CREG_wr_q0 <= 1'b0;
   end
end        

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        wren_wraddrs_del0 <= 7'b0000000;
        wren_wraddrs_del1 <= 7'b0000000;
        wren_wraddrs_del2 <= 7'b0000000;
        wren_wraddrs_del3 <= 7'b0000000;
        wren_wraddrs_del4 <= 7'b0000000;
        wren_wraddrs_del5 <= 7'b0000000;
        wren_wraddrs_del6 <= 7'b0000000;
    end
    else begin
        wren_wraddrs_del0 <= {wren, wraddrs[5:0]};
        wren_wraddrs_del1 <= wren_wraddrs_del0;
        wren_wraddrs_del2 <= wren_wraddrs_del1;
        wren_wraddrs_del3 <= wren_wraddrs_del2;
        wren_wraddrs_del4 <= wren_wraddrs_del3;
        wren_wraddrs_del5 <= wren_wraddrs_del4;
        wren_wraddrs_del6 <= wren_wraddrs_del5;
    end
end        

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        delay0 <= 1'b0; 
        delay1 <= 1'b0; 
        delay2 <= 1'b0; 
        delay3 <= 1'b0; 
        delay4 <= 1'b0; 
        delay5 <= 1'b0;
        Round_del <= 1'b0;
    end    
    else begin
        delay0 <= (Rmult_is_infinite | C_is_infinite) & ~Invalid_Add_Op;    
        delay1 <= delay0;
        delay2 <= delay1;
        delay3 <= delay2;
        delay4 <= delay3;
        delay5 <= delay4;
        Round_del <= rnd;
    end
end    

endmodule