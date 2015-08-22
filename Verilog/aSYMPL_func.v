 `timescale 1ns/100ps
// aSYMPL Floating-Point Math Block 
// Version 2.00 August 15, 2015.
// Copyright (C) 2014-2015 by Jerry D. Harthcock.  All rights reserved without prejudice.
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
 
module aSYMPL_func ( 
    RESET,
    CLK,
    thread,
    thread_q2,
    opcode_q1,
    constn_q1,
    OPsrcA_q1,
    OPsrcB_q1,
    wren,
    wraddrs,
    rdSrcAdata,
    rdSrcBdata,
    rdenA,
    rdaddrsA,
    rddataA,
    rdenB,
    rdaddrsB,
    rddataB,
    fp_flags,
    ready
    );

input RESET, CLK, wren, rdenA, rdenB;
input [6:0] wraddrs, rdaddrsA, rdaddrsB;
input [1:0] thread, thread_q2;
input [3:0] opcode_q1;
input [1:0] constn_q1;
input [7:0] OPsrcA_q1;
input [7:0] OPsrcB_q1;

input [31:0] rdSrcAdata, rdSrcBdata;
output [31:0]rddataA, rddataB;
output [1:0] fp_flags;
output ready;

parameter MOV_ = 4'b0000;
parameter BTB_ = 4'b0100;

reg [33:0] rddataA_out, rddataB_out;
reg [6:3] srcA_q1, srcB_q1;
reg rdenA_q1, rdenB_q1;

reg [31:0] fwrsrcAdata;
reg [31:0] fwrsrcBdata;

reg readyA;
reg readyB;

reg wren_mul,
    wren_add,
    wren_div,
    wren_sqrt,
    wren_log,
    wren_exp,
    wren_itof,
    wren_ftoi;
    
reg rdenA_mul,
    rdenA_add,
    rdenA_div,
    rdenA_sqrt,
    rdenA_log,
    rdenA_exp,
    rdenA_itof,
    rdenA_ftoi;
    
reg rdenB_mul,
    rdenB_add,
    rdenB_div,
    rdenB_sqrt,
    rdenB_log,
    rdenB_exp,
    rdenB_itof,
    rdenB_ftoi;    

wire ready_mul,
     ready_add,
     ready_div,
     ready_sqrt,
     ready_log,
     ready_exp,
     ready_itof,
     ready_ftoi;

wire [31:0] semaphor_q1;

wire [1:0] fp_flags; 

wire ready;    

wire [3:0] wrfunc_sel;
wire [3:0] rdAfunc_sel;
wire [3:0] rdBfunc_sel;
wire [3:0] srcA_q1_sel;
wire [3:0] srcB_q1_sel;

wire [31:0] rddataA, rddataB, rddataA_cnv, rddataB_cnv;

wire [33:0] wrdataA_FP, wrdataB_FP;

wire [33:0] rddataB_FP_mul;
wire [33:0] rddataB_FP_add;
wire [33:0] rddataB_FP_div;
wire [33:0] rddataB_FP_sqrt;
wire [33:0] rddataB_FP_log;
wire [33:0] rddataB_FP_exp;
wire [33:0] rddataB_FP_itof;
wire [33:0] rddataB_INT_ftoi;

wire [33:0] rddataA_FP_mul;
wire [33:0] rddataA_FP_add;
wire [33:0] rddataA_FP_div;
wire [33:0] rddataA_FP_sqrt;
wire [33:0] rddataA_FP_log;
wire [33:0] rddataA_FP_exp;
wire [33:0] rddataA_FP_itof;
wire [33:0] rddataA_INT_ftoi;

assign wrfunc_sel = wraddrs[6:3];
assign rdAfunc_sel = rdaddrsA[6:3];
assign rdBfunc_sel = rdaddrsB[6:3];
assign srcA_q1_sel = srcA_q1[6:3];
assign srcB_q1_sel = srcB_q1[6:3];

assign rddataA = rddataA_out[31:0];
assign rddataB = (opcode_q1==BTB_) ? semaphor_q1 : rddataB_out[31:0];

assign semaphor_q1 = {24'b00_0000, 
                      ready_mul,
                      ready_add,
                      ready_div,
                      ready_sqrt,
                      ready_log,
                      ready_exp,
                      ready_itof,
                      ready_ftoi};
                      
assign fp_flags = rddataA_out[33:32];
assign ready = readyA & readyB;                      
  
func_ftoi ftoi(
    .RESET    (RESET     ),
    .CLK      (CLK       ),
    .opcode_q1(opcode_q1 ),
    .wren     (wren_ftoi ),
    .wraddrs  ({thread_q2, wraddrs[2:0]}),
    .wrdata   (fwrsrcAdata),
    .rdenA    (rdenA_ftoi),
    .rdaddrsA ({thread, rdaddrsA[2:0]}),
    .rddataA  (rddataA_INT_ftoi),
    .rdenB    (rdenB_ftoi ),
    .rdaddrsB ({thread, rdaddrsB[2:0]}),
    .rddataB  (rddataB_INT_ftoi),
    .ready    (ready_ftoi));  
  
func_itof itof(
    .RESET    (RESET     ),
    .CLK      (CLK       ),
    .opcode_q1(opcode_q1 ),
    .wren     (wren_itof ),
    .wraddrs  ({thread_q2, wraddrs[2:0]}),
    .wrdata   (fwrsrcAdata),
    .rdenA    (rdenA_itof),
    .rdaddrsA ({thread, rdaddrsA[2:0]}),
    .rddataA  (rddataA_FP_itof),
    .rdenB    (rdenB_itof ),
    .rdaddrsB ({thread, rdaddrsB[2:0]}),
    .rddataB  (rddataB_FP_itof),
    .ready    (ready_itof));    

func_mul mul(             
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_mul      ),
    .wraddrs  ({thread_q2, wraddrs[3:0]}),
    .wrdataA  (fwrsrcAdata   ),
    .wrdataB  (fwrsrcBdata   ),
    .rdenA    (rdenA_mul     ),
    .rdaddrsA ({thread, rdaddrsA[3:0]}),
    .rddataA  (rddataA_FP_mul),
    .rdenB    (rdenB_mul     ),
    .rdaddrsB (rdaddrsB[5:0] ),
    .rddataB  (rddataB_FP_mul),
    .ready    (ready_mul     ));
    
func_add add(             
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .opcode_q1(opcode_q1 ),
    .wren     (wren_add      ),
    .wraddrs  ({thread_q2, wraddrs[4:0]}),
    .wrdataA  (fwrsrcAdata   ),
    .wrdataB  (fwrsrcBdata   ),
    .rdenA    (rdenA_add     ),
    .rdaddrsA ({thread, rdaddrsA[4:0]}),
    .rddataA  (rddataA_FP_add),
    .rdenB    (rdenB_add     ),
    .rdaddrsB ({thread, rdaddrsB[4:0]}),
    .rddataB  (rddataB_FP_add),
    .ready    (ready_add     ));
    
func_div div(              
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_div      ),
    .wraddrs  ({thread_q2, wraddrs[3:0]}),
    .wrdataA  (fwrsrcAdata   ),
    .wrdataB  (fwrsrcBdata   ),
    .rdenA    (rdenA_div     ),
    .rdaddrsA ({thread, rdaddrsA[3:0]}),
    .rddataA  (rddataA_FP_div),
    .rdenB    (rdenB_div     ),
    .rdaddrsB ({thread, rdaddrsB[3:0]}),
    .rddataB  (rddataB_FP_div),
    .ready    (ready_div     ));
    
func_sqrt sqrt(              
    .RESET    (RESET          ),
    .CLK      (CLK            ),
    .opcode_q1(opcode_q1      ),
    .wren     (wren_sqrt      ),
    .wraddrs  ({thread_q2, wraddrs[3:0]}),
    .wrdataA  (fwrsrcAdata    ),
    .rdenA    (rdenA_sqrt     ),
    .rdaddrsA ({thread, rdaddrsA[3:0]}),
    .rddataA  (rddataA_FP_sqrt),
    .rdenB    (rdenB_sqrt     ),
    .rdaddrsB ({thread, rdaddrsB[3:0]}),
    .rddataB  (rddataB_FP_sqrt),
    .ready    (ready_sqrt     ));

func_log log(              
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_log      ),
    .wraddrs  ({thread_q2, wraddrs[3:0]}),
    .wrdataA  (fwrsrcAdata   ),
    .rdenA    (rdenA_log     ),
    .rdaddrsA ({thread, rdaddrsA[3:0]}),
    .rddataA  (rddataA_FP_log),
    .rdenB    (rdenB_log     ),
    .rdaddrsB ({thread, rdaddrsB[3:0]}),
    .rddataB  (rddataB_FP_log),
    .ready    (ready_log     ));

func_exp exp(              
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_exp      ),
    .wraddrs  ({thread_q2, wraddrs[3:0]}),
    .wrdataA  (fwrsrcAdata   ),
    .rdenA    (rdenA_exp     ),
    .rdaddrsA ({thread, rdaddrsA[3:0]}),
    .rddataA  (rddataA_FP_exp),
    .rdenB    (rdenB_exp     ),
    .rdaddrsB ({thread, rdaddrsB[3:0]}),
    .rddataB  (rddataB_FP_exp),
    .ready    (ready_exp     ));


always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        fwrsrcAdata <= 32'h00000000;
        fwrsrcBdata <= 32'h00000000;
    end
    else if (&constn_q1 && (opcode_q1==MOV_)) begin        // MOV immediate
            fwrsrcAdata <= {16'h0000, OPsrcA_q1, OPsrcB_q1};
            fwrsrcBdata <= rdSrcBdata; 
    end        
    else begin     // any combination of direct or indirect
        fwrsrcAdata <= rdSrcAdata;             
        fwrsrcBdata <= rdSrcBdata; 
    end
end    
    
    
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        rdenA_q1 <= 1'b0;
        rdenB_q1 <= 1'b0;
        srcA_q1 <= 4'b0000;
        srcB_q1 <= 4'b0000;
    end
    else begin
        rdenA_q1 <= rdenA;
        rdenB_q1 <= rdenB;
        srcA_q1 <= rdaddrsA[6:3];
        srcB_q1 <= rdaddrsB[6:3];
    end
end            
   
always @(*) 
    if (rdenA_q1)
        casex (srcA_q1_sel)
            4'b00xx : begin
                        rddataA_out = rddataA_FP_add[33:0];
                        readyA = ready_add;
                      end   
            4'b010x : begin
                        rddataA_out = rddataA_FP_mul[33:0];
                        readyA = ready_mul;
                      end  
            4'b0110 : begin
                        rddataA_out = rddataA_FP_itof[33:0]; 
                        readyA = ready_itof;
                      end  
            4'b0111 : begin
                        rddataA_out = rddataA_INT_ftoi[33:0]; 
                        readyA = ready_ftoi;
                      end  
            4'b100x : begin
                        rddataA_out = rddataA_FP_div[33:0]; 
                        readyA = ready_div;
                      end  
            4'b101x : begin
                        rddataA_out = rddataA_FP_sqrt[33:0];
                        readyA = ready_sqrt;
                      end  
            4'b110x : begin
                        rddataA_out = rddataA_FP_log[33:0]; 
                        readyA = ready_log;
                      end  
            4'b111x : begin
                        rddataA_out = rddataA_FP_exp[33:0]; 
                        readyA = ready_exp;
                      end  
        endcase 
        else begin
                rddataA_out = 34'h0_0000_0000;
                readyA = rdenB_q1;
        end
                      
always @(*) 
    if (rdenB_q1)
        casex (srcB_q1_sel)
            4'b00xx : begin
                        rddataB_out = rddataB_FP_add[33:0];
                        readyB = ready_add;
                      end   
            4'b010x : begin
                        rddataB_out = rddataB_FP_mul[33:0];
                        readyB = ready_mul;
                      end  
            4'b0110 : begin
                        rddataB_out = rddataB_FP_itof[33:0]; 
                        readyB = ready_itof;
                      end  
            4'b0111 : begin
                        rddataB_out = rddataB_INT_ftoi[33:0]; 
                        readyB = ready_ftoi;
                      end  
            4'b100x : begin
                        rddataB_out = rddataB_FP_div[33:0]; 
                        readyB = ready_div;
                      end  
            4'b101x : begin
                        rddataB_out = rddataB_FP_sqrt[33:0];
                        readyB = ready_sqrt;
                      end  
            4'b110x : begin
                        rddataB_out = rddataB_FP_log[33:0]; 
                        readyB = ready_log;
                      end  
            4'b111x : begin
                        rddataB_out = rddataB_FP_exp[33:0]; 
                        readyB = ready_exp;
                      end  
        endcase 
    else begin
            rddataB_out = 34'h0_0000_0000;
            readyB = rdenA_q1;
    end

always @(*) begin
    if ((wrfunc_sel[3:2] == 2'b00) && wren) wren_add = 1'b1;      //00 01 is fadd, 10 11 is fsub
    else wren_add = 1'b0;
    if ((wrfunc_sel[3:1] == 3'b010) && wren) wren_mul = 1'b1;
    else wren_mul = 1'b0;
    if ((wrfunc_sel[3:0] == 4'b0110) && wren) wren_itof = 1'b1;
    else wren_itof = 1'b0;
    if ((wrfunc_sel[3:0] == 4'b0111) & wren) wren_ftoi = 1'b1;
    else wren_ftoi = 1'b0;
    if ((wrfunc_sel[3:1] == 3'b100) && wren) wren_div = 1'b1;
    else wren_div = 1'b0;
    if ((wrfunc_sel[3:1] == 3'b101) && wren) wren_sqrt = 1'b1;
    else wren_sqrt = 1'b0;
    if ((wrfunc_sel[3:1] == 3'b110) && wren) wren_log = 1'b1;
    else wren_log = 1'b0;
    if ((wrfunc_sel[3:1] == 3'b111) && wren) wren_exp = 1'b1;
    else wren_exp = 1'b0;
end    


always @(*) begin
    if ((rdAfunc_sel[3:2] == 2'b00) && rdenA) rdenA_add = 1'b1;
    else rdenA_add = 1'b0;
    if ((rdAfunc_sel[3:1] == 3'b010) && rdenA) rdenA_mul = 1'b1;
    else rdenA_mul = 1'b0;
    if ((rdAfunc_sel[3:0] == 4'b0110) && rdenA) rdenA_itof = 1'b1;
    else rdenA_itof = 1'b0;
    if ((rdAfunc_sel[3:0] == 4'b0111) && rdenA) rdenA_ftoi = 1'b1;
    else rdenA_ftoi = 1'b0;
    if ((rdAfunc_sel[3:1] == 3'b100) && rdenA) rdenA_div = 1'b1;
    else rdenA_div = 1'b0;
    if ((rdAfunc_sel[3:1] == 3'b101) && rdenA) rdenA_sqrt = 1'b1;
    else rdenA_sqrt = 1'b0;
    if ((rdAfunc_sel[3:1] == 3'b110) && rdenA) rdenA_log = 1'b1;
    else rdenA_log = 1'b0;
    if ((rdAfunc_sel[3:1] == 3'b111) && rdenA) rdenA_exp = 1'b1;
    else rdenA_exp = 1'b0;
end    

always @(*) begin
    if ((rdBfunc_sel[3:2] == 2'b00) && rdenB) rdenB_add = 1'b1;
    else rdenB_add = 1'b0;
    if ((rdBfunc_sel[3:1] == 3'b010) && rdenB) rdenB_mul = 1'b1;
    else rdenB_mul = 1'b0;
    if ((rdBfunc_sel[3:0] == 4'b0110) && rdenB) rdenB_itof = 1'b1;
    else rdenB_itof = 1'b0;
    if ((rdBfunc_sel[3:0] == 4'b0111) && rdenB) rdenB_ftoi = 1'b1;
    else rdenB_ftoi = 1'b0;
    if ((rdBfunc_sel[3:1] == 3'b100) && rdenB) rdenB_div = 1'b1;
    else rdenB_div = 1'b0;
    if ((rdBfunc_sel[3:1] == 3'b101) && rdenB) rdenB_sqrt = 1'b1;
    else rdenB_sqrt = 1'b0;
    if ((rdBfunc_sel[3:1] == 3'b110) && rdenB) rdenB_log = 1'b1;
    else rdenB_log = 1'b0;
    if ((rdBfunc_sel[3:1] == 3'b111) && rdenB) rdenB_exp = 1'b1;
    else rdenB_exp = 1'b0;
end    

endmodule