 `timescale 1ns/100ps
// func_atomic.v
// atomic function instructions (trig & reciprocal) for use in SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-Compute Engine
// Author:  Jerry D. Harthcock
// Version:  1.03  Dec. 12, 2015
// December 07, 2014
// Copyright (C) 2014-2015.  All rights reserved without prejudice.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                   SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-Compute Engine                           //
//                              Evaluation and Product Development License                                       //
//                                                                                                               //
// Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"), //
// the original author and exclusive copyright owner of the SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-  //
// Compute Engine Verilog RTL IP core family and instruction-set architecture ("this IP"), hereby grants to      //
// recipient of this IP ("licensee"), a world-wide, paid-up, non-exclusive license to use this IP for the        //
// non-commercial purposes of evaluation, education, and development of end products and related development     //
// tools only. For a license to use this IP in commercial products intended for sale, license, lease or any      //
// other form of barter, contact licensor at:  SYMPL.gpu@gmail.com                                               //
//                                                                                                               //
// Any customization, modification, or derivative work of this IP must include an exact copy of this license     //
// and original copyright notice at the very top of each source file and derived netlist, and, in the case of    //
// binaries, a printed copy of this license and/or a text format copy in a separate file distributed with said   //
// netlists or binary files having the file name, "LICENSE.txt".  You, the licensee, also agree not to remove    //
// any copyright notices from any source file covered under this Evaluation and Product Development License.     //
//                                                                                                               //
// THIS IP IS PROVIDED "AS IS".  LICENSOR DOES NOT WARRANT OR GUARANTEE THAT YOUR USE OF THIS IP WILL NOT        //
// INFRINGE THE RIGHTS OF OTHERS OR THAT IT IS SUITABLE OR FIT FOR ANY PURPOSE AND THAT YOU, THE LICENSEE, AGREE //
// TO HOLD LICENSOR HARMLESS FROM ANY CLAIM BROUGHT BY YOU OR ANY THIRD PARTY FOR YOUR SUCH USE.                 //                               
//                                                                                                               //
// Licensor reserves all his rights without prejudice, including, but in no way limited to, the right to change  //
// or modify the terms and conditions of this Evaluation and Product Development License anytime without notice  //
// of any kind to anyone. By using this IP for any purpose, you agree to all the terms and conditions set forth  //
// in this Evaluation and Product Development License.                                                           //
//                                                                                                               //
// This Evaluation and Product Development License does not include the right to sell products that incorporate  //
// this IP or any IP derived from this IP.  If you would like to obtain such a license, please contact Licensor. //                                                                                            //
//                                                                                                               //
// Licensor can be contacted at:  SYMPL.gpu@gmail.com                                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module func_atomic (
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

//assign inv_out = 32'h0000_0000;

endmodule                    
                        
                                          

       
    
    