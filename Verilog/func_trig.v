 `timescale 1ns/100ps
// func_atomic.v
// For use in SYMPL FP324-AXI4 multi-thread multi-processing core only
// Author:  Jerry D. Harthcock
// Version:  2.00
// August 15, 2015
// Copyright (C) 2014-2015.  All rights reserved without prejudice.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                           SYMPL FP324-AXI4 32-Bit Mult-Thread Multi-Processor                                 //
//                              Evaluation and Product Development License                                       //
//                                                                                                               //
// Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"), //
// the original author and exclusive copyright owner of this SYMPL FP324-AXI4 32-Bit Mult-Thread Multi-Processor //
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

module func_trig (
    wrdata,     
    opcode_q2,
    sin_out,
    cos_out,
    tan_out,
    cot_out,
    rcp_out);
    
input [3:0] opcode_q2;
input [9:0] wrdata;
output [31:0] sin_out, cos_out, tan_out, cot_out, rcp_out;

parameter RCP_ = 4'b1011;

wire [9:0] wrdata;
wire [31:0] rcp_out;
wire [31:0] sin_out;
wire [31:0] cos_out;
wire [31:0] tan_out;
wire [31:0] cot_out;


trigd trigd(     //sin cos tan cot in degrees, 1 deg resolution, input range +/- 0 to 360 integer, output float32
    .opcode_q2 (opcode_q2),
    .x (wrdata[9:0]),
    .sin (sin_out),
    .cos (cos_out),
    .tan (tan_out),
    .cot (cot_out));

rcp rcp(
    .rdenA   (opcode_q2 == RCP_),
    .x       (wrdata[7:0]),
    .rddataA (rcp_out));
        
//assign rcp_out = 32'h0000_0000;

endmodule                    
                        
                                          

       
    
    