 `timescale 1ns/100ps
// Author:  Jerry D. Harthcock
// Version 2.14   January 18, 2016.
// Copyright (C) 2014-2016.  All rights reserved.
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
 
module aSYMPL_func_CPU ( 
    RESET,
    CLK,
    pc_q2,
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
    CPU_C_reg,
    exc_codeA,
    exc_codeB,
    
    CPU_CREG_wr,
    
    ready,
    
    round_mode_q1,
    

    CPU_invalid,  
    CPU_div_by_0, 
    CPU_overflow, 
    CPU_underflow,
    CPU_inexact
    );

input RESET, CLK, wren, rdenA, rdenB;
input [11:0] pc_q2;
input [6:0] wraddrs;
input [7:0] rdaddrsA, rdaddrsB;
input [3:0] opcode_q1;
input [1:0] constn_q1;
input [7:0] OPsrcA_q1;
input [7:0] OPsrcB_q1;

input [31:0] rdSrcAdata, rdSrcBdata;
input [31:0] CPU_C_reg;
input [1:0] round_mode_q1;

output [31:0]rddataA, rddataB;
output [3:0] exc_codeA;
output [3:0] exc_codeB;

input CPU_CREG_wr;

output ready;

output CPU_invalid;  
output CPU_div_by_0; 
output CPU_overflow; 
output CPU_underflow;
output CPU_inexact;  

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

wire [35:0] CPU_rddataB_FP_dot;

wire ready_dot;     
    
wire A_is_qNaN;  // A is quiet NaN
wire B_is_qNaN;  // B is quiet NaN

wire CPU_invalid;  
wire CPU_div_by_0; 
wire CPU_overflow; 
wire CPU_underflow;
wire CPU_inexact; 


// exception signals
wire CPU_invalid_mul;
wire CPU_overflow_mul;
wire CPU_underflow_mul;
wire CPU_inexact_mul;

wire CPU_invalid_add;
wire CPU_overflow_add;
wire CPU_underflow_add;
wire CPU_inexact_add;

wire CPU_invalid_div;
wire CPU_div_by_0_div;
wire CPU_overflow_div;
wire CPU_underflow_div;
wire CPU_inexact_div;

wire CPU_invalid_sqrt;
wire CPU_overflow_sqrt;
wire CPU_underflow_sqrt;
wire CPU_inexact_sqrt;

wire CPU_invalid_fma;
wire CPU_overflow_fma;
wire CPU_underflow_fma;
wire CPU_inexact_fma;

wire CPU_invalid_log;
wire CPU_div_by_0_log;
wire CPU_overflow_log;
wire CPU_underflow_log;
wire CPU_inexact_log;

wire CPU_invalid_exp;
wire CPU_overflow_exp;
wire CPU_underflow_exp;
wire CPU_inexact_exp;

wire CPU_invalid_ftoi;
wire CPU_overflow_ftoi;
wire CPU_underflow_ftoi;
wire CPU_inexact_ftoi;  

//combined exception signals
assign CPU_invalid   = CPU_invalid_mul  |
                       CPU_invalid_add  |
                       CPU_invalid_div  |
                       CPU_invalid_sqrt |
                       CPU_invalid_fma  |
                       CPU_invalid_log  |
                       CPU_invalid_exp  |
                       CPU_invalid_ftoi ;

assign CPU_div_by_0  = CPU_div_by_0_div  |
                       CPU_div_by_0_log  ;
 
assign CPU_overflow  = CPU_overflow_mul  |
                       CPU_overflow_add  |
                       CPU_overflow_div  |
                       CPU_overflow_sqrt |
                       CPU_overflow_fma  |
                       CPU_overflow_log  |
                       CPU_overflow_exp  |
                       CPU_overflow_ftoi ;

assign CPU_underflow = CPU_underflow_mul  |
                       CPU_underflow_add  |
                       CPU_underflow_div  |
                       CPU_underflow_sqrt |
                       CPU_underflow_fma  |
                       CPU_underflow_log  |
                       CPU_underflow_exp  |
                       CPU_underflow_ftoi ;

assign CPU_inexact   = CPU_inexact_mul  |
                       CPU_inexact_add  |
                       CPU_inexact_div  |
                       CPU_inexact_sqrt |
                       CPU_inexact_fma  |
                       CPU_inexact_log  |
                       CPU_inexact_exp  |
                       CPU_inexact_ftoi ;


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
  
func_ftoi_CPU ftoi(
    .RESET    (RESET     ),
    .CLK      (CLK       ),
    .pc_q2_del( pc_q2_del_0 ),
    .qNaN_del (propgat_NaN_del_0),
    .opcode_q1(opcode_q1 ),
    .wren     (wren_ftoi ),
    .wraddrs  (wraddrs[2:0]),
    .wrdata   (fwrsrcAdata),
    .rdenA    (rdenA_ftoi),
    .rdaddrsA ( rdaddrsA[2:0]),
    .rddataA  (rddataA_INT_ftoi),
    .rdenB    (rdenB_ftoi ),
    .rdaddrsB (rdaddrsB[2:0]),
    .rddataB  (rddataB_INT_ftoi),
    .ready    (ready_ftoi),
    
    .round_mode    (round_mode_q2_del_0),

    .CPU_invalid   (CPU_invalid_ftoi   ),
    .CPU_overflow  (CPU_overflow_ftoi  ),
    .CPU_underflow (CPU_underflow_ftoi ),
    .CPU_inexact   (CPU_inexact_ftoi   )   
    );  
  
func_itof_CPU itof(
    .RESET    (RESET     ),
    .CLK      (CLK       ),
    .opcode_q1(opcode_q1 ),
    .wren     (wren_itof ),
    .wraddrs  (wraddrs[2:0]),
    .wrdata   (fwrsrcAdata),
    .rdenA    (rdenA_itof),
    .rdaddrsA (rdaddrsA[2:0]),
    .rddataA  (rddataA_FP_itof),
    .rdenB    (rdenB_itof ),
    .rdaddrsB (rdaddrsB[2:0]),
    .rddataB  (rddataB_FP_itof),
    .ready    (ready_itof));    

func_mul_CPU mul(             
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .pc_q2_del( pc_q2_del_1  ),
    .qNaN_del (propgat_NaN_del_1),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_mul      ),
    .wraddrs  (wraddrs[3:0]  ),
    .wrdataA  (fwrsrcAdata   ),
    .wrdataB  (fwrsrcBdata   ),
    .rdenA    (rdenA_mul     ),
    .rdaddrsA (rdaddrsA[3:0]),
    .rddataA  (rddataA_FP_mul),
    .rdenB    (rdenB_mul     ),
    .rdaddrsB (rdaddrsB[3:0]),
    .rddataB  (rddataB_FP_mul),
    .ready    (ready_mul     ),
    
    .round_mode(round_mode_q2_del_0 ),
   
    .CPU_invalid  (CPU_invalid_mul  ),
    .CPU_overflow (CPU_overflow_mul ),
    .CPU_underflow(CPU_underflow_mul),
    .CPU_inexact  (CPU_inexact_mul  )
    );
    
func_add_CPU add(             
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .pc_q2_del( pc_q2_del_4  ),
    .qNaN_del (propgat_NaN_del_4),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_add      ),
    .wraddrs  (wraddrs[4:0]  ),
    .wrdataA  (fwrsrcAdata   ),
    .wrdataB  (fwrsrcBdata   ),
    .rdenA    (rdenA_add     ),
    .rdaddrsA (rdaddrsA[4:0] ),
    .rddataA  (rddataA_FP_add),
    .rdenB    (rdenB_add     ),
    .rdaddrsB (rdaddrsB[4:0] ),
    .rddataB  (rddataB_FP_add),
    .ready    (ready_add     ),
    
    .round_mode(round_mode_q2_del_3 ),
   
    .CPU_invalid  (CPU_invalid_add  ),
    .CPU_overflow (CPU_overflow_add ),
    .CPU_underflow(CPU_underflow_add),
    .CPU_inexact  (CPU_inexact_add  )
    );
    
func_div_CPU div(              
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .pc_q2_del( pc_q2_del_10 ),
    .qNaN_del (propgat_NaN_del_10),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_div      ),
    .wraddrs  (wraddrs[3:0]  ),
    .wrdataA  (fwrsrcAdata   ),
    .wrdataB  (fwrsrcBdata   ),
    .rdenA    (rdenA_div     ),
    .rdaddrsA (rdaddrsA[3:0] ),
    .rddataA  (rddataA_FP_div),
    .rdenB    (rdenB_div     ),
    .rdaddrsB (rdaddrsB[3:0]),
    .rddataB  (rddataB_FP_div),
    .ready    (ready_div     ),
    
    .round_mode (round_mode_q2_del_9),
   
    .CPU_invalid  (CPU_invalid_div  ),
    .CPU_div_by_0 (CPU_div_by_0_div ),
    .CPU_overflow (CPU_overflow_div ),
    .CPU_underflow(CPU_underflow_div),
    .CPU_inexact  (CPU_inexact_div  )
    );
    
func_sqrt_CPU sqrt(              
    .RESET    (RESET          ),
    .CLK      (CLK            ),
    .pc_q2_del(pc_q2_del_10   ),
    .qNaN_del (propgat_NaN_del_10),
    .opcode_q1(opcode_q1      ),
    .wren     (wren_sqrt      ),
    .wraddrs  (wraddrs[3:0]   ),
    .wrdataA  (fwrsrcAdata    ),
    .rdenA    (rdenA_sqrt     ),
    .rdaddrsA ( rdaddrsA[3:0] ),
    .rddataA  (rddataA_FP_sqrt),
    .rdenB    (rdenB_sqrt     ),
    .rdaddrsB ( rdaddrsB[3:0] ),
    .rddataB  (rddataB_FP_sqrt),
    .ready    (ready_sqrt     ),
    
    .round_mode(round_mode_q2_del_9 ),
   
    .CPU_invalid  (CPU_invalid_sqrt  ),
    .CPU_overflow (CPU_overflow_sqrt ),
    .CPU_underflow(CPU_underflow_sqrt),
    .CPU_inexact  (CPU_inexact_sqrt  )
    );
    
func_fma_CPU fma(             
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .pc_q2_del( pc_q2_del_7  ),
    .qNaN_del (propgat_NaN_del_7),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_fma      ),
    .wraddrs  (wraddrs[3:0]  ),
    .wrdataA  (fwrsrcAdata   ),
    .wrdataB  (fwrsrcBdata   ),
    .rdenA    (rdenA_fma     ),
    .rdaddrsA (rdaddrsA[3:0] ),                        
    .rddataA  (rddataA_FP_fma),                                 
    .rdenB    (rdenB_fma     ),                                 
    .rdaddrsB (rdaddrsB[3:0] ),                        
    .rddataB  (rddataB_FP_fma),
    .C_reg    (C_reg         ),

    .ready    (ready_fma     ),

    .CPU_CREG_wr (CPU_CREG_wr),
    
    .round_mode(round_mode_q2_del_6 ),
    
    .CPU_invalid  (CPU_invalid_fma  ),
    .CPU_overflow (CPU_overflow_fma ),
    .CPU_underflow(CPU_underflow_fma),
    .CPU_inexact  (CPU_inexact_fma  )
    );
    
func_log_CPU log(              
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .pc_q2_del( pc_q2_del_8  ),
    .qNaN_del (propgat_NaN_del_8),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_log      ),
    .wraddrs  ( wraddrs[2:0] ),
    .wrdataA  (fwrsrcAdata   ),
    .rdenA    (rdenA_log     ),
    .rdaddrsA (rdaddrsA[2:0] ),
    .rddataA  (rddataA_FP_log),
    .rdenB    (rdenB_log     ),
    .rdaddrsB (rdaddrsB[2:0] ),
    .rddataB  (rddataB_FP_log),
    .ready    (ready_log     ),
    
    .round_mode(round_mode_q2_del_7 ),
   
    .CPU_invalid  (CPU_invalid_log  ),
    .CPU_div_by_0 (CPU_div_by_0_log ),
    .CPU_overflow (CPU_overflow_log ),
    .CPU_underflow(CPU_underflow_log),
    .CPU_inexact  (CPU_inexact_log  )
    );

func_exp_CPU exp(              
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .pc_q2_del( pc_q2_del_6  ),
    .qNaN_del (propgat_NaN_del_6),
    .opcode_q1(opcode_q1     ),
    .wren     (wren_exp      ),
    .wraddrs  (wraddrs[2:0]  ),
    .wrdataA  (fwrsrcAdata   ),
    .rdenA    (rdenA_exp     ),
    .rdaddrsA (rdaddrsA[2:0] ),
    .rddataA  (rddataA_FP_exp),
    .rdenB    (rdenB_exp     ),
    .rdaddrsB (rdaddrsB[2:0] ),
    .rddataB  (rddataB_FP_exp),
    .ready    (ready_exp     ),
    
    .round_mode(round_mode_q2_del_5 ),
   
    .CPU_invalid  (CPU_invalid_exp  ),
    .CPU_overflow (CPU_overflow_exp ),
    .CPU_underflow(CPU_underflow_exp),
    .CPU_inexact  (CPU_inexact_exp  )
    );

always@(*) begin
    if (wren_fma) C_reg = CPU_C_reg;    
    else C_reg = 32'h0000_0000;
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