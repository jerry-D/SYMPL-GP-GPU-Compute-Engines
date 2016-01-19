 `timescale 1ns/100ps
// Author:  Jerry D. Harthcock
// Version:  2.05  January 18, 2016
// Copyright (C) 2014-2016.  All rights reserved.
//
// latency for ITOF is 2 clocks
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

module func_itof_CPU (
    RESET,
    CLK,
    opcode_q1,
    wren,
    wraddrs,
    wrdata,
    rdenA,
    rdaddrsA,
    rddataA,
    rdenB,
    rdaddrsB,
    rddataB,
    ready);

input RESET, CLK, wren, rdenA, rdenB;
input [3:0] opcode_q1;
input [2:0] wraddrs, rdaddrsA, rdaddrsB;
input [31:0] wrdata;
output [35:0] rddataA, rddataB;
output ready;

parameter BTB_ = 4'b0100;

reg [3:0] delay0, delay1;
reg [7:0] semaphor;  // one for each memory location
reg readyA;
reg readyB;
reg nA_sel;

reg [31:0] nAq;

wire ready;

wire [31:0] nA;
wire [35:0] rddataA, rddataB; 
wire [33:0] nRA_FP, nRB_FP;
wire wrenq;
wire [2:0] wraddrsq;

wire [33:0] nR;

assign ready = readyA & readyB;
assign wrenq = delay1[3];
assign wraddrsq = delay1[2:0]; 
assign nA = wrdata;

FXP_To_FP itof_0(
    .clk(CLK),
    .I (nAq),
    .O (nR));
   
FP_To_IEEE754 fptoieeeA(
    .X (nRA_FP),
    .R (rddataA[31:0]));
       
 FP_To_IEEE754 fptoieeeB(
    .X (nRB_FP),
    .R (rddataB[31:0])); 
 
assign rddataA[35:32] = 4'b0000;  
assign rddataB[35:32] = 4'b0000;                     

/*
    assign nR = 36'h0_0000_0000; 
    assign rddataA = nRA_FP;
    assign rddataB = nRB_FP;                             
*/

//RAM_func #(.ADDRS_WIDTH(5), .DATA_WIDTH(34))
RAM_func #(.ADDRS_WIDTH(3), .DATA_WIDTH(34))
    ram32_itof(
    .CLK        (CLK      ),
    .wren       (wrenq    ),
    .wraddrs    (wraddrsq ),
    .wrdata     ({ nR}),
    .rdenA      (rdenA    ),
    .rdaddrsA   (rdaddrsA ),
    .rddataA    (nRA_FP   ),
    .rdenB      (rdenB    ),
    .rdaddrsB   (rdaddrsB ),
    .rddataB    (nRB_FP   ));

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        nAq <= 32'h0000_0000;
    end
    else begin
        if (wren) nAq <= nA;
        else nAq <= 32'h0000_0000;
    end    
end         

always @(posedge CLK or posedge RESET) begin
    if (RESET) semaphor <= 8'hFF;
    else begin
        if (wren) semaphor[wraddrs] <= 1'b0;
        if (wrenq) semaphor[wraddrsq] <= 1'b1;
    end
end
always@(posedge CLK or posedge RESET) begin
    if (RESET) begin
        delay0  <= 4'h0;
        delay1  <= 4'h0;
    end    
    else begin
        delay0  <= {wren, wraddrs};
        delay1  <= delay0;    
    end 
end        

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        readyA <= 1'b0;
        readyB <= 1'b0;
    end  
    else begin
        if (rdenA) readyA <= (wrenq & (rdaddrsA == wraddrsq)) ? 1'b1 : semaphor[rdaddrsA];
        else readyA <= rdenB;         
        if (rdenB) readyB <= (wrenq & (rdaddrsB == wraddrsq)) ? 1'b1 : semaphor[rdaddrsB];
        else readyB <=rdenA;
    end   
end

endmodule