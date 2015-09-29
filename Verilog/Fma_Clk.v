 `timescale 1ns/100ps
// sub-wrapper for Dot_Clk
// For use in SYMPL FP32X-AXI4 multi-thread RISC only
// Author:  Jerry D. Harthcock
// Version:  1.02 September 23, 2015
// September 9, 2015
// Copyright (C) 2015.  All rights reserved without prejudice.
//
// latency for DOT is 8 clocks
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                              SYMPL FP32X-AXI4 32-Bit Mult-Thread RISC                                         //
//                              Evaluation and Product Development License                                       //
//                                                                                                               //
// Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"), //
// the original author and exclusive copyright owner of this SYMPL FP32X-AXI4 32-Bit Mult-Thread RISC            //
// Verilog RTL IP core ("this IP"), hereby grants to recipient of this IP ("licensee"), a world-wide, paid-up,   //
// non-exclusive license to use this IP for the purposes of evaluation, education, and development of end        //
// products and related development tools only.                                                                  //
//                                                                                                               //
// Also subject to the terms and conditions set forth herein, Jerry D. Harthcock, exlusive inventor and owner    //
// of US Patent No. 7,073,048, entitled "CASCADED MICROCOMPUTER ARRAY AND METHOD", issue date July 4, 2006       //
// ("the '048 patent"), hereby grants a world-wide, paid-up, non-exclusive license under the '048 patent to use  //
// this IP for the purposes of evaluation, education, and development of end products and related development    //
// tools only.                                                                                                   //
//                                                                                                               //
// Any customization, modification, or derivative work of this IP must include an exact copy of this license     //
// and original copyright notice at the very top of each source file and derived netlist, and, in the case of    //
// binaries, a printed copy of this license and/or a text format copy in a separate file distributed with said   //
// netlists or binary files having the file name, "LICENSE.txt".  You, the licensee, also agree not to remove    //
// any copyright notices from any source file covered under this Evaluation and Product Development License.     //
//                                                                                                               //
// LICENSOR DOES NOT WARRANT OR GUARANTEE THAT YOUR USE OF THIS IP WILL NOT INFRINGE THE RIGHTS OF OTHERS OR     //
// THAT IT IS SUITABLE OR FIT FOR ANY PURPOSE AND THAT YOU, THE LICENSEE, AGREE TO HOLD LICENSOR HARMLESS FROM   //
// ANY CLAIM BROUGHT BY YOU OR ANY THIRD PARTY FOR YOUR SUCH USE.                                                //
//                                                                                                               //
// Licensor reserves all his rights without prejudice, including, but in no way limited to, the right to change  //
// or modify the terms and conditions of this Evaluation and Product Development License anytime without notice  //
// of any kind to anyone. By using this IP for any purpose, you agree to all the terms and conditions set forth  //
// in this Evaluation and Product Development License.                                                           //
//                                                                                                               //
// This Evaluation and Product Development License does not include the right to sell products that incorporate  //
// this IP, any IP derived from this IP, or the '048 patent.  If you would like to obtain such a license, please //
// contact Licensor.                                                                                             //
//                                                                                                               //
// Licensor can be contacted at:  SYMPL.gpu@gmail.com                                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Fma_Clk (
    CLK,
    RESET,
    X,
    Y,
    C,
    R,
    Invalid_Add_Op,
    round,
    sign,
    roundit, 
    supress_Ovfl_sig,
    Round_del    
    );
    
input CLK, RESET;
//input [33:0] X, Y, C;
//output [33:0] R;
input [34:0] X, Y, C;
output [34:0] R;
output Invalid_Add_Op;
output round;
output sign;
input  roundit;
output supress_Ovfl_sig;
output Round_del;

//reg [33:0] Cq;
reg [34:0] Cq;
reg delay0, delay1, delay2, delay3, delay4, delay5;
reg Round_del;

wire Rmult_is_infinite;
wire C_is_infinite;
wire Invalid_Add_Op;

//wire [48:0] Rmult;
//wire [48:0] Radd;
//wire [33:0] R;
wire [49:0] Rmult;
wire [49:0] Radd;
wire [34:0] R;
wire round;
wire sign;
wire rnd;

wire supress_Ovfl_sig;

assign supress_Ovfl_sig = delay5;    

//assign Rmult_is_infinite = (Rmult[48:47]==2'b10);
//assign C_is_infinite = (Cq[33:32]==2'b10);    //C has overflowed if true
assign Rmult_is_infinite = (Rmult[49:48]==2'b10);
assign C_is_infinite = (Cq[34:32]==2'b10);    //C has overflowed if true
//assign Invalid_Add_Op =  Rmult_is_infinite & C_is_infinite & (Rmult[46] ^ Cq[31]);
assign Invalid_Add_Op =  Rmult_is_infinite & C_is_infinite & (Rmult[47] ^ Cq[32]);

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
//    .X   ((Rmult[48:47]==2'b01) ? Rmult : 49'h0_0000_0000_0000),
    .X   ((Rmult[49:48]==2'b01) ? Rmult : 50'h0_0000_0000_0000),
    .Y   ({Cq, 15'h0000}),
    .R   (Radd ),
    .rnd (rnd  )    // modified internally so result is not rounded, thus this bit simply detects if the result is inexact
    );    

// (1 * C) this mult pipe is 1 stage deep used to convert back to 8 23
//FPMult_8_1_8_38_8_23_uid2 thinMUL(
FPMult_9_1_9_38_9_23_uid2 thinMUL(     // 9 1 9 38 9 23
    .clk (CLK  ),
    .rst (RESET),
//    .X   (12'b01_0_011_1111_10),      // +1.0 
    .X   (13'b01_0_0111_1111_10),      // +1.0 
    .Y   (Radd  ),
    .R   (R    ),
    .round  (round  ),
    .sign   (sign   ),
    .roundit(roundit)
    );

always @(posedge CLK or posedge RESET) begin
    if (RESET) Cq <= 35'h0_0000_0000;
    else Cq <= C;
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