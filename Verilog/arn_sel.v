 // arn_sel.v
 `timescale 1ns/100ps
 // Indirect addressing mode address translator 
 // Author:  Jerry D. Harthcock
 // Version:  3.03    January 18, 2016
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

module DATA_ADDRS_mod(
    tr3_AR3,
    tr3_AR2,
    tr3_AR1,
    tr3_AR0,
    tr2_AR3,
    tr2_AR2,
    tr2_AR1,
    tr2_AR0,
    tr1_AR3,
    tr1_AR2,
    tr1_AR1,
    tr1_AR0,
    tr0_AR3,
    tr0_AR2,
    tr0_AR1,
    tr0_AR0,
    constn,
    OPdest_q2,
    OPsrcA,   
    OPsrcB,   
    ACT_THREAD,
    thread_q2,
    dest,
    srcA,
    srcB
    );

input [13:0]  tr3_AR3;
input [13:0]  tr3_AR2;
input [13:0]  tr3_AR1;
input [13:0]  tr3_AR0;
input [13:0]  tr2_AR3;
input [13:0]  tr2_AR2;
input [13:0]  tr2_AR1;
input [13:0]  tr2_AR0;
input [13:0]  tr1_AR3;
input [13:0]  tr1_AR2;
input [13:0]  tr1_AR1;
input [13:0]  tr1_AR0;
input [13:0]  tr0_AR3;
input [13:0]  tr0_AR2;
input [13:0]  tr0_AR1;
input [13:0]  tr0_AR0;
input [1:0]   constn;
input [7:0]   OPdest_q2;
input [7:0]   OPsrcA;   
input [7:0]   OPsrcB;   
input [1:0]   ACT_THREAD;
input [1:0]   thread_q2;
output [13:0] dest;
output [13:0] srcA;
output [13:0] srcB;

parameter THREAD3 = 2'b11;   //P_ADDRS[31:30] indicate active thread
parameter THREAD2 = 2'b10;   //P_ADDRS[31:30] indicate active thread
parameter THREAD1 = 2'b01;   //P_ADDRS[31:30] indicate active thread
parameter THREAD0 = 2'b00;   //P_ADDRS[31:30] indicate active thread

reg  [13:0] DEST_ind; 
reg  [13:0] SRC_A_ind; 
reg  [13:0] SRC_B_ind; 

wire [1:0] DEST_ARn_sel;
wire [1:0] SRC_A_sel;   
wire [1:0] SRC_B_sel; 

wire indir_mode_srcA;
wire indir_mode_srcB;
wire indir_mode_dest;

wire [13:0] dest;
wire [13:0] srcA;
wire [13:0] srcB;
    
assign DEST_ARn_sel = OPdest_q2[1:0];
assign SRC_A_sel    = OPsrcA[1:0];
assign SRC_B_sel    = OPsrcB[1:0];

assign indir_mode_dest = ~OPdest_q2[7] & &OPdest_q2[6:4] & |OPdest_q2[3:2];
assign indir_mode_srcA = ~constn[1] & ~OPsrcA[7] & &OPsrcA[6:4] & |OPsrcA[3:2];
assign indir_mode_srcB = ~constn[0] & ~OPsrcB[7]  & &OPsrcB[6:4] & |OPsrcB[3:2];

assign dest = indir_mode_dest ? DEST_ind  : {6'b000000, OPdest_q2[7:0]};
assign srcA = indir_mode_srcA ? SRC_A_ind : {1'b0, constn[1] & ~constn[0], 4'b0000, OPsrcA[7:0]};
assign srcB = indir_mode_srcB ? SRC_B_ind : {6'b000000, OPsrcB[7:0]};

// destination   
always @(*) begin
    case (thread_q2)
    THREAD3 : case (DEST_ARn_sel) 
                 2'b00 : DEST_ind = tr3_AR0; 
                 2'b01 : DEST_ind = tr3_AR1; 
                 2'b10 : DEST_ind = tr3_AR2; 
                 2'b11 : DEST_ind = tr3_AR3;
              endcase  
    THREAD2 : case (DEST_ARn_sel) 
                 2'b00 : DEST_ind = tr2_AR0; 
                 2'b01 : DEST_ind = tr2_AR1; 
                 2'b10 : DEST_ind = tr2_AR2; 
                 2'b11 : DEST_ind = tr2_AR3;
              endcase    
    THREAD1 : case (DEST_ARn_sel) 
                 2'b00 : DEST_ind = tr1_AR0; 
                 2'b01 : DEST_ind = tr1_AR1; 
                 2'b10 : DEST_ind = tr1_AR2; 
                 2'b11 : DEST_ind = tr1_AR3;
              endcase    
    THREAD0 : case (DEST_ARn_sel) 
                 2'b00 : DEST_ind = tr0_AR0; 
                 2'b01 : DEST_ind = tr0_AR1; 
                 2'b10 : DEST_ind = tr0_AR2; 
                 2'b11 : DEST_ind = tr0_AR3;
              endcase
   endcase
end

//src_A
always @(*) begin
    case (ACT_THREAD)
    THREAD3 : case (SRC_A_sel) 
                 2'b00 : SRC_A_ind = tr3_AR0; 
                 2'b01 : SRC_A_ind = tr3_AR1; 
                 2'b10 : SRC_A_ind = tr3_AR2; 
                 2'b11 : SRC_A_ind = tr3_AR3;
              endcase  
    THREAD2 : case (SRC_A_sel) 
                 2'b00 : SRC_A_ind = tr2_AR0; 
                 2'b01 : SRC_A_ind = tr2_AR1; 
                 2'b10 : SRC_A_ind = tr2_AR2; 
                 2'b11 : SRC_A_ind = tr2_AR3;
              endcase    
    THREAD1 : case (SRC_A_sel) 
                 2'b00 : SRC_A_ind = tr1_AR0; 
                 2'b01 : SRC_A_ind = tr1_AR1; 
                 2'b10 : SRC_A_ind = tr1_AR2; 
                 2'b11 : SRC_A_ind = tr1_AR3;
              endcase    
    THREAD0 : case (SRC_A_sel) 
                 2'b00 : SRC_A_ind = tr0_AR0; 
                 2'b01 : SRC_A_ind = tr0_AR1; 
                 2'b10 : SRC_A_ind = tr0_AR2; 
                 2'b11 : SRC_A_ind = tr0_AR3;
              endcase
   endcase
end

//src_B
always @(*) begin
    case (ACT_THREAD)
    THREAD3 : case (SRC_B_sel) 
                 2'b00 : SRC_B_ind = tr3_AR0; 
                 2'b01 : SRC_B_ind = tr3_AR1; 
                 2'b10 : SRC_B_ind = tr3_AR2; 
                 2'b11 : SRC_B_ind = tr3_AR3;
              endcase  
    THREAD2 : case (SRC_B_sel) 
                 2'b00 : SRC_B_ind = tr2_AR0; 
                 2'b01 : SRC_B_ind = tr2_AR1; 
                 2'b10 : SRC_B_ind = tr2_AR2; 
                 2'b11 : SRC_B_ind = tr2_AR3;
              endcase    
    THREAD1 : case (SRC_B_sel) 
                 2'b00 : SRC_B_ind = tr1_AR0; 
                 2'b01 : SRC_B_ind = tr1_AR1; 
                 2'b10 : SRC_B_ind = tr1_AR2; 
                 2'b11 : SRC_B_ind = tr1_AR3;
              endcase    
    THREAD0 : case (SRC_B_sel) 
                 2'b00 : SRC_B_ind = tr0_AR0; 
                 2'b01 : SRC_B_ind = tr0_AR1; 
                 2'b10 : SRC_B_ind = tr0_AR2; 
                 2'b11 : SRC_B_ind = tr0_AR3;
              endcase
   endcase
end
   
endmodule   