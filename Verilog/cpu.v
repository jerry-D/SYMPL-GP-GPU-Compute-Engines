`timescale 1ns/100ps
// Author:  Jerry D. Harthcock
// Version:  2.54  January 18, 2016
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

module CPU (
         PC,
         P_DATAi,
         PRAM_rddataA,     
         rdprog,
         srcA,
         srcB,
         dest_q2, 
         pre_PC,        
         tpRAM_1_rddataA,  
         tpRAM_1_rddataB,
         resultout,                                         
         rdsrcA,
         rdsrcB,
         rdconstA,         
         wrcycl,
         CLK,
         RESET_IN,
         CPU_done,
         dsize,
         
         DMA0wren,
         DMA0wraddrs,
         DMA0rden,
         DMA0rdaddrs,
         DMA0collide,
         DMA0_IRQ,
         
         GPU3_RESET,         
         GPU2_RESET,         
         GPU1_RESET,         
         GPU0_RESET,
         
         IRQ_in,
         
         SWBRKdet,
         byte_swap
         );
          
output  [19:0] PC;
input   [31:0] P_DATAi;
input   [31:0] PRAM_rddataA;     
output         rdprog;
output  [23:0] srcA;
output  [23:0] srcB;
output  [23:0] dest_q2;
output  [19:0] pre_PC;
input   [31:0] tpRAM_1_rddataA;  
input   [31:0] tpRAM_1_rddataB;
output  [31:0] resultout;
output         rdsrcA;
output         rdsrcB;
output         rdconstA;
output         wrcycl;
input          CLK;
input          RESET_IN;
output         CPU_done;
output         dsize;

output         DMA0wren;
output  [23:0] DMA0wraddrs;
output         DMA0rden;
output  [23:0] DMA0rdaddrs;
input          DMA0collide;
output         DMA0_IRQ;

output         GPU3_RESET;
output         GPU2_RESET;
output         GPU1_RESET;
output         GPU0_RESET;

input   [15:0] IRQ_in;   //inverted input order for priority encoder

output         SWBRKdet;

output         byte_swap;

//register map                                                                                                                                      
parameter   AR3_ADDRS     = 24'h000073;
parameter   AR2_ADDRS     = 24'h000072;
parameter   AR1_ADDRS     = 24'h000071;
parameter   AR0_ADDRS     = 24'h000070;
parameter	PC_ADDRS 	  = 24'h00006F;	
parameter	PC_COPY 	  = 24'h00006E;	
parameter	ST_ADDRS 	  = 24'h00006D;	
parameter   RPT_ADDRS     = 24'h00006C; 
parameter   SPSH_ADDRS    = 24'h00006B; 
parameter   SPOP_ADDRS    = 24'h00006A; 
parameter   SNOP_ADDRS    = 24'h000069; 
parameter   SP_ADDRS      = 24'h000068; 
parameter   LPCNT1_ADDRS  = 24'h000067; 
parameter   LPCNT0_ADDRS  = 24'h000066; 
parameter   TIMER_ADDRS   = 24'h000065; 
parameter   CREG_ADDRS    = 24'h000064;
parameter   CAPT3_ADDRS   = 24'h000063; 
parameter   CAPT2_ADDRS   = 24'h000062; 
parameter   CAPT1_ADDRS   = 24'h000061; 
parameter   CAPT0_ADDRS   = 24'h000060; 
parameter   INTEN_ADDRS   = 24'h00005F;
parameter   DMA0_CSR      = 24'h00005E; 
parameter   DMA0_RDADDRS  = 24'h00005D;
parameter   DMA0_WRADDRS  = 24'h00005C;
parameter   VECT_ADDRS    = 24'h00005B; 

parameter	MOV_	= 4'b0000;		
parameter	AND_	= 4'b0001;
parameter	OR_	    = 4'b0010;
parameter	XOR_	= 4'b0011;
parameter	BTB_	= 4'b0100;			  //bit test and branch
parameter	BCND_	= 4'b0100; 			  //branch on condition
parameter   DBNZ_   = 4'b0100;            //decrement srcB and branch if result is not zero
parameter	SHFT_	= 4'b0101;
parameter	ADD_	= 4'b0110;
parameter	ADDC_	= 4'b0111;
parameter   SUB_    = 4'b1000;
parameter   SUBB_   = 4'b1001;
parameter   MUL_    = 4'b1010;

parameter   LEFT_  = 3'b000;
parameter   LSL_   = 3'b001;
parameter   ASL_   = 3'b010;
parameter   ROL_   = 3'b011;
parameter   RIGHT_ = 3'b100;
parameter   LSR_   = 3'b101;
parameter   ASR_   = 3'b110;
parameter   ROR_   = 3'b111;          
 
reg [19:0] pc_q1;
reg [1:0] constn_q1;         // 00 = no const lookup, 10 = srcA, 01 = srcB, 11 = immediate
reg [3:0] opcode_q1;
reg [23:0] srcA_q1;
reg [23:0] srcB_q1;
reg [7:0] OPdest_q1;
reg [7:0] OPsrcA_q1;
reg [7:0] OPsrcB_q1;

// state2 read
reg [19:0] pc_q2;
reg [3:0] opcode_q2;
reg [23:0] srcA_q2;
reg [23:0] srcB_q2;
reg [7:0] OPdest_q2;
reg [7:0] OPsrcA_q2;
reg [7:0] OPsrcB_q2;

reg [31:0] CPU_AR3;
reg [31:0] CPU_AR2;
reg [31:0] CPU_AR1;
reg [31:0] CPU_AR0;

reg [23:0] CPU_SP;
reg [23:0] CPU_SP_read;

reg [15:0] INTEN;  //general-purpose interrupt enable register, which includes GPU swbrkdet, and GPU DONE inputs

reg [19:0] CPU_PC;
reg [19:0] CPU_PC_COPY;
reg [31:0] CPU_timer;
reg [31:0] CPU_timercmpr;

reg GPU3_RESET;
reg GPU2_RESET;
reg GPU1_RESET;
reg GPU0_RESET; 

reg CPU_IRQ_IE;
reg CPU_alt_del_nxact; 
reg CPU_alt_del_unfl;  
reg CPU_alt_del_ovfl;  
reg CPU_alt_del_div0;  
reg CPU_alt_del_inv;   
reg CPU_alt_nxact_handl;
reg CPU_alt_unfl_handl;
reg CPU_alt_ovfl_handl;
reg CPU_alt_div0_handl;
reg CPU_alt_inv_handl;
reg CPU_inexact_flag;
reg CPU_underflow_flag;
reg CPU_overflow_flag;
reg CPU_divby0_flag;
reg CPU_invalid_flag;

reg CPU_Z;
reg CPU_C;
reg CPU_N;
reg CPU_V;
reg CPU_done;   
    
reg [31:0] CPU_C_reg;

reg [2:0] STATE;
reg [1:0] CPU_pipe_flush;

reg [31:0] wrsrcAdata;
reg [31:0] wrsrcBdata;
 
reg [31:0] resultout;
reg        Z_q2;
reg        C_q2;
reg        N_q2;
reg        V_q2;

reg        CPU_ld_vector_q1;
reg        CPU_ld_vector_q2;
reg        CPU_ld_vector_q3;

//loop counter for DBNZ
reg [14:0] CPU_LPCNT0;
reg [14:0] CPU_LPCNT1;

reg [15:0] shiftbucket;
reg [31:0] rdSrcAdata;
reg [31:0] rdSrcBdata; 
reg [19:0] pre_PC;

reg [1:0]  round_mode_q1;

reg [23:0] REPEAT;

reg wrdisable;

reg [31:0] brlshft_ROR;
reg [31:0] brlshft_ROL;

reg fp_ready_q2;
reg fp_sel_q2;

reg [3:0] IRQ_VECT; 

wire [19:0] PC;

wire rddisable; 

wire [2:0] shiftype;
wire [3:0] shiftamount;
wire [4:0] shiftamount1;
wire       sb;
wire [16:0] sbits;

wire [1:0] round_mode; 
wire    rdconstA;
wire    SWBRKdet;
wire    rdcycl;
wire    wrcycl;

wire [3:0] exc_codeA;
wire [3:0] exc_codeB;

wire fp_ready_q1;

wire [31:0] PRAM_rddataA;

wire [31:0] tpRAM_0_rddataA; 
wire [31:0] tpRAM_1_rddataA; 
wire [31:0] tpRAM_0_rddataB; 
wire [31:0] tpRAM_1_rddataB; 

wire [3:0]  opcode;
wire [1:0]  constn;

wire [23:0] srcA;
wire [23:0] srcB;
wire [23:0] srcAout;
wire [23:0] srcBout;

wire [7:0] OPdest;    
wire [7:0] OPsrcA;
wire [7:0] OPsrcB;

wire [31:0] adder_out;
wire adder_CO;
wire adder_OVO;    
wire adder_ZO; 

wire [31:0] bitsel;
wire discont;

wire LD_PC;

wire rdprog; 
wire rdsrcA; 
wire rdsrcB;
wire [19:0] next_PC;  
wire RESET_IN;
wire RESET;

wire RPT_not_z;

wire [31:0] CPU_STATUS;
wire [31:0] CPU_STATUSq2;

wire pipe_flush;

wire [14:0] CPU_LPCNT1_dec;
wire [14:0] CPU_LPCNT0_dec;

wire CPU_LPCNT1_nz;
wire CPU_LPCNT0_nz;

wire CPU_NMI;
wire CPU_IRQ;

wire [19:0] CPU_vector;
wire CPU_ld_vector;
wire CPU_NMI_ack;  
wire CPU_IRQ_ack; 

wire CPU_invalid_imm;  
wire CPU_divby0_imm;   
wire CPU_overflow_imm; 
wire CPU_underflow_imm;
wire CPU_inexact_imm;  

wire CPU_divby0_del;
wire CPU_overflow_del;
wire CPU_underflow_del;
wire CPU_inexact_del;


wire bitmatch;

wire adder_CI; 
   
wire [23:0] DMA0wraddrs;
wire [23:0] DMA0rdaddrs;
wire [31:0] CPU_DMA0_rddataA;
wire [31:0] CPU_DMA0_rddataB;
wire DMA0wren;
wire DMA0rden;
wire DMA0_IRQ;

wire DMA0_rd_selA;
wire DMA0_rd_selB;
wire DMA0_wr_sel;

wire [31:0] F128_rddataA;
wire [31:0] F128_rddataB;

wire byte_swap;

wire [1:0] dsize;

wire fp_sel_q1;
wire CPU_rewind_PC;

wire [31:0] CPU_capt_dataA;
wire [31:0] CPU_capt_dataB;

wire CPU_EXC_in_service;      
wire CPU_invalid_in_service;  
wire CPU_divby0_in_service;   
wire CPU_overflow_in_service; 
wire CPU_underflow_in_service;
wire CPU_inexact_in_service; 

wire CPU_invalid;  
wire CPU_divby0; 
wire CPU_overflow; 
wire CPU_underflow;
wire CPU_inexact;
 
wire CPU_CREG_wr;  

wire [2:0] GPUs; // number of quad-shader GPUs available 
wire GPU3_done;  //GPU done bits ordinarily should come into CPU core via IRQ_in inputs and do assignments here
wire GPU2_done;
wire GPU1_done;
wire GPU0_done;

assign GPU3_done = IRQ_in[3];
assign GPU2_done = IRQ_in[2];
assign GPU1_done = IRQ_in[1];
assign GPU0_done = IRQ_in[0];  //GPU0 has highest priority

assign GPUs[2:0] = GPU3_done + GPU2_done + GPU1_done + GPU0_done;                                                                                                    

assign DMA0_rd_selA = rdsrcA & ((srcA==DMA0_RDADDRS) | (srcA==DMA0_WRADDRS) | (srcA==DMA0_CSR));   
assign DMA0_rd_selB = rdsrcB & ((srcB==DMA0_RDADDRS) | (srcB==DMA0_WRADDRS) | (srcB==DMA0_CSR));   
assign DMA0_wr_sel = wrcycl & ((dest_q2==DMA0_RDADDRS) | (dest_q2==DMA0_WRADDRS) | (dest_q2==DMA0_CSR));   

assign adder_CI = CPU_C; 

assign next_PC = CPU_PC + (~RPT_not_z ? 1'b1 : 1'b0);
assign PC = CPU_PC;

assign CPU_LPCNT1_dec = CPU_LPCNT1 - 1'b1;
assign CPU_LPCNT0_dec = CPU_LPCNT0 - 1'b1;

assign CPU_LPCNT1_nz = |CPU_LPCNT1_dec;
assign CPU_LPCNT0_nz = |CPU_LPCNT0_dec;

assign pipe_flush = |CPU_pipe_flush;

assign RESET = RESET_IN;
assign RPT_not_z = |REPEAT;   
     
assign srcA = srcAout;
assign srcB = srcBout;  


assign bitmatch = (|(bitsel & wrsrcBdata)) ^ OPsrcA_q2[6];
   
assign discont = ((((opcode_q2 == BTB_) & bitmatch) & ~pipe_flush) | 
                 ((dest_q2==PC_ADDRS) & wrcycl)    | 
                 CPU_ld_vector_q3 
                 ); // goes high exactly one clock before PC discontinuity actually occurs

assign LD_PC = RESET ;

assign rdprog = 1'b1; 
assign rdsrcA = rdcycl & ~constn[1]; 
assign rdsrcB = rdcycl & ~constn[0]; 

assign bitsel = 1'b1<< OPsrcA_q2[4:0];

assign round_mode = P_DATAi[31:30]; 
assign dsize =  P_DATAi[31:30];                                                                                                                                                                                                                    
assign constn = P_DATAi[29:28];
assign opcode = P_DATAi[27:24];
assign OPdest = P_DATAi[23:16];    
assign OPsrcA = P_DATAi[15:8];
assign OPsrcB = P_DATAi[7:0];

assign rddisable = 1'b0;
assign SWBRKdet = (opcode_q2==BTB_) & (dest_q2==8'h00) & (OPsrcA==8'h1F) & (OPsrcB==8'h64) & ~discont;  //relative BTBS (to self) of REPEAT reg ALWAYS == swbrk
assign fetch = STATE[2];
assign rdcycl = ~rddisable;
assign wrcycl = ~wrdisable & STATE[0] & ~pipe_flush;
assign sb = wrsrcAdata[31];

assign CPU_CREG_wr = wrcycl & (dest_q2==CREG_ADDRS);                                                                                                           

assign CPU_invalid   = CPU_invalid_imm;
assign CPU_divby0    = CPU_alt_del_div0  ? CPU_divby0_del    : CPU_divby0_imm;
assign CPU_overflow  = CPU_alt_del_ovfl  ? CPU_overflow_del  : CPU_overflow_imm;
assign CPU_underflow = CPU_alt_del_unfl  ? CPU_underflow_del : CPU_underflow_imm;
assign CPU_inexact   = CPU_alt_del_nxact ? CPU_inexact_del   : CPU_inexact_imm;

assign fp_sel_q1 = (((~|srcA_q1[12:8] & srcA_q1[7]) & ~constn_q1[1]) | ((~|srcB_q1[12:8] & srcB_q1[7]) & ~constn_q1[0])) & ~(opcode_q1==BTB_);

assign CPU_rewind_PC = ~fp_ready_q2 & fp_sel_q2;

assign sbits = {sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb};

assign shiftype = srcB_q2[6:4];
assign shiftamount = srcB_q2[3:0];
assign shiftamount1 = shiftamount + 1'b1;

assign rdconstA =  constn[1] & ~constn[0];
  
assign CPU_NMI = ~CPU_done & (CPU_timer==CPU_timercmpr);
assign CPU_IRQ = (INTEN[15] & IRQ_in[15]) |
                 (INTEN[14] & IRQ_in[14]) |
                 (INTEN[13] & IRQ_in[13]) |
                 (INTEN[12] & IRQ_in[12]) |
                 (INTEN[11] & IRQ_in[11]) |
                 (INTEN[10] & IRQ_in[10]) |
                 (INTEN[9]  & IRQ_in[9] ) |
                 (INTEN[8]  & IRQ_in[8] ) |
                 (INTEN[7]  & IRQ_in[7] ) |
                 (INTEN[6]  & IRQ_in[6] ) |
                 (INTEN[5]  & IRQ_in[5] ) |
                 (INTEN[4]  & IRQ_in[4] ) |
                 (INTEN[3]  & IRQ_in[3] ) |
                 (INTEN[2]  & IRQ_in[2] ) |
                 (INTEN[1]  & IRQ_in[1] ) |
                 (INTEN[0]  & IRQ_in[0] ) ;    //IRQ_in[0] has highest priority

assign  CPU_STATUSq2 = { 2'b10,
                         Z_q2 | V_q2,                // LTE (less than or equal)
                        ~Z_q2 & V_q2,                // LT  (less than)
                         ((dest_q2 == ST_ADDRS) & wrcycl) ? resultout[27] : GPU3_RESET,
                         ((dest_q2 == ST_ADDRS) & wrcycl) ? resultout[26] : GPU2_RESET,
                         ((dest_q2 == ST_ADDRS) & wrcycl) ? resultout[25] : GPU1_RESET,
                         ((dest_q2 == ST_ADDRS) & wrcycl) ? resultout[24] : GPU0_RESET,                         
                         1'b0,
                         CPU_IRQ,                    // CPU general-purpose interrupt request
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[21] : CPU_IRQ_IE,   //general-purpose interrupt global enable
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[20] : CPU_alt_del_nxact,                         
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[19] : CPU_alt_del_unfl,                         
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[18] : CPU_alt_del_ovfl,                         
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[17] : CPU_alt_del_div0,                         
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[16] : CPU_alt_del_inv,                         
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[15] : CPU_alt_nxact_handl,
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[14] : CPU_alt_unfl_handl,
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[13] : CPU_alt_ovfl_handl,
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[12] : CPU_alt_div0_handl,
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[11] : CPU_alt_inv_handl,
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[10] : CPU_inexact_flag,
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[9]  : CPU_underflow_flag,
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[8]  : CPU_overflow_flag,
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[7]  : CPU_divby0_flag,
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[6]  : CPU_invalid_flag,
                         ((dest_q2==ST_ADDRS) & wrcycl) ? resultout[5]  : CPU_done, 
                         1'b0,
                         V_q2,     
                         N_q2,     
                         C_q2,     
                         Z_q2
                         };
                         
                         
DATA_ADDRS_mod_CPU data_addrs_mod(
    .MOV_q0        (opcode==MOV_),  //for 16-bit table-read from program memory using "@"
    .CPU_SP        (CPU_SP    ),
    .CPU_SP_read   (CPU_SP_read),
    .CPU_AR3       (CPU_AR3   ),
    .CPU_AR2       (CPU_AR2   ),
    .CPU_AR1       (CPU_AR1   ),
    .CPU_AR0       (CPU_AR0   ),
    .constn        (constn    ),
    .OPdest_q2     (OPdest_q2 ),
    .OPsrcA        (OPsrcA    ),
    .OPsrcB        (OPsrcB    ),
    .dest          (dest_q2   ),
    .srcA          (srcAout   ),
    .srcB          (srcBout   ));   

ADDER_32 adder_32 (
    .SUBTRACT ((opcode_q2 == SUB_) | (opcode_q2 == SUBB_)),
    .TERM_A   (wrsrcAdata), 	  
	.TERM_B   (wrsrcBdata), 
	.CI       (((opcode_q2 == ADDC_) | (opcode_q2 == SUBB_))? adder_CI : 1'b0),  // carry in
	.ADDER_OUT(adder_out ), // adder out
	.CO       (adder_CO ),  // carry out
	.HCO      ( ), 		    // half carry out (aka aux. carry)
	.OVO      (adder_OVO ), // overflow out
    .ZERO     (adder_ZO )); // zero out    
    
RAM_tp #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    ram1024(
    .CLK(CLK),
    .wren(wrcycl & ~|dest_q2[23:10]),
    .wraddrs(dest_q2[9:0]),
    .wrdata(resultout),
    .rdenA(rdsrcA & ~|srcA[23:10]),
    .rdaddrsA(srcA[9:0]),
    .rddataA(tpRAM_0_rddataA),
    .rdenB(rdsrcB & ~|srcB[23:10]),
    .rdaddrsB(srcB[9:0]),
    .rddataB(tpRAM_0_rddataB)
    );
    
aSYMPL_func_CPU fpmath( 
   .RESET    (RESET),
   .CLK      (CLK ),
   .pc_q2    (pc_q2[11:0]),
   .opcode_q1(opcode_q1),
   .constn_q1 (constn_q1 ),
   .OPsrcA_q1(OPsrcA_q1),
   .OPsrcB_q1(OPsrcB_q1),
   .wren     (wrcycl & ~|dest_q2[23:8] & dest_q2[7]),
   .wraddrs  (dest_q2[6:0]),
   .rdSrcAdata (rdSrcAdata ),
   .rdSrcBdata (rdSrcBdata ),
   .rdenA    (rdsrcA & ~|srcA[23:8] & srcA[7]),
   .rdaddrsA (srcA[7:0]),
   .rddataA  (F128_rddataA),
   .rdenB    (rdsrcB & ~|srcB[23:8] & srcB[7]),
   .rddataB  (F128_rddataB),
   .rdaddrsB (srcB[7:0]),
   .CPU_C_reg(CPU_C_reg ),
   .exc_codeA(exc_codeA ), 
   .exc_codeB(exc_codeB ),
   
   .CPU_CREG_wr(CPU_CREG_wr), 
   
   .ready    (fp_ready_q1),
   
   .round_mode_q1(round_mode_q1    ),
      
   .CPU_invalid  (CPU_invalid_imm  ),
   .CPU_div_by_0 (CPU_divby0_imm   ),
   .CPU_overflow (CPU_overflow_imm ),
   .CPU_underflow(CPU_underflow_imm),
   .CPU_inexact  (CPU_inexact_imm  )
   );
     
exc_capture_CPU exc_capt(     // quasi-trace buffer
    .CLK            (CLK        ),
    .RESET          (RESET      ),
    .srcA_q1        (srcA_q1[13:0]),
    .srcB_q1        (srcB_q1[13:0]),
    .addrsMode_q1   (constn_q1  ),
    .dest_q2        (dest_q2[13:0]),
    .pc_q1          (pc_q1[13:0]),
    .rdSrcAdata     (F128_rddataA),
    .rdSrcBdata     (F128_rddataB),
    .exc_codeA      (exc_codeA  ),
    .exc_codeB      (exc_codeB  ),
    .rdenA          (rdsrcA & (srcA[13:2]==11'b0_0000_0110_00)),
    .rdenB          (rdsrcB & (srcB[13:2]==11'b0_0000_0110_00)),
    .round_mode_q1  (round_mode_q1       ),
    .ready_in       (fp_ready_q1         ),
    .alt_nxact_handl(CPU_alt_nxact_handl ),
    .alt_unfl_handl (CPU_alt_unfl_handl  ),
    .alt_ovfl_handl (CPU_alt_ovfl_handl  ),
    .alt_div0_handl (CPU_alt_div0_handl  ),
    .alt_inv_handl  (CPU_alt_inv_handl   ),
    .invalid        (CPU_invalid_del     ),
    .divby0         (CPU_divby0_del      ),
    .overflow       (CPU_overflow_del    ),
    .underflow      (CPU_underflow_del   ),
    .inexact        (CPU_inexact_del     ),
    .capt_dataA     (CPU_capt_dataA      ),
    .capt_dataB     (CPU_capt_dataB      )
    );                                      

int_cntrl_CPU int_cntrl (
    .CLK                  (CLK          ),
    .RESET                (RESET        ),
    .PC                   (PC           ),
    .opcode_q2            (opcode_q2    ),
    .srcA_q2              (srcA_q2      ),
    .OPsrcA_q2            (OPsrcA_q2    ),
    .NMI                  (CPU_NMI      ),
    .inexact_exc          (CPU_inexact   & CPU_alt_nxact_handl),
    .underflow_exc        (CPU_underflow & CPU_alt_unfl_handl ),
    .overflow_exc         (CPU_overflow  & CPU_alt_ovfl_handl ),
    .divby0_exc           (CPU_divby0    & CPU_alt_div0_handl ),
    .invalid_exc          (CPU_invalid   & CPU_alt_inv_handl  ),
    .IRQ                  (CPU_IRQ      ),
    .IRQ_IE               (CPU_IRQ_IE   ),
    .vector               (CPU_vector   ),
    .ld_vector            (CPU_ld_vector),
    .NMI_ack              (CPU_NMI_ack  ),
    .EXC_ack              (CPU_EXC_ack  ),
    .IRQ_ack              (CPU_IRQ_ack  ),
    .EXC_in_service       (CPU_EXC_in_service      ),
    .invalid_in_service   (CPU_invalid_in_service  ),
    .divby0_in_service    (CPU_divby0_in_service   ),
    .overflow_in_service  (CPU_overflow_in_service ),
    .underflow_in_service (CPU_underflow_in_service),
    .inexact_in_service   (CPU_inexact_in_service  ),
    .wrcycl               (wrcycl       ),
    .pipe_flush           (|pipe_flush  )
    );   

aSYMPL_DMA dma0(
    .CLK       (CLK             ),
    .RESET     (RESET           ),
    .wren      (DMA0_wr_sel     ),
    .wraddrs   (dest_q2[1:0]    ),
    .wrdata    (resultout       ),
    .rdenA     (DMA0_rd_selA    ),
    .rdenB     (DMA0_rd_selB    ),
    .rdaddrsA  (srcA[1:0]       ),
    .rdaddrsB  (srcB[1:0]       ),
    .rddataA   (CPU_DMA0_rddataA),
    .rddataB   (CPU_DMA0_rddataB),
    .DMAwren   (DMA0wren        ),
    .DMAwraddrs(DMA0wraddrs     ),
    .DMArden   (DMA0rden        ),
    .DMArdaddrs(DMA0rdaddrs     ),
    .DMAcollide(DMA0collide     ),
    .DMA_IRQ   (DMA0_IRQ        ),
    .byte_swap (byte_swap       )
    );

wire [15:0] IRQ_in_swapped;
assign IRQ_in_swapped[15:0] = {IRQ_in[0], IRQ_in[1], IRQ_in[2], IRQ_in[3], IRQ_in[4], IRQ_in[5], IRQ_in[6], IRQ_in[7], IRQ_in[8], IRQ_in[9], IRQ_in[10], IRQ_in[11], IRQ_in[12], IRQ_in[13], IRQ_in[14], IRQ_in[15]};    
always @(*) 
        casex(IRQ_in_swapped)
            16'b1xxxxxxxxxxxxxxx : IRQ_VECT = 4'h0;    
            16'b01xxxxxxxxxxxxxx : IRQ_VECT = 4'h1;    
            16'b001xxxxxxxxxxxxx : IRQ_VECT = 4'h2;    
            16'b0001xxxxxxxxxxxx : IRQ_VECT = 4'h3;    
            16'b00001xxxxxxxxxxx : IRQ_VECT = 4'h4;    
            16'b000001xxxxxxxxxx : IRQ_VECT = 4'h5;    
            16'b0000001xxxxxxxxx : IRQ_VECT = 4'h6;    
            16'b00000001xxxxxxxx : IRQ_VECT = 4'h7;    
            16'b000000001xxxxxxx : IRQ_VECT = 4'h8;    
            16'b0000000001xxxxxx : IRQ_VECT = 4'h9;    
            16'b00000000001xxxxx : IRQ_VECT = 4'hA;    
            16'b000000000001xxxx : IRQ_VECT = 4'hB;    
            16'b0000000000001xxx : IRQ_VECT = 4'hC;    
            16'b00000000000001xx : IRQ_VECT = 4'hD;    
            16'b000000000000001x : IRQ_VECT = 4'hE;    
            16'b0000000000000001 : IRQ_VECT = 4'hF;    
        endcase
               
always @(*) begin
    case (shiftamount)
        4'h0 : brlshft_ROR = {wrsrcAdata[0],    wrsrcAdata[31:1]} ;
        4'h1 : brlshft_ROR = {wrsrcAdata[1:0],  wrsrcAdata[31:2]} ;
        4'h2 : brlshft_ROR = {wrsrcAdata[2:0],  wrsrcAdata[31:3]} ;
        4'h3 : brlshft_ROR = {wrsrcAdata[3:0],  wrsrcAdata[31:4]} ;
        4'h4 : brlshft_ROR = {wrsrcAdata[4:0],  wrsrcAdata[31:5]} ;
        4'h5 : brlshft_ROR = {wrsrcAdata[5:0],  wrsrcAdata[31:6]} ;
        4'h6 : brlshft_ROR = {wrsrcAdata[6:0],  wrsrcAdata[31:7]} ;
        4'h7 : brlshft_ROR = {wrsrcAdata[7:0],  wrsrcAdata[31:8]} ;
        4'h8 : brlshft_ROR = {wrsrcAdata[8:0],  wrsrcAdata[31:9]} ;
        4'h9 : brlshft_ROR = {wrsrcAdata[9:0],  wrsrcAdata[31:10]};
        4'hA : brlshft_ROR = {wrsrcAdata[10:0], wrsrcAdata[31:11]};
        4'hB : brlshft_ROR = {wrsrcAdata[11:0], wrsrcAdata[31:12]};
        4'hC : brlshft_ROR = {wrsrcAdata[12:0], wrsrcAdata[31:13]};
        4'hD : brlshft_ROR = {wrsrcAdata[13:0], wrsrcAdata[31:14]};
        4'hE : brlshft_ROR = {wrsrcAdata[14:0], wrsrcAdata[31:15]};
        4'hF : brlshft_ROR = {wrsrcAdata[15:0], wrsrcAdata[31:16]};
    endcase
end  

always @(*) begin
    case (shiftamount)
        4'h0 : brlshft_ROL = {wrsrcAdata[30:0], wrsrcAdata[31]}   ;
        4'h1 : brlshft_ROL = {wrsrcAdata[29:0], wrsrcAdata[31:30]};
        4'h2 : brlshft_ROL = {wrsrcAdata[28:0], wrsrcAdata[31:29]};
        4'h3 : brlshft_ROL = {wrsrcAdata[27:0], wrsrcAdata[31:28]};
        4'h4 : brlshft_ROL = {wrsrcAdata[26:0], wrsrcAdata[31:27]};
        4'h5 : brlshft_ROL = {wrsrcAdata[25:0], wrsrcAdata[31:26]};
        4'h6 : brlshft_ROL = {wrsrcAdata[24:0], wrsrcAdata[31:25]};
        4'h7 : brlshft_ROL = {wrsrcAdata[23:0], wrsrcAdata[31:24]};
        4'h8 : brlshft_ROL = {wrsrcAdata[22:0], wrsrcAdata[31:23]};
        4'h9 : brlshft_ROL = {wrsrcAdata[21:0], wrsrcAdata[31:22]};
        4'hA : brlshft_ROL = {wrsrcAdata[20:0], wrsrcAdata[31:21]};
        4'hB : brlshft_ROL = {wrsrcAdata[19:0], wrsrcAdata[31:20]};
        4'hC : brlshft_ROL = {wrsrcAdata[18:0], wrsrcAdata[31:19]};
        4'hD : brlshft_ROL = {wrsrcAdata[17:0], wrsrcAdata[31:18]};
        4'hE : brlshft_ROL = {wrsrcAdata[16:0], wrsrcAdata[31:17]};
        4'hF : brlshft_ROL = {wrsrcAdata[15:0], wrsrcAdata[31:16]};
    endcase
end        
    
always @(*) begin
    if (STATE[1]) casex (opcode_q2)
        BTB_  : wrdisable = 1'b1;                
        
        MOV_  ,	 // all other opcodes write is active during q2
        AND_  ,	
        OR_	  ,
        XOR_  ,	
        SHFT_ ,
        ADDC_ ,
        ADD_  ,
        SUB_  ,
        SUBB_ ,
        MUL_  :	wrdisable = 1'b0;
    
        default : wrdisable = 1'b1;
        endcase
    else wrdisable = 1'b1;
end        
          
always @(*) begin
    if (RESET) pre_PC = 20'h00100;
    else if (CPU_ld_vector) pre_PC = CPU_vector;
    else if ((dest_q2 == PC_ADDRS) && (wrcycl | CPU_ld_vector_q3)) pre_PC = resultout;
    else if ((opcode_q2 == BTB_) && ((|(bitsel & wrsrcBdata)) ^ OPsrcA_q2[6]) && ~pipe_flush) pre_PC = pc_q2 + {{12{dest_q2[7]}}, dest_q2[7:0]}; 
    else pre_PC = next_PC;
end    

wire srcAcollide;               
wire srcBcollide;               
assign srcAcollide = (srcA_q1==dest_q2) & wrcycl;
assign srcBcollide = (srcB_q1==dest_q2) & wrcycl;

always @(*) begin                                                                                                                       
                                                                                                                                        
         casex (srcA_q1)                                                                                                                
             24'b1xxxxxxxxxxxxxxxxxxxxxxx : rdSrcAdata = srcAcollide ? resultout : PRAM_rddataA;    //program memory table-read         
             24'b01xxxxxxxxxxxxxxxxxxxxxx,                                                                                              
             24'b001xxxxxxxxxxxxxxxxxxxxx,                                                                                              
             24'b0001xxxxxxxxxxxxxxxxxxxx,                                                                                              
             24'b00001xxxxxxxxxxxxxxxxxxx,                                                                                              
             24'b000001xxxxxxxxxxxxxxxxxx,                                                                                              
             24'b0000001xxxxxxxxxxxxxxxxx,                                                                                              
             24'b00000001xxxxxxxxxxxxxxxx,                                                                                              
             24'b000000001xxxxxxxxxxxxxxx,                                                                                              
             24'b0000000001xxxxxxxxxxxxxx,                                                                                              
             24'b00000000001xxxxxxxxxxxxx,                                                                                              
             24'b000000000001xxxxxxxxxxxx,                                                                                              
             24'b0000000000001xxxxxxxxxxx : rdSrcAdata = srcAcollide ? resultout : tpRAM_1_rddataA;                                     
             24'b00000000000001xxxxxxxxxx,                                                                                              
             24'b000000000000001xxxxxxxxx,                                                                                              
             24'b0000000000000001xxxxxxxx : rdSrcAdata = srcAcollide ? resultout : tpRAM_0_rddataA;                                     
             24'b00000000000000001xxxxxxx : rdSrcAdata =  F128_rddataA;                                                                 
                                                                                                                                        
                      AR3_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CPU_AR3;                                                      
                      AR2_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CPU_AR2;                                                      
                      AR1_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CPU_AR1;                                                      
                      AR0_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CPU_AR0;                                                      
                       PC_ADDRS : rdSrcAdata = srcAcollide  ? resultout : {12'h000, CPU_PC};
                        PC_COPY : rdSrcAdata = srcAcollide  ? resultout : {12'h000, CPU_PC_COPY};
                       ST_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CPU_STATUSq2;
                       SP_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CPU_SP;
                   LPCNT1_ADDRS : rdSrcAdata = srcAcollide  ? resultout : {16'h0000, CPU_LPCNT1_nz, CPU_LPCNT1};
                   LPCNT0_ADDRS : rdSrcAdata = srcAcollide  ? resultout : {16'h0000, CPU_LPCNT0_nz, CPU_LPCNT0};
                    TIMER_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CPU_timer;
                       
                     CREG_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CPU_C_reg;                               
                       
                    CAPT3_ADDRS,
                    CAPT2_ADDRS,
                    CAPT1_ADDRS,
                    CAPT0_ADDRS : rdSrcAdata = CPU_capt_dataA;                    
                                                                                                                          
                       DMA0_CSR : rdSrcAdata = srcAcollide  ? resultout : CPU_DMA0_rddataA; 
                   DMA0_RDADDRS : rdSrcAdata = srcAcollide  ? resultout : CPU_DMA0_rddataA;
                   DMA0_WRADDRS : rdSrcAdata = srcAcollide  ? resultout : CPU_DMA0_rddataA;
                   
                  INTEN_ADDRS   : rdSrcAdata = srcAcollide  ? {IRQ_in[15:0], resultout[15:0]} : {IRQ_in[15:0], INTEN[15:0]};
                    VECT_ADDRS  : rdSrcAdata = {GPUs[2:0], 25'h0000_000, IRQ_VECT};
                                                                                                          
             24'b0000000000000000010xxxxx : rdSrcAdata = srcAcollide  ? resultout : tpRAM_0_rddataA; 
             24'b000000000000000000xxxxxx : rdSrcAdata = srcAcollide  ? resultout : tpRAM_0_rddataA; 
                                                 
             default : rdSrcAdata = 32'h0000_0000;  
         endcase                        
end    
 
always @(*) begin
         
         casex (srcB_q1)                            
             24'b01xxxxxxxxxxxxxxxxxxxxxx,       
             24'b001xxxxxxxxxxxxxxxxxxxxx,       
             24'b0001xxxxxxxxxxxxxxxxxxxx,       
             24'b00001xxxxxxxxxxxxxxxxxxx,       
             24'b000001xxxxxxxxxxxxxxxxxx,       
             24'b0000001xxxxxxxxxxxxxxxxx,       
             24'b00000001xxxxxxxxxxxxxxxx,       
             24'b000000001xxxxxxxxxxxxxxx,       
             24'b0000000001xxxxxxxxxxxxxx,  
             24'b00000000001xxxxxxxxxxxxx,  
             24'b000000000001xxxxxxxxxxxx,  
             24'b0000000000001xxxxxxxxxxx : rdSrcBdata = srcBcollide ? resultout : tpRAM_1_rddataB;
             24'b00000000000001xxxxxxxxxx,  
             24'b000000000000001xxxxxxxxx,  
             24'b0000000000000001xxxxxxxx : rdSrcBdata = srcBcollide ? resultout : tpRAM_0_rddataB;  
             24'b00000000000000001xxxxxxx : rdSrcBdata =  F128_rddataB;                
             
                      AR3_ADDRS : rdSrcBdata = srcBcollide  ? resultout : CPU_AR3;                                                      
                      AR2_ADDRS : rdSrcBdata = srcBcollide  ? resultout : CPU_AR2;                                                      
                      AR1_ADDRS : rdSrcBdata = srcBcollide  ? resultout : CPU_AR1;                                                      
                      AR0_ADDRS : rdSrcBdata = srcBcollide  ? resultout : CPU_AR0;                                                      
                       PC_ADDRS : rdSrcBdata = srcBcollide  ? resultout : {12'h000, CPU_PC};
                        PC_COPY : rdSrcBdata = srcBcollide  ? resultout : {12'h000, CPU_PC_COPY};
                       ST_ADDRS : rdSrcBdata = srcBcollide  ? resultout : CPU_STATUSq2;
                       SP_ADDRS : rdSrcBdata = srcBcollide  ? resultout : CPU_SP;
                   LPCNT1_ADDRS : rdSrcBdata = srcBcollide  ? resultout : {16'h0000, CPU_LPCNT1_nz, CPU_LPCNT1};
                   LPCNT0_ADDRS : rdSrcBdata = srcBcollide  ? resultout : {16'h0000, CPU_LPCNT0_nz, CPU_LPCNT0};
                    TIMER_ADDRS : rdSrcBdata = srcBcollide  ? resultout : CPU_timer;
                       
                     CREG_ADDRS : rdSrcBdata = srcBcollide  ? resultout : CPU_C_reg;                               
                       
                    CAPT3_ADDRS,
                    CAPT2_ADDRS,
                    CAPT1_ADDRS,
                    CAPT0_ADDRS : rdSrcBdata = CPU_capt_dataB;                    
                                                                                                                          
                       DMA0_CSR : rdSrcBdata = srcBcollide  ? resultout : CPU_DMA0_rddataB; 
                   DMA0_RDADDRS : rdSrcBdata = srcBcollide  ? resultout : CPU_DMA0_rddataB;
                   DMA0_WRADDRS : rdSrcBdata = srcBcollide  ? resultout : CPU_DMA0_rddataB;
                   
                  INTEN_ADDRS   : rdSrcBdata = srcBcollide  ? {IRQ_in[15:0], resultout[15:0]} : {IRQ_in[15:0], INTEN[15:0]};
                    VECT_ADDRS  : rdSrcBdata = {GPUs[2:0], 25'h0000_000, IRQ_VECT};
                                                                                                          
             24'b0000000000000000010xxxxx : rdSrcBdata = srcBcollide  ? resultout : tpRAM_0_rddataB; 
             24'b000000000000000000xxxxxx : rdSrcBdata = srcBcollide  ? resultout : tpRAM_0_rddataB; 
                                                 
             default : rdSrcBdata = 32'h0000_0000;  
         endcase                      
end    

wire PC_stack_op;
assign PC_stack_op = ((opcode_q2==MOV_) & ((OPdest_q2==PC_ADDRS) & (OPsrcA_q2==(SP_ADDRS+1))) | ((OPdest_q2==(SP_ADDRS+2)) & (OPsrcA_q2==PC_ADDRS)));    //pop or push PC
  
always @(*)  begin     
    if (~|STATE[1:0]) begin 
        {Z_q2, C_q2, N_q2, V_q2} = {1'b1, 1'b0, 1'b0, 1'b0};
        resultout = 32'h00000000;
    end    
    else
        casex (opcode_q2)
            MOV_  : begin
                       resultout = wrsrcAdata;
                       Z_q2 = PC_stack_op ? CPU_Z : ~|wrsrcAdata;
                       N_q2 = PC_stack_op ? CPU_N :  wrsrcAdata[31];
                       C_q2 = CPU_C;
                       V_q2 = CPU_V;
                    end    
                                 	
            OR_   :	begin
                       resultout = wrsrcAdata | wrsrcBdata;
                       Z_q2 = ~|(wrsrcAdata | wrsrcBdata);
                       N_q2 = wrsrcAdata[31] | wrsrcBdata[31];
                       C_q2 = CPU_C;
                       V_q2 = CPU_V;
                    end    
            XOR_  :	begin
                       resultout = wrsrcAdata ^ wrsrcBdata;
                       Z_q2 = ~|(wrsrcAdata ^ wrsrcBdata);
                       N_q2 = wrsrcAdata[31] ^ wrsrcBdata[31];
                       C_q2 = CPU_C;
                       V_q2 = CPU_V;
                    end    
            AND_  :	begin
                       resultout = wrsrcAdata & wrsrcBdata;
                       Z_q2 = ~|(wrsrcAdata & wrsrcBdata);
                       N_q2 = wrsrcAdata[31] & wrsrcBdata[31];
                       C_q2 = CPU_C;
                       V_q2 = CPU_V;
                    end    
            ADDC_,
             ADD_,
            SUBB_, 
             SUB_ : begin
                        resultout = adder_out;
                        Z_q2 = adder_ZO;
                        V_q2 = adder_OVO;
                        C_q2 = adder_CO;
                        N_q2 = adder_out[31];
                    end 
             MUL_ : begin
                       resultout = wrsrcAdata[15:0] * wrsrcBdata[15:0];
                       Z_q2 = ~|wrsrcAdata[15:0] | ~|wrsrcBdata[15:0];
                       N_q2 = wrsrcAdata[15] ^ wrsrcBdata[15];
                       C_q2 = CPU_C;
                       V_q2 = CPU_V;
                    end                                                            
                                                             
            SHFT_ : begin
                        casex (shiftype)
                            ASL_,
                            LEFT_  : begin
                                        resultout = wrsrcAdata << shiftamount1;
                                        Z_q2 = CPU_Z;
                                        N_q2 = CPU_N;
                                        C_q2 = CPU_C;
                                        V_q2 = CPU_V;
                                     end   
                            LSL_   : begin
                                        {C_q2, resultout} = {wrsrcAdata, 1'b0} << shiftamount1;
                                        Z_q2 = CPU_Z;
                                        N_q2 = CPU_N;
                                        V_q2 = CPU_V;
                                     end 
                            ROL_   : begin
                                        resultout =  brlshft_ROL;
                                        Z_q2 = CPU_Z;
                                        N_q2 = CPU_N;
                                        C_q2 = CPU_C;
                                        V_q2 = CPU_V;
                                     end           
                            RIGHT_ : begin                                        
                                        resultout = wrsrcAdata >> shiftamount1;
                                        Z_q2 = CPU_Z;
                                        N_q2 = CPU_N;
                                        C_q2 = CPU_C;
                                        V_q2 = CPU_V;
                                     end   
                            LSR_   : begin
                                        {resultout, C_q2} = {1'b0, wrsrcAdata} >> shiftamount1;
                                        Z_q2 = CPU_Z;
                                        N_q2 = CPU_N;
                                        V_q2 = CPU_V;
                                     end   
                            ASR_   : begin
                                        {shiftbucket, resultout[31:0]} = {sbits, wrsrcAdata[31:1]} >> shiftamount1;
                                        Z_q2 = CPU_Z;
                                        N_q2 = CPU_N;
                                        C_q2 = CPU_C;
                                        V_q2 = CPU_V;
                                     end    
                            ROR_   : begin
                                        resultout =  brlshft_ROR;
                                        Z_q2 = CPU_Z;
                                        N_q2 = CPU_N;
                                        C_q2 = CPU_C;
                                        V_q2 = CPU_V;
                                     end    
                        endcase
                    end  
                    BTB_   : begin
                                resultout = wrsrcBdata;
                                Z_q2 = CPU_Z;
                                N_q2 = CPU_N;
                                C_q2 = CPU_C;
                                V_q2 = CPU_V;
                             end 
                                           
                   default : begin
                                resultout = wrsrcAdata;
                                Z_q2 = CPU_Z;
                                N_q2 = CPU_N;
                                C_q2 = CPU_C;
                                V_q2 = CPU_V;
                             end 
        endcase 
end 

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        REPEAT <= 24'h00_0000;
    end
    else if (( &constn && (OPdest==RPT_ADDRS[7:0])) && ~RPT_not_z && ~discont) REPEAT[23:0] <= {8'h00, P_DATAi[15:0]}; 
    else if ((~|constn && (OPdest==RPT_ADDRS[7:0])) && ~RPT_not_z && ~discont && &OPsrcA[6:4] && ~OPsrcA[3:2]) begin
        casex(OPsrcA)
            8'h74,
            8'h78,
            8'h7C : REPEAT[23:0] <= (wrcycl && (dest_q2==AR0_ADDRS)) ? resultout[23:0] : CPU_AR0[23:0];
 
            8'h75,
            8'h79,
            8'h7D : REPEAT[23:0] <= (wrcycl && (dest_q2==AR1_ADDRS)) ? resultout[23:0] : CPU_AR1[23:0];
                        
            8'h76,
            8'h7A,
            8'h7E : REPEAT[23:0] <= (wrcycl && (dest_q2==AR2_ADDRS)) ? resultout[23:0] : CPU_AR2[23:0];
                        
            8'h77,
            8'h7B,
            8'h7F : REPEAT[23:0] <= (wrcycl && (dest_q2==AR3_ADDRS)) ? resultout[23:0] : CPU_AR3[23:0];
        endcase                
    end 
    else if (|REPEAT[23:0]) REPEAT[23:0] <= REPEAT[23:0] - 1'b1;
end   

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        CPU_LPCNT1 <= 15'h0000;
        CPU_LPCNT0 <= 15'h0000;
    end 
    else begin
        if ((dest_q2==LPCNT0_ADDRS) && wrcycl) CPU_LPCNT0 <= resultout[14:0];
        else if ((opcode_q2==BTB_) && (srcB_q2==LPCNT0_ADDRS) && |CPU_LPCNT0 && ~pipe_flush) CPU_LPCNT0 <= CPU_LPCNT0_dec;
        
        if ((dest_q2==LPCNT1_ADDRS) && wrcycl) CPU_LPCNT1 <= resultout[14:0];
        else if ((opcode_q2==BTB_) && (srcB_q2==LPCNT1_ADDRS) && |CPU_LPCNT1 && ~pipe_flush) CPU_LPCNT1 <= CPU_LPCNT1_dec;
    end    
end

wire [1:0] OPmode_q1;
wire branch;
wire jump;
assign OPmode_q1 = round_mode_q1;
assign branch = (opcode_q2 == BTB_) & ((|(bitsel & wrsrcBdata)) ^ OPsrcA_q2[6]) & ~pipe_flush;
assign jump = (dest_q2 == PC_ADDRS) & wrcycl;
always @(posedge CLK or posedge RESET) begin  
                                                                   
    if (RESET) begin  
        // state 1 fetch                                                                                         
        pc_q1      <= 20'h00100;                                                                               
        constn_q1  <= 2'b00;                         
        opcode_q1 <= 4'b0000;                                                                                  
        srcA_q1   <= 24'h000000;                                                                                
        srcB_q1   <= 24'h000000;                                                                                
        OPdest_q1 <= 8'h00;
        OPsrcA_q1 <= 8'h00;
        OPsrcB_q1 <= 8'h00;
        
        round_mode_q1 <= 2'b00;

        // state2 read
        pc_q2     <= 20'h00100;
        opcode_q2 <= 4'b0000;
        srcA_q2   <= 24'h000000;                                                                                
        srcB_q2   <= 24'h000000;
        OPdest_q2 <= 8'h00;
        OPsrcA_q2 <= 8'h00;        
        OPsrcB_q2 <= 8'h00;        

        CPU_PC <= 20'h00100;
        CPU_PC_COPY <= 20'h00100;
        
        CPU_timer <= 32'h0000_0000; 
        CPU_timercmpr <= 20'h00000;         

        CPU_AR3 <= 32'h01000000;
        CPU_AR2 <= 32'h01000000;
        CPU_AR1 <= 32'h01000000;
        CPU_AR0 <= 32'h01000000;
        
        CPU_SP  <= 32'h007FFFFF;
        CPU_SP_read <= 32'h007FFFFF;
        
        GPU3_RESET <= 1'b1;
        GPU2_RESET <= 1'b1;
        GPU1_RESET <= 1'b1;
        GPU0_RESET <= 1'b1;
        
        CPU_alt_del_nxact   <= 1'b0;
        CPU_alt_del_unfl    <= 1'b0;
        CPU_alt_del_ovfl    <= 1'b0;
        CPU_alt_del_div0    <= 1'b0;
        CPU_alt_del_inv     <= 1'b0;
        CPU_alt_nxact_handl <= 1'b0;
        CPU_alt_unfl_handl  <= 1'b0;
        CPU_alt_ovfl_handl  <= 1'b0;
        CPU_alt_div0_handl  <= 1'b0;
        CPU_alt_inv_handl   <= 1'b0;
        CPU_inexact_flag    <= 1'b0;
        CPU_underflow_flag  <= 1'b0;
        CPU_overflow_flag   <= 1'b0;
        CPU_divby0_flag     <= 1'b0;
        CPU_invalid_flag    <= 1'b0;
        
        CPU_C_reg <= 32'h00000000;

        CPU_Z <= 1'b1;
        CPU_C <= 1'b0;
        CPU_N <= 1'b0;
        CPU_V <= 1'b0;
                
        CPU_done   <= 1'b1;
        CPU_IRQ_IE <= 1'b0;                //general-purpose interrupt global enable
        CPU_ld_vector_q1 <= 1'b0;
        CPU_ld_vector_q2 <= 1'b0;
        CPU_ld_vector_q3 <= 1'b0;
        
        fp_ready_q2 <= 1'b0;        
        fp_sel_q2   <= 1'b0;
                
        INTEN <= 16'h0000;
        
        wrsrcAdata <= 32'h00000000;
        wrsrcBdata <= 32'h00000000; 
        
        STATE <= 3'b100;
        
        CPU_pipe_flush <= 2'b00;
    end    
    else begin
///////////////////////////// PC /////////////////////////////

        CPU_pipe_flush[0] <= discont;  // if anything causes a PC discontinuity is detected (about to occur), then flush instr pipe (disable write) for 2 clocks
        CPU_pipe_flush[1] <= CPU_pipe_flush[0];
        
        CPU_ld_vector_q1 <= CPU_ld_vector;
        CPU_ld_vector_q2 <= CPU_ld_vector_q1;
        CPU_ld_vector_q3 <= CPU_ld_vector_q2;

        if (CPU_ld_vector) begin
            CPU_PC <= CPU_vector;
            if (branch) CPU_PC_COPY <= pc_q2 + {{12{dest_q2[7]}}, dest_q2[7:0]};
            else if (jump) CPU_PC_COPY = resultout[19:0];
            else CPU_PC_COPY = pc_q2 + 1'b1; 
        end   
        else if (CPU_ld_vector_q3) CPU_PC <= resultout[19:0];
        else if (CPU_rewind_PC) begin
            CPU_PC <= pc_q2;
            CPU_PC_COPY <= pc_q2 + 1'b1; 
        end 
        else if ((opcode_q2 == BTB_) && ((|(bitsel & wrsrcBdata)) ^ OPsrcA_q2[6]) && ~pipe_flush) begin            
            CPU_PC <= pc_q2 + {{12{dest_q2[7]}}, dest_q2[7:0]};             
            CPU_PC_COPY <= pc_q2 + 1'b1; 
        end         
        else if ((dest_q2 == PC_ADDRS) && wrcycl) begin
            CPU_PC <= resultout[19:0];                       
            CPU_PC_COPY <= pc_q2 + 1'b1;  //don't copy PC if interrupt vector fetch
        end      
        else  CPU_PC <= RPT_not_z ? CPU_PC : next_PC;  
        
    ////////////////////////// FP STATUS FLAGS //////////////////////////////

        if (CPU_invalid && ~CPU_alt_inv_handl) CPU_invalid_flag <= 1'b1;                                                      
        else if (wrcycl && (dest_q2==ST_ADDRS)) CPU_invalid_flag <= resultout[6];                       
                                                                                                                                                                                                                                                                       
        if (CPU_divby0 && ~CPU_alt_div0_handl) CPU_divby0_flag <= 1'b1;                                                                 
        else if (wrcycl && (dest_q2==ST_ADDRS)) CPU_divby0_flag <= resultout[7];                                  
                                                                                                                                         
        if (CPU_overflow && ~CPU_alt_ovfl_handl) CPU_overflow_flag <= 1'b1;
        else if (wrcycl && (dest_q2==ST_ADDRS)) CPU_overflow_flag <= resultout[8];
                 
        if (CPU_underflow && ~CPU_alt_unfl_handl) CPU_underflow_flag <= 1'b1;
        else if (wrcycl && (dest_q2==ST_ADDRS)) CPU_underflow_flag <= resultout[9];
                                                                                                                                  
        if (wrcycl && (dest_q2==ST_ADDRS)) CPU_inexact_flag <= resultout[10];                     
                                                                                                                                  
        if ((dest_q2==ST_ADDRS) && wrcycl) {GPU3_RESET, 
                                            GPU2_RESET, 
                                            GPU1_RESET, 
                                            GPU0_RESET, 
                                            CPU_IRQ_IE, 
                                            CPU_alt_del_nxact,  
                                            CPU_alt_del_unfl,   
                                            CPU_alt_del_ovfl,   
                                            CPU_alt_del_div0,   
                                            CPU_alt_del_inv,    
                                            CPU_alt_nxact_handl,
                                            CPU_alt_unfl_handl, 
                                            CPU_alt_ovfl_handl, 
                                            CPU_alt_div0_handl, 
                                            CPU_alt_inv_handl,
                                            CPU_done, 
                                            CPU_V, 
                                            CPU_N, 
                                            CPU_C, 
                                            CPU_Z} <= {resultout[27:24], resultout[21:11], resultout[5], resultout[3:0]}; 
        else if (wrcycl) {CPU_V, CPU_N, CPU_C, CPU_Z} <= {V_q2, N_q2, C_q2, Z_q2};
        
        if ((dest_q2==CREG_ADDRS) && wrcycl) CPU_C_reg <= resultout;
                        
        if ((dest_q2== INTEN_ADDRS) && wrcycl) INTEN <= resultout[15:0];
        

        if ((dest_q2==TIMER_ADDRS) && wrcycl) begin 
            CPU_timer <= 32'h00000;
            CPU_timercmpr <= resultout[31:0];
        end                   
        else if (~CPU_done && ~(CPU_timer==CPU_timercmpr)) CPU_timer <= CPU_timer + 1'b1;                   
                
        STATE <= {1'b1, STATE[2:1]};    //rotate right 1 into msb
     
        round_mode_q1 <= round_mode;
        pc_q1     <=  PC      ; 
        constn_q1  <=  constn ;                                                                                               
        opcode_q1 <=  opcode  ;                                                                                               
        srcA_q1   <=  srcA    ;                                                                                               
        srcB_q1   <=  srcB    ;                                                                                               
        OPdest_q1 <= OPdest   ;
        OPsrcA_q1 <= OPsrcA   ;
        OPsrcB_q1 <= OPsrcB   ;

        fp_ready_q2 <= fp_ready_q1;
        fp_sel_q2   <= fp_sel_q1;
        opcode_q2 <= opcode_q1;        
        pc_q2     <= pc_q1    ;               
        srcA_q2   <= srcA_q1  ; 
        srcB_q2   <= srcB_q1  ; 
        OPdest_q2 <= OPdest_q1;
        OPsrcA_q2 <= OPsrcA_q1;
        
        case (opcode_q1)      //read data stored temporarily in wrsrcAdata and wrsrcBdata
        
           MOV_	:  case(constn_q1)
                     2'b00 : begin    // both srcA and srcB are either direct or indirect
                                wrsrcAdata <= rdSrcAdata;             
                                wrsrcBdata <= rdSrcBdata; 
                             end
                     2'b01 : begin   //srcA is direct or indirect and srcB is 8-bit immediate
                                wrsrcAdata <= rdSrcAdata;             
                                wrsrcBdata <= {24'h000000, OPsrcB_q1};
                             end
                     2'b10 : begin  //srcA is table-read and srcB is direct or indirect 
                                wrsrcAdata <= rdSrcAdata;             
                                wrsrcBdata <= rdSrcBdata; 
                             end
                     2'b11 : begin //16-bit immediate with sign-extend only available for 16-bit immediate      
                                wrsrcAdata <= &OPmode_q1 ? {{16{OPsrcA_q1[7]}}, {OPsrcA_q1, OPsrcB_q1}} : {16'h0000, OPsrcA_q1, OPsrcB_q1};
                                wrsrcBdata <= rdSrcBdata; 
                             end
                   endcase           
            OR_,	
           XOR_,	
           AND_,	
           ADD_,
          ADDC_,
           SUB_,
          SUBB_,
           MUL_,
          SHFT_,
           BTB_	 : if (constn_q1[0]) begin    //immediate
                        wrsrcBdata <= {24'h000000, OPsrcB_q1};
                        wrsrcAdata <= rdSrcAdata;
                    end
                    else begin
                        wrsrcBdata <= rdSrcBdata;
                        wrsrcAdata <= rdSrcAdata;
                    end
        endcase

//SPSH_ADDRS    = 24'h00006B        
//SPOP_ADDRS    = 24'h00006A
//SNOP_ADDRS    = 24'h000069

        if (~discont && &constn && (OPdest==8'h68)) begin
            CPU_SP[23:0] <= {(&round_mode_q1 ? {1'b0, {7{OPsrcA[7]}}} : 8'h00), OPsrcA[7:0], OPsrcB[7:0]};  //immediate write to SP during newthreadq has priority over any update         
            CPU_SP_read  <= {(&round_mode_q1 ? {1'b0, {7{OPsrcA[7]}}} : 8'h00), OPsrcA[7:0], OPsrcB[7:0]};
        end    
        else if (wrcycl && (OPdest_q2==8'h6A)) begin
            CPU_SP <= {1'b0, resultout[22:0]}; //direct write to SP during q2 has priority over any update 
            CPU_SP_read  <= {(&round_mode_q1 ? {8{OPsrcA[7]}} : 8'h00), OPsrcA[7:0], OPsrcB[7:0]};
        end            
        if (~constn[1] && ~discont && (OPsrcA==8'h6A) && ~(CPU_SP[23:0]==24'h7FFFFF))  begin   //SP auto-post-increment of indirect srcA address SPOP occurs during instruction fetch (state0)
//SP POP      
              CPU_SP_read <= CPU_SP_read + 1'b1;  
              CPU_SP[23:0] <= CPU_SP[23:0] + 1'b1;
        end
              
        if (~constn[0] && ~discont && (OPsrcB==8'h6A) && ~(CPU_SP[23:0]==24'h7FFFFF))  begin   //SP auto-post-increment of indirect srcB address SPOP occurs during instruction fetch (state0)
              CPU_SP_read <= CPU_SP_read + 1'b1;  
              CPU_SP[23:0] <= CPU_SP[23:0] + 1'b1;
        end       
//SP PUSH               
        if (wrcycl && (OPdest_q2==8'h6B)) begin      
            CPU_SP_read[23:0] <= CPU_SP[23:0];       //used for SP POP
            CPU_SP[23:0] <= CPU_SP[23:0] - 1'b1;
        end

        if (~discont && &constn && (OPdest==8'h70)) CPU_AR0[23:0] <= {8'h00, OPsrcA[7:0], OPsrcB[7:0]};  //immediate write to ARn during newthreadq has priority over any update         
        else if (wrcycl && (OPdest_q2==8'h70)) CPU_AR0 <= |resultout[31:24] ? resultout : {CPU_AR0[31:24], resultout[23:0]}; //direct write to ARn during q2 has priority over any update         
        if (~constn[1] && ~discont && ((OPsrcA==8'h78) || (OPsrcA==8'h7C)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcA)
              8'h78 : CPU_AR0[23:0] <= CPU_AR0[23:0] + CPU_AR0[31:24];
              8'h7C : CPU_AR0[23:0] <= CPU_AR0[23:0] - CPU_AR0[31:24];
            endcase
        if (~constn[0] && ~discont && ((OPsrcB==8'h78) || (OPsrcB==8'h7C)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcB)
              8'h78 : CPU_AR0[23:0] <= CPU_AR0[23:0] + CPU_AR0[31:24];
              8'h7C : CPU_AR0[23:0] <= CPU_AR0[23:0] - CPU_AR0[31:24];
            endcase
        if (wrcycl)
            case (OPdest_q2)
              8'h78 : CPU_AR0[23:0] <= CPU_AR0[23:0] + CPU_AR0[31:24];
              8'h7C : CPU_AR0[23:0] <= CPU_AR0[23:0] - CPU_AR0[31:24];
            endcase

        if (~discont && &constn && (OPdest==8'h71)) CPU_AR1[23:0] <= {8'h00, OPsrcA[7:0], OPsrcB[7:0]};  //immediate write to ARn during newthreadq has priority over any update         
        else if (wrcycl && (OPdest_q2==8'h71)) CPU_AR1 <= |resultout[31:24] ? resultout : {CPU_AR1[31:24], resultout[23:0]}; //direct write to ARn during q2 has priority over any update         
        if (~constn[1] && ~discont && ((OPsrcA==8'h79) || (OPsrcA==8'h7D)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcA)
              8'h79 : CPU_AR1[23:0] <= CPU_AR1[23:0] + CPU_AR1[31:24];
              8'h7D : CPU_AR1[23:0] <= CPU_AR1[23:0] - CPU_AR1[31:24];
            endcase
        if (~constn[0] && ~discont && ((OPsrcB==8'h79) || (OPsrcB==8'h7D)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcB)
              8'h79 : CPU_AR1[23:0] <= CPU_AR1[23:0] + CPU_AR1[31:24];
              8'h7D : CPU_AR1[23:0] <= CPU_AR1[23:0] - CPU_AR1[31:24];
            endcase
        if (wrcycl)
            case (OPdest_q2)
              8'h79 : CPU_AR1[23:0] <= CPU_AR1[23:0] + CPU_AR1[31:24];
              8'h7D : CPU_AR1[23:0] <= CPU_AR1[23:0] - CPU_AR1[31:24];
            endcase

        if (~discont && &constn && (OPdest==8'h72)) CPU_AR2[23:0] <= {8'h00, OPsrcA[7:0], OPsrcB[7:0]};  //immediate write to ARn during newthreadq has priority over any update         
        else if (wrcycl && (OPdest_q2==8'h72)) CPU_AR2 <= |resultout[31:24] ? resultout : {CPU_AR2[31:24], resultout[23:0]}; //direct write to ARn during q2 has priority over any update         
        if (~constn[1] && ~discont && ((OPsrcA==8'h7A) || (OPsrcA==8'h7E)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcA)
              8'h7A : CPU_AR2[23:0] <= CPU_AR2[23:0] + CPU_AR2[31:24];
              8'h7E : CPU_AR2[23:0] <= CPU_AR2[23:0] - CPU_AR2[31:24];
            endcase
        if (~constn[0] && ~discont && ((OPsrcB==8'h7A) || (OPsrcB==8'h7E)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcB)
              8'h7A : CPU_AR2[23:0] <= CPU_AR2[23:0] + CPU_AR2[31:24];
              8'h7E : CPU_AR2[23:0] <= CPU_AR2[23:0] - CPU_AR2[31:24];
            endcase
        if (wrcycl)
            case (OPdest_q2)
              8'h7A : CPU_AR2[23:0] <= CPU_AR2[23:0] + CPU_AR2[31:24];
              8'h7E : CPU_AR2[23:0] <= CPU_AR2[23:0] - CPU_AR2[31:24];
            endcase

        if (~discont && &constn && (OPdest==8'h73)) CPU_AR3[23:0] <= {8'h00, OPsrcA[7:0], OPsrcB[7:0]};  //immediate write to ARn during newthreadq has priority over any update         
        else if (wrcycl && (OPdest_q2==8'h73)) CPU_AR3 <= |resultout[31:24] ? resultout : {CPU_AR3[31:24], resultout[23:0]}; //direct write to ARn during q2 has priority over any update         
        if (~constn[1] && ~discont && ((OPsrcA==8'h7B) || (OPsrcA==8'h7F)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcA)
              8'h7B : CPU_AR3[23:0] <= CPU_AR3[23:0] + CPU_AR3[31:24];
              8'h7F : CPU_AR3[23:0] <= CPU_AR3[23:0] - CPU_AR3[31:24];
            endcase
        if (~constn[0] && ~discont && ((OPsrcB==8'h7B) || (OPsrcB==8'h7F)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcB)
              8'h7B : CPU_AR3[23:0] <= CPU_AR3[23:0] + CPU_AR3[31:24];
              8'h7F : CPU_AR3[23:0] <= CPU_AR3[23:0] - CPU_AR3[31:24];
            endcase
        if (wrcycl)
            case (OPdest_q2)
              8'h7B : CPU_AR3[23:0] <= CPU_AR3[23:0] + CPU_AR3[31:24];
              8'h7F : CPU_AR3[23:0] <= CPU_AR3[23:0] - CPU_AR3[31:24];
            endcase                
    end           
end
                                                      
endmodule