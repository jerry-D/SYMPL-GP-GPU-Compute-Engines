 `timescale 1ns/100ps
// Author:  Jerry D. Harthcock
// Version:  2.08  January 18, 2016
// Copyright (C) 2014-2016.  All rights reserved.
//
// latency for FMUL is 3 clocks
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

module func_mul_CPU (
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

    CPU_invalid,  
    CPU_overflow, 
    CPU_underflow,
    CPU_inexact  
    );

input RESET, CLK, wren, rdenA, rdenB;
input [11:0] pc_q2_del;
input [22:0] qNaN_del;
input [3:0] opcode_q1;
input [3:0] wraddrs, rdaddrsA, rdaddrsB;   
input [31:0] wrdataA, wrdataB;

input [1:0] round_mode;

output [35:0] rddataA, rddataB;
output ready;

output CPU_invalid;  
output CPU_overflow; 
output CPU_underflow;
output CPU_inexact;  

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
reg [6:0] delay0, delay1;   // 
reg [15:0] semaphor;  // one for each memory location
reg readyA;
reg readyB;

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
wire [3:0] wraddrsq;                 //{thread, wraddrs}


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

wire CPU_invalid;
wire CPU_overflow;
wire CPU_underflow;
wire CPU_inexact;

wire invalid_del;
wire [3:0] raw_excptns;

wire roundit;
wire bothInf;
wire bothInf_del;
wire result_subnormal;

assign result_subnormal = (nR_FP[31:24]==8'h00) & |nR_FP[22:0];

assign bothInf = A_is_infinite & B_is_infinite;


// all "invalid" exceptions occur on the front-end 
// (ie, during operand-write cycle into the operator input register)
assign invalid = ((A_is_NaN  & ~nA[22])        |   
                  (B_is_NaN  & ~nB[22])        |
                  (A_is_zero & B_is_infinite)  |
                  (B_is_zero & A_is_infinite)) &
                   wren ;

// all other exceptions occur on the back-end 
// (ie, operand-read cycle when results are read out of result buffer where 
// the back-end exceptions are encoded and stored)

assign overflow = nR_FP[34] & ~nR_FP[33] & ~bothInf_del & ~invalid_del;
assign underflow = rounded & result_subnormal & ~invalid_del; 
assign inexact =  rounded & ~invalid_del;

assign CPU_invalid   = invalid;
assign CPU_overflow  = overflow;
assign CPU_underflow = underflow;
assign CPU_inexact   = inexact;

assign raw_excptns = {inexact, underflow, overflow, 1'b0}; //raw exceptions are not yet encloded

//assign NaN_payload = {wraddrsq[5:0], mult_oob, 1'b0, pc_q2_del};  // the 1'b0 is reserved for future elongated 13-bit PC vs current 12-bit PC
assign NaN_payload = {2'b00, wraddrsq[3:0], mult_oob, 1'b0, pc_q2_del};  // the 1'b0 is reserved for future elongated 13-bit PC vs current 12-bit PC
                                                             // the two msb's of wraddrsq is thread number that initiated the invalid operation

//                vv--encoded exception is null for "invalid" because these two bits are for back-end use only                                                             
assign qNaN = {2'b00, 1'b0, 8'hFF, 1'b1, NaN_payload[21:0]}; // quiet NaN with payload
//                       ^--sign      ^-- quiet

assign ready = readyA & readyB;

assign bothInf_del = delay1[6];
assign invalid_del = delay1[5];
assign wrenq = delay1[4];
assign wraddrsq = delay1[3:0];             

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

    Mul_Clk mul_clk0(
      .X (nA_FPq),
      .Y (nB_FPq),
      .R (nR_FP),

      .clk (CLK),
      .round   (round  ),
      .roundit (roundit),
      .sign    (sign   )
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
            zero : nRq = nR[31] ? 32'hFF7F_FFFF : 32'h7F7F_FFFF;
    endcase
end    

//RAM64x34tp ram64(
RAM_func #(.ADDRS_WIDTH(4), .DATA_WIDTH(36))
    ram64_mulclk(
    .CLK        (CLK     ),
    .wren       (wrenq   ),
    .wraddrs    (wraddrsq),   
//                                                   v--if invalid, insert quiet NaN with payload                                                              v--else write result with IEEE exception code, if any
    .wrdata     (invalid_del ? {invalid_del, 1'b0, qNaN} : (qNaN_del[22] ? {2'b00, 2'b00, 1'b0, 8'hFF, 1'b1, qNaN_del[21:0]} : {1'b0, backend_exception[1:0], nRq})),
//                                                                                                                 ^--else if input was quiet NaN, then propogate and insert original payload            
    .rdenA      (rdenA   ),   
    .rdaddrsA   (rdaddrsA),
    .rddataA    (rddataA ),
    .rdenB      (rdenB   ),
    .rdaddrsB   (rdaddrsB),
    .rddataB    (rddataB ));

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
        nB = wrdataB;
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
    if (RESET) semaphor <= 16'hFFFF;
    else begin
        if (wren) semaphor[wraddrs] <= 1'b0;
        if (wrenq) semaphor[wraddrsq] <= 1'b1;
    end
end     
  
always@(posedge CLK or posedge RESET) begin
    if (RESET) begin
        delay0 <= 7'h000;
        delay1 <= 7'h000;
    end    
    else begin
        delay0 <= {bothInf, invalid, wren, wraddrs};
        delay1 <= delay0;    
    end  
end

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        readyA <= 1'b0;
        readyB <= 1'b0;
    end  
    else begin
         readyA <= rdenA ? semaphor[rdaddrsA] : (rdenB & semaphor[rdaddrsB]);
         readyB <= rdenB ? semaphor[rdaddrsB] : (rdenA & semaphor[rdaddrsA]);
    end   
end

endmodule
