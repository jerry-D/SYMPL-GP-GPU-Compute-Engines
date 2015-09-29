`timescale 1ns/100ps
// rounding mode selector for use with SYMPL FP32X-AXI4 multi-thread RISC and FloPoCo operators only
// Author:  Jerry D. Harthcock
// Version:  1.00  September 15, 2015
// September 15, 2015
// Copyright (C) 2015.  All rights reserved without prejudice.
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

module round_sel (
    round_mode,
    round,
    roundit,
    sign
    );

input round, sign;
input [1:0] round_mode;
output roundit;

wire roundit;
wire roundToZero;
wire roundToNearest;
wire roundToPos;
wire roundToNeg;

wire rounditToPos;
wire rounditToNeg;

wire either_nearest_or_zero;
wire either_pos_or_neg;


assign roundToNearest = (round_mode==2'b00);
assign roundToPos     = (round_mode==2'b01);
assign roundToNeg     = (round_mode==2'b10);
assign roundToZero    = (round_mode==2'b11);    

assign rounditToPos = roundToPos & round & ~sign;
assign rounditToNeg = roundToNeg & round &  sign;

assign either_nearest_or_zero = roundToNearest ? round : 1'b0;
assign either_pos_or_neg      = roundToPos     ? rounditToPos : rounditToNeg;

assign roundit = (roundToNearest | roundToZero) ? either_nearest_or_zero : either_pos_or_neg;

endmodule