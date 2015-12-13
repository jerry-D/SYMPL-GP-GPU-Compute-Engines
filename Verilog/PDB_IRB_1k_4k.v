 // 1k x 32 x 4 x 3 (1k x 32 PDB for threads 3:0 + 4k x 32 for IRB SRAM for SYMPL FP32X quad-shader GP-GPU Compute engine
 `timescale 1ns/1ns
 // For use in SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-Compute Engine
 // Author:  Jerry D. Harthcock
 // Version:  1.02  Dec. 12, 2015
 // Copyright (C) 2015.  All rights reserved without prejudice.
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

module PDB_1kx32_IRB(
    CLK          ,  
    thread       ,
    thread_q2    ,  
    cgs_wren     ,
    cgs_wraddrs  ,  
    cgs_wrdata   ,
    cgs_rden     ,
    cgs_rdaddrs  ,
    cgs_rddata   ,
    DMA0_wren    ,
    DMA0_wraddrs ,
    DMA0_wrdata  ,
    DMA1_rden    ,
    DMA1_rdaddrs ,
    DMA1_rddata  ,
    shdr_wren    ,
    shdr_wraddrs ,
    shdr_wrdata  ,
    shdr_rdenA   ,
    shdr_rdaddrsA,
    shdr_rddataA ,
    shdr_rdenB   ,
    shdr_rdaddrsB,
    shdr_rddataB ,
    DMA0_collide ,
    DMA1_collide 
    );

input         CLK;  
input  [1:0]  thread;
input  [1:0]  thread_q2;  
input         cgs_wren;
input  [12:0] cgs_wraddrs;    //8k 4x1kPDB + 4k IRB
input  [31:0] cgs_wrdata;
input         cgs_rden;
input  [12:0] cgs_rdaddrs;
output [31:0] cgs_rddata;
input         DMA0_wren;
input  [12:0] DMA0_wraddrs;
input  [31:0] DMA0_wrdata;
input         DMA1_rden;
input  [12:0] DMA1_rdaddrs;
output [31:0] DMA1_rddata;
input         shdr_wren;
input  [12:0] shdr_wraddrs;
input  [31:0] shdr_wrdata;
input         shdr_rdenA;
input  [12:0] shdr_rdaddrsA;
output [31:0] shdr_rddataA;
input         shdr_rdenB;
input  [12:0] shdr_rdaddrsB;
output [31:0] shdr_rddataB;

output        DMA0_collide;
output        DMA1_collide;

reg [31:0] shdr_rddataA;
reg [31:0] shdr_rddataB;
reg [31:0] DMA1_rddata;
reg [31:0] cgs_rddata;

reg [4:0] DMA1_rdsel_q1;
reg [4:0] cgs_rdsel_q1; 
reg [4:0] shdr_rdselA_q1; 
reg [4:0] shdr_rdselB_q1; 

wire DMA0_collide;
wire DMA1_collide;

wire shdr_wren3;
wire shdr_wren2;
wire shdr_wren1;
wire shdr_wren0;

wire cgs_wren3;
wire cgs_wren2;
wire cgs_wren1;
wire cgs_wren0;

wire shdr_rdenA3;
wire shdr_rdenA2;
wire shdr_rdenA1;
wire shdr_rdenA0;

wire shdr_rdenB3;
wire shdr_rdenB2;
wire shdr_rdenB1;
wire shdr_rdenB0;

wire cgs_rden3;
wire cgs_rden2;
wire cgs_rden1;
wire cgs_rden0;

wire DMA1_rden3;
wire DMA1_rden2;
wire DMA1_rden1;
wire DMA1_rden0;

wire DMA0_wren3;
wire DMA0_wren2;
wire DMA0_wren1;
wire DMA0_wren0;

wire shdr_wrenIRB;
wire cgs_wrenIRB;
wire DMA0_wrenIRB;
wire shdr_rdenA_IRB;
wire shdr_rdenB_IRB;
wire cgs_rdenIRB;
wire DMA1_rdenIRB;

wire [31:0] rddataA3;
wire [31:0] rddataA2;
wire [31:0] rddataA1;
wire [31:0] rddataA0;
wire [31:0] rddataA_IRB;

wire [31:0] rddataB3;
wire [31:0] rddataB2;
wire [31:0] rddataB1;
wire [31:0] rddataB0;
wire [31:0] rddataB_IRB;

assign shdr_wren3  = shdr_wren & (thread_q2==2'b11) & (shdr_wraddrs[12:10]==3'b010);
assign shdr_wren2  = shdr_wren & (thread_q2==2'b10) & (shdr_wraddrs[12:10]==3'b010);
assign shdr_wren1  = shdr_wren & (thread_q2==2'b01) & (shdr_wraddrs[12:10]==3'b010);
assign shdr_wren0  = shdr_wren & (thread_q2==2'b00) & (shdr_wraddrs[12:10]==3'b010);

assign shdr_wrenIRB = shdr_wren & (shdr_wraddrs[12:11]==2'b10);
                   
assign cgs_wren3   = cgs_wren & (cgs_wraddrs[12:10]==3'b011);
assign cgs_wren2   = cgs_wren & (cgs_wraddrs[12:10]==3'b010);
assign cgs_wren1   = cgs_wren & (cgs_wraddrs[12:10]==3'b001);
assign cgs_wren0   = cgs_wren & (cgs_wraddrs[12:10]==3'b000);

assign cgs_wrenIRB = cgs_wren & (cgs_wraddrs[12:11]==2'b10);
                   
assign shdr_rdenA3 = shdr_rdenA & (thread==2'b11) & (shdr_rdaddrsA[12:10]==3'b010);
assign shdr_rdenA2 = shdr_rdenA & (thread==2'b10) & (shdr_rdaddrsA[12:10]==3'b010);
assign shdr_rdenA1 = shdr_rdenA & (thread==2'b01) & (shdr_rdaddrsA[12:10]==3'b010);
assign shdr_rdenA0 = shdr_rdenA & (thread==2'b00) & (shdr_rdaddrsA[12:10]==3'b010);

assign shdr_rdenA_IRB = shdr_rdenA & (shdr_rdaddrsA[12:11]==2'b10);
                   
assign shdr_rdenB3 = shdr_rdenB & (thread==2'b11) & (shdr_rdaddrsB[12:10]==3'b010);
assign shdr_rdenB2 = shdr_rdenB & (thread==2'b10) & (shdr_rdaddrsB[12:10]==3'b010);
assign shdr_rdenB1 = shdr_rdenB & (thread==2'b01) & (shdr_rdaddrsB[12:10]==3'b010);
assign shdr_rdenB0 = shdr_rdenB & (thread==2'b00) & (shdr_rdaddrsB[12:10]==3'b010);

assign shdr_rdenB_IRB = shdr_rdenB & (shdr_rdaddrsB[12:11]==2'b10);
                   
assign cgs_rden3   = cgs_rden & (cgs_rdaddrs[12:10]==3'b011);
assign cgs_rden2   = cgs_rden & (cgs_rdaddrs[12:10]==3'b010);
assign cgs_rden1   = cgs_rden & (cgs_rdaddrs[12:10]==3'b001);
assign cgs_rden0   = cgs_rden & (cgs_rdaddrs[12:10]==3'b000);

assign cgs_rdenIRB = cgs_rden & (cgs_rdaddrs[12:11]==2'b10);
                   
assign DMA1_rden3  = DMA1_rden & (DMA1_rdaddrs[12:10]==3'b011);
assign DMA1_rden2  = DMA1_rden & (DMA1_rdaddrs[12:10]==3'b010);
assign DMA1_rden1  = DMA1_rden & (DMA1_rdaddrs[12:10]==3'b001);
assign DMA1_rden0  = DMA1_rden & (DMA1_rdaddrs[12:10]==3'b000);

assign DMA1_rdenIRB   = DMA1_rden & (DMA1_rdaddrs[12:11]==2'b10);
                   
assign DMA0_wren3  = DMA0_wren & (DMA0_wraddrs[12:10]==3'b011);
assign DMA0_wren2  = DMA0_wren & (DMA0_wraddrs[12:10]==3'b010);
assign DMA0_wren1  = DMA0_wren & (DMA0_wraddrs[12:10]==3'b001);
assign DMA0_wren0  = DMA0_wren & (DMA0_wraddrs[12:10]==3'b000);

assign DMA0_wrenIRB   = DMA0_wren & (DMA0_wraddrs[12:11]==2'b10);

assign DMA0_collide = (cgs_wren3 & DMA0_wren3) |
                      (cgs_wren2 & DMA0_wren2) |
                      (cgs_wren1 & DMA0_wren1) |
                      (cgs_wren0 & DMA0_wren0) |
                      (cgs_wrenIRB & DMA0_wrenIRB);

assign DMA1_collide = (cgs_rden3   & DMA1_rden3)   |
                      (cgs_rden2   & DMA1_rden2)   |
                      (cgs_rden1   & DMA1_rden1)   |
                      (cgs_rden0   & DMA1_rden0)   |
                      (cgs_rdenIRB & DMA1_rdenIRB) |
                      (shdr_rdenB3 & DMA1_rden3)   |
                      (shdr_rdenB2 & DMA1_rden2)   |
                      (shdr_rdenB1 & DMA1_rden1)   |
                      (shdr_rdenB0 & DMA1_rden0)   |
                      (shdr_rdenB_IRB & DMA1_rdenIRB);
 
                        
RAM_tp #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    PDB_3(      // 1k x 32   private parameter-data buffer thread3
    .CLK      (CLK ),
    .wren     (shdr_wren3 ? 1'b1 : (cgs_wren3 ? 1'b1 : DMA0_wren3)),
    .wraddrs  (shdr_wren3 ? shdr_wraddrs[9:0] : (cgs_wren3 ? cgs_wraddrs[9:0] : DMA0_wraddrs[9:0])),
    .wrdata   (shdr_wren3 ? shdr_wrdata : (cgs_wren3 ? cgs_wrdata : DMA0_wrdata)),
    .rdenA    (shdr_rdenA3 ? 1'b1 : cgs_rden3),
    .rdaddrsA (shdr_rdenA3 ? shdr_rdaddrsA[9:0] : cgs_rdaddrs[9:0]),
    .rddataA  (rddataA3),
    .rdenB    (shdr_rdenB3 ? 1'b1 : DMA1_rden3),
    .rdaddrsB (shdr_rdenB3 ? shdr_rdaddrsB[9:0] :  DMA1_rdaddrs[9:0]),
    .rddataB  (rddataB3)
     );

RAM_tp #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    PDB_2(      // 1k x 32   private parameter-data buffer thread2
    .CLK      (CLK ),
    .wren     (shdr_wren2 ? 1'b1 : (cgs_wren2 ? 1'b1 : DMA0_wren2)),
    .wraddrs  (shdr_wren2 ? shdr_wraddrs[9:0] : (cgs_wren2 ? cgs_wraddrs[9:0] : DMA0_wraddrs[9:0])),
    .wrdata   (shdr_wren2 ? shdr_wrdata : (cgs_wren2 ? cgs_wrdata : DMA0_wrdata)),
    .rdenA    (shdr_rdenA2 ? 1'b1 : cgs_rden2),
    .rdaddrsA (shdr_rdenA2 ? shdr_rdaddrsA[9:0] : cgs_rdaddrs[9:0]),
    .rddataA  (rddataA2),
    .rdenB    (shdr_rdenB2 ? 1'b1 : DMA1_rden2),
    .rdaddrsB (shdr_rdenB2 ? shdr_rdaddrsB[9:0] :  DMA1_rdaddrs[9:0]),
    .rddataB  (rddataB2)
     );

RAM_tp #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    PDB_1(      // 1k x 32   private parameter-data buffer thread1
    .CLK      (CLK ),
    .wren     (shdr_wren1 ? 1'b1 : (cgs_wren1 ? 1'b1 : DMA0_wren1)),
    .wraddrs  (shdr_wren1 ? shdr_wraddrs[9:0] : (cgs_wren1 ? cgs_wraddrs[9:0] : DMA0_wraddrs[9:0])),
    .wrdata   (shdr_wren1 ? shdr_wrdata : (cgs_wren1 ? cgs_wrdata : DMA0_wrdata)),
    .rdenA    (shdr_rdenA1 ? 1'b1 : cgs_rden1),
    .rdaddrsA (shdr_rdenA1 ? shdr_rdaddrsA[9:0] : cgs_rdaddrs[9:0]),
    .rddataA  (rddataA1),
    .rdenB    (shdr_rdenB1 ? 1'b1 : DMA1_rden1),
    .rdaddrsB (shdr_rdenB1 ? shdr_rdaddrsB[9:0] :  DMA1_rdaddrs[9:0]),
    .rddataB  (rddataB1)
     );

RAM_tp #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    PDB_0(      // 1k x 32   private parameter-data buffer thread0
    .CLK      (CLK ),
    .wren     (shdr_wren0 ? 1'b1 : (cgs_wren0 ? 1'b1 : DMA0_wren0)),
    .wraddrs  (shdr_wren0 ? shdr_wraddrs[9:0] : (cgs_wren0 ? cgs_wraddrs[9:0] : DMA0_wraddrs[9:0])),
    .wrdata   (shdr_wren0 ? shdr_wrdata : (cgs_wren0 ? cgs_wrdata : DMA0_wrdata)),
    .rdenA    (shdr_rdenA0 ? 1'b1 : cgs_rden0),
    .rdaddrsA (shdr_rdenA0 ? shdr_rdaddrsA[9:0] : cgs_rdaddrs[9:0]),
    .rddataA  (rddataA0),
    .rdenB    (shdr_rdenB0 ? 1'b1 : DMA1_rden0),
    .rdaddrsB (shdr_rdenB0 ? shdr_rdaddrsB[9:0] :  DMA1_rdaddrs[9:0]),
    .rddataB  (rddataB0)
     );

RAM_tp #(.ADDRS_WIDTH(12), .DATA_WIDTH(32))
    IRB(      // 4k x 32  global intermediate result buffer 
    .CLK      (CLK ),
    .wren     (shdr_wrenIRB ? 1'b1 : (cgs_wrenIRB ? 1'b1 : DMA0_wrenIRB)),
    .wraddrs  (shdr_wrenIRB ? shdr_wraddrs[11:0] : (cgs_wrenIRB ? cgs_wraddrs[11:0] : DMA0_wraddrs[11:0])),
    .wrdata   (shdr_wrenIRB ? shdr_wrdata : (cgs_wrenIRB ? cgs_wrdata : DMA0_wrdata)),
    .rdenA    (shdr_rdenA_IRB),
    .rdaddrsA (shdr_rdaddrsA[11:0]),
    .rddataA  (rddataA_IRB),
    .rdenB    (shdr_rdenB_IRB ? 1'b1 : (cgs_rdenIRB ? 1'b1 : DMA1_rdenIRB)),
    .rdaddrsB (shdr_rdenB_IRB ? shdr_rdaddrsB[11:0] : (cgs_rdenIRB ? cgs_rdaddrs[11:0] : DMA1_rdaddrs[11:0])),
    .rddataB  (rddataB_IRB)
     );

always @(posedge CLK) begin
    DMA1_rdsel_q1   <= {DMA1_rdenIRB, DMA1_rden3, DMA1_rden2, DMA1_rden1, DMA1_rden0};
    cgs_rdsel_q1    <= {cgs_rdenIRB, cgs_rden3, cgs_rden2, cgs_rden1, cgs_rden0}; 
    shdr_rdselA_q1  <= {shdr_rdenA_IRB, shdr_rdenA3, shdr_rdenA2, shdr_rdenA1, shdr_rdenA0};
    shdr_rdselB_q1  <= {shdr_rdenB_IRB, shdr_rdenB3, shdr_rdenB2, shdr_rdenB1, shdr_rdenB0};
end

always @(*)
    if (|shdr_rdselA_q1)
        casex (shdr_rdselA_q1)
            5'bxxxx1 : shdr_rddataA = rddataA0;
            5'bxxx1x : shdr_rddataA = rddataA1;
            5'bxx1xx : shdr_rddataA = rddataA2;
            5'bx1xxx : shdr_rddataA = rddataA3;
            5'b1xxxx : shdr_rddataA = rddataA_IRB;
             default : shdr_rddataA = 32'h0000_0000;  
        endcase
    else shdr_rddataA = 32'h0000_0000;

always @(*)
    if (|cgs_rdsel_q1)
        casex (cgs_rdsel_q1)
            5'bxxxx1 : cgs_rddata = rddataA0;
            5'bxxx1x : cgs_rddata = rddataA1;
            5'bxx1xx : cgs_rddata = rddataA2;
            5'bx1xxx : cgs_rddata = rddataA3;
            5'b1xxxx : cgs_rddata = rddataA_IRB;
             default : cgs_rddata = 32'h0000_0000;
        endcase
    else cgs_rddata = 32'h0000_0000;

always @(*)
    if (|shdr_rdselB_q1)
        casex (shdr_rdselB_q1)
            5'bxxxx1 : shdr_rddataB = rddataB0;
            5'bxxx1x : shdr_rddataB = rddataB1;
            5'bxx1xx : shdr_rddataB = rddataB2;
            5'bx1xxx : shdr_rddataB = rddataB3;
            5'b1xxxx : shdr_rddataB = rddataB_IRB;
             default : shdr_rddataB = 32'h0000_0000;
        endcase
    else shdr_rddataB = 32'h0000_0000;

always @(*)
    if (|DMA1_rdsel_q1)
        casex (DMA1_rdsel_q1)
            5'bxxxx1 : DMA1_rddata = rddataB0;
            5'bxxx1x : DMA1_rddata = rddataB1;
            5'bxx1xx : DMA1_rddata = rddataB2;
            5'bx1xxx : DMA1_rddata = rddataB3;
            5'b1xxxx : DMA1_rddata = rddataB_IRB;
             default : DMA1_rddata = 32'h0000_0000;
        endcase
    else DMA1_rddata = 32'h0000_0000;
        

endmodule

