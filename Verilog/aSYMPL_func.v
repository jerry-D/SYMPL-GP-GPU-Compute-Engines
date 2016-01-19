 `timescale 1ns/100ps
// Author:  Jerry D. Harthcock
// Version 2.14 January 18, 2016.
// Copyright (C) 2014-2016 by Jerry D. Harthcock.  All rights reserved.
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
 
module aSYMPL_func ( 
    RESET,
    CLK,
    pc_q2,
    thread,
    thread_q1,
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
    tr0_C_reg,
    tr1_C_reg,
    tr2_C_reg,
    tr3_C_reg,
    exc_codeA,
    exc_codeB,
    
    tr3_CREG_wr,
    tr2_CREG_wr,
    tr1_CREG_wr,
    tr0_CREG_wr,
    
    ready,
    
    round_mode_q1,
    
    tr3_invalid,  
    tr3_div_by_0, 
    tr3_overflow, 
    tr3_underflow,
    tr3_inexact,  

    tr2_invalid,  
    tr2_div_by_0, 
    tr2_overflow, 
    tr2_underflow,
    tr2_inexact,  

    tr1_invalid,  
    tr1_div_by_0, 
    tr1_overflow, 
    tr1_underflow,
    tr1_inexact,  

    tr0_invalid,  
    tr0_div_by_0, 
    tr0_overflow, 
    tr0_underflow,
    tr0_inexact
    );

input RESET, CLK, wren, rdenA, rdenB;
input [11:0] pc_q2;
input [6:0] wraddrs;
input [7:0] rdaddrsA, rdaddrsB;
input [1:0] thread, thread_q1, thread_q2;
input [3:0] opcode_q1;
input [1:0] constn_q1;
input [7:0] OPsrcA_q1;
input [7:0] OPsrcB_q1;

input [31:0] rdSrcAdata, rdSrcBdata;
input [31:0] tr0_C_reg, tr1_C_reg, tr2_C_reg, tr3_C_reg;
input [1:0] round_mode_q1;

output [31:0]rddataA, rddataB;
output [3:0] exc_codeA;
output [3:0] exc_codeB;

input tr3_CREG_wr;
input tr2_CREG_wr;
input tr1_CREG_wr;
input tr0_CREG_wr;

output ready;

output tr3_invalid;  
output tr3_div_by_0; 
output tr3_overflow; 
output tr3_underflow;
output tr3_inexact;  

output tr2_invalid;  
output tr2_div_by_0; 
output tr2_overflow; 
output tr2_underflow;
output tr2_inexact;  

output tr1_invalid;  
output tr1_div_by_0; 
output tr1_overflow; 
output tr1_underflow;
output tr1_inexact;  

output tr0_invalid;  
output tr0_div_by_0; 
output tr0_overflow; 
output tr0_underflow;
output tr0_inexact;  

parameter MOV_ = 4'b0000;
parameter BTB_ = 4'b0100;

reg [35:0] rddataA_out, rddataB_out;
reg [7:0] srcA_q1, srcB_q1;
reg rdenA_q1, rdenB_q1;
reg [31:0] C_reg;
reg [31:0] fwrsrcAdata;
reg [31:0] fwrsrcBdata;

reg readyA;
reg readyB;

reg [1:0] round_mode_q2;

reg [1:0] round_mode_q2_del_0,
          round_mode_q2_del_1,
          round_mode_q2_del_2,
          round_mode_q2_del_3,
          round_mode_q2_del_4,
          round_mode_q2_del_5,
          round_mode_q2_del_6,
          round_mode_q2_del_7,
          round_mode_q2_del_8,
          round_mode_q2_del_9,
          round_mode_q2_del_10,
          round_mode_q2_del_11;

reg [11:0] pc_q2_del_0, 
           pc_q2_del_1, 
           pc_q2_del_2, 
           pc_q2_del_3, 
           pc_q2_del_4, 
           pc_q2_del_5, 
           pc_q2_del_6, 
           pc_q2_del_7, 
           pc_q2_del_8, 
           pc_q2_del_9, 
           pc_q2_del_10,
           pc_q2_del_11, 
           pc_q2_del_12; 
           
reg [22:0] propgat_NaN_del_0,    //msb = 1 signals NaN is propagating; lower bits are payload
           propgat_NaN_del_1,
           propgat_NaN_del_2,
           propgat_NaN_del_3,
           propgat_NaN_del_4,
           propgat_NaN_del_5,
           propgat_NaN_del_6,
           propgat_NaN_del_7,
           propgat_NaN_del_8,
           propgat_NaN_del_9,
           propgat_NaN_del_10,
           propgat_NaN_del_11,
           propgat_NaN_del_12;


reg wren_mul,
    wren_add,
    wren_div,
    wren_sqrt,
    wren_fma,
    wren_log,
    wren_exp,
    wren_itof,
    wren_ftoi;
    
reg rdenA_mul,
    rdenA_add,
    rdenA_div,
    rdenA_sqrt,
    rdenA_fma,
    rdenA_log,
    rdenA_exp,
    rdenA_itof,
    rdenA_ftoi;
    
reg rdenB_mul,
    rdenB_add,
    rdenB_div,
    rdenB_sqrt,
    rdenB_fma,
    rdenB_log,
    rdenB_exp,
    rdenB_itof,
    rdenB_ftoi;    

wire ready_mul,
     ready_add,
     ready_div,
     ready_sqrt,
     ready_fma,
     ready_log,
     ready_exp,
     ready_itof,
     ready_ftoi;

wire [31:0] semaphor_q1;

wire [3:0] exc_codeA;
wire [3:0] exc_codeB;

wire ready;    

wire [3:0] wrfunc_sel;
wire [3:0] rdAfunc_sel;
wire [3:0] rdBfunc_sel;
wire [7:0] srcA_q1_sel;
wire [7:0] srcB_q1_sel;

wire [31:0] rddataA, rddataB, rddataA_cnv, rddataB_cnv;

wire [33:0] wrdataA_FP, wrdataB_FP;

wire [35:0] rddataB_FP_mul;
wire [35:0] rddataB_FP_add;
wire [35:0] rddataB_FP_div;
wire [35:0] rddataB_FP_sqrt;
wire [35:0] rddataB_FP_fma;
wire [35:0] rddataB_FP_log;
wire [35:0] rddataB_FP_exp;
wire [35:0] rddataB_FP_itof;
wire [35:0] rddataB_INT_ftoi;

wire [35:0] rddataA_FP_mul;
wire [35:0] rddataA_FP_add;
wire [35:0] rddataA_FP_div;
wire [35:0] rddataA_FP_sqrt;
wire [35:0] rddataA_FP_fma;
wire [35:0] rddataA_FP_log;
wire [35:0] rddataA_FP_exp;
wire [35:0] rddataA_FP_itof;
wire [35:0] rddataA_INT_ftoi;

wire [35:0] tr3_rddataB_FP_dot;
wire [35:0] tr2_rddataB_FP_dot;
wire [35:0] tr1_rddataB_FP_dot;
wire [35:0] tr0_rddataB_FP_dot;

wire ready_dot;     
    
wire A_is_qNaN;  // A is quiet NaN
wire B_is_qNaN;  // B is quiet NaN

wire tr3_invalid;  
wire tr3_div_by_0; 
wire tr3_overflow; 
wire tr3_underflow;
wire tr3_inexact; 

wire tr2_invalid;  
wire tr2_div_by_0; 
wire tr2_overflow; 
wire tr2_underflow;
wire tr2_inexact; 

wire tr1_invalid;  
wire tr1_div_by_0; 
wire tr1_overflow; 
wire tr1_underflow;
wire tr1_inexact; 

wire tr0_invalid;  
wire tr0_div_by_0; 
wire tr0_overflow; 
wire tr0_underflow;
wire tr0_inexact; 

// thread 3 exception signals
wire tr3_invalid_mul;
wire tr3_overflow_mul;
wire tr3_underflow_mul;
wire tr3_inexact_mul;

wire tr3_invalid_add;
wire tr3_overflow_add;
wire tr3_underflow_add;
wire tr3_inexact_add;

wire tr3_invalid_div;
wire tr3_div_by_0_div;
wire tr3_overflow_div;
wire tr3_underflow_div;
wire tr3_inexact_div;

wire tr3_invalid_sqrt;
wire tr3_overflow_sqrt;
wire tr3_underflow_sqrt;
wire tr3_inexact_sqrt;

wire tr3_invalid_fma;
wire tr3_overflow_fma;
wire tr3_underflow_fma;
wire tr3_inexact_fma;

wire tr3_invalid_log;
wire tr3_div_by_0_log;
wire tr3_overflow_log;
wire tr3_underflow_log;
wire tr3_inexact_log;

wire tr3_invalid_exp;
wire tr3_overflow_exp;
wire tr3_underflow_exp;
wire tr3_inexact_exp;

wire tr3_invalid_ftoi;
wire tr3_overflow_ftoi;
wire tr3_underflow_ftoi;
wire tr3_inexact_ftoi;    

// thread 2 exception signals
wire tr2_invalid_mul;
wire tr2_overflow_mul;
wire tr2_underflow_mul;
wire tr2_inexact_mul;

wire tr2_invalid_add;
wire tr2_overflow_add;
wire tr2_underflow_add;
wire tr2_inexact_add;

wire tr2_invalid_div;
wire tr2_div_by_0_div;
wire tr2_overflow_div;
wire tr2_underflow_div;
wire tr2_inexact_div;

wire tr2_invalid_sqrt;
wire tr2_overflow_sqrt;
wire tr2_underflow_sqrt;
wire tr2_inexact_sqrt;

wire tr2_invalid_fma;
wire tr2_overflow_fma;
wire tr2_underflow_fma;
wire tr2_inexact_fma;

wire tr2_invalid_log;
wire tr2_div_by_0_log;
wire tr2_overflow_log;
wire tr2_underflow_log;
wire tr2_inexact_log;

wire tr2_invalid_exp;
wire tr2_overflow_exp;
wire tr2_underflow_exp;
wire tr2_inexact_exp;

wire tr2_invalid_ftoi;
wire tr2_overflow_ftoi;
wire tr2_underflow_ftoi;
wire tr2_inexact_ftoi;  
 
// thread 1 exception signals
wire tr1_invalid_mul;
wire tr1_overflow_mul;
wire tr1_underflow_mul;
wire tr1_inexact_mul;

wire tr1_invalid_add;
wire tr1_overflow_add;
wire tr1_underflow_add;
wire tr1_inexact_add;

wire tr1_invalid_div;
wire tr1_div_by_0_div;
wire tr1_overflow_div;
wire tr1_underflow_div;
wire tr1_inexact_div;

wire tr1_invalid_sqrt;
wire tr1_overflow_sqrt;
wire tr1_underflow_sqrt;
wire tr1_inexact_sqrt;

wire tr1_invalid_fma;
wire tr1_overflow_fma;
wire tr1_underflow_fma;
wire tr1_inexact_fma;

wire tr1_invalid_log;
wire tr1_div_by_0_log;
wire tr1_overflow_log;
wire tr1_underflow_log;
wire tr1_inexact_log;

wire tr1_invalid_exp;
wire tr1_overflow_exp;
wire tr1_underflow_exp;
wire tr1_inexact_exp;

wire tr1_invalid_ftoi;
wire tr1_overflow_ftoi;
wire tr1_underflow_ftoi;
wire tr1_inexact_ftoi;  

// thread 0 exception signals
wire tr0_invalid_mul;
wire tr0_overflow_mul;
wire tr0_underflow_mul;
wire tr0_inexact_mul;

wire tr0_invalid_add;
wire tr0_overflow_add;
wire tr0_underflow_add;
wire tr0_inexact_add;

wire tr0_invalid_div;
wire tr0_div_by_0_div;
wire tr0_overflow_div;
wire tr0_underflow_div;
wire tr0_inexact_div;

wire tr0_invalid_sqrt;
wire tr0_overflow_sqrt;
wire tr0_underflow_sqrt;
wire tr0_inexact_sqrt;

wire tr0_invalid_fma;
wire tr0_overflow_fma;
wire tr0_underflow_fma;
wire tr0_inexact_fma;

wire tr0_invalid_log;
wire tr0_div_by_0_log;
wire tr0_overflow_log;
wire tr0_underflow_log;
wire tr0_inexact_log;

wire tr0_invalid_exp;
wire tr0_overflow_exp;
wire tr0_underflow_exp;
wire tr0_inexact_exp;

wire tr0_invalid_ftoi;
wire tr0_overflow_ftoi;
wire tr0_underflow_ftoi;
wire tr0_inexact_ftoi;  

//thread 3 combined exception signals
assign tr3_invalid   = tr3_invalid_mul  |
                       tr3_invalid_add  |
                       tr3_invalid_div  |
                       tr3_invalid_sqrt |
                       tr3_invalid_fma  |
                       tr3_invalid_log  |
                       tr3_invalid_exp  |
                       tr3_invalid_ftoi ;

assign tr3_div_by_0  = tr3_div_by_0_div  |
                       tr3_div_by_0_log  ;
 
assign tr3_overflow  = tr3_overflow_mul  |
                       tr3_overflow_add  |
                       tr3_overflow_div  |
                       tr3_overflow_sqrt |
                       tr3_overflow_fma  |
                       tr3_overflow_log  |
                       tr3_overflow_exp  |
                       tr3_overflow_ftoi ;

assign tr3_underflow = tr3_underflow_mul  |
                       tr3_underflow_add  |
                       tr3_underflow_div  |
                       tr3_underflow_sqrt |
                       tr3_underflow_fma  |
                       tr3_underflow_log  |
                       tr3_underflow_exp  |
                       tr3_underflow_ftoi ;

assign tr3_inexact   = tr3_inexact_mul  |
                       tr3_inexact_add  |
                       tr3_inexact_div  |
                       tr3_inexact_sqrt |
                       tr3_inexact_fma  |
                       tr3_inexact_log  |
                       tr3_inexact_exp  |
                       tr3_inexact_ftoi ;

//thread 2 combined exception signals
assign tr2_invalid   = tr2_invalid_mul  |
                       tr2_invalid_add  |
                       tr2_invalid_div  |
                       tr2_invalid_sqrt |
                       tr2_invalid_fma  |
                       tr2_invalid_log  |
                       tr2_invalid_exp  |
                       tr2_invalid_ftoi ;

assign tr2_div_by_0  = tr2_div_by_0_div  |
                       tr2_div_by_0_log  ;
 
assign tr2_overflow  = tr2_overflow_mul  |
                       tr2_overflow_add  |
                       tr2_overflow_div  |
                       tr2_overflow_sqrt |
                       tr2_overflow_fma  |
                       tr2_overflow_log  |
                       tr2_overflow_exp  |
                       tr2_overflow_ftoi ;

assign tr2_underflow = tr2_underflow_mul  |
                       tr2_underflow_add  |
                       tr2_underflow_div  |
                       tr2_underflow_sqrt |
                       tr2_underflow_fma  |
                       tr2_underflow_log  |
                       tr2_underflow_exp  |
                       tr2_underflow_ftoi ;  

assign tr2_inexact   = tr2_inexact_mul  |
                       tr2_inexact_add  |
                       tr2_inexact_div  |
                       tr2_inexact_sqrt |
                       tr2_inexact_fma  |
                       tr2_inexact_log  |
                       tr2_inexact_exp  |
                       tr2_inexact_ftoi ;
 
//thread 1 combined exception signals
assign tr1_invalid   = tr1_invalid_mul  |
                       tr1_invalid_add  |
                       tr1_invalid_div  |
                       tr1_invalid_sqrt |
                       tr1_invalid_fma  |
                       tr1_invalid_log  |
                       tr1_invalid_exp  |
                       tr1_invalid_ftoi ;

assign tr1_div_by_0  = tr1_div_by_0_div  |
                       tr1_div_by_0_log  ;
 
assign tr1_overflow  = tr1_overflow_mul  |
                       tr1_overflow_add  |
                       tr1_overflow_div  |
                       tr1_overflow_sqrt |
                       tr1_overflow_fma  |
                       tr1_overflow_log  |
                       tr1_overflow_exp  |
                       tr1_overflow_ftoi ;

assign tr1_underflow = tr1_underflow_mul  |
                       tr1_underflow_add  |
                       tr1_underflow_div  |
                       tr1_underflow_sqrt |
                       tr1_underflow_fma  |
                       tr1_underflow_log  |
                       tr1_underflow_exp  |
                       tr1_underflow_ftoi ;

assign tr1_inexact   = tr1_inexact_mul  |
                       tr1_inexact_add  |
                       tr1_inexact_div  |
                       tr1_inexact_sqrt |
                       tr1_inexact_fma  |
                       tr1_inexact_log  |
                       tr1_inexact_exp  |
                       tr1_inexact_ftoi ;

//thread 0 combined exception signals
assign tr0_invalid   = tr0_invalid_mul  |
                       tr0_invalid_add  |
                       tr0_invalid_div  |
                       tr0_invalid_sqrt |
                       tr0_invalid_fma  |
                       tr0_invalid_log  |
                       tr0_invalid_exp  |
                       tr0_invalid_ftoi ;

assign tr0_div_by_0  = tr0_div_by_0_div  |
                       tr0_div_by_0_log  ;
 
assign tr0_overflow  = tr0_overflow_mul  |
                       tr0_overflow_add  |
                       tr0_overflow_div  |
                       tr0_overflow_sqrt |
                       tr0_overflow_fma  |
                       tr0_overflow_log  |
                       tr0_overflow_exp  |
                       tr0_overflow_ftoi ;

assign tr0_underflow = tr0_underflow_mul  |
                       tr0_underflow_add  |
                       tr0_underflow_div  |
                       tr0_underflow_sqrt |
                       tr0_underflow_fma  |
                       tr0_underflow_log  |
                       tr0_underflow_exp  |
                       tr0_underflow_ftoi ;

assign tr0_inexact   = tr0_inexact_mul  |
                       tr0_inexact_add  |
                       tr0_inexact_div  |
                       tr0_inexact_sqrt |
                       tr0_inexact_fma  |
                       tr0_inexact_log  |
                       tr0_inexact_exp  |
                       tr0_inexact_ftoi ;


assign A_is_qNaN = &fwrsrcAdata[30:22] & |fwrsrcAdata[21:0];
assign B_is_qNaN = &fwrsrcBdata[30:22] & |fwrsrcBdata[21:0];

assign wrfunc_sel = wraddrs[6:3];
assign rdAfunc_sel = rdaddrsA[6:3];
assign rdBfunc_sel = rdaddrsB[6:3];
assign srcA_q1_sel = srcA_q1[7:0];
assign srcB_q1_sel = srcB_q1[7:0];

assign rddataA = rddataA_out[31:0];
assign rddataB = (opcode_q1==BTB_) ? semaphor_q1 : rddataB_out[31:0];

assign semaphor_q1 = {23'h00_0000,
                      ready_fma,
                      ready_mul,
                      ready_add,
                      ready_div,
                      ready_sqrt,
                      ready_log,
                      ready_exp,
                      ready_itof,
                      ready_ftoi};
                      
assign exc_codeA = rddataA_out[35:32];
assign exc_codeB = rddataB_out[35:32];

assign ready = readyA & readyB;                      
  
func_ftoi ftoi(
    .RESET    (RESET     ),
    .CLK      (CLK       ),
    .pc_q2_del( pc_q2_del_0 ),
    .qNaN_del (propgat_NaN_del_0),
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
    .ready    (ready_ftoi),
    
    .round_mode    (round_mode_q2_del_0),

    .tr3_invalid   (tr3_invalid_ftoi   ),  
    .tr3_overflow  (tr3_overflow_ftoi  ), 
    .tr3_underflow (tr3_underflow_ftoi ),
    .tr3_inexact   (tr3_inexact_ftoi   ),  

    .tr2_invalid   (tr2_invalid_ftoi   ),
    .tr2_overflow  (tr2_overflow_ftoi  ),
    .tr2_underflow (tr2_underflow_ftoi ),
    .tr2_inexact   (tr2_inexact_ftoi   ),

    .tr1_invalid   (tr1_invalid_ftoi   ),  
    .tr1_overflow  (tr1_overflow_ftoi  ),
    .tr1_underflow (tr1_underflow_ftoi ),
    .tr1_inexact   (tr1_inexact_ftoi   ),

    .tr0_invalid   (tr0_invalid_ftoi   ),
    .tr0_overflow  (tr0_overflow_ftoi  ),
    .tr0_underflow (tr0_underflow_ftoi ),
    .tr0_inexact   (tr0_inexact_ftoi   )   
    );  
  
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
    .pc_q2_del( pc_q2_del_1  ),
    .qNaN_del (propgat_NaN_del_1),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_mul      ),
    .wraddrs  ({thread_q2, wraddrs[3:0]}),
    .wrdataA  (fwrsrcAdata   ),
    .wrdataB  (fwrsrcBdata   ),
    .rdenA    (rdenA_mul     ),
    .rdaddrsA ({thread, rdaddrsA[3:0]}),
    .rddataA  (rddataA_FP_mul),
    .rdenB    (rdenB_mul     ),
    .rdaddrsB ({thread, rdaddrsB[3:0]}),
    .rddataB  (rddataB_FP_mul),
    .ready    (ready_mul     ),
    
    .round_mode(round_mode_q2_del_0 ),
   
    .tr3_invalid  (tr3_invalid_mul  ),
    .tr3_overflow (tr3_overflow_mul ),
    .tr3_underflow(tr3_underflow_mul),
    .tr3_inexact  (tr3_inexact_mul  ),
    
    .tr2_invalid  (tr2_invalid_mul  ),
    .tr2_overflow (tr2_overflow_mul ),
    .tr2_underflow(tr2_underflow_mul),
    .tr2_inexact  (tr2_inexact_mul  ),

    .tr1_invalid  (tr1_invalid_mul  ),
    .tr1_overflow (tr1_overflow_mul ),
    .tr1_underflow(tr1_underflow_mul),
    .tr1_inexact  (tr1_inexact_mul  ),

    .tr0_invalid  (tr0_invalid_mul  ),
    .tr0_overflow (tr0_overflow_mul ),
    .tr0_underflow(tr0_underflow_mul),
    .tr0_inexact  (tr0_inexact_mul  )
    );
    
func_add add(             
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .pc_q2_del( pc_q2_del_4  ),
    .qNaN_del (propgat_NaN_del_4),
    .opcode_q1(opcode_q1     ),
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
    .ready    (ready_add     ),
    
    .round_mode(round_mode_q2_del_3 ),
   
    .tr3_invalid  (tr3_invalid_add  ),
    .tr3_overflow (tr3_overflow_add ),
    .tr3_underflow(tr3_underflow_add),
    .tr3_inexact  (tr3_inexact_add  ),
    
    .tr2_invalid  (tr2_invalid_add  ),
    .tr2_overflow (tr2_overflow_add ),
    .tr2_underflow(tr2_underflow_add),
    .tr2_inexact  (tr2_inexact_add  ),

    .tr1_invalid  (tr1_invalid_add  ),
    .tr1_overflow (tr1_overflow_add ),
    .tr1_underflow(tr1_underflow_add),
    .tr1_inexact  (tr1_inexact_add  ),

    .tr0_invalid  (tr0_invalid_add  ),
    .tr0_overflow (tr0_overflow_add ),
    .tr0_underflow(tr0_underflow_add),
    .tr0_inexact  (tr0_inexact_add  )
    );
    
func_div div(              
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .pc_q2_del( pc_q2_del_10 ),
    .qNaN_del (propgat_NaN_del_10),
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
    .ready    (ready_div     ),
    
    .round_mode (round_mode_q2_del_9),
   
    .tr3_invalid  (tr3_invalid_div  ),
    .tr3_div_by_0 (tr3_div_by_0_div ),
    .tr3_overflow (tr3_overflow_div ),
    .tr3_underflow(tr3_underflow_div),
    .tr3_inexact  (tr3_inexact_div  ),
    
    .tr2_invalid  (tr2_invalid_div  ),
    .tr2_div_by_0 (tr2_div_by_0_div ),
    .tr2_overflow (tr2_overflow_div ),
    .tr2_underflow(tr2_underflow_div),
    .tr2_inexact  (tr2_inexact_div  ),

    .tr1_invalid  (tr1_invalid_div  ),
    .tr1_div_by_0 (tr1_div_by_0_div ),
    .tr1_overflow (tr1_overflow_div ),
    .tr1_underflow(tr1_underflow_div),
    .tr1_inexact  (tr1_inexact_div  ),

    .tr0_invalid  (tr0_invalid_div  ),
    .tr0_div_by_0 (tr0_div_by_0_div ),
    .tr0_overflow (tr0_overflow_div ),
    .tr0_underflow(tr0_underflow_div),
    .tr0_inexact  (tr0_inexact_div  )
    );
    
func_sqrt sqrt(              
    .RESET    (RESET          ),
    .CLK      (CLK            ),
    .pc_q2_del(pc_q2_del_10   ),
    .qNaN_del (propgat_NaN_del_10),
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
    .ready    (ready_sqrt     ),
    
    .round_mode(round_mode_q2_del_9 ),
   
    .tr3_invalid  (tr3_invalid_sqrt  ),
    .tr3_overflow (tr3_overflow_sqrt ),
    .tr3_underflow(tr3_underflow_sqrt),
    .tr3_inexact  (tr3_inexact_sqrt  ),
    
    .tr2_invalid  (tr2_invalid_sqrt  ),
    .tr2_overflow (tr2_overflow_sqrt ),
    .tr2_underflow(tr2_underflow_sqrt),
    .tr2_inexact  (tr2_inexact_sqrt  ),

    .tr1_invalid  (tr1_invalid_sqrt  ),
    .tr1_overflow (tr1_overflow_sqrt ),
    .tr1_underflow(tr1_underflow_sqrt),
    .tr1_inexact  (tr1_inexact_sqrt  ),

    .tr0_invalid  (tr0_invalid_sqrt  ),
    .tr0_overflow (tr0_overflow_sqrt ),
    .tr0_underflow(tr0_underflow_sqrt),
    .tr0_inexact  (tr0_inexact_sqrt  )
    );
    
func_fma fma(             
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .pc_q2_del( pc_q2_del_7  ),
    .qNaN_del (propgat_NaN_del_7),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_fma      ),
    .wraddrs  ({thread_q2, wraddrs[3:0]}),
    .wrdataA  (fwrsrcAdata   ),
    .wrdataB  (fwrsrcBdata   ),
    .rdenA    (rdenA_fma     ),
    .rdaddrsA ({thread, rdaddrsA[3:0]}),                        
    .rddataA  (rddataA_FP_fma),                                 
    .rdenB    (rdenB_fma     ),                                 
    .rdaddrsB ({thread, rdaddrsB[3:0]}),                        
    .rddataB  (rddataB_FP_fma),
    .C_reg    (C_reg         ),

    .ready    (ready_fma     ),

    .tr3_CREG_wr (tr3_CREG_wr),
    .tr2_CREG_wr (tr2_CREG_wr),
    .tr1_CREG_wr (tr1_CREG_wr),
    .tr0_CREG_wr (tr0_CREG_wr),
    
    .round_mode(round_mode_q2_del_6 ),
    
    .tr3_invalid  (tr3_invalid_fma  ),
    .tr3_overflow (tr3_overflow_fma ),
    .tr3_underflow(tr3_underflow_fma),
    .tr3_inexact  (tr3_inexact_fma  ),
    
    .tr2_invalid  (tr2_invalid_fma  ),
    .tr2_overflow (tr2_overflow_fma ),
    .tr2_underflow(tr2_underflow_fma),
    .tr2_inexact  (tr2_inexact_fma  ),
    
    .tr1_invalid  (tr1_invalid_fma  ),
    .tr1_overflow (tr1_overflow_fma ),
    .tr1_underflow(tr1_underflow_fma),
    .tr1_inexact  (tr1_inexact_fma  ),
    
    .tr0_invalid  (tr0_invalid_fma  ),
    .tr0_overflow (tr0_overflow_fma ),
    .tr0_underflow(tr0_underflow_fma),
    .tr0_inexact  (tr0_inexact_fma  )
    );
    
func_log log(              
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .pc_q2_del( pc_q2_del_8  ),
    .qNaN_del (propgat_NaN_del_8),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_log      ),
    .wraddrs  ({thread_q2, wraddrs[2:0]}),
    .wrdataA  (fwrsrcAdata   ),
    .rdenA    (rdenA_log     ),
    .rdaddrsA ({thread, rdaddrsA[2:0]}),
    .rddataA  (rddataA_FP_log),
    .rdenB    (rdenB_log     ),
    .rdaddrsB ({thread, rdaddrsB[2:0]}),
    .rddataB  (rddataB_FP_log),
    .ready    (ready_log     ),
    
    .round_mode(round_mode_q2_del_7 ),
   
    .tr3_invalid  (tr3_invalid_log  ),
    .tr3_div_by_0 (tr3_div_by_0_log ),
    .tr3_overflow (tr3_overflow_log ),
    .tr3_underflow(tr3_underflow_log),
    .tr3_inexact  (tr3_inexact_log  ),
    
    .tr2_invalid  (tr2_invalid_log  ),
    .tr2_div_by_0 (tr2_div_by_0_log ),
    .tr2_overflow (tr2_overflow_log ),
    .tr2_underflow(tr2_underflow_log),
    .tr2_inexact  (tr2_inexact_log  ),

    .tr1_invalid  (tr1_invalid_log  ),
    .tr1_div_by_0 (tr1_div_by_0_log ),
    .tr1_overflow (tr1_overflow_log ),
    .tr1_underflow(tr1_underflow_log),
    .tr1_inexact  (tr1_inexact_log  ),

    .tr0_invalid  (tr0_invalid_log  ),
    .tr0_div_by_0 (tr0_div_by_0_log ),
    .tr0_overflow (tr0_overflow_log ),
    .tr0_underflow(tr0_underflow_log),
    .tr0_inexact  (tr0_inexact_log  )
    );

func_exp exp(              
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .pc_q2_del( pc_q2_del_6  ),
    .qNaN_del (propgat_NaN_del_6),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_exp      ),
    .wraddrs  ({thread_q2, wraddrs[2:0]}),
    .wrdataA  (fwrsrcAdata   ),
    .rdenA    (rdenA_exp     ),
    .rdaddrsA ({thread, rdaddrsA[2:0]}),
    .rddataA  (rddataA_FP_exp),
    .rdenB    (rdenB_exp     ),
    .rdaddrsB ({thread, rdaddrsB[2:0]}),
    .rddataB  (rddataB_FP_exp),
    .ready    (ready_exp     ),
    
    .round_mode(round_mode_q2_del_5 ),
   
    .tr3_invalid  (tr3_invalid_exp  ),
    .tr3_overflow (tr3_overflow_exp ),
    .tr3_underflow(tr3_underflow_exp),
    .tr3_inexact  (tr3_inexact_exp  ),
    
    .tr2_invalid  (tr2_invalid_exp  ),
    .tr2_overflow (tr2_overflow_exp ),
    .tr2_underflow(tr2_underflow_exp),
    .tr2_inexact  (tr2_inexact_exp  ),

    .tr1_invalid  (tr1_invalid_exp  ),
    .tr1_overflow (tr1_overflow_exp ),
    .tr1_underflow(tr1_underflow_exp),
    .tr1_inexact  (tr1_inexact_exp  ),

    .tr0_invalid  (tr0_invalid_exp  ),
    .tr0_overflow (tr0_overflow_exp ),
    .tr0_underflow(tr0_underflow_exp),
    .tr0_inexact  (tr0_inexact_exp  )
    );

always@(*) begin
    if (wren_fma) 
        case(thread_q2)
            2'b00 : C_reg = tr0_C_reg;    
            2'b01 : C_reg = tr1_C_reg;    
            2'b10 : C_reg = tr2_C_reg;    
            2'b11 : C_reg = tr3_C_reg;    
        endcase
    else C_reg = tr0_C_reg;
end        
        
// to be used in NaN diagnostic payload for "invalid" exceptions where qNaN is substitued for results
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        pc_q2_del_0  <= 12'h000;
        pc_q2_del_1  <= 12'h000; 
        pc_q2_del_2  <= 12'h000; 
        pc_q2_del_3  <= 12'h000; 
        pc_q2_del_4  <= 12'h000; 
        pc_q2_del_5  <= 12'h000; 
        pc_q2_del_6  <= 12'h000; 
        pc_q2_del_7  <= 12'h000; 
        pc_q2_del_8  <= 12'h000; 
        pc_q2_del_9  <= 12'h000; 
        pc_q2_del_10 <= 12'h000;
        pc_q2_del_11 <= 12'h000;
    end
    else begin
        pc_q2_del_0  <= pc_q2;
        pc_q2_del_1  <= pc_q2_del_0;
        pc_q2_del_2  <= pc_q2_del_1;
        pc_q2_del_3  <= pc_q2_del_2;
        pc_q2_del_4  <= pc_q2_del_3;
        pc_q2_del_5  <= pc_q2_del_4;
        pc_q2_del_6  <= pc_q2_del_5;
        pc_q2_del_7  <= pc_q2_del_6;
        pc_q2_del_8  <= pc_q2_del_7;
        pc_q2_del_9  <= pc_q2_del_8;
        pc_q2_del_10 <= pc_q2_del_9;
        pc_q2_del_11 <= pc_q2_del_10;
        pc_q2_del_12 <= pc_q2_del_11;
    end
end        

// for propagating qNaN payloads where, as operands, they remain quiet without raising exceptions and are substituted for results
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        propgat_NaN_del_0  <= 23'h00_0000;
        propgat_NaN_del_1  <= 23'h00_0000;
        propgat_NaN_del_2  <= 23'h00_0000;
        propgat_NaN_del_3  <= 23'h00_0000;
        propgat_NaN_del_4  <= 23'h00_0000;
        propgat_NaN_del_5  <= 23'h00_0000;
        propgat_NaN_del_6  <= 23'h00_0000;
        propgat_NaN_del_7  <= 23'h00_0000;
        propgat_NaN_del_8  <= 23'h00_0000;
        propgat_NaN_del_9  <= 23'h00_0000;
        propgat_NaN_del_10 <= 23'h00_0000;
        propgat_NaN_del_11 <= 23'h00_0000;
        propgat_NaN_del_12 <= 23'h00_0000;
    end
    else begin
        propgat_NaN_del_0  <= {(A_is_qNaN | B_is_qNaN), (A_is_qNaN ? fwrsrcAdata[21:0] : fwrsrcBdata[21:0])};
        propgat_NaN_del_1  <= propgat_NaN_del_0 ;
        propgat_NaN_del_2  <= propgat_NaN_del_1 ;
        propgat_NaN_del_3  <= propgat_NaN_del_2 ;
        propgat_NaN_del_4  <= propgat_NaN_del_3 ;
        propgat_NaN_del_5  <= propgat_NaN_del_4 ;
        propgat_NaN_del_6  <= propgat_NaN_del_5 ;
        propgat_NaN_del_7  <= propgat_NaN_del_6 ;
        propgat_NaN_del_8  <= propgat_NaN_del_7 ;
        propgat_NaN_del_9  <= propgat_NaN_del_8 ;
        propgat_NaN_del_10 <= propgat_NaN_del_9 ;
        propgat_NaN_del_11 <= propgat_NaN_del_10;
        propgat_NaN_del_12 <= propgat_NaN_del_11;
    end
end 

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        round_mode_q2_del_0 <= 2'b00;    
        round_mode_q2_del_1 <= 2'b00;
        round_mode_q2_del_2 <= 2'b00;
        round_mode_q2_del_3 <= 2'b00;
        round_mode_q2_del_4 <= 2'b00;
        round_mode_q2_del_5 <= 2'b00;
        round_mode_q2_del_6 <= 2'b00;
        round_mode_q2_del_7 <= 2'b00;
        round_mode_q2_del_8 <= 2'b00;
        round_mode_q2_del_9 <= 2'b00;
        round_mode_q2_del_10 <= 2'b00;
        round_mode_q2_del_11 <= 2'b00;
    end
    else begin
        round_mode_q2_del_0 <= round_mode_q2;
        round_mode_q2_del_1 <= round_mode_q2_del_0;
        round_mode_q2_del_2 <= round_mode_q2_del_1;
        round_mode_q2_del_3 <= round_mode_q2_del_2;
        round_mode_q2_del_4 <= round_mode_q2_del_3;
        round_mode_q2_del_5 <= round_mode_q2_del_4;
        round_mode_q2_del_6 <= round_mode_q2_del_5;
        round_mode_q2_del_7 <= round_mode_q2_del_6;
        round_mode_q2_del_8 <= round_mode_q2_del_7;
        round_mode_q2_del_9 <= round_mode_q2_del_8;
        round_mode_q2_del_10 <= round_mode_q2_del_9;
        round_mode_q2_del_11 <= round_mode_q2_del_10;
    end
end        
                                                                     
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        fwrsrcAdata <= 32'h00000000;
        fwrsrcBdata <= 32'h00000000;
        round_mode_q2 <= 2'b00;
    end
    else begin
        if (&constn_q1 && (opcode_q1==MOV_)) begin        // MOV immediate 16
            fwrsrcAdata <= {16'h0000, OPsrcA_q1, OPsrcB_q1};
            fwrsrcBdata <= rdSrcBdata; 
        end        
        else if (constn_q1[0] && (opcode_q1==MOV_)) begin        // MOV immediate 8
            fwrsrcAdata <= rdSrcAdata;
            fwrsrcBdata <= {24'h0000_00, OPsrcB_q1}; 
        end        
        else begin     // any combination of direct or indirect
            fwrsrcAdata <= rdSrcAdata;             
            fwrsrcBdata <= rdSrcBdata; 
        end
        round_mode_q2 <= round_mode_q1;
    end 
end    
    
    
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        rdenA_q1 <= 1'b0;
        rdenB_q1 <= 1'b0;
        srcA_q1 <= 8'h00;
        srcB_q1 <= 8'h00;
    end
    else begin
        rdenA_q1 <= rdenA;
        rdenB_q1 <= rdenB;
        srcA_q1 <= rdaddrsA[7:0];
        srcB_q1 <= rdaddrsB[7:0];
    end
end            
   
always @(*) 
    if (rdenA_q1)
        casex (srcA_q1_sel)
            8'b100xxxxx : begin
                            rddataA_out = rddataA_FP_add;
                            readyA = ready_add;
                          end   
            8'b1010xxxx : begin
                            rddataA_out = rddataA_FP_mul;
                            readyA = ready_mul;
                          end  
            8'b10110xxx : begin
                            rddataA_out = rddataA_FP_itof; 
                            readyA = ready_itof;
                          end  
            8'b10111xxx : begin
                            rddataA_out = rddataA_INT_ftoi; 
                            readyA = ready_ftoi;
                          end  
            8'b1100xxxx : begin
                            rddataA_out = rddataA_FP_div; 
                            readyA = ready_div;
                          end  
            8'b1101xxxx : begin
                            rddataA_out = rddataA_FP_sqrt;
                            readyA = ready_sqrt;
                          end  
            8'b1110xxxx : begin
                            rddataA_out = rddataA_FP_fma; 
                            readyA = ready_fma;
                          end  
            8'b11110xxx : begin
                            rddataA_out = rddataA_FP_log; 
                            readyA = ready_log;
                          end  
            8'b11111xxx : begin
                            rddataA_out = rddataA_FP_exp; 
                            readyA = ready_exp;
                          end 
                default : begin
                            rddataA_out = 36'h0_0000_0000;
                            readyA = rdenB_q1;
                          end
        endcase 
        else begin
           rddataA_out = 36'h0_0000_0000;
           readyA = rdenB_q1;
        end
                      
always @(*) 
    if (rdenB_q1)
        casex (srcB_q1_sel)
            8'b100xxxxx : begin
                            rddataB_out = rddataB_FP_add;
                            readyB = ready_add;
                          end   
            8'b1010xxxx : begin
                            rddataB_out = rddataB_FP_mul;
                            readyB = ready_mul;
                          end  
            8'b10110xxx : begin
                            rddataB_out = rddataB_FP_itof; 
                            readyB = ready_itof;
                          end  
            8'b10111xxx : begin
                            rddataB_out = rddataB_INT_ftoi; 
                            readyB = ready_ftoi;
                          end  
            8'b1100xxxx : begin
                            rddataB_out = rddataB_FP_div; 
                            readyB = ready_div;
                          end  
            8'b1101xxxx : begin
                            rddataB_out = rddataB_FP_sqrt;
                            readyB = ready_sqrt;
                          end  
            8'b1110xxxx : begin
                            rddataB_out = rddataB_FP_fma; 
                            readyB = ready_fma;
                          end  
            8'b11110xxx : begin
                            rddataB_out = rddataB_FP_log; 
                            readyB = ready_log;
                          end  
            8'b11111xxx : begin
                           rddataB_out = rddataB_FP_exp; 
                           readyB = ready_exp;
                          end  
                default : begin
                            rddataB_out = 36'h0_0000_0000;
                            readyB = rdenA_q1;
                          end
        endcase 
    else begin
       rddataB_out = 36'h0_0000_0000;
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
    if ((wrfunc_sel[3:1] == 3'b110) && wren) wren_fma = 1'b1;
    else wren_fma = 1'b0;   
    if ((wrfunc_sel[3:0] == 4'b1110) && wren) wren_log = 1'b1;
    else wren_log = 1'b0;
    if ((wrfunc_sel[3:0] == 4'b1111) && wren) wren_exp = 1'b1;
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
    if ((rdAfunc_sel[3:1] == 3'b110) && rdenA) rdenA_fma = 1'b1;
    else rdenA_fma = 1'b0;
    if ((rdAfunc_sel[3:0] == 4'b1110) && rdenA) rdenA_log = 1'b1;
    else rdenA_log = 1'b0;
    if ((rdAfunc_sel[3:0] == 4'b1111) && rdenA) rdenA_exp = 1'b1;
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
    if ((rdBfunc_sel[3:1] == 3'b101) && rdenB) rdenB_fma = 1'b1;
    else rdenB_fma = 1'b0;
    if ((rdBfunc_sel[3:0] == 4'b1110) && rdenB) rdenB_log = 1'b1;
    else rdenB_log = 1'b0;
    if ((rdBfunc_sel[3:0] == 4'b1111) && rdenB) rdenB_exp = 1'b1;
    else rdenB_exp = 1'b0;
end    

endmodule