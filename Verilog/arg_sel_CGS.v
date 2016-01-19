 // arg_sel_CGS.v
 `timescale 1ns/100ps
 // Author:  Jerry D. Harthcock
 // Version:  2.101    January 18, 2016
 // Copyright (C) 2014-2015.  All rights reserved.
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

module DATA_ADDRS_mod_CGS(
    MOV_q0,
    CGS_SP,     
    CGS_SP_read,
    CGS_AR3,
    CGS_AR2,
    CGS_AR1,
    CGS_AR0,
    constn,
    OPdest_q2,
    OPsrcA,   
    OPsrcB,   
    dest,
    srcA,
    srcB
    );

input MOV_q0;
input [23:0]    CGS_SP;
input [23:0]    CGS_SP_read;
input [31:0] 	CGS_AR3;
input [31:0] 	CGS_AR2;
input [31:0] 	CGS_AR1;
input [31:0] 	CGS_AR0;
input [1:0]     constn;
input [7:0] 	OPdest_q2;
input [7:0] 	OPsrcA;   
input [7:0] 	OPsrcB;   
output [23:0] 	dest;
output [23:0] 	srcA;
output [23:0] 	srcB;

reg  [23:0]	DEST_ind; 
reg  [23:0]	SRC_A_ind; 
reg  [23:0]	SRC_B_ind; 

wire [1:0] DEST_ARn_sel;
wire [1:0] SRC_A_sel; 	
wire [1:0] SRC_B_sel; 

wire indir_mode_srcA;
wire indir_mode_srcB;
wire indir_mode_dest;

wire SP_push;
wire SP_popA;
wire SP_popB;

wire [23:0] dest;
wire [23:0] srcA;
wire [23:0] srcB;

assign DEST_ARn_sel = OPdest_q2[1:0];
assign SRC_A_sel 	= OPsrcA[1:0];
assign SRC_B_sel 	= OPsrcB[1:0];
	                                                                                                     
assign SP_push = (OPdest_q2==8'h6B);
assign SP_popA = (OPsrcA==8'h6A) | (OPsrcA==8'h69); 
assign SP_popB = (OPsrcB==8'h6A) | (OPsrcB==8'h69); 

assign indir_mode_dest = (~OPdest_q2[7] & &OPdest_q2[6:4] & |OPdest_q2[3:2]) | SP_push;
assign indir_mode_srcA = (~constn[1] & ~OPsrcA[7])  & ((&OPsrcA[6:4] & |OPsrcA[3:2]) | SP_popA);
assign indir_mode_srcB = (~constn[0] & ~OPsrcB[7])  & ((&OPsrcB[6:4] & |OPsrcB[3:2]) | SP_popB);

assign dest = indir_mode_dest ?  (SP_push ? CGS_SP : DEST_ind)  : {16'h0000, OPdest_q2[7:0]};
//assign srcA = indir_mode_srcA ?  (SP_popA ? CGS_SP_read : SRC_A_ind) : ((MOV_q0 & constn[1] & ~constn[0]) ? {constn[1] & ~constn[0], 7'h00, OPsrcA[7:0], OPsrcB[7:0]} : {constn[1] & ~constn[0], 15'h0000, OPsrcA[7:0]});
//assign srcA = indir_mode_srcA ?  (SP_popA ? CGS_SP_read : SRC_A_ind) :  (MOV_q0 ? {10'h000, constn[1] & ~constn[0], 5'b00000, OPsrcA[7:0]} : {10'h000, constn[1] & ~constn[0], 5'b00000, OPsrcA[7:0]});
assign srcA = indir_mode_srcA ?  (SP_popA ? CGS_SP_read : SRC_A_ind) :  ((MOV_q0 & constn[1] & ~constn[0]) ? {10'h000, constn[1] & ~constn[0], OPsrcA[4:0], OPsrcB[7:0]} : {10'h000, constn[1] & ~constn[0], 5'b00000, OPsrcA[7:0]});
assign srcB = indir_mode_srcB ?  (SP_popB ? CGS_SP_read : SRC_B_ind) : {16'h0000, OPsrcB[7:0]};

// destination   
always @(*) begin
     case (DEST_ARn_sel) 
     	2'b00 : DEST_ind = CGS_AR0[23:0]; 
     	2'b01 : DEST_ind = CGS_AR1[23:0]; 
     	2'b10 : DEST_ind = CGS_AR2[23:0]; 
     	2'b11 : DEST_ind = CGS_AR3[23:0];
     endcase
end

//src_A
always @(*) begin
   case (SRC_A_sel) 
   	   2'b00 : SRC_A_ind = CGS_AR0[23:0]; 
   	   2'b01 : SRC_A_ind = CGS_AR1[23:0]; 
   	   2'b10 : SRC_A_ind = CGS_AR2[23:0]; 
   	   2'b11 : SRC_A_ind = CGS_AR3[23:0];
   endcase
end

//src_B
always @(*) begin
   case (SRC_B_sel) 
   	2'b00 : SRC_B_ind = CGS_AR0[23:0]; 
   	2'b01 : SRC_B_ind = CGS_AR1[23:0]; 
   	2'b10 : SRC_B_ind = CGS_AR2[23:0]; 
   	2'b11 : SRC_B_ind = CGS_AR3[23:0];
   endcase
end        
   
endmodule   