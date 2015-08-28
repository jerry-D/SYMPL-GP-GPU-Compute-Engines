 `timescale 1ns/100ps
// sched_stack.v
// Fine-grained scheduler stack for use with SYMPL FP32X-AXI4 RISC core only
// Author:  Jerry D. Harthcock
// Version:  1.21  August 27, 2015
// November 24, 2014
// Copyright (C) 2014.  All rights reserved without prejudice.
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

module sched_stack (
        CLK,
        RESET,
        sched_3,
        sched_2,
        sched_1,
        sched_0,
        sched_3q,
        sched_2q,
        sched_1q,
        sched_0q,
        LOCKED,
        RPT_not_z
        );
    
input   CLK,
        RESET,
        sched_3,
        sched_2,
        sched_1,
        sched_0,
        LOCKED,
        RPT_not_z;
        
output  sched_3q,
        sched_2q,
        sched_1q,
        sched_0q;
        

reg [7:0] thread3q,        
          thread2q,
          thread1q;

reg     sched_3q,
        sched_2q,
        sched_1q,
        sched_0q;
        

wire    sched_3,
        sched_2,
        sched_1,
        sched_0;

wire    sched_3q_empty,
        sched_2q_empty,
        sched_1q_empty;

wire    sched_3q_full,
        sched_2q_full,
        sched_1q_full;
        
wire    sched_3_blocked;
        
assign sched_3_blocked = sched_0 | sched_1 | sched_2 | ~sched_1q_empty | ~sched_2q_empty; 

assign  sched_3q_empty = ~|thread3q;
assign  sched_2q_empty = ~|thread2q;
assign  sched_1q_empty = ~|thread1q;

assign  sched_3q_full = &thread3q;
assign  sched_2q_full = &thread2q;
assign  sched_1q_full = &thread1q;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
         thread3q <= 8'b00000000;              
         thread2q <= 8'b00000000;
         thread1q <= 8'b00000000;
         sched_0q <= 1'b0;
         sched_1q <= 1'b0;
         sched_2q <= 1'b0;
         sched_3q <= 1'b0;
    end
    else if (~(LOCKED | RPT_not_z)) begin

        sched_0q <= sched_0; 
    
        if ((sched_1 && sched_0 && ~sched_1q_full))
            thread1q[7:0] <= {1'b1, thread1q[7:1]};       // sched 1 push
        else if (sched_1) sched_1q <= 1'b1;
        else if (~sched_0 && ~sched_1q_empty) begin
            sched_1q <= 1'b1; 
            thread1q[7:0] <= {thread1q[6:0], 1'b0};  // sched 1 pop
        end    
        else sched_1q <= 1'b0;      
          
        if ((sched_2 && (sched_0 | sched_1 | ~sched_1q_empty) && ~sched_2q_full))
            thread2q[7:0] <= {1'b1, thread2q[7:1]};       // sched 2 push
        else if (sched_2) sched_2q <= 1'b1;
        else if (~(sched_0 | sched_1 | ~sched_1q_empty) && ~sched_2q_empty) begin
            sched_2q <= 1'b1; 
            thread2q[7:0] <= {thread2q[6:0], 1'b0};  // sched 2 pop
        end
        else sched_2q <= 1'b0; 

        if ((sched_3 && sched_3_blocked && ~sched_3q_full))
            thread3q[7:0] <= {1'b1, thread3q[7:1]};       // sched 3 push
        else if (sched_3) sched_3q <= 1'b1;
        else if (~sched_3_blocked && ~sched_3q_empty) begin
            sched_3q <= 1'b1; 
            thread3q[7:0] <= {thread3q[6:0], 1'b0};  // sched 3 pop
        end      
        else sched_3q <= 1'b0;       
    end
end                                                                    
endmodule