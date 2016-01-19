`timescale 1ns/100ps
// Author:  Jerry D. Harthcock
// Version:  2.53  January, 2016
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

module CGS (
         PC,
         P_DATAi,
         ROM_4k_rddataA,     
         rdprog,
         srcA,
         srcB,
         dest_q2, 
         pre_PC,        
         private_2048_rddataA,  
         private_2048_rddataB,
         resultout,
         rdsrcA,
         rdsrcB,
         rdconstA,         
         wrcycl,
         CLK,
         RESET_IN,
         CGS_done,
         
         DMA1wren,
         DMA1wraddrs,
         DMA1rden,
         DMA1rdaddrs,
         DMA1collide,
         
         DMA0wren,
         DMA0wraddrs,
         DMA0rden,
         DMA0rdaddrs,
         DMA0collide,
         
         shdr3_RESET,         
         shdr2_RESET,         
         shdr1_RESET,         
         shdr0_RESET,
         
         frc_IRQ_thread,
         done_thread,
         swbrkdet_thread,
         
         command,         
         
         SWBRKdet,
         byte_swap_wr,
         byte_swap_rd
         );
          
output  [11:0] PC;
input   [31:0] P_DATAi;
input   [31:0] ROM_4k_rddataA;     
output         rdprog;
output  [23:0] srcA;
output  [23:0] srcB;
output  [23:0] dest_q2;
output  [11:0] pre_PC;
input   [31:0] private_2048_rddataA;  
input   [31:0] private_2048_rddataB;
output  [31:0] resultout;
output         rdsrcA;
output         rdsrcB;
output         rdconstA;
output         wrcycl;
input          CLK;
input          RESET_IN;
output         CGS_done;

output         DMA1wren;
output  [23:0] DMA1wraddrs;
output         DMA1rden;
output  [23:0] DMA1rdaddrs;
input          DMA1collide;

output         DMA0wren;
output  [23:0] DMA0wraddrs;
output         DMA0rden;
output  [23:0] DMA0rdaddrs;
input          DMA0collide;

output         shdr3_RESET;
output         shdr2_RESET;
output         shdr1_RESET;
output         shdr0_RESET;

output  [15:0] frc_IRQ_thread;
input   [15:0] done_thread;
input   [15:0] swbrkdet_thread;

input   [31:0] command;

output         SWBRKdet;

output         byte_swap_wr;
output         byte_swap_rd;
                                                                                                                                      
parameter   AR3_ADDRS     = 24'h000073;
parameter   AR2_ADDRS     = 24'h000072;
parameter   AR1_ADDRS     = 24'h000071;
parameter   AR0_ADDRS     = 24'h000070;
parameter	PC_ADDRS 	  = 24'h00006F;	//address of each PC in private memory
parameter	PC_COPY 	  = 24'h00006E;	//status register address for each thread
parameter	ST_ADDRS 	  = 24'h00006D;	//status register address for each thread
parameter   RPT_ADDRS     = 24'h00006C;
parameter   SPSH_ADDRS    = 24'h00006B;         
parameter   SPOP_ADDRS    = 24'h00006A;         
parameter   SNOP_ADDRS    = 24'h000069;         
parameter   SP_ADDRS      = 24'h000068;
parameter   LPCNT1_ADDRS  = 24'h000067;    //loop counter 1 address
parameter   LPCNT0_ADDRS  = 24'h000066;    //loop counter 0 address
parameter   TIMER_ADDRS   = 24'h000065;
parameter   COMMAND_ADDRS = 24'h000064;   // command/semiphore address
parameter   FRC_IRQ_ADDRS = 24'h000063;   //force thread interrupt--can be used for forcing a breakpoint on a thread   
parameter   DMA1_CSR      = 24'h000062;
parameter   DMA1_RDADDRS  = 24'h000061;
parameter   DMA1_WRADDRS  = 24'h000060;
parameter   DONE_IE_ADDRS = 24'h00005F;   //interrupt enables for thread DONE and their status inputs
parameter   DMA0_CSR      = 24'h00005E;
parameter   DMA0_RDADDRS  = 24'h00005D;
parameter   DMA0_WRADDRS  = 24'h00005C;

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
 
// state 1 fetch
reg [11:0] pc_q1;
reg [1:0] constn_q1;         // 00 = no const lookup, 10 = srcA, 01 = srcB, 11 = immediate
reg [3:0] opcode_q1;
reg [23:0] srcA_q1;
reg [23:0] srcB_q1;
reg [7:0] OPdest_q1;
reg [7:0] OPsrcA_q1;
reg [7:0] OPsrcB_q1;

// state2 read
reg [1:0] page_q2;
reg [11:0] pc_q2;
reg [3:0] opcode_q2;
reg [23:0] srcA_q2;
reg [23:0] srcB_q2;
reg [7:0] OPdest_q2;
reg [7:0] OPsrcA_q2;
reg [7:0] OPsrcB_q2;

reg [31:0] CGS_AR3;
reg [31:0] CGS_AR2;
reg [31:0] CGS_AR1;
reg [31:0] CGS_AR0;

reg [23:0] CGS_SP;
reg [23:0] CGS_SP_read;

reg [11:0] CGS_PC;
reg [11:0] CGS_PC_COPY;
reg [31:0] CGS_timer;
reg [31:0] CGS_timercmpr;

reg  CGS_IRQ_IE;
reg  CGS_EXC_IE;


reg CGS_Z;
reg CGS_C;
reg CGS_N;
reg CGS_V;
reg CGS_done;   
    
reg [2:0] STATE;
reg [1:0] CGS_pipe_flush;

reg [31:0] wrsrcAdata;
reg [31:0] wrsrcBdata;
 
reg [31:0] resultout;
reg        Z_q2;
reg        C_q2;
reg        N_q2;
reg        V_q2;

reg shdr3_RESET;
reg shdr2_RESET;
reg shdr1_RESET;
reg shdr0_RESET;

reg [15:0] frc_IRQ_thread;
reg [15:0] DONE_IE;
reg [5:0]  IRQ_VECT;
reg        CGS_ld_vector_q1;
reg        CGS_ld_vector_q2;
reg        CGS_ld_vector_q3;

//loop counter for DBNZ
reg [14:0] CGS_LPCNT0;
reg [14:0] CGS_LPCNT1;

reg [15:0] shiftbucket;
reg [31:0] rdSrcAdata;
reg [31:0] rdSrcBdata; 
reg [11:0] pre_PC;

reg [23:0] REPEAT;

reg wrdisable;

reg [31:0] brlshft_ROR;
reg [31:0] brlshft_ROL;

wire [11:0] PC;

wire rddisable; 

wire [2:0] shiftype;
wire [3:0] shiftamount;
wire [4:0] shiftamount1;
wire       sb;
wire [16:0] sbits;

wire    rdconstA;
wire    SWBRKdet;
wire    rdcycl;
wire    wrcycl;

wire [31:0] CGS_RAM_rddataA;  
wire [31:0] CGS_RAM_rddataB;
  
wire [31:0] private_2048_rddataA; 
wire [31:0] private_2048_rddataB; 

wire [31:0] ROM_4k_rddataA;

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
wire [11:0] next_PC;  
wire RESET_IN;
wire RESET;

wire RPT_not_z;

wire [31:0] CGS_STATUS;
wire [31:0] CGS_STATUSq2;

wire pipe_flush;

wire [14:0] CGS_LPCNT1_dec;
wire [14:0] CGS_LPCNT0_dec;

wire CGS_LPCNT1_nz;
wire CGS_LPCNT0_nz;

wire CGS_NMI;
wire CGS_EXC;
wire CGS_IRQ;

wire [11:0] CGS_vector;
wire CGS_ld_vector;
wire CGS_NMI_ack;  
wire CGS_IRQ_ack; 

wire bitmatch;

wire adder_CI; 

wire [23:0] DMA1wraddrs;
wire [23:0] DMA1rdaddrs;
wire [31:0] CGS_DMA1_rddataA;
wire [31:0] CGS_DMA1_rddataB;
wire DMA1wren;
wire DMA1rden;
wire DMA1_IRQ;
   
wire [23:0] DMA0wraddrs;
wire [23:0] DMA0rdaddrs;
wire [31:0] CGS_DMA0_rddataA;
wire [31:0] CGS_DMA0_rddataB;
wire DMA0wren;
wire DMA0rden;
wire DMA0_IRQ;

wire DMA0_rd_selA;
wire DMA0_rd_selB;
wire DMA1_rd_selA;
wire DMA1_rd_selB;
wire DMA0_wr_sel;
wire DMA1_wr_sel;

wire byte_swap_wr;
wire byte_swap_rd;

wire [33:0] IRQ_in;

assign IRQ_in = {(done_thread[15:0] & DONE_IE[15:0]), swbrkdet_thread[15:0], DMA1_IRQ, DMA0_IRQ};

assign CGS_EXC = |command;

assign DMA0_rd_selA = rdsrcA & ((srcA==DMA0_RDADDRS) | (srcA==DMA0_WRADDRS) | (srcA==DMA0_CSR));   
assign DMA0_rd_selB = rdsrcB & ((srcB==DMA0_RDADDRS) | (srcB==DMA0_WRADDRS) | (srcB==DMA0_CSR));   
assign DMA1_rd_selA = rdsrcA & ((srcA==DMA1_RDADDRS) | (srcA==DMA1_WRADDRS) | (srcA==DMA1_CSR));   
assign DMA1_rd_selB = rdsrcB & ((srcB==DMA1_RDADDRS) | (srcB==DMA1_WRADDRS) | (srcB==DMA1_CSR));
assign DMA0_wr_sel = wrcycl & ((dest_q2==DMA0_RDADDRS) | (dest_q2==DMA0_WRADDRS) | (dest_q2==DMA0_CSR));   
assign DMA1_wr_sel = wrcycl & ((dest_q2==DMA1_RDADDRS) | (dest_q2==DMA1_WRADDRS) | (dest_q2==DMA1_CSR));   

assign adder_CI = CGS_C; 

assign next_PC = CGS_PC + (~RPT_not_z ? 1'b1 : 1'b0);
assign PC = CGS_PC;

assign CGS_LPCNT1_dec = CGS_LPCNT1 - 1'b1;
assign CGS_LPCNT0_dec = CGS_LPCNT0 - 1'b1;

assign CGS_LPCNT1_nz = |CGS_LPCNT1_dec;
assign CGS_LPCNT0_nz = |CGS_LPCNT0_dec;

assign pipe_flush = |CGS_pipe_flush;

assign RESET = RESET_IN;
assign RPT_not_z = |REPEAT;   
     
assign srcA = srcAout;
assign srcB = srcBout;  


assign bitmatch = (|(bitsel & wrsrcBdata)) ^ OPsrcA_q2[6];
   
assign discont = ((((opcode_q2 == BTB_) & bitmatch) & ~pipe_flush) | 
                 ((dest_q2==PC_ADDRS) & wrcycl)    | 
                 CGS_ld_vector_q3 
                 ); // goes high exactly one clock before PC discontinuity actually occurs

assign LD_PC = RESET ;

assign rdprog = 1'b1; 
assign rdsrcA = rdcycl & ~constn[1]; 
assign rdsrcB = rdcycl & ~constn[0]; 

assign bitsel = 1'b1<< OPsrcA_q2[4:0];
assign OPdest = P_DATAi[23:16];    
assign OPsrcA = P_DATAi[15:8];
assign OPsrcB = P_DATAi[7:0];

assign rddisable = 1'b0;
assign SWBRKdet = (opcode_q2==BTB_) & (dest_q2==8'h00) & (OPsrcA==8'h1F) & (OPsrcB==8'h64) & ~discont;  //relative BTBS (to self) of REPEAT reg ALWAYS == swbrk
assign fetch = STATE[2];
assign rdcycl = ~rddisable;
assign wrcycl = ~wrdisable & STATE[0] & ~pipe_flush;                                                                                                                                                                                                                    
assign opcode =  P_DATAi[27:24];
assign constn = P_DATAi[29:28];
assign sb = wrsrcAdata[31];

assign sbits = {sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb, sb};

assign shiftype = srcB_q2[6:4];
assign shiftamount = srcB_q2[3:0];
assign shiftamount1 = shiftamount + 1'b1;

assign rdconstA =  constn[1] & ~constn[0];
  
assign CGS_NMI = ~CGS_done & (CGS_timer==CGS_timercmpr);
assign CGS_IRQ = 1'b0;

assign  CGS_STATUSq2 =  {2'b10,
                         Z_q2 | V_q2,                // LTE (less than or equal)
                        ~Z_q2 & V_q2,                // LT  (less than)
                         12'b0000_0000_0000,
                         ((dest_q2 == ST_ADDRS) & wrcycl) ? resultout[12] : shdr3_RESET,
                         ((dest_q2 == ST_ADDRS) & wrcycl) ? resultout[11] : shdr2_RESET,
                         ((dest_q2 == ST_ADDRS) & wrcycl) ? resultout[10] : shdr1_RESET,
                         ((dest_q2 == ST_ADDRS) & wrcycl) ? resultout[9]  : shdr0_RESET,                         
                         CGS_IRQ,
                         CGS_EXC,
                         ((dest_q2 == ST_ADDRS) & wrcycl) ? resultout[6] : CGS_IRQ_IE,
                         ((dest_q2 == ST_ADDRS) & wrcycl) ? resultout[6] : CGS_EXC_IE,
                         2'b00,
                         ((dest_q2 == ST_ADDRS) & wrcycl) ? resultout[5] : CGS_done, 
                         1'b0,
                         V_q2,     
                         N_q2,     
                         C_q2,     
                         Z_q2};
                         
DATA_ADDRS_mod_CGS data_addrs_mod(
    .MOV_q0        (opcode==MOV_),  //for 16-bit table-read from program memory using "@"
    .CGS_SP        (CGS_SP    ),
    .CGS_SP_read   (CGS_SP_read),
    .CGS_AR3       (CGS_AR3   ),
    .CGS_AR2       (CGS_AR2   ),
    .CGS_AR1       (CGS_AR1   ),
    .CGS_AR0       (CGS_AR0   ),
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

//RAM32x32tp global_32 (
RAM_tp  #(.ADDRS_WIDTH(10), .DATA_WIDTH(32)) 
    ram1024(
    .CLK(CLK),
    .wren(wrcycl & (dest_q2[23:10]==14'h0000)),
    .wraddrs(dest_q2[9:0]),
    .wrdata(resultout),
    .rdenA(rdsrcA & (srcA[23:10]==14'h0000)),
    .rdaddrsA(srcA[9:0]),
    .rddataA(CGS_RAM_rddataA),
    .rdenB(rdsrcB & (srcB[23:10]==4'h0000)),
    .rdaddrsB(srcB[9:0]),
    .rddataB(CGS_RAM_rddataB));          

CGS_int_cntrl CGS_int_cntrl(
    .CLK             (CLK          ),
    .RESET           (RESET        ),
    .PC              (PC           ),
    .opcode_q2       (opcode_q2    ),
    .srcA_q2         (srcA_q2      ),
    .dest_q2         (dest_q2      ),
    .NMI             (CGS_NMI      ),
    .EXC             (CGS_EXC      ),
    .EXC_IE          (CGS_EXC_IE   ),
    .IRQ             (CGS_IRQ      ),
    .IRQ_IE          (CGS_IRQ_IE   ),
    .vector          (CGS_vector   ),
    .ld_vector       (CGS_ld_vector),
    .NMI_ack         (CGS_NMI_ack  ),
    .EXC_ack         (             ),
    .IRQ_ack         (CGS_IRQ_ack  ),
    .wrcycl          (wrcycl       ),
    .pipe_flush      (pipe_flush   )
    );   

aSYMPL_DMA dma1(
    .CLK       (CLK             ),
    .RESET     (RESET           ),
    .wren      (DMA1_wr_sel     ),
    .wraddrs   (dest_q2[1:0]    ),
    .wrdata    (resultout       ),
    .rdenA     (DMA1_rd_selA    ),
    .rdenB     (DMA1_rd_selB    ),
    .rdaddrsA  (srcA[1:0]       ),
    .rdaddrsB  (srcB[1:0]       ),
    .rddataA   (CGS_DMA1_rddataA),
    .rddataB   (CGS_DMA1_rddataB),
    .DMAwren   (DMA1wren        ),
    .DMAwraddrs(DMA1wraddrs     ),
    .DMArden   (DMA1rden        ),
    .DMArdaddrs(DMA1rdaddrs     ),
    .DMAcollide(DMA1collide     ),   
    .DMA_IRQ   (DMA1_IRQ        ),
    .byte_swap (byte_swap_wr    )
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
    .rddataA   (CGS_DMA0_rddataA),
    .rddataB   (CGS_DMA0_rddataB),
    .DMAwren   (DMA0wren        ),
    .DMAwraddrs(DMA0wraddrs     ),
    .DMArden   (DMA0rden        ),
    .DMArdaddrs(DMA0rdaddrs     ),
    .DMAcollide(DMA0collide     ),
    .DMA_IRQ   (DMA0_IRQ        ),
    .byte_swap (byte_swap_rd    )
    );

always @(*) begin
    casex(IRQ_in)
        34'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_x1 : IRQ_VECT = 6'h01;    //DMA channel 0 done
        34'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_1x : IRQ_VECT = 6'h02;    //DMA channel 1 done
        34'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxx1_xx : IRQ_VECT = 6'h03;    //swbrk detect thread0
        34'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxx1x_xx : IRQ_VECT = 6'h04;    //swbrk detect thread1
        34'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxx1xx_xx : IRQ_VECT = 6'h05;    //swbrk detect thread2
        34'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxx1xxx_xx : IRQ_VECT = 6'h06;    //swbrk detect thread3
        34'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxx1xxxx_xx : IRQ_VECT = 6'h07;    //swbrk detect thread4
        34'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xx1xxxxx_xx : IRQ_VECT = 6'h08;    //swbrk detect thread5
        34'bxxxxxxxx_xxxxxxxx_xxxxxxxx_x1xxxxxx_xx : IRQ_VECT = 6'h09;    //swbrk detect thread6
        34'bxxxxxxxx_xxxxxxxx_xxxxxxxx_1xxxxxxx_xx : IRQ_VECT = 6'h0A;    //swbrk detect thread7
        34'bxxxxxxxx_xxxxxxxx_xxxxxxx1_xxxxxxxx_xx : IRQ_VECT = 6'h0B;    //swbrk detect thread8
        34'bxxxxxxxx_xxxxxxxx_xxxxxx1x_xxxxxxxx_xx : IRQ_VECT = 6'h0C;    //swbrk detect thread9
        34'bxxxxxxxx_xxxxxxxx_xxxxx1xx_xxxxxxxx_xx : IRQ_VECT = 6'h0D;    //swbrk detect thread10
        34'bxxxxxxxx_xxxxxxxx_xxxx1xxx_xxxxxxxx_xx : IRQ_VECT = 6'h0E;    //swbrk detect thread11
        34'bxxxxxxxx_xxxxxxxx_xxx1xxxx_xxxxxxxx_xx : IRQ_VECT = 6'h0F;    //swbrk detect thread12
        34'bxxxxxxxx_xxxxxxxx_xx1xxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h10;    //swbrk detect thread13
        34'bxxxxxxxx_xxxxxxxx_x1xxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h11;    //swbrk detect thread14
        34'bxxxxxxxx_xxxxxxxx_1xxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h12;    //swbrk detect thread15
        34'bxxxxxxxx_xxxxxxx1_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h13;    //done thread0
        34'bxxxxxxxx_xxxxxx1x_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h14;    //done thread1
        34'bxxxxxxxx_xxxxx1xx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h15;    //done thread2
        34'bxxxxxxxx_xxxx1xxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h16;    //done thread3
        34'bxxxxxxxx_xxx1xxxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h17;    //done thread4
        34'bxxxxxxxx_xx1xxxxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h18;    //done thread5
        34'bxxxxxxxx_x1xxxxxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h19;    //done thread6
        34'bxxxxxxxx_1xxxxxxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h1A;    //done thread7
        34'bxxxxxxx1_xxxxxxxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h1B;    //done thread8
        34'bxxxxxx1x_xxxxxxxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h1C;    //done thread9
        34'bxxxxx1xx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h1D;    //done thread10
        34'bxxxx1xxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h1E;    //done thread11
        34'bxxx1xxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h1F;    //done thread12
        34'bxx1xxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h20;    //done thread13
        34'bx1xxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h21;    //done thread14
        34'b1xxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xx : IRQ_VECT = 6'h22;    //done thread15
    default : IRQ_VECT = 6'h00;
    endcase 
end           
             
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
    if (RESET) pre_PC = 12'h100;
    else if (CGS_ld_vector) pre_PC = CGS_vector;
    else if ((dest_q2 == PC_ADDRS) && (wrcycl | CGS_ld_vector_q3)) pre_PC = resultout;
    else if ((opcode_q2 == BTB_) && ((|(bitsel & wrsrcBdata)) ^ OPsrcA_q2[6]) && ~pipe_flush) pre_PC = pc_q2 + {dest_q2[7], dest_q2[7], dest_q2[7], dest_q2[7], dest_q2[7:0]}; 
    else pre_PC = next_PC;
end    

wire srcAcollide;               
wire srcBcollide;               
assign srcAcollide = (srcA_q1==dest_q2) & wrcycl;
assign srcBcollide = (srcB_q1==dest_q2) & wrcycl;

always @(*) begin
         
         casex (srcA_q1)
             24'b00000000001xxxxxxxxxxxxx : rdSrcAdata =  srcAcollide ? resultout : ROM_4k_rddataA;       
//           24'b0000000000001xxxxxxxxxxx : rdSrcAdata = private_2048_rddataA; 
             24'b00000000000001xxxxxxxxxx : rdSrcAdata = srcAcollide ? resultout : CGS_RAM_rddataA;  
             24'b000000000000001xxxxxxxxx : rdSrcAdata = srcAcollide ? resultout : CGS_RAM_rddataA;  
             24'b0000000000000001xxxxxxxx : rdSrcAdata = srcAcollide ? resultout : CGS_RAM_rddataA;  
             24'b00000000000000001xxxxxxx : rdSrcAdata = srcAcollide ? resultout : CGS_RAM_rddataA;   
             
                      AR3_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CGS_AR3;                      
                      AR2_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CGS_AR2;                      
                      AR1_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CGS_AR1;
                      AR0_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CGS_AR0;
                       PC_ADDRS : rdSrcAdata = srcAcollide  ? resultout : {20'h00000, CGS_PC};
                        PC_COPY : rdSrcAdata = srcAcollide  ? resultout : {20'h00000, CGS_PC_COPY};
                       ST_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CGS_STATUSq2;
                       SP_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CGS_SP;
                   LPCNT1_ADDRS : rdSrcAdata = srcAcollide  ? resultout : {16'h0000, CGS_LPCNT1_nz, CGS_LPCNT1};
                   LPCNT0_ADDRS : rdSrcAdata = srcAcollide  ? resultout : {16'h0000, CGS_LPCNT0_nz, CGS_LPCNT0};
                    TIMER_ADDRS : rdSrcAdata = srcAcollide  ? resultout : CGS_timer; 
                  COMMAND_ADDRS : rdSrcAdata = srcAcollide  ? resultout : command; 
                    
                       DMA1_CSR : rdSrcAdata = srcAcollide ? resultout : CGS_DMA1_rddataA;  
                   DMA1_RDADDRS : rdSrcAdata = srcAcollide ? resultout : CGS_DMA1_rddataA;
                   DMA1_WRADDRS : rdSrcAdata = srcAcollide ? resultout : CGS_DMA1_rddataA;
                   
                  FRC_IRQ_ADDRS : rdSrcAdata = srcAcollide  ? {resultout[31:16], 10'b0000_0000_00, IRQ_VECT[5:0]} : {frc_IRQ_thread[15:0], 11'b0000_0000_000, IRQ_VECT[4:0]}; 
                                                                                   
                       DMA0_CSR : rdSrcAdata = srcAcollide  ? resultout : CGS_DMA0_rddataA; 
                   DMA0_RDADDRS : rdSrcAdata = srcAcollide  ? resultout : CGS_DMA0_rddataA;
                   DMA0_WRADDRS : rdSrcAdata = srcAcollide  ? resultout : CGS_DMA0_rddataA;
                   
                  DONE_IE_ADDRS : rdSrcAdata = srcAcollide  ? {done_thread[15:0], resultout[15:0]} : {done_thread[15:0], DONE_IE[15:0]};
                  
             24'b0000000000000000010xxxxx : rdSrcAdata = srcAcollide  ? resultout : CGS_RAM_rddataA; 
             24'b000000000000000000xxxxxx : rdSrcAdata = srcAcollide  ? resultout : CGS_RAM_rddataA; 
                                                 
             default : rdSrcAdata = private_2048_rddataA;  
         endcase                        
end    
 
always @(*) begin
         
         casex (srcB_q1)                            
             24'b00000000000001xxxxxxxxxx : rdSrcBdata = srcBcollide ? resultout : CGS_RAM_rddataB;  
             24'b000000000000001xxxxxxxxx : rdSrcBdata = srcBcollide ? resultout : CGS_RAM_rddataB;  
             24'b0000000000000001xxxxxxxx : rdSrcBdata = srcBcollide ? resultout : CGS_RAM_rddataB;  
             24'b00000000000000001xxxxxxx : rdSrcBdata = srcBcollide ? resultout : CGS_RAM_rddataB;   
             
                      AR3_ADDRS : rdSrcBdata = srcBcollide ? resultout : CGS_AR3;                      
                      AR2_ADDRS : rdSrcBdata = srcBcollide ? resultout : CGS_AR2;                      
                      AR1_ADDRS : rdSrcBdata = srcBcollide ? resultout : CGS_AR1;
                      AR0_ADDRS : rdSrcBdata = srcBcollide ? resultout : CGS_AR0;
                       PC_ADDRS : rdSrcBdata = srcBcollide ? resultout : {20'h00000, CGS_PC};
                        PC_COPY : rdSrcBdata = srcBcollide ? resultout : {20'h00000, CGS_PC_COPY};
                       ST_ADDRS : rdSrcBdata = srcBcollide ? resultout : CGS_STATUSq2;
                       SP_ADDRS : rdSrcBdata = srcBcollide  ? resultout: CGS_SP;
                   LPCNT1_ADDRS : rdSrcBdata = srcBcollide ? resultout : {16'h0000, CGS_LPCNT1_nz, CGS_LPCNT1};
                   LPCNT0_ADDRS : rdSrcBdata = srcBcollide ? resultout : {16'h0000, CGS_LPCNT0_nz, CGS_LPCNT0};
                    TIMER_ADDRS : rdSrcBdata = srcBcollide ? resultout : CGS_timer;                               
                  COMMAND_ADDRS : rdSrcBdata = srcBcollide ? resultout : command; 
                   
                       DMA1_CSR : rdSrcBdata = srcBcollide ? resultout : CGS_DMA1_rddataB;  
                   DMA1_RDADDRS : rdSrcBdata = srcBcollide ? resultout : CGS_DMA1_rddataB;
                   DMA1_WRADDRS : rdSrcBdata = srcBcollide ? resultout : CGS_DMA1_rddataB;
                                                                                     
                  FRC_IRQ_ADDRS : rdSrcBdata = srcBcollide ? {resultout[31:16], 10'b0000_0000_00, IRQ_VECT[5:0]} : {frc_IRQ_thread[15:0], 11'b0000_0000_000, IRQ_VECT[4:0]}; 
                  
                       DMA0_CSR : rdSrcBdata = srcBcollide ? resultout : CGS_DMA0_rddataB; 
                   DMA0_RDADDRS : rdSrcBdata = srcBcollide ? resultout : CGS_DMA0_rddataB;
                   DMA0_WRADDRS : rdSrcBdata = srcBcollide ? resultout : CGS_DMA0_rddataB;
                   
                  DONE_IE_ADDRS : rdSrcBdata = srcBcollide ? {done_thread[15:0], resultout[15:0]} : {done_thread[15:0], DONE_IE[15:0]}; 

             24'b0000000000000000010xxxxx : rdSrcBdata = srcBcollide ? resultout : CGS_RAM_rddataB; 
             24'b000000000000000000xxxxxx : rdSrcBdata = srcBcollide ? resultout : CGS_RAM_rddataB; 
                                                 
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
                       Z_q2 = PC_stack_op ? CGS_Z : ~|wrsrcAdata;
                       N_q2 = PC_stack_op ? CGS_N :  wrsrcAdata[31];
                       C_q2 = CGS_C;
                       V_q2 = CGS_V;
                    end    
                                 	
            OR_   :	begin
                       resultout = wrsrcAdata | wrsrcBdata;
                       Z_q2 = ~|(wrsrcAdata | wrsrcBdata);
                       N_q2 = wrsrcAdata[31] | wrsrcBdata[31];
                       C_q2 = CGS_C;
                       V_q2 = CGS_V;
                    end    
            XOR_  :	begin
                       resultout = wrsrcAdata ^ wrsrcBdata;
                       Z_q2 = ~|(wrsrcAdata ^ wrsrcBdata);
                       N_q2 = wrsrcAdata[31] ^ wrsrcBdata[31];
                       C_q2 = CGS_C;
                       V_q2 = CGS_V;
                    end    
            AND_  :	begin
                       resultout = wrsrcAdata & wrsrcBdata;
                       Z_q2 = ~|(wrsrcAdata & wrsrcBdata);
                       N_q2 = wrsrcAdata[31] & wrsrcBdata[31];
                       C_q2 = CGS_C;
                       V_q2 = CGS_V;
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
                       C_q2 = CGS_C;
                       V_q2 = CGS_V;
                    end                                                            
                                                             
            SHFT_ : begin
                        casex (shiftype)
                            ASL_,
                            LEFT_  : begin
                                        resultout = wrsrcAdata << shiftamount1;
                                        Z_q2 = CGS_Z;
                                        N_q2 = CGS_N;
                                        C_q2 = CGS_C;
                                        V_q2 = CGS_V;
                                     end   
                            LSL_   : begin
                                        {C_q2, resultout} = {wrsrcAdata, 1'b0} << shiftamount1;
                                        Z_q2 = CGS_Z;
                                        N_q2 = CGS_N;
                                        V_q2 = CGS_V;
                                     end 
                            ROL_   : begin
                                        resultout =  brlshft_ROL;
                                        Z_q2 = CGS_Z;
                                        N_q2 = CGS_N;
                                        C_q2 = CGS_C;
                                        V_q2 = CGS_V;
                                     end           
                            RIGHT_ : begin                                        
                                        resultout = wrsrcAdata >> shiftamount1;
                                        Z_q2 = CGS_Z;
                                        N_q2 = CGS_N;
                                        C_q2 = CGS_C;
                                        V_q2 = CGS_V;
                                     end   
                            LSR_   : begin
                                        {resultout, C_q2} = {1'b0, wrsrcAdata} >> shiftamount1;
                                        Z_q2 = CGS_Z;
                                        N_q2 = CGS_N;
                                        V_q2 = CGS_V;
                                     end   
                            ASR_   : begin
                                        {shiftbucket, resultout[31:0]} = {sbits, wrsrcAdata[31:1]} >> shiftamount1;
                                        Z_q2 = CGS_Z;
                                        N_q2 = CGS_N;
                                        C_q2 = CGS_C;
                                        V_q2 = CGS_V;
                                     end    
                            ROR_   : begin
                                        resultout =  brlshft_ROR;
                                        Z_q2 = CGS_Z;
                                        N_q2 = CGS_N;
                                        C_q2 = CGS_C;
                                        V_q2 = CGS_V;
                                     end    
                        endcase
                    end  
                    BTB_   : begin
                                resultout = wrsrcBdata;
                                Z_q2 = CGS_Z;
                                N_q2 = CGS_N;
                                C_q2 = CGS_C;
                                V_q2 = CGS_V;
                             end 
                                           
                   default : begin
                                resultout = wrsrcAdata;
                                Z_q2 = CGS_Z;
                                N_q2 = CGS_N;
                                C_q2 = CGS_C;
                                V_q2 = CGS_V;
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
            8'h7C : REPEAT[23:0] <= (wrcycl && (dest_q2==AR0_ADDRS)) ? resultout[23:0] : CGS_AR0[23:0];
 
            8'h75,
            8'h79,
            8'h7D : REPEAT[23:0] <= (wrcycl && (dest_q2==AR1_ADDRS)) ? resultout[23:0] : CGS_AR1[23:0];
                        
            8'h76,
            8'h7A,
            8'h7E : REPEAT[23:0] <= (wrcycl && (dest_q2==AR2_ADDRS)) ? resultout[23:0] : CGS_AR2[23:0];
                        
            8'h77,
            8'h7B,
            8'h7F : REPEAT[23:0] <= (wrcycl && (dest_q2==AR3_ADDRS)) ? resultout[23:0] : CGS_AR3[23:0];
        endcase                
    end 
    else if (|REPEAT[23:0]) REPEAT[23:0] <= REPEAT[23:0] - 1'b1;
end   

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        CGS_LPCNT1 <= 15'h0000;
        CGS_LPCNT0 <= 15'h0000;
    end 
    else begin
        if ((dest_q2==LPCNT0_ADDRS) && wrcycl) CGS_LPCNT0 <= resultout[14:0];
        else if ((opcode_q2==BTB_) && (srcB_q2==LPCNT0_ADDRS) && |CGS_LPCNT0 && ~pipe_flush) CGS_LPCNT0 <= CGS_LPCNT0_dec;
        
        if ((dest_q2==LPCNT1_ADDRS) && wrcycl) CGS_LPCNT1 <= resultout[14:0];
        else if ((opcode_q2==BTB_) && (srcB_q2==LPCNT1_ADDRS) && |CGS_LPCNT1 && ~pipe_flush) CGS_LPCNT1 <= CGS_LPCNT1_dec;
    end    
end

reg [1:0] OPmode_q1;
wire branch;
wire jump;

assign branch = (opcode_q2 == BTB_) & ((|(bitsel & wrsrcBdata)) ^ OPsrcA_q2[6]) & ~pipe_flush;
assign jump = (dest_q2 == PC_ADDRS) & wrcycl;
always @(posedge CLK or posedge RESET) begin  
                                                                   
    if (RESET) begin  
        // state 1 fetch                                                                                         
        pc_q1     <= 12'h100;                                                                               
        constn_q1  <= 2'b00;                         
        opcode_q1 <= 4'b0000;                                                                                  
        srcA_q1   <= 24'h000000;                                                                                
        srcB_q1   <= 24'h000000;                                                                                
        OPdest_q1 <= 8'h00;
        OPsrcA_q1 <= 8'h00;
        OPsrcB_q1 <= 8'h00;
        OPmode_q1 <= 2'b00;

        // state2 read
        pc_q2     <= 12'h100;
        opcode_q2 <= 4'b0000;
        srcA_q2   <= 24'h000000;                                                                                
        srcB_q2   <= 24'h000000;
        OPdest_q2 <= 8'h00;
        OPsrcA_q2 <= 8'h00;        
        OPsrcB_q2 <= 8'h00;        

        CGS_PC <= 12'h100;
        CGS_PC_COPY <= 12'h100;
        
        CGS_timer <= 32'h0000_0000; 
        CGS_timercmpr <= 32'h0000_0000;         

        CGS_AR3 <= 32'h01000000;
        CGS_AR2 <= 32'h01000000;
        CGS_AR1 <= 32'h01000000;
        CGS_AR0 <= 32'h01000000;
        
        CGS_SP  <= 32'h007FFFFF;
        CGS_SP_read <= 32'h007FFFFF;        
        
        shdr3_RESET <= 1'b1;
        shdr2_RESET <= 1'b1;
        shdr1_RESET <= 1'b1;
        shdr0_RESET <= 1'b1;

        CGS_Z <= 1'b1;
        CGS_C <= 1'b0;
        CGS_N <= 1'b0;
        CGS_V <= 1'b0;
                
        CGS_done   <= 1'b1;
        CGS_EXC_IE <= 1'b0;
        CGS_IRQ_IE <= 1'b0;         
        CGS_ld_vector_q1 <= 1'b0;
        CGS_ld_vector_q2 <= 1'b0;
        CGS_ld_vector_q3 <= 1'b0;
        
        frc_IRQ_thread <= 16'h0000;
        DONE_IE <= 16'h0000;
        
        wrsrcAdata <= 32'h00000000;
        wrsrcBdata <= 32'h00000000; 
        
        STATE <= 3'b100;
        
        CGS_pipe_flush <= 2'b00;
    end    
    else begin
////////////////////////////////////////////////////////////

        CGS_pipe_flush[0] <= discont;  // if anything causes a PC discontinuity is detected (about to occur), then flush instr pipe (disable write) for 2 clocks
        CGS_pipe_flush[1] <= CGS_pipe_flush[0];
        
        CGS_ld_vector_q1 <= CGS_ld_vector;
        CGS_ld_vector_q2 <= CGS_ld_vector_q1;
        CGS_ld_vector_q3 <= CGS_ld_vector_q2;

        if (CGS_ld_vector) begin
            CGS_PC <= CGS_vector;
            if (branch) CGS_PC_COPY <= pc_q2 + {dest_q2[7], dest_q2[7], dest_q2[7], dest_q2[7], dest_q2[7:0]};
            else if (jump) CGS_PC_COPY = resultout;
            else CGS_PC_COPY = pc_q2 + 1'b1; 
        end   
        else if (CGS_ld_vector_q3) CGS_PC <= resultout;
        else if ((opcode_q2 == BTB_) && ((|(bitsel & wrsrcBdata)) ^ OPsrcA_q2[6]) && ~pipe_flush) begin            
            CGS_PC <= pc_q2 + {dest_q2[7], dest_q2[7], dest_q2[7], dest_q2[7], dest_q2[7:0]};             
            CGS_PC_COPY <= pc_q2 + 1'b1; 
        end         
        else if ((dest_q2 == PC_ADDRS) && wrcycl) begin
            CGS_PC <= resultout[11:0];                       
            CGS_PC_COPY <= pc_q2 + 1'b1;  //don't copy PC if interrupt vector fetch
        end      
        else  CGS_PC <= RPT_not_z ? CGS_PC : next_PC;   
        
        if ((dest_q2==ST_ADDRS) && wrcycl) {shdr3_RESET, shdr2_RESET, shdr1_RESET, shdr0_RESET, CGS_IRQ_IE, CGS_EXC_IE, CGS_done, CGS_V, CGS_N, CGS_C, CGS_Z} <= {resultout[15:12], resultout[9], resultout[8], resultout[5], resultout[3:0]}; 
        else if (wrcycl) {CGS_V, CGS_N, CGS_C, CGS_Z} <= {V_q2, N_q2, C_q2, Z_q2};
                
        if ((dest_q2== FRC_IRQ_ADDRS) && wrcycl) frc_IRQ_thread <= resultout[15:0];
        
        if ((dest_q2== DONE_IE_ADDRS) && wrcycl) DONE_IE <= resultout[15:0];
        
        if ((dest_q2==TIMER_ADDRS) && wrcycl) begin 
            CGS_timer <= 32'h0000_0000;
            CGS_timercmpr <= resultout;
        end                   
        else if (~CGS_done && ~(CGS_timer==CGS_timercmpr)) CGS_timer <= CGS_timer + 1'b1;                   
                
        STATE <= {1'b1, STATE[2:1]};    //rotate right 1 into msb
     
        pc_q1     <=  PC      ; 
        constn_q1  <=  constn ;                                                                                               
        opcode_q1 <=  opcode  ;                                                                                               
        srcA_q1   <=  srcA    ;                                                                                               
        srcB_q1   <=  srcB    ;                                                                                               
        OPdest_q1 <= OPdest   ;
        OPsrcA_q1 <= OPsrcA   ;
        OPsrcB_q1 <= OPsrcB   ;
        OPmode_q1 <= P_DATAi[31:30];

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
            CGS_SP[23:0] <= {(&OPmode_q1 ? {1'b0, {7{OPsrcA[7]}}} : 8'h00), OPsrcA[7:0], OPsrcB[7:0]};  //immediate write to SP during newthreadq has priority over any update         
            CGS_SP_read  <= {(&OPmode_q1 ? {1'b0, {7{OPsrcA[7]}}} : 8'h00), OPsrcA[7:0], OPsrcB[7:0]};
        end    
        else if (wrcycl && (OPdest_q2==8'h6A)) begin
            CGS_SP <= {1'b0, resultout[22:0]}; //direct write to SP during q2 has priority over any update 
            CGS_SP_read  <= {(&OPmode_q1 ? {8{OPsrcA[7]}} : 8'h00), OPsrcA[7:0], OPsrcB[7:0]};
        end            
        if (~constn[1] && ~discont && (OPsrcA==8'h6A) && ~(CGS_SP[23:0]==24'h7FFFFF))  begin   //SP auto-post-increment of indirect srcA address SPOP occurs during instruction fetch (state0)
//SP POP      
              CGS_SP_read <= CGS_SP_read + 1'b1;  
              CGS_SP[23:0] <= CGS_SP[23:0] + 1'b1;
        end
              
        if (~constn[0] && ~discont && (OPsrcB==8'h6A) && ~(CGS_SP[23:0]==24'h7FFFFF))  begin   //SP auto-post-increment of indirect srcB address SPOP occurs during instruction fetch (state0)
              CGS_SP_read <= CGS_SP_read + 1'b1;  
              CGS_SP[23:0] <= CGS_SP[23:0] + 1'b1;
        end       
//SP PUSH               
        if (wrcycl && (OPdest_q2==8'h6B)) begin      
            CGS_SP_read[23:0] <= CGS_SP[23:0];       //used for SP POP
            CGS_SP[23:0] <= CGS_SP[23:0] - 1'b1;
        end


        if (~discont && &constn && (OPdest==8'h70)) CGS_AR0[23:0] <= {8'h00, OPsrcA[7:0], OPsrcB[7:0]};  //immediate write to ARn during newthreadq has priority over any update         
        else if (wrcycl && (OPdest_q2==8'h70)) CGS_AR0 <= |resultout[31:24] ? resultout : {CGS_AR0[31:24], resultout[23:0]}; //direct write to ARn during q2 has priority over any update         
        if (~constn[1] && ~discont && ((OPsrcA==8'h78) || (OPsrcA==8'h7C)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcA)
              8'h78 : CGS_AR0[23:0] <= CGS_AR0[23:0] + CGS_AR0[31:24];
              8'h7C : CGS_AR0[23:0] <= CGS_AR0[23:0] - CGS_AR0[31:24];
            endcase
        if (~constn[0] && ~discont && ((OPsrcB==8'h78) || (OPsrcB==8'h7C)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcB)
              8'h78 : CGS_AR0[23:0] <= CGS_AR0[23:0] + CGS_AR0[31:24];
              8'h7C : CGS_AR0[23:0] <= CGS_AR0[23:0] - CGS_AR0[31:24];
            endcase
        if (wrcycl)
            case (OPdest_q2)
              8'h78 : CGS_AR0[23:0] <= CGS_AR0[23:0] + CGS_AR0[31:24];
              8'h7C : CGS_AR0[23:0] <= CGS_AR0[23:0] - CGS_AR0[31:24];
            endcase

        if (~discont && &constn && (OPdest==8'h71)) CGS_AR1[23:0] <= {8'h00, OPsrcA[7:0], OPsrcB[7:0]};  //immediate write to ARn during newthreadq has priority over any update         
        else if (wrcycl && (OPdest_q2==8'h71)) CGS_AR1 <= |resultout[31:24] ? resultout : {CGS_AR1[31:24], resultout[23:0]}; //direct write to ARn during q2 has priority over any update         
        if (~constn[1] && ~discont && ((OPsrcA==8'h79) || (OPsrcA==8'h7D)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcA)
              8'h79 : CGS_AR1[23:0] <= CGS_AR1[23:0] + CGS_AR1[31:24];
              8'h7D : CGS_AR1[23:0] <= CGS_AR1[23:0] - CGS_AR1[31:24];
            endcase
        if (~constn[0] && ~discont && ((OPsrcB==8'h79) || (OPsrcB==8'h7D)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcB)
              8'h79 : CGS_AR1[23:0] <= CGS_AR1[23:0] + CGS_AR1[31:24];
              8'h7D : CGS_AR1[23:0] <= CGS_AR1[23:0] - CGS_AR1[31:24];
            endcase
        if (wrcycl)
            case (OPdest_q2)
              8'h79 : CGS_AR1[23:0] <= CGS_AR1[23:0] + CGS_AR1[31:24];
              8'h7D : CGS_AR1[23:0] <= CGS_AR1[23:0] - CGS_AR1[31:24];
            endcase

        if (~discont && &constn && (OPdest==8'h72)) CGS_AR2[23:0] <= {8'h00, OPsrcA[7:0], OPsrcB[7:0]};  //immediate write to ARn during newthreadq has priority over any update         
        else if (wrcycl && (OPdest_q2==8'h72)) CGS_AR2 <= |resultout[31:24] ? resultout : {CGS_AR2[31:24], resultout[23:0]}; //direct write to ARn during q2 has priority over any update         
        if (~constn[1] && ~discont && ((OPsrcA==8'h7A) || (OPsrcA==8'h7E)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcA)
              8'h7A : CGS_AR2[23:0] <= CGS_AR2[23:0] + CGS_AR2[31:24];
              8'h7E : CGS_AR2[23:0] <= CGS_AR2[23:0] - CGS_AR2[31:24];
            endcase
        if (~constn[0] && ~discont && ((OPsrcB==8'h7A) || (OPsrcB==8'h7E)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcB)
              8'h7A : CGS_AR2[23:0] <= CGS_AR2[23:0] + CGS_AR2[31:24];
              8'h7E : CGS_AR2[23:0] <= CGS_AR2[23:0] - CGS_AR2[31:24];
            endcase
        if (wrcycl)
            case (OPdest_q2)
              8'h7A : CGS_AR2[23:0] <= CGS_AR2[23:0] + CGS_AR2[31:24];
              8'h7E : CGS_AR2[23:0] <= CGS_AR2[23:0] - CGS_AR2[31:24];
            endcase

        if (~discont && &constn && (OPdest==8'h73)) CGS_AR3[23:0] <= {8'h00, OPsrcA[7:0], OPsrcB[7:0]};  //immediate write to ARn during newthreadq has priority over any update         
        else if (wrcycl && (OPdest_q2==8'h73)) CGS_AR3 <= |resultout[31:24] ? resultout : {CGS_AR3[31:24], resultout[23:0]}; //direct write to ARn during q2 has priority over any update         
        if (~constn[1] && ~discont && ((OPsrcA==8'h7B) || (OPsrcA==8'h7F)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcA)
              8'h7B : CGS_AR3[23:0] <= CGS_AR3[23:0] + CGS_AR3[31:24];
              8'h7F : CGS_AR3[23:0] <= CGS_AR3[23:0] - CGS_AR3[31:24];
            endcase
        if (~constn[0] && ~discont && ((OPsrcB==8'h7B) || (OPsrcB==8'h7F)))     //ARn auto-post-increment/decrement of indirect srcA address ARn occurs during instruction fetch (state0)
            case (OPsrcB)
              8'h7B : CGS_AR3[23:0] <= CGS_AR3[23:0] + CGS_AR3[31:24];
              8'h7F : CGS_AR3[23:0] <= CGS_AR3[23:0] - CGS_AR3[31:24];
            endcase
        if (wrcycl)
            case (OPdest_q2)
              8'h7B : CGS_AR3[23:0] <= CGS_AR3[23:0] + CGS_AR3[31:24];
              8'h7F : CGS_AR3[23:0] <= CGS_AR3[23:0] - CGS_AR3[31:24];
            endcase                
    end           
end
                                                      
endmodule