 `timescale 1ns/100ps

// wrapper for FP ADD/SUB
// For use in SYMPL FP32X-AXI4 multi-thread RISC core only
// Author:  Jerry D. Harthcock
// Version:  2.05 Sept 28, 2015
// August 15, 2015
// Copyright (C) 2014-2015.  All rights reserved without prejudice.
// latency for FADD is 4 clocks
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

module func_add (
    RESET,
    CLK,
    pc_q2_del,
    qNaN_del,
    opcode_q1,
    wren,
    wraddrs,
    wrdataA,
    wrdataB,
    rdenA,
    rdaddrsA,
    rddataA,
    rdenB,
    rdaddrsB,
    rddataB,
    ready,
    
    round_mode,

    tr3_invalid,  
    tr3_overflow, 
    tr3_underflow,
    tr3_inexact,  

    tr2_invalid,  
    tr2_overflow, 
    tr2_underflow,
    tr2_inexact,  

    tr1_invalid,  
    tr1_overflow, 
    tr1_underflow,
    tr1_inexact,  

    tr0_invalid,  
    tr0_overflow, 
    tr0_underflow,
    tr0_inexact  
    );

input RESET, CLK, wren, rdenA, rdenB;
input [11:0] pc_q2_del;
input [22:0] qNaN_del;
input [3:0] opcode_q1;
input [6:0] wraddrs, rdaddrsA, rdaddrsB;
input [31:0] wrdataA, wrdataB;

input [1:0] round_mode;

output [35:0] rddataA, rddataB;
output ready;

output tr3_invalid;  
output tr3_overflow; 
output tr3_underflow;
output tr3_inexact;  

output tr2_invalid;  
output tr2_overflow; 
output tr2_underflow;
output tr2_inexact;  

output tr1_invalid;  
output tr1_overflow; 
output tr1_underflow;
output tr1_inexact;  

output tr0_invalid;  
output tr0_overflow; 
output tr0_underflow;
output tr0_inexact; 
 
parameter BTB_ = 4'b0100;

// invalid operation codes
parameter sig_NaN      = 3'b000;  // singnaling NaN is an operand
parameter mult_oob     = 3'b001;  // multiply operands out of bounds, multiplication(0, INF) or multiplication(?INF, 0)
parameter fsd_mult_oob = 3'b010;  // fused multiply operands out of bounds
parameter add_oob      = 3'b011;  // add or subract or fusedmultadd operands out of bounds
parameter div_oob      = 3'b100;  // division operands out of bounds, division(0, 0) or division(?INF, INF) 
parameter rem_oob      = 3'b101;  // remainder operands out of bounds, remainder(x, y), when y is zero or x is infinite (and neither is NaN)
parameter sqrt_oob     = 3'b110;  // square-root operand out of bounds, operand is less than zero
parameter quantize     = 3'b111;  // conversion result does not fit in dest, or a converted finite yields (or would yield) infinite result

// encoded backend exception codes (prioritized)
parameter _no_excpt_   = 3'b000; // no back-end exception
parameter _div_by_0_   = 3'b001; // divide by zero
parameter _overflow_   = 3'b010; // operation resulted in overflow (inexact is implied)
parameter _underflow_  = 3'b011; // operation resulted in underflow (inexact is implied)
parameter _inexact_    = 3'b100; // inexact result due to rounding

reg [31:0] nA, nB;
reg [9:0] delay0, delay1, delay2, delay3;
reg [127:0] semaphor;  // one for each memory location  (2 x 16 x 4)  16 for add and 16 for sub x 4 (threads)
reg readyA;
reg readyB;
reg [6:0] rdaddrsA_q1;
reg [6:0] rdaddrsB_q1;
reg rdenA_q1;
reg rdenB_q1;

reg [34:0] nA_FPq;
reg [34:0] nB_FPq;

reg [2:0] backend_exception;

reg rounded;

wire ready;

wire [35:0] rddataA, rddataB;
wire [34:0] nA_FP, nB_FP;
wire [34:0] nR_FP;
wire [31:0] nR;
wire wrenq;
wire [6:0] wraddrsq;
wire [1:0] thread_q2;

wire A_is_infinite; 
wire A_is_finite;   
wire A_is_NaN;      
wire A_is_zero;     
wire A_is_subnormal;

wire B_is_infinite; 
wire B_is_finite;   
wire B_is_NaN;      
wire B_is_zero;     
wire B_is_subnormal;

wire [21:0] NaN_payload;
wire [33:0] qNaN;

wire invalid;
wire overflow;
wire underflow;
wire inexact;

wire tr3_invalid;
wire tr3_overflow;
wire tr3_underflow;
wire tr3_inexact;

wire tr2_invalid;
wire tr2_overflow;
wire tr2_underflow;
wire tr2_inexact;

wire tr1_invalid;
wire tr1_overflow;
wire tr1_underflow;
wire tr1_inexact;

wire tr0_invalid;
wire tr0_overflow;
wire tr0_underflow;
wire tr0_inexact;

wire invalid_del;
wire [3:0] raw_excptns;
wire [1:0] thread_del;

wire roundit;
wire AorB_is_Inf;
wire AorB_is_Inf_del;
wire subtractInf;
wire result_subnormal;

assign result_subnormal = (nR_FP[31:24]==8'h00) & |nR_FP[22:0];
assign subtractInf = (A_is_infinite & B_is_infinite) & (nA[31] ^ nB[31]);
assign AorB_is_Inf = (A_is_infinite | B_is_infinite) & ~subtractInf;

assign thread_q2 = wraddrs[6:5];

// all "invalid" exceptions occur on the front-end 
// (ie, during operand-write cycle into the operator input register)
assign invalid = ((A_is_NaN  & ~nA[22]) |   
                  (B_is_NaN  & ~nB[22]) |
                   subtractInf) &            //magnitude subtraction
                   wren;
// all other exceptions occur on the back-end 
// (ie, operand-read cycle when results are read out of result buffer where 
// the back-end exceptions are encoded and stored)
                  

assign overflow = nR_FP[34] & ~nR_FP[33] & ~AorB_is_Inf_del & ~invalid_del;
assign underflow = rounded & result_subnormal & ~invalid_del; 
assign inexact = rounded & ~invalid_del;

assign tr3_invalid   = invalid & (thread_q2==2'b11);
assign tr3_overflow  = overflow & (thread_del==2'b11);
assign tr3_underflow = underflow & (thread_del==2'b11);
assign tr3_inexact   = inexact & (thread_del==2'b11);

assign tr2_invalid   = invalid & (thread_q2==2'b10);
assign tr2_overflow  = overflow & (thread_del==2'b10);
assign tr2_underflow = underflow & (thread_del==2'b10);
assign tr2_inexact   = inexact & (thread_del==2'b10);

assign tr1_invalid   = invalid & (thread_q2==2'b01);
assign tr1_overflow  = overflow & (thread_del==2'b01);
assign tr1_underflow = underflow & (thread_del==2'b01);
assign tr1_inexact   = inexact & (thread_del==2'b01);

assign tr0_invalid   = invalid & (thread_q2==2'b00);
assign tr0_overflow  = overflow & (thread_del==2'b00);
assign tr0_underflow = underflow & (thread_del==2'b00);
assign tr0_inexact   = inexact & (thread_del==2'b00);

assign raw_excptns = {inexact, underflow, overflow, 1'b0}; //raw exceptions are not yet encloded

assign NaN_payload = {wraddrsq[5:0], add_oob, 1'b0, pc_q2_del};  // the 1'b0 is reserved for future elongated 13-bit PC vs current 12-bit PC
                                                             // the two msb's of wraddrsq is thread number that initiated the invalid operation

//                vv--encoded exception is null for "invalid" because these two bits are for back-end use only                                                             
assign qNaN = {2'b00, 1'b0, 8'hFF, 1'b1, NaN_payload[21:0]}; // quiet NaN with payload
//                       ^--sign      ^-- quiet

assign ready = readyA & readyB;

assign AorB_is_Inf_del = delay3[9];
assign invalid_del = delay3[8];
assign wrenq = delay3[7];
assign wraddrsq = delay3[6:0];             
assign thread_del = delay3[6:5];

    IEEE754_To_FP9_filtered ieeetofpA(
      .X (nA),
      .wren (wren),
      .R (nA_FP),
      .input_is_infinite (A_is_infinite ),
      .input_is_finite   (A_is_finite   ),
      .input_is_NaN      (A_is_NaN      ),
      .input_is_zero     (A_is_zero     ),
      .input_is_subnormal(A_is_subnormal)
      );

    IEEE754_To_FP9_filtered  ieeetofpB(
      .X (nB),
      .wren (wren),
      .R (nB_FP),
      .input_is_infinite (B_is_infinite ),
      .input_is_finite   (B_is_finite   ),
      .input_is_NaN      (B_is_NaN      ),
      .input_is_zero     (B_is_zero     ),
      .input_is_subnormal(B_is_subnormal)
      );

    Add_Clk  add_clk0(
      .X (nA_FPq),
      .Y (nB_FPq),
      .R (nR_FP),
      .clk (CLK),
      .signR_d2 (sign   ),
      .rnd      (round  ),
      .roundit  (roundit)      
      );
      
    round_sel rnd_sel(
      .round_mode (round_mode),
      .round      (round     ),
      .roundit    (roundit   ),
      .sign       (sign      )
    );        
      
    FP9_To_IEEE754 fptoieeeA(
      .X (nR_FP),
      .R (nR)
      );

parameter nearest  = 2'b00;
parameter positive = 2'b01;
parameter negative = 2'b10;
parameter zero     = 2'b11;
reg [31:0] nRq;
reg [1:0] round_modeq;

always @(posedge CLK or posedge RESET) begin
    if (RESET) round_modeq <= 2'b00;
    else round_modeq <= round_mode;
end 

always @(*) begin
    if (~overflow) nRq = nR;
    else 
    case(round_modeq)
         nearest : nRq = nR[31] ? 32'hFF80_0000 : 32'h7F80_0000;
        positive : nRq = nR[31] ? 32'hFF7F_FFFF : 32'h7F80_0000; 
        negative : nRq = nR[31] ? 32'hFF80_0000 : 32'h7F7F_FFFF;    
            zero : nRq = nR[31] ? 31'hFF7F_FFFF : 32'h7F7F_FFFF;
    endcase
end                 

RAM_tp #(.ADDRS_WIDTH(7), .DATA_WIDTH(36))
    ram128_addclk(
    .CLK        (CLK      ),
    .wren       (wrenq    ),
    .wraddrs    (wraddrsq ),
//                                                  v--if invalid, insert quiet NaN with payload                                                                   v--else write result with IEEE exception code, if any
    .wrdata     (invalid_del ? {invalid_del, 1'b0, qNaN} : (qNaN_del[22] ? {2'b00, 2'b00, 1'b0, 8'hFF, 1'b1, qNaN_del[21:0]} : {1'b0, backend_exception[2:0], nRq})),
//                                                                                                                     ^--else if input was quiet NaN, then propogate and insert original payload            
    .rdenA      (rdenA    ),
    .rdaddrsA   (rdaddrsA ),
    .rddataA    (rddataA  ),
    .rdenB      (rdenB    ),
    .rdaddrsB   (rdaddrsB ),
    .rddataB    (rddataB  )
    );
     
// this is where raw exceptins are encoded    
always @(*) begin
    if (~invalid_del)
        casex (raw_excptns) 
            4'bxxx1 : backend_exception = _div_by_0_;
            4'bxx1x : backend_exception = _overflow_;
            4'bx1xx : backend_exception = _underflow_;
            4'b1xxx : backend_exception = _inexact_;
            default : backend_exception = _no_excpt_;  
        endcase
    else backend_exception = _no_excpt_; 
end                
    
always @(*) begin
    if (wren) begin
        nA = wrdataA;
        nB = {(wrdataB[31] ^ wraddrs[4]), wrdataB[30:0]};     //if wraddrs[4] = 1 then subtract
    end
    else begin
        nA = 32'h0000_0000;    
        nB = 32'h0000_0000; 
    end
end           

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        nA_FPq <= 35'h0_0000_0000;
        nB_FPq <= 35'h0_0000_0000;
        rounded <= 1'b0;
    end
    else begin    
        nA_FPq <= nA_FP;
        nB_FPq <= nB_FP;
        rounded <= roundit;
    end
end    

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        semaphor <= 128'h0000_0000_0000_0000_0000_0000_0000_0000;
        rdenA_q1 <= 1'b0;
        rdenB_q1 <= 1'b0;
        rdaddrsA_q1 <= 7'h00;
        rdaddrsB_q1 <= 7'h00;
    end    
    else begin
        rdenA_q1 <= rdenA;
        rdenB_q1 <= rdenB;
        rdaddrsA_q1 <= rdaddrsA;
        rdaddrsB_q1 <= rdaddrsB;
        
        if (rdenA_q1 && rdenB_q1 && (rdaddrsA_q1==rdaddrsB_q1) && ~(opcode_q1==BTB_) && semaphor[rdaddrsA_q1]) semaphor[rdaddrsA_q1] <= 1'b0;
        else begin
            if (rdenA_q1 && ~(opcode_q1==BTB_) && semaphor[rdaddrsA_q1]) semaphor[rdaddrsA_q1] <= 1'b0;
            if (wrenq && ~(rdenA_q1 & (wraddrsq == rdaddrsA_q1))) semaphor[wraddrsq] <= 1'b1;
            if (rdenB_q1 && ~(opcode_q1==BTB_) && semaphor[rdaddrsB_q1]) semaphor[rdaddrsB_q1] <= 1'b0;
            if (wrenq && ~(rdenB_q1 & (wraddrsq == rdaddrsB_q1))) semaphor[wraddrsq] <= 1'b1;
        end
    end    
end            

always@(posedge CLK or posedge RESET) begin
    if (RESET) begin
        delay0 <= 10'h000;
        delay1 <= 10'h000;
        delay2 <= 10'h000;
        delay3 <= 10'h000;
//        delay4 <= 9'h00;
//        delay5 <= 9'h00;
    end    
    else begin
        delay0 <= {AorB_is_Inf, invalid, wren, wraddrs};
        delay1 <= delay0;    
        delay2 <= delay1;
        delay3 <= delay2;    
//        delay4 <= delay3;
//        delay5 <= delay4;
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