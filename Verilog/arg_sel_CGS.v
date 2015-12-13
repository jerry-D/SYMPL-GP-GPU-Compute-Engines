 // arg_sel_CGS.v
 `timescale 1ns/100ps
 // SYMPL GP-GPU Compute Engine Coarse-Grained Scheduler indirect addressing module
 // Author:  Jerry D. Harthcock
 // Version:  2.11    Dec. 12, 2015
 // November 24, 2014
 // Copyright (C) 2014.  All rights reserved without prejudice.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                   SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-Compute Engine                           //
//                              Evaluation and Product Development License                                       //
//                                                                                                               //
// Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"), //
// the original author and exclusive copyright owner of the SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-  //
// Compute Engine Verilog RTL IP core family and instruction-set architecture ("this IP"), hereby grants to      //
// recipient of this IP ("licensee"), a world-wide, paid-up, non-exclusive license to use this IP for the        //
// non-commercial purposes of evaluation, education, and development of end products and related development     //
// tools only. For a license to use this IP in commercial products intended for sale, license, lease or any      //
// other form of barter, contact licensor at:  SYMPL.gpu@gmail.com                                               //
//                                                                                                               //
// Any customization, modification, or derivative work of this IP must include an exact copy of this license     //
// and original copyright notice at the very top of each source file and derived netlist, and, in the case of    //
// binaries, a printed copy of this license and/or a text format copy in a separate file distributed with said   //
// netlists or binary files having the file name, "LICENSE.txt".  You, the licensee, also agree not to remove    //
// any copyright notices from any source file covered under this Evaluation and Product Development License.     //
//                                                                                                               //
// THIS IP IS PROVIDED "AS IS".  LICENSOR DOES NOT WARRANT OR GUARANTEE THAT YOUR USE OF THIS IP WILL NOT        //
// INFRINGE THE RIGHTS OF OTHERS OR THAT IT IS SUITABLE OR FIT FOR ANY PURPOSE AND THAT YOU, THE LICENSEE, AGREE //
// TO HOLD LICENSOR HARMLESS FROM ANY CLAIM BROUGHT BY YOU OR ANY THIRD PARTY FOR YOUR SUCH USE.                 //                               
//                                                                                                               //
// Licensor reserves all his rights without prejudice, including, but in no way limited to, the right to change  //
// or modify the terms and conditions of this Evaluation and Product Development License anytime without notice  //
// of any kind to anyone. By using this IP for any purpose, you agree to all the terms and conditions set forth  //
// in this Evaluation and Product Development License.                                                           //
//                                                                                                               //
// This Evaluation and Product Development License does not include the right to sell products that incorporate  //
// this IP or any IP derived from this IP.  If you would like to obtain such a license, please contact Licensor. //                                                                                            //
//                                                                                                               //
// Licensor can be contacted at:  SYMPL.gpu@gmail.com                                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DATA_ADDRS_mod_CGS(
    tr0_AR3,
    tr0_AR2,
    tr0_AR1,
    tr0_AR0,
    constn,
    OPdest_q2,
    OPsrcA,   
    OPsrcB,   
    dest,
    srcA,
    srcB
    );

input [31:0] 	tr0_AR3;
input [31:0] 	tr0_AR2;
input [31:0] 	tr0_AR1;
input [31:0] 	tr0_AR0;
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

wire [1:0]	DEST_ARn_MOD;
wire [1:0]	SRC_A_MOD;
wire [1:0]	SRC_B_MOD;

wire [1:0] DEST_ARn_sel;
wire [1:0] SRC_A_sel; 	
wire [1:0] SRC_B_sel; 

wire indir_mode_srcA;
wire indir_mode_srcB;
wire indir_mode_dest;

wire [23:0] dest;
wire [23:0] srcA;
wire [23:0] srcB;
	
assign DEST_ARn_sel = OPdest_q2[1:0];
assign SRC_A_sel 	= OPsrcA[1:0];
assign SRC_B_sel 	= OPsrcB[1:0];

assign indir_mode_dest = ~OPdest_q2[7] & &OPdest_q2[6:4] & |OPdest_q2[3:2];
assign indir_mode_srcA = ~constn[1] & ~OPsrcA[7] & &OPsrcA[6:4] & |OPsrcA[3:2];
assign indir_mode_srcB = ~constn[0] & ~OPsrcB[7]  & &OPsrcB[6:4] & |OPsrcB[3:2];

assign dest = indir_mode_dest ?  DEST_ind  : {16'h0000, OPdest_q2[7:0]};
assign srcA = indir_mode_srcA ?  SRC_A_ind : {10'h000, constn[1] & ~constn[0], 5'b00000, OPsrcA[7:0]};
assign srcB = indir_mode_srcB ?  SRC_B_ind : {16'h0000, OPsrcB[7:0]};

// destination   
always @(*) begin
     case (DEST_ARn_sel) 
     	2'b00 : DEST_ind = tr0_AR0[23:0]; 
     	2'b01 : DEST_ind = tr0_AR1[23:0]; 
     	2'b10 : DEST_ind = tr0_AR2[23:0]; 
     	2'b11 : DEST_ind = tr0_AR3[23:0];
     endcase
end

//src_A
always @(*) begin
   case (SRC_A_sel) 
   	   2'b00 : SRC_A_ind = tr0_AR0[23:0]; 
   	   2'b01 : SRC_A_ind = tr0_AR1[23:0]; 
   	   2'b10 : SRC_A_ind = tr0_AR2[23:0]; 
   	   2'b11 : SRC_A_ind = tr0_AR3[23:0];
   endcase
end

//src_B
always @(*) begin
   case (SRC_B_sel) 
   	2'b00 : SRC_B_ind = tr0_AR0[23:0]; 
   	2'b01 : SRC_B_ind = tr0_AR1[23:0]; 
   	2'b10 : SRC_B_ind = tr0_AR2[23:0]; 
   	2'b11 : SRC_B_ind = tr0_AR3[23:0];
   endcase
end        
   
endmodule   