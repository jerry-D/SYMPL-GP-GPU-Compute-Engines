 // 64k x 32 x 3 SRAM for SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-Compute Engine
 `timescale 1ns/1ns
 // For use in SYMPL FP32S multi-thread multi-processing core only
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

module datapool_64kx32(
    CLKA,
    CLKB,
    cgs_wren,
    cgs_wraddrs,
    cgs_wrdata,
    cgs_rden,
    cgs_rdaddrs,
    cgs_rddata,
    DMA1_wren,
    DMA1_wraddrs,
    DMA1_wrdata,
    DMA0_rden,
    DMA0_rdaddrs,
    DMA0_rddata,
    SYS_wren,
    SYS_wraddrs,
    SYS_wrdata,
    SYS_rden,
    SYS_rdaddrs,
    SYS_rddata,
    DMA1_collide,
    DMA0_collide
//    SYSWRcollide,
//    SYSRDcollide
    );
    
input         CLKA;    
input         CLKB;    
input         cgs_wren;
input  [15:0] cgs_wraddrs;
input  [31:0] cgs_wrdata;
input         cgs_rden;
input  [15:0] cgs_rdaddrs;
output [31:0] cgs_rddata;
input         DMA1_wren;
input  [15:0] DMA1_wraddrs;
input  [31:0] DMA1_wrdata;
input         DMA0_rden;
input  [15:0] DMA0_rdaddrs;
output [31:0] DMA0_rddata;
input         SYS_wren;
input  [15:0] SYS_wraddrs;
input  [31:0] SYS_wrdata;
input         SYS_rden;
input  [15:0] SYS_rdaddrs;
output [31:0] SYS_rddata;
output        DMA0_collide;
output        DMA1_collide;
//output        SYSWRcollide;
//output        SYSRDcollide;
              
reg [31:0] SYS_rddata;
reg [31:0] DMA0_rddata;
reg [31:0] cgs_rddata;

reg [5:0] DMA0_rdaddrs_q1;
reg [5:0] cgs_rdaddrs_q1; 
reg [5:0] SYS_rdaddrs_q1; 

wire DMA0_collide;
wire DMA1_collide;

wire cgs_rden63;
wire cgs_rden62;
wire cgs_rden61;
wire cgs_rden60;
wire cgs_rden59;
wire cgs_rden58;
wire cgs_rden57;
wire cgs_rden56;
wire cgs_rden55;
wire cgs_rden54;
wire cgs_rden53;
wire cgs_rden52;
wire cgs_rden51;
wire cgs_rden50;
wire cgs_rden49;
wire cgs_rden48;
wire cgs_rden47;
wire cgs_rden46;
wire cgs_rden45;
wire cgs_rden44;
wire cgs_rden43;
wire cgs_rden42;
wire cgs_rden41;
wire cgs_rden40;
wire cgs_rden39;
wire cgs_rden38;
wire cgs_rden37;
wire cgs_rden36;
wire cgs_rden35;
wire cgs_rden34;
wire cgs_rden33;
wire cgs_rden32;
wire cgs_rden31;
wire cgs_rden30;
wire cgs_rden29;
wire cgs_rden28;
wire cgs_rden27;
wire cgs_rden26;
wire cgs_rden25;
wire cgs_rden24;
wire cgs_rden23;
wire cgs_rden22;
wire cgs_rden21;
wire cgs_rden20;
wire cgs_rden19;
wire cgs_rden18;
wire cgs_rden17;
wire cgs_rden16;
wire cgs_rden15;
wire cgs_rden14;
wire cgs_rden13;
wire cgs_rden12;
wire cgs_rden11;
wire cgs_rden10;
wire cgs_rden9;
wire cgs_rden8;
wire cgs_rden7;
wire cgs_rden6;
wire cgs_rden5;
wire cgs_rden4;
wire cgs_rden3;
wire cgs_rden2;
wire cgs_rden1;
wire cgs_rden0;

wire cgs_wren63;
wire cgs_wren62;
wire cgs_wren61;
wire cgs_wren60;
wire cgs_wren59;
wire cgs_wren58;
wire cgs_wren57;
wire cgs_wren56;
wire cgs_wren55;
wire cgs_wren54;
wire cgs_wren53;
wire cgs_wren52;
wire cgs_wren51;
wire cgs_wren50;
wire cgs_wren49;
wire cgs_wren48;
wire cgs_wren47;
wire cgs_wren46;
wire cgs_wren45;
wire cgs_wren44;
wire cgs_wren43;
wire cgs_wren42;
wire cgs_wren41;
wire cgs_wren40;
wire cgs_wren39;
wire cgs_wren38;
wire cgs_wren37;
wire cgs_wren36;
wire cgs_wren35;
wire cgs_wren34;
wire cgs_wren33;
wire cgs_wren32;
wire cgs_wren31;
wire cgs_wren30;
wire cgs_wren29;
wire cgs_wren28;
wire cgs_wren27;
wire cgs_wren26;
wire cgs_wren25;
wire cgs_wren24;
wire cgs_wren23;
wire cgs_wren22;
wire cgs_wren21;
wire cgs_wren20;
wire cgs_wren19;
wire cgs_wren18;
wire cgs_wren17;
wire cgs_wren16;
wire cgs_wren15;
wire cgs_wren14;
wire cgs_wren13;
wire cgs_wren12;
wire cgs_wren11;
wire cgs_wren10;
wire cgs_wren9;
wire cgs_wren8;
wire cgs_wren7;
wire cgs_wren6;
wire cgs_wren5;
wire cgs_wren4;
wire cgs_wren3;
wire cgs_wren2;
wire cgs_wren1;
wire cgs_wren0;

wire SYS_rden63;
wire SYS_rden62;
wire SYS_rden61;
wire SYS_rden60;
wire SYS_rden59;
wire SYS_rden58;
wire SYS_rden57;
wire SYS_rden56;
wire SYS_rden55;
wire SYS_rden54;
wire SYS_rden53;
wire SYS_rden52;
wire SYS_rden51;
wire SYS_rden50;
wire SYS_rden49;
wire SYS_rden48;
wire SYS_rden47;
wire SYS_rden46;
wire SYS_rden45;
wire SYS_rden44;
wire SYS_rden43;
wire SYS_rden42;
wire SYS_rden41;
wire SYS_rden40;
wire SYS_rden39;
wire SYS_rden38;
wire SYS_rden37;
wire SYS_rden36;
wire SYS_rden35;
wire SYS_rden34;
wire SYS_rden33;
wire SYS_rden32;
wire SYS_rden31;
wire SYS_rden30;
wire SYS_rden29;
wire SYS_rden28;
wire SYS_rden27;
wire SYS_rden26;
wire SYS_rden25;
wire SYS_rden24;
wire SYS_rden23;
wire SYS_rden22;
wire SYS_rden21;
wire SYS_rden20;
wire SYS_rden19;
wire SYS_rden18;
wire SYS_rden17;
wire SYS_rden16;
wire SYS_rden15;
wire SYS_rden14;
wire SYS_rden13;
wire SYS_rden12;
wire SYS_rden11;
wire SYS_rden10;
wire SYS_rden9;
wire SYS_rden8;
wire SYS_rden7;
wire SYS_rden6;
wire SYS_rden5;
wire SYS_rden4;
wire SYS_rden3;
wire SYS_rden2;
wire SYS_rden1;
wire SYS_rden0;

wire SYS_wren63;
wire SYS_wren62;
wire SYS_wren61;
wire SYS_wren60;
wire SYS_wren59;
wire SYS_wren58;
wire SYS_wren57;
wire SYS_wren56;
wire SYS_wren55;
wire SYS_wren54;
wire SYS_wren53;
wire SYS_wren52;
wire SYS_wren51;
wire SYS_wren50;
wire SYS_wren49;
wire SYS_wren48;
wire SYS_wren47;
wire SYS_wren46;
wire SYS_wren45;
wire SYS_wren44;
wire SYS_wren43;
wire SYS_wren42;
wire SYS_wren41;
wire SYS_wren40;
wire SYS_wren39;
wire SYS_wren38;
wire SYS_wren37;
wire SYS_wren36;
wire SYS_wren35;
wire SYS_wren34;
wire SYS_wren33;
wire SYS_wren32;
wire SYS_wren31;
wire SYS_wren30;
wire SYS_wren29;
wire SYS_wren28;
wire SYS_wren27;
wire SYS_wren26;
wire SYS_wren25;
wire SYS_wren24;
wire SYS_wren23;
wire SYS_wren22;
wire SYS_wren21;
wire SYS_wren20;
wire SYS_wren19;
wire SYS_wren18;
wire SYS_wren17;
wire SYS_wren16;
wire SYS_wren15;
wire SYS_wren14;
wire SYS_wren13;
wire SYS_wren12;
wire SYS_wren11;
wire SYS_wren10;
wire SYS_wren9;
wire SYS_wren8;
wire SYS_wren7;
wire SYS_wren6;
wire SYS_wren5;
wire SYS_wren4;
wire SYS_wren3;
wire SYS_wren2;
wire SYS_wren1;
wire SYS_wren0;

wire DMA0_rden63;
wire DMA0_rden62;
wire DMA0_rden61;
wire DMA0_rden60;
wire DMA0_rden59;
wire DMA0_rden58;
wire DMA0_rden57;
wire DMA0_rden56;
wire DMA0_rden55;
wire DMA0_rden54;
wire DMA0_rden53;
wire DMA0_rden52;
wire DMA0_rden51;
wire DMA0_rden50;
wire DMA0_rden49;
wire DMA0_rden48;
wire DMA0_rden47;
wire DMA0_rden46;
wire DMA0_rden45;
wire DMA0_rden44;
wire DMA0_rden43;
wire DMA0_rden42;
wire DMA0_rden41;
wire DMA0_rden40;
wire DMA0_rden39;
wire DMA0_rden38;
wire DMA0_rden37;
wire DMA0_rden36;
wire DMA0_rden35;
wire DMA0_rden34;
wire DMA0_rden33;
wire DMA0_rden32;
wire DMA0_rden31;
wire DMA0_rden30;
wire DMA0_rden29;
wire DMA0_rden28;
wire DMA0_rden27;
wire DMA0_rden26;
wire DMA0_rden25;
wire DMA0_rden24;
wire DMA0_rden23;
wire DMA0_rden22;
wire DMA0_rden21;
wire DMA0_rden20;
wire DMA0_rden19;
wire DMA0_rden18;
wire DMA0_rden17;
wire DMA0_rden16;
wire DMA0_rden15;
wire DMA0_rden14;
wire DMA0_rden13;
wire DMA0_rden12;
wire DMA0_rden11;
wire DMA0_rden10;
wire DMA0_rden9;
wire DMA0_rden8;
wire DMA0_rden7;
wire DMA0_rden6;
wire DMA0_rden5;
wire DMA0_rden4;
wire DMA0_rden3;
wire DMA0_rden2;
wire DMA0_rden1;
wire DMA0_rden0;

wire DMA1_wren63;
wire DMA1_wren62;
wire DMA1_wren61;
wire DMA1_wren60;
wire DMA1_wren59;
wire DMA1_wren58;
wire DMA1_wren57;
wire DMA1_wren56;
wire DMA1_wren55;
wire DMA1_wren54;
wire DMA1_wren53;
wire DMA1_wren52;
wire DMA1_wren51;
wire DMA1_wren50;
wire DMA1_wren49;
wire DMA1_wren48;
wire DMA1_wren47;
wire DMA1_wren46;
wire DMA1_wren45;
wire DMA1_wren44;
wire DMA1_wren43;
wire DMA1_wren42;
wire DMA1_wren41;
wire DMA1_wren40;
wire DMA1_wren39;
wire DMA1_wren38;
wire DMA1_wren37;
wire DMA1_wren36;
wire DMA1_wren35;
wire DMA1_wren34;
wire DMA1_wren33;
wire DMA1_wren32;
wire DMA1_wren31;
wire DMA1_wren30;
wire DMA1_wren29;
wire DMA1_wren28;
wire DMA1_wren27;
wire DMA1_wren26;
wire DMA1_wren25;
wire DMA1_wren24;
wire DMA1_wren23;
wire DMA1_wren22;
wire DMA1_wren21;
wire DMA1_wren20;
wire DMA1_wren19;
wire DMA1_wren18;
wire DMA1_wren17;
wire DMA1_wren16;
wire DMA1_wren15;
wire DMA1_wren14;
wire DMA1_wren13;
wire DMA1_wren12;
wire DMA1_wren11;
wire DMA1_wren10;
wire DMA1_wren9;
wire DMA1_wren8;
wire DMA1_wren7;
wire DMA1_wren6;
wire DMA1_wren5;
wire DMA1_wren4;
wire DMA1_wren3;
wire DMA1_wren2;
wire DMA1_wren1;
wire DMA1_wren0;

wire [31:0] rddataB_63;
wire [31:0] rddataB_62;
wire [31:0] rddataB_61;
wire [31:0] rddataB_60;
wire [31:0] rddataB_59;
wire [31:0] rddataB_58;
wire [31:0] rddataB_57;
wire [31:0] rddataB_56;
wire [31:0] rddataB_55;
wire [31:0] rddataB_54;
wire [31:0] rddataB_53;
wire [31:0] rddataB_52;
wire [31:0] rddataB_51;
wire [31:0] rddataB_50;
wire [31:0] rddataB_49;
wire [31:0] rddataB_48;
wire [31:0] rddataB_47;
wire [31:0] rddataB_46;
wire [31:0] rddataB_45;
wire [31:0] rddataB_44;
wire [31:0] rddataB_43;
wire [31:0] rddataB_42;
wire [31:0] rddataB_41;
wire [31:0] rddataB_40;
wire [31:0] rddataB_39;
wire [31:0] rddataB_38;
wire [31:0] rddataB_37;
wire [31:0] rddataB_36;
wire [31:0] rddataB_35;
wire [31:0] rddataB_34;
wire [31:0] rddataB_33;
wire [31:0] rddataB_32;
wire [31:0] rddataB_31;
wire [31:0] rddataB_30;
wire [31:0] rddataB_29;
wire [31:0] rddataB_28;
wire [31:0] rddataB_27;
wire [31:0] rddataB_26;
wire [31:0] rddataB_25;
wire [31:0] rddataB_24;
wire [31:0] rddataB_23;
wire [31:0] rddataB_22;
wire [31:0] rddataB_21;
wire [31:0] rddataB_20;
wire [31:0] rddataB_19;
wire [31:0] rddataB_18;
wire [31:0] rddataB_17;
wire [31:0] rddataB_16;
wire [31:0] rddataB_15;
wire [31:0] rddataB_14;
wire [31:0] rddataB_13;
wire [31:0] rddataB_12;
wire [31:0] rddataB_11;
wire [31:0] rddataB_10;
wire [31:0] rddataB_9;
wire [31:0] rddataB_8;
wire [31:0] rddataB_7;
wire [31:0] rddataB_6;
wire [31:0] rddataB_5;
wire [31:0] rddataB_4;
wire [31:0] rddataB_3;
wire [31:0] rddataB_2;
wire [31:0] rddataB_1;
wire [31:0] rddataB_0;

wire [31:0] SYS_rddata63;
wire [31:0] SYS_rddata62;
wire [31:0] SYS_rddata61;
wire [31:0] SYS_rddata60;
wire [31:0] SYS_rddata59;
wire [31:0] SYS_rddata58;
wire [31:0] SYS_rddata57;
wire [31:0] SYS_rddata56;
wire [31:0] SYS_rddata55;
wire [31:0] SYS_rddata54;
wire [31:0] SYS_rddata53;
wire [31:0] SYS_rddata52;
wire [31:0] SYS_rddata51;
wire [31:0] SYS_rddata50;
wire [31:0] SYS_rddata49;
wire [31:0] SYS_rddata48;
wire [31:0] SYS_rddata47;
wire [31:0] SYS_rddata46;
wire [31:0] SYS_rddata45;
wire [31:0] SYS_rddata44;
wire [31:0] SYS_rddata43;
wire [31:0] SYS_rddata42;
wire [31:0] SYS_rddata41;
wire [31:0] SYS_rddata40;
wire [31:0] SYS_rddata39;
wire [31:0] SYS_rddata38;
wire [31:0] SYS_rddata37;
wire [31:0] SYS_rddata36;
wire [31:0] SYS_rddata35;
wire [31:0] SYS_rddata34;
wire [31:0] SYS_rddata33;
wire [31:0] SYS_rddata32;
wire [31:0] SYS_rddata31;
wire [31:0] SYS_rddata30;
wire [31:0] SYS_rddata29;
wire [31:0] SYS_rddata28;
wire [31:0] SYS_rddata27;
wire [31:0] SYS_rddata26;
wire [31:0] SYS_rddata25;
wire [31:0] SYS_rddata24;
wire [31:0] SYS_rddata23;
wire [31:0] SYS_rddata22;
wire [31:0] SYS_rddata21;
wire [31:0] SYS_rddata20;
wire [31:0] SYS_rddata19;
wire [31:0] SYS_rddata18;
wire [31:0] SYS_rddata17;
wire [31:0] SYS_rddata16;
wire [31:0] SYS_rddata15;
wire [31:0] SYS_rddata14;
wire [31:0] SYS_rddata13;
wire [31:0] SYS_rddata12;
wire [31:0] SYS_rddata11;
wire [31:0] SYS_rddata10;
wire [31:0] SYS_rddata9;
wire [31:0] SYS_rddata8;
wire [31:0] SYS_rddata7;
wire [31:0] SYS_rddata6;
wire [31:0] SYS_rddata5;
wire [31:0] SYS_rddata4;
wire [31:0] SYS_rddata3;
wire [31:0] SYS_rddata2;
wire [31:0] SYS_rddata1;
wire [31:0] SYS_rddata0;
                      
assign cgs_rden63 = cgs_rden & (cgs_rdaddrs[15:10]==6'b111111);
assign cgs_rden62 = cgs_rden & (cgs_rdaddrs[15:10]==6'b111110);
assign cgs_rden61 = cgs_rden & (cgs_rdaddrs[15:10]==6'b111101);
assign cgs_rden60 = cgs_rden & (cgs_rdaddrs[15:10]==6'b111100);
assign cgs_rden59 = cgs_rden & (cgs_rdaddrs[15:10]==6'b111011);
assign cgs_rden58 = cgs_rden & (cgs_rdaddrs[15:10]==6'b111010);
assign cgs_rden57 = cgs_rden & (cgs_rdaddrs[15:10]==6'b111001);
assign cgs_rden56 = cgs_rden & (cgs_rdaddrs[15:10]==6'b111000);
assign cgs_rden55 = cgs_rden & (cgs_rdaddrs[15:10]==6'b110111);
assign cgs_rden54 = cgs_rden & (cgs_rdaddrs[15:10]==6'b110110);
assign cgs_rden53 = cgs_rden & (cgs_rdaddrs[15:10]==6'b110101);
assign cgs_rden52 = cgs_rden & (cgs_rdaddrs[15:10]==6'b110100);
assign cgs_rden51 = cgs_rden & (cgs_rdaddrs[15:10]==6'b110011);
assign cgs_rden50 = cgs_rden & (cgs_rdaddrs[15:10]==6'b110010);
assign cgs_rden49 = cgs_rden & (cgs_rdaddrs[15:10]==6'b110001);
assign cgs_rden48 = cgs_rden & (cgs_rdaddrs[15:10]==6'b110000);
assign cgs_rden47 = cgs_rden & (cgs_rdaddrs[15:10]==6'b101111);
assign cgs_rden46 = cgs_rden & (cgs_rdaddrs[15:10]==6'b101110);
assign cgs_rden45 = cgs_rden & (cgs_rdaddrs[15:10]==6'b101101);
assign cgs_rden44 = cgs_rden & (cgs_rdaddrs[15:10]==6'b101100);
assign cgs_rden43 = cgs_rden & (cgs_rdaddrs[15:10]==6'b101011);
assign cgs_rden42 = cgs_rden & (cgs_rdaddrs[15:10]==6'b101010);
assign cgs_rden41 = cgs_rden & (cgs_rdaddrs[15:10]==6'b101001);
assign cgs_rden40 = cgs_rden & (cgs_rdaddrs[15:10]==6'b101000);
assign cgs_rden39 = cgs_rden & (cgs_rdaddrs[15:10]==6'b100111);
assign cgs_rden38 = cgs_rden & (cgs_rdaddrs[15:10]==6'b100110);
assign cgs_rden37 = cgs_rden & (cgs_rdaddrs[15:10]==6'b100101);
assign cgs_rden36 = cgs_rden & (cgs_rdaddrs[15:10]==6'b100100);
assign cgs_rden35 = cgs_rden & (cgs_rdaddrs[15:10]==6'b100011);
assign cgs_rden34 = cgs_rden & (cgs_rdaddrs[15:10]==6'b100010);
assign cgs_rden33 = cgs_rden & (cgs_rdaddrs[15:10]==6'b100001);
assign cgs_rden32 = cgs_rden & (cgs_rdaddrs[15:10]==6'b100000);
assign cgs_rden31 = cgs_rden & (cgs_rdaddrs[15:10]==6'b011111);
assign cgs_rden30 = cgs_rden & (cgs_rdaddrs[15:10]==6'b011110);
assign cgs_rden29 = cgs_rden & (cgs_rdaddrs[15:10]==6'b011101);
assign cgs_rden28 = cgs_rden & (cgs_rdaddrs[15:10]==6'b011100);
assign cgs_rden27 = cgs_rden & (cgs_rdaddrs[15:10]==6'b011011);
assign cgs_rden26 = cgs_rden & (cgs_rdaddrs[15:10]==6'b011010);
assign cgs_rden25 = cgs_rden & (cgs_rdaddrs[15:10]==6'b011001);
assign cgs_rden24 = cgs_rden & (cgs_rdaddrs[15:10]==6'b011000);
assign cgs_rden23 = cgs_rden & (cgs_rdaddrs[15:10]==6'b010111);
assign cgs_rden22 = cgs_rden & (cgs_rdaddrs[15:10]==6'b010110);
assign cgs_rden21 = cgs_rden & (cgs_rdaddrs[15:10]==6'b010101);
assign cgs_rden20 = cgs_rden & (cgs_rdaddrs[15:10]==6'b010100);
assign cgs_rden19 = cgs_rden & (cgs_rdaddrs[15:10]==6'b010011);
assign cgs_rden18 = cgs_rden & (cgs_rdaddrs[15:10]==6'b010010);
assign cgs_rden17 = cgs_rden & (cgs_rdaddrs[15:10]==6'b010001);
assign cgs_rden16 = cgs_rden & (cgs_rdaddrs[15:10]==6'b010000);
assign cgs_rden15 = cgs_rden & (cgs_rdaddrs[15:10]==6'b001111);
assign cgs_rden14 = cgs_rden & (cgs_rdaddrs[15:10]==6'b001110);
assign cgs_rden13 = cgs_rden & (cgs_rdaddrs[15:10]==6'b001101);
assign cgs_rden12 = cgs_rden & (cgs_rdaddrs[15:10]==6'b001100);
assign cgs_rden11 = cgs_rden & (cgs_rdaddrs[15:10]==6'b001011);
assign cgs_rden10 = cgs_rden & (cgs_rdaddrs[15:10]==6'b001010);
assign cgs_rden9  = cgs_rden & (cgs_rdaddrs[15:10]==6'b001001);
assign cgs_rden8  = cgs_rden & (cgs_rdaddrs[15:10]==6'b001000);
assign cgs_rden7  = cgs_rden & (cgs_rdaddrs[15:10]==6'b000111);
assign cgs_rden6  = cgs_rden & (cgs_rdaddrs[15:10]==6'b000110);
assign cgs_rden5  = cgs_rden & (cgs_rdaddrs[15:10]==6'b000101);
assign cgs_rden4  = cgs_rden & (cgs_rdaddrs[15:10]==6'b000100);
assign cgs_rden3  = cgs_rden & (cgs_rdaddrs[15:10]==6'b000011);
assign cgs_rden2  = cgs_rden & (cgs_rdaddrs[15:10]==6'b000010);
assign cgs_rden1  = cgs_rden & (cgs_rdaddrs[15:10]==6'b000001);
assign cgs_rden0  = cgs_rden & (cgs_rdaddrs[15:10]==6'b000000);

assign cgs_wren63 = cgs_wren & (cgs_wraddrs[15:10]==6'b111111);
assign cgs_wren62 = cgs_wren & (cgs_wraddrs[15:10]==6'b111110);
assign cgs_wren61 = cgs_wren & (cgs_wraddrs[15:10]==6'b111101);
assign cgs_wren60 = cgs_wren & (cgs_wraddrs[15:10]==6'b111100);
assign cgs_wren59 = cgs_wren & (cgs_wraddrs[15:10]==6'b111011);
assign cgs_wren58 = cgs_wren & (cgs_wraddrs[15:10]==6'b111010);
assign cgs_wren57 = cgs_wren & (cgs_wraddrs[15:10]==6'b111001);
assign cgs_wren56 = cgs_wren & (cgs_wraddrs[15:10]==6'b111000);
assign cgs_wren55 = cgs_wren & (cgs_wraddrs[15:10]==6'b110111);
assign cgs_wren54 = cgs_wren & (cgs_wraddrs[15:10]==6'b110110);
assign cgs_wren53 = cgs_wren & (cgs_wraddrs[15:10]==6'b110101);
assign cgs_wren52 = cgs_wren & (cgs_wraddrs[15:10]==6'b110100);
assign cgs_wren51 = cgs_wren & (cgs_wraddrs[15:10]==6'b110011);
assign cgs_wren50 = cgs_wren & (cgs_wraddrs[15:10]==6'b110010);
assign cgs_wren49 = cgs_wren & (cgs_wraddrs[15:10]==6'b110001);
assign cgs_wren48 = cgs_wren & (cgs_wraddrs[15:10]==6'b110000);
assign cgs_wren47 = cgs_wren & (cgs_wraddrs[15:10]==6'b101111);
assign cgs_wren46 = cgs_wren & (cgs_wraddrs[15:10]==6'b101110);
assign cgs_wren45 = cgs_wren & (cgs_wraddrs[15:10]==6'b101101);
assign cgs_wren44 = cgs_wren & (cgs_wraddrs[15:10]==6'b101100);
assign cgs_wren43 = cgs_wren & (cgs_wraddrs[15:10]==6'b101011);
assign cgs_wren42 = cgs_wren & (cgs_wraddrs[15:10]==6'b101010);
assign cgs_wren41 = cgs_wren & (cgs_wraddrs[15:10]==6'b101001);
assign cgs_wren40 = cgs_wren & (cgs_wraddrs[15:10]==6'b101000);
assign cgs_wren39 = cgs_wren & (cgs_wraddrs[15:10]==6'b100111);
assign cgs_wren38 = cgs_wren & (cgs_wraddrs[15:10]==6'b100110);
assign cgs_wren37 = cgs_wren & (cgs_wraddrs[15:10]==6'b100101);
assign cgs_wren36 = cgs_wren & (cgs_wraddrs[15:10]==6'b100100);
assign cgs_wren35 = cgs_wren & (cgs_wraddrs[15:10]==6'b100011);
assign cgs_wren34 = cgs_wren & (cgs_wraddrs[15:10]==6'b100010);
assign cgs_wren33 = cgs_wren & (cgs_wraddrs[15:10]==6'b100001);
assign cgs_wren32 = cgs_wren & (cgs_wraddrs[15:10]==6'b100000);
assign cgs_wren31 = cgs_wren & (cgs_wraddrs[15:10]==6'b011111);
assign cgs_wren30 = cgs_wren & (cgs_wraddrs[15:10]==6'b011110);
assign cgs_wren29 = cgs_wren & (cgs_wraddrs[15:10]==6'b011101);
assign cgs_wren28 = cgs_wren & (cgs_wraddrs[15:10]==6'b011100);
assign cgs_wren27 = cgs_wren & (cgs_wraddrs[15:10]==6'b011011);
assign cgs_wren26 = cgs_wren & (cgs_wraddrs[15:10]==6'b011010);
assign cgs_wren25 = cgs_wren & (cgs_wraddrs[15:10]==6'b011001);
assign cgs_wren24 = cgs_wren & (cgs_wraddrs[15:10]==6'b011000);
assign cgs_wren23 = cgs_wren & (cgs_wraddrs[15:10]==6'b010111);
assign cgs_wren22 = cgs_wren & (cgs_wraddrs[15:10]==6'b010110);
assign cgs_wren21 = cgs_wren & (cgs_wraddrs[15:10]==6'b010101);
assign cgs_wren20 = cgs_wren & (cgs_wraddrs[15:10]==6'b010100);
assign cgs_wren19 = cgs_wren & (cgs_wraddrs[15:10]==6'b010011);
assign cgs_wren18 = cgs_wren & (cgs_wraddrs[15:10]==6'b010010);
assign cgs_wren17 = cgs_wren & (cgs_wraddrs[15:10]==6'b010001);
assign cgs_wren16 = cgs_wren & (cgs_wraddrs[15:10]==6'b010000);
assign cgs_wren15 = cgs_wren & (cgs_wraddrs[15:10]==6'b001111);
assign cgs_wren14 = cgs_wren & (cgs_wraddrs[15:10]==6'b001110);
assign cgs_wren13 = cgs_wren & (cgs_wraddrs[15:10]==6'b001101);
assign cgs_wren12 = cgs_wren & (cgs_wraddrs[15:10]==6'b001100);
assign cgs_wren11 = cgs_wren & (cgs_wraddrs[15:10]==6'b001011);
assign cgs_wren10 = cgs_wren & (cgs_wraddrs[15:10]==6'b001010);
assign cgs_wren9  = cgs_wren & (cgs_wraddrs[15:10]==6'b001001);
assign cgs_wren8  = cgs_wren & (cgs_wraddrs[15:10]==6'b001000);
assign cgs_wren7  = cgs_wren & (cgs_wraddrs[15:10]==6'b000111);
assign cgs_wren6  = cgs_wren & (cgs_wraddrs[15:10]==6'b000110);
assign cgs_wren5  = cgs_wren & (cgs_wraddrs[15:10]==6'b000101);
assign cgs_wren4  = cgs_wren & (cgs_wraddrs[15:10]==6'b000100);
assign cgs_wren3  = cgs_wren & (cgs_wraddrs[15:10]==6'b000011);
assign cgs_wren2  = cgs_wren & (cgs_wraddrs[15:10]==6'b000010);
assign cgs_wren1  = cgs_wren & (cgs_wraddrs[15:10]==6'b000001);
assign cgs_wren0  = cgs_wren & (cgs_wraddrs[15:10]==6'b000000);

assign SYS_rden63 = SYS_rden & (SYS_rdaddrs[15:10]==6'b111111);
assign SYS_rden62 = SYS_rden & (SYS_rdaddrs[15:10]==6'b111110);
assign SYS_rden61 = SYS_rden & (SYS_rdaddrs[15:10]==6'b111101);
assign SYS_rden60 = SYS_rden & (SYS_rdaddrs[15:10]==6'b111100);
assign SYS_rden59 = SYS_rden & (SYS_rdaddrs[15:10]==6'b111011);
assign SYS_rden58 = SYS_rden & (SYS_rdaddrs[15:10]==6'b111010);
assign SYS_rden57 = SYS_rden & (SYS_rdaddrs[15:10]==6'b111001);
assign SYS_rden56 = SYS_rden & (SYS_rdaddrs[15:10]==6'b111000);
assign SYS_rden55 = SYS_rden & (SYS_rdaddrs[15:10]==6'b110111);
assign SYS_rden54 = SYS_rden & (SYS_rdaddrs[15:10]==6'b110110);
assign SYS_rden53 = SYS_rden & (SYS_rdaddrs[15:10]==6'b110101);
assign SYS_rden52 = SYS_rden & (SYS_rdaddrs[15:10]==6'b110100);
assign SYS_rden51 = SYS_rden & (SYS_rdaddrs[15:10]==6'b110011);
assign SYS_rden50 = SYS_rden & (SYS_rdaddrs[15:10]==6'b110010);
assign SYS_rden49 = SYS_rden & (SYS_rdaddrs[15:10]==6'b110001);
assign SYS_rden48 = SYS_rden & (SYS_rdaddrs[15:10]==6'b110000);
assign SYS_rden47 = SYS_rden & (SYS_rdaddrs[15:10]==6'b101111);
assign SYS_rden46 = SYS_rden & (SYS_rdaddrs[15:10]==6'b101110);
assign SYS_rden45 = SYS_rden & (SYS_rdaddrs[15:10]==6'b101101);
assign SYS_rden44 = SYS_rden & (SYS_rdaddrs[15:10]==6'b101100);
assign SYS_rden43 = SYS_rden & (SYS_rdaddrs[15:10]==6'b101011);
assign SYS_rden42 = SYS_rden & (SYS_rdaddrs[15:10]==6'b101010);
assign SYS_rden41 = SYS_rden & (SYS_rdaddrs[15:10]==6'b101001);
assign SYS_rden40 = SYS_rden & (SYS_rdaddrs[15:10]==6'b101000);
assign SYS_rden39 = SYS_rden & (SYS_rdaddrs[15:10]==6'b100111);
assign SYS_rden38 = SYS_rden & (SYS_rdaddrs[15:10]==6'b100110);
assign SYS_rden37 = SYS_rden & (SYS_rdaddrs[15:10]==6'b100101);
assign SYS_rden36 = SYS_rden & (SYS_rdaddrs[15:10]==6'b100100);
assign SYS_rden35 = SYS_rden & (SYS_rdaddrs[15:10]==6'b100011);
assign SYS_rden34 = SYS_rden & (SYS_rdaddrs[15:10]==6'b100010);
assign SYS_rden33 = SYS_rden & (SYS_rdaddrs[15:10]==6'b100001);
assign SYS_rden32 = SYS_rden & (SYS_rdaddrs[15:10]==6'b100000);
assign SYS_rden31 = SYS_rden & (SYS_rdaddrs[15:10]==6'b011111);
assign SYS_rden30 = SYS_rden & (SYS_rdaddrs[15:10]==6'b011110);
assign SYS_rden29 = SYS_rden & (SYS_rdaddrs[15:10]==6'b011101);
assign SYS_rden28 = SYS_rden & (SYS_rdaddrs[15:10]==6'b011100);
assign SYS_rden27 = SYS_rden & (SYS_rdaddrs[15:10]==6'b011011);
assign SYS_rden26 = SYS_rden & (SYS_rdaddrs[15:10]==6'b011010);
assign SYS_rden25 = SYS_rden & (SYS_rdaddrs[15:10]==6'b011001);
assign SYS_rden24 = SYS_rden & (SYS_rdaddrs[15:10]==6'b011000);
assign SYS_rden23 = SYS_rden & (SYS_rdaddrs[15:10]==6'b010111);
assign SYS_rden22 = SYS_rden & (SYS_rdaddrs[15:10]==6'b010110);
assign SYS_rden21 = SYS_rden & (SYS_rdaddrs[15:10]==6'b010101);
assign SYS_rden20 = SYS_rden & (SYS_rdaddrs[15:10]==6'b010100);
assign SYS_rden19 = SYS_rden & (SYS_rdaddrs[15:10]==6'b010011);
assign SYS_rden18 = SYS_rden & (SYS_rdaddrs[15:10]==6'b010010);
assign SYS_rden17 = SYS_rden & (SYS_rdaddrs[15:10]==6'b010001);
assign SYS_rden16 = SYS_rden & (SYS_rdaddrs[15:10]==6'b010000);
assign SYS_rden15 = SYS_rden & (SYS_rdaddrs[15:10]==6'b001111);
assign SYS_rden14 = SYS_rden & (SYS_rdaddrs[15:10]==6'b001110);
assign SYS_rden13 = SYS_rden & (SYS_rdaddrs[15:10]==6'b001101);
assign SYS_rden12 = SYS_rden & (SYS_rdaddrs[15:10]==6'b001100);
assign SYS_rden11 = SYS_rden & (SYS_rdaddrs[15:10]==6'b001011);
assign SYS_rden10 = SYS_rden & (SYS_rdaddrs[15:10]==6'b001010);
assign SYS_rden9  = SYS_rden & (SYS_rdaddrs[15:10]==6'b001001);
assign SYS_rden8  = SYS_rden & (SYS_rdaddrs[15:10]==6'b001000);
assign SYS_rden7  = SYS_rden & (SYS_rdaddrs[15:10]==6'b000111);
assign SYS_rden6  = SYS_rden & (SYS_rdaddrs[15:10]==6'b000110);
assign SYS_rden5  = SYS_rden & (SYS_rdaddrs[15:10]==6'b000101);
assign SYS_rden4  = SYS_rden & (SYS_rdaddrs[15:10]==6'b000100);
assign SYS_rden3  = SYS_rden & (SYS_rdaddrs[15:10]==6'b000011);
assign SYS_rden2  = SYS_rden & (SYS_rdaddrs[15:10]==6'b000010);
assign SYS_rden1  = SYS_rden & (SYS_rdaddrs[15:10]==6'b000001);
assign SYS_rden0  = SYS_rden & (SYS_rdaddrs[15:10]==6'b000000);

assign SYS_wren63 = SYS_wren & (SYS_wraddrs[15:10]==6'b111111);
assign SYS_wren62 = SYS_wren & (SYS_wraddrs[15:10]==6'b111110);
assign SYS_wren61 = SYS_wren & (SYS_wraddrs[15:10]==6'b111101);
assign SYS_wren60 = SYS_wren & (SYS_wraddrs[15:10]==6'b111100);
assign SYS_wren59 = SYS_wren & (SYS_wraddrs[15:10]==6'b111011);
assign SYS_wren58 = SYS_wren & (SYS_wraddrs[15:10]==6'b111010);
assign SYS_wren57 = SYS_wren & (SYS_wraddrs[15:10]==6'b111001);
assign SYS_wren56 = SYS_wren & (SYS_wraddrs[15:10]==6'b111000);
assign SYS_wren55 = SYS_wren & (SYS_wraddrs[15:10]==6'b110111);
assign SYS_wren54 = SYS_wren & (SYS_wraddrs[15:10]==6'b110110);
assign SYS_wren53 = SYS_wren & (SYS_wraddrs[15:10]==6'b110101);
assign SYS_wren52 = SYS_wren & (SYS_wraddrs[15:10]==6'b110100);
assign SYS_wren51 = SYS_wren & (SYS_wraddrs[15:10]==6'b110011);
assign SYS_wren50 = SYS_wren & (SYS_wraddrs[15:10]==6'b110010);
assign SYS_wren49 = SYS_wren & (SYS_wraddrs[15:10]==6'b110001);
assign SYS_wren48 = SYS_wren & (SYS_wraddrs[15:10]==6'b110000);
assign SYS_wren47 = SYS_wren & (SYS_wraddrs[15:10]==6'b101111);
assign SYS_wren46 = SYS_wren & (SYS_wraddrs[15:10]==6'b101110);
assign SYS_wren45 = SYS_wren & (SYS_wraddrs[15:10]==6'b101101);
assign SYS_wren44 = SYS_wren & (SYS_wraddrs[15:10]==6'b101100);
assign SYS_wren43 = SYS_wren & (SYS_wraddrs[15:10]==6'b101011);
assign SYS_wren42 = SYS_wren & (SYS_wraddrs[15:10]==6'b101010);
assign SYS_wren41 = SYS_wren & (SYS_wraddrs[15:10]==6'b101001);
assign SYS_wren40 = SYS_wren & (SYS_wraddrs[15:10]==6'b101000);
assign SYS_wren39 = SYS_wren & (SYS_wraddrs[15:10]==6'b100111);
assign SYS_wren38 = SYS_wren & (SYS_wraddrs[15:10]==6'b100110);
assign SYS_wren37 = SYS_wren & (SYS_wraddrs[15:10]==6'b100101);
assign SYS_wren36 = SYS_wren & (SYS_wraddrs[15:10]==6'b100100);
assign SYS_wren35 = SYS_wren & (SYS_wraddrs[15:10]==6'b100011);
assign SYS_wren34 = SYS_wren & (SYS_wraddrs[15:10]==6'b100010);
assign SYS_wren33 = SYS_wren & (SYS_wraddrs[15:10]==6'b100001);
assign SYS_wren32 = SYS_wren & (SYS_wraddrs[15:10]==6'b100000);
assign SYS_wren31 = SYS_wren & (SYS_wraddrs[15:10]==6'b011111);
assign SYS_wren30 = SYS_wren & (SYS_wraddrs[15:10]==6'b011110);
assign SYS_wren29 = SYS_wren & (SYS_wraddrs[15:10]==6'b011101);
assign SYS_wren28 = SYS_wren & (SYS_wraddrs[15:10]==6'b011100);
assign SYS_wren27 = SYS_wren & (SYS_wraddrs[15:10]==6'b011011);
assign SYS_wren26 = SYS_wren & (SYS_wraddrs[15:10]==6'b011010);
assign SYS_wren25 = SYS_wren & (SYS_wraddrs[15:10]==6'b011001);
assign SYS_wren24 = SYS_wren & (SYS_wraddrs[15:10]==6'b011000);
assign SYS_wren23 = SYS_wren & (SYS_wraddrs[15:10]==6'b010111);
assign SYS_wren22 = SYS_wren & (SYS_wraddrs[15:10]==6'b010110);
assign SYS_wren21 = SYS_wren & (SYS_wraddrs[15:10]==6'b010101);
assign SYS_wren20 = SYS_wren & (SYS_wraddrs[15:10]==6'b010100);
assign SYS_wren19 = SYS_wren & (SYS_wraddrs[15:10]==6'b010011);
assign SYS_wren18 = SYS_wren & (SYS_wraddrs[15:10]==6'b010010);
assign SYS_wren17 = SYS_wren & (SYS_wraddrs[15:10]==6'b010001);
assign SYS_wren16 = SYS_wren & (SYS_wraddrs[15:10]==6'b010000);
assign SYS_wren15 = SYS_wren & (SYS_wraddrs[15:10]==6'b001111);
assign SYS_wren14 = SYS_wren & (SYS_wraddrs[15:10]==6'b001110);
assign SYS_wren13 = SYS_wren & (SYS_wraddrs[15:10]==6'b001101);
assign SYS_wren12 = SYS_wren & (SYS_wraddrs[15:10]==6'b001100);
assign SYS_wren11 = SYS_wren & (SYS_wraddrs[15:10]==6'b001011);
assign SYS_wren10 = SYS_wren & (SYS_wraddrs[15:10]==6'b001010);
assign SYS_wren9  = SYS_wren & (SYS_wraddrs[15:10]==6'b001001);
assign SYS_wren8  = SYS_wren & (SYS_wraddrs[15:10]==6'b001000);
assign SYS_wren7  = SYS_wren & (SYS_wraddrs[15:10]==6'b000111);
assign SYS_wren6  = SYS_wren & (SYS_wraddrs[15:10]==6'b000110);
assign SYS_wren5  = SYS_wren & (SYS_wraddrs[15:10]==6'b000101);
assign SYS_wren4  = SYS_wren & (SYS_wraddrs[15:10]==6'b000100);
assign SYS_wren3  = SYS_wren & (SYS_wraddrs[15:10]==6'b000011);
assign SYS_wren2  = SYS_wren & (SYS_wraddrs[15:10]==6'b000010);
assign SYS_wren1  = SYS_wren & (SYS_wraddrs[15:10]==6'b000001);
assign SYS_wren0  = SYS_wren & (SYS_wraddrs[15:10]==6'b000000);

assign DMA0_rden63 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b111111);
assign DMA0_rden62 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b111110);
assign DMA0_rden61 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b111101);
assign DMA0_rden60 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b111100);
assign DMA0_rden59 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b111011);
assign DMA0_rden58 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b111010);
assign DMA0_rden57 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b111001);
assign DMA0_rden56 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b111000);
assign DMA0_rden55 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b110111);
assign DMA0_rden54 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b110110);
assign DMA0_rden53 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b110101);
assign DMA0_rden52 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b110100);
assign DMA0_rden51 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b110011);
assign DMA0_rden50 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b110010);
assign DMA0_rden49 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b110001);
assign DMA0_rden48 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b110000);
assign DMA0_rden47 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b101111);
assign DMA0_rden46 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b101110);
assign DMA0_rden45 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b101101);
assign DMA0_rden44 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b101100);
assign DMA0_rden43 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b101011);
assign DMA0_rden42 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b101010);
assign DMA0_rden41 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b101001);
assign DMA0_rden40 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b101000);
assign DMA0_rden39 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b100111);
assign DMA0_rden38 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b100110);
assign DMA0_rden37 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b100101);
assign DMA0_rden36 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b100100);
assign DMA0_rden35 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b100011);
assign DMA0_rden34 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b100010);
assign DMA0_rden33 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b100001);
assign DMA0_rden32 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b100000);
assign DMA0_rden31 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b011111);
assign DMA0_rden30 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b011110);
assign DMA0_rden29 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b011101);
assign DMA0_rden28 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b011100);
assign DMA0_rden27 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b011011);
assign DMA0_rden26 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b011010);
assign DMA0_rden25 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b011001);
assign DMA0_rden24 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b011000);
assign DMA0_rden23 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b010111);
assign DMA0_rden22 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b010110);
assign DMA0_rden21 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b010101);
assign DMA0_rden20 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b010100);
assign DMA0_rden19 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b010011);
assign DMA0_rden18 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b010010);
assign DMA0_rden17 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b010001);
assign DMA0_rden16 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b010000);
assign DMA0_rden15 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b001111);
assign DMA0_rden14 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b001110);
assign DMA0_rden13 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b001101);
assign DMA0_rden12 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b001100);
assign DMA0_rden11 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b001011);
assign DMA0_rden10 = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b001010);
assign DMA0_rden9  = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b001001);
assign DMA0_rden8  = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b001000);
assign DMA0_rden7  = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b000111);
assign DMA0_rden6  = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b000110);
assign DMA0_rden5  = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b000101);
assign DMA0_rden4  = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b000100);
assign DMA0_rden3  = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b000011);
assign DMA0_rden2  = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b000010);
assign DMA0_rden1  = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b000001);
assign DMA0_rden0  = DMA0_rden & (DMA0_rdaddrs[15:10]==6'b000000);

assign DMA1_wren63 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b111111);
assign DMA1_wren62 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b111110);
assign DMA1_wren61 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b111101);
assign DMA1_wren60 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b111100);
assign DMA1_wren59 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b111011);
assign DMA1_wren58 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b111010);
assign DMA1_wren57 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b111001);
assign DMA1_wren56 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b111000);
assign DMA1_wren55 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b110111);
assign DMA1_wren54 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b110110);
assign DMA1_wren53 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b110101);
assign DMA1_wren52 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b110100);
assign DMA1_wren51 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b110011);
assign DMA1_wren50 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b110010);
assign DMA1_wren49 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b110001);
assign DMA1_wren48 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b110000);
assign DMA1_wren47 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b101111);
assign DMA1_wren46 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b101110);
assign DMA1_wren45 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b101101);
assign DMA1_wren44 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b101100);
assign DMA1_wren43 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b101011);
assign DMA1_wren42 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b101010);
assign DMA1_wren41 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b101001);
assign DMA1_wren40 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b101000);
assign DMA1_wren39 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b100111);
assign DMA1_wren38 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b100110);
assign DMA1_wren37 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b100101);
assign DMA1_wren36 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b100100);
assign DMA1_wren35 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b100011);
assign DMA1_wren34 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b100010);
assign DMA1_wren33 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b100001);
assign DMA1_wren32 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b100000);
assign DMA1_wren31 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b011111);
assign DMA1_wren30 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b011110);
assign DMA1_wren29 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b011101);
assign DMA1_wren28 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b011100);
assign DMA1_wren27 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b011011);
assign DMA1_wren26 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b011010);
assign DMA1_wren25 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b011001);
assign DMA1_wren24 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b011000);
assign DMA1_wren23 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b010111);
assign DMA1_wren22 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b010110);
assign DMA1_wren21 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b010101);
assign DMA1_wren20 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b010100);
assign DMA1_wren19 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b010011);
assign DMA1_wren18 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b010010);
assign DMA1_wren17 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b010001);
assign DMA1_wren16 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b010000);
assign DMA1_wren15 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b001111);
assign DMA1_wren14 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b001110);
assign DMA1_wren13 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b001101);
assign DMA1_wren12 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b001100);
assign DMA1_wren11 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b001011);
assign DMA1_wren10 = DMA1_wren & (DMA1_wraddrs[15:10]==6'b001010);
assign DMA1_wren9  = DMA1_wren & (DMA1_wraddrs[15:10]==6'b001001);
assign DMA1_wren8  = DMA1_wren & (DMA1_wraddrs[15:10]==6'b001000);
assign DMA1_wren7  = DMA1_wren & (DMA1_wraddrs[15:10]==6'b000111);
assign DMA1_wren6  = DMA1_wren & (DMA1_wraddrs[15:10]==6'b000110);
assign DMA1_wren5  = DMA1_wren & (DMA1_wraddrs[15:10]==6'b000101);
assign DMA1_wren4  = DMA1_wren & (DMA1_wraddrs[15:10]==6'b000100);
assign DMA1_wren3  = DMA1_wren & (DMA1_wraddrs[15:10]==6'b000011);
assign DMA1_wren2  = DMA1_wren & (DMA1_wraddrs[15:10]==6'b000010);
assign DMA1_wren1  = DMA1_wren & (DMA1_wraddrs[15:10]==6'b000001);
assign DMA1_wren0  = DMA1_wren & (DMA1_wraddrs[15:10]==6'b000000);

assign DMA0_collide = (DMA0_rden63 & cgs_rden63) |
                      (DMA0_rden62 & cgs_rden62) |
                      (DMA0_rden61 & cgs_rden61) |
                      (DMA0_rden60 & cgs_rden60) |
                      (DMA0_rden59 & cgs_rden59) |
                      (DMA0_rden58 & cgs_rden58) |
                      (DMA0_rden57 & cgs_rden57) |
                      (DMA0_rden56 & cgs_rden56) |
                      (DMA0_rden55 & cgs_rden55) |
                      (DMA0_rden54 & cgs_rden54) |
                      (DMA0_rden53 & cgs_rden53) |
                      (DMA0_rden52 & cgs_rden52) |
                      (DMA0_rden51 & cgs_rden51) |
                      (DMA0_rden50 & cgs_rden50) |
                      (DMA0_rden49 & cgs_rden49) |
                      (DMA0_rden48 & cgs_rden48) |
                      (DMA0_rden47 & cgs_rden47) |
                      (DMA0_rden46 & cgs_rden46) |
                      (DMA0_rden45 & cgs_rden45) |
                      (DMA0_rden44 & cgs_rden44) |
                      (DMA0_rden43 & cgs_rden43) |
                      (DMA0_rden42 & cgs_rden42) |
                      (DMA0_rden41 & cgs_rden41) |
                      (DMA0_rden40 & cgs_rden40) |
                      (DMA0_rden39 & cgs_rden39) |
                      (DMA0_rden38 & cgs_rden38) |
                      (DMA0_rden37 & cgs_rden37) |
                      (DMA0_rden36 & cgs_rden36) |
                      (DMA0_rden35 & cgs_rden35) |
                      (DMA0_rden34 & cgs_rden34) |
                      (DMA0_rden33 & cgs_rden33) |
                      (DMA0_rden32 & cgs_rden32) |
                      (DMA0_rden31 & cgs_rden31) |
                      (DMA0_rden30 & cgs_rden30) |
                      (DMA0_rden29 & cgs_rden29) |
                      (DMA0_rden28 & cgs_rden28) |
                      (DMA0_rden27 & cgs_rden27) |
                      (DMA0_rden26 & cgs_rden26) |
                      (DMA0_rden25 & cgs_rden25) |
                      (DMA0_rden24 & cgs_rden24) |
                      (DMA0_rden23 & cgs_rden23) |
                      (DMA0_rden22 & cgs_rden22) |
                      (DMA0_rden21 & cgs_rden21) |
                      (DMA0_rden20 & cgs_rden20) |
                      (DMA0_rden19 & cgs_rden19) |
                      (DMA0_rden18 & cgs_rden18) |
                      (DMA0_rden17 & cgs_rden17) |
                      (DMA0_rden16 & cgs_rden16) |
                      (DMA0_rden15 & cgs_rden15) |
                      (DMA0_rden14 & cgs_rden14) |
                      (DMA0_rden13 & cgs_rden13) |
                      (DMA0_rden12 & cgs_rden12) |
                      (DMA0_rden11 & cgs_rden11) |
                      (DMA0_rden10 & cgs_rden10) |
                      (DMA0_rden9  & cgs_rden9 ) |
                      (DMA0_rden8  & cgs_rden8 ) |
                      (DMA0_rden7  & cgs_rden7 ) |
                      (DMA0_rden6  & cgs_rden6 ) |
                      (DMA0_rden5  & cgs_rden5 ) |
                      (DMA0_rden4  & cgs_rden4 ) |
                      (DMA0_rden3  & cgs_rden3 ) |
                      (DMA0_rden2  & cgs_rden2 ) |
                      (DMA0_rden1  & cgs_rden1 ) |
                      (DMA0_rden0  & cgs_rden0 ) ;

assign DMA1_collide = (DMA1_wren63 & cgs_wren63) |
                      (DMA1_wren62 & cgs_wren62) |
                      (DMA1_wren61 & cgs_wren61) |
                      (DMA1_wren60 & cgs_wren60) |
                      (DMA1_wren59 & cgs_wren59) |
                      (DMA1_wren58 & cgs_wren58) |
                      (DMA1_wren57 & cgs_wren57) |
                      (DMA1_wren56 & cgs_wren56) |
                      (DMA1_wren55 & cgs_wren55) |
                      (DMA1_wren54 & cgs_wren54) |
                      (DMA1_wren53 & cgs_wren53) |
                      (DMA1_wren52 & cgs_wren52) |
                      (DMA1_wren51 & cgs_wren51) |
                      (DMA1_wren50 & cgs_wren50) |
                      (DMA1_wren49 & cgs_wren49) |
                      (DMA1_wren48 & cgs_wren48) |
                      (DMA1_wren47 & cgs_wren47) |
                      (DMA1_wren46 & cgs_wren46) |
                      (DMA1_wren45 & cgs_wren45) |
                      (DMA1_wren44 & cgs_wren44) |
                      (DMA1_wren43 & cgs_wren43) |
                      (DMA1_wren42 & cgs_wren42) |
                      (DMA1_wren41 & cgs_wren41) |
                      (DMA1_wren40 & cgs_wren40) |
                      (DMA1_wren39 & cgs_wren39) |
                      (DMA1_wren38 & cgs_wren38) |
                      (DMA1_wren37 & cgs_wren37) |
                      (DMA1_wren36 & cgs_wren36) |
                      (DMA1_wren35 & cgs_wren35) |
                      (DMA1_wren34 & cgs_wren34) |
                      (DMA1_wren33 & cgs_wren33) |
                      (DMA1_wren32 & cgs_wren32) |
                      (DMA1_wren31 & cgs_wren31) |
                      (DMA1_wren30 & cgs_wren30) |
                      (DMA1_wren29 & cgs_wren29) |
                      (DMA1_wren28 & cgs_wren28) |
                      (DMA1_wren27 & cgs_wren27) |
                      (DMA1_wren26 & cgs_wren26) |
                      (DMA1_wren25 & cgs_wren25) |
                      (DMA1_wren24 & cgs_wren24) |
                      (DMA1_wren23 & cgs_wren23) |
                      (DMA1_wren22 & cgs_wren22) |
                      (DMA1_wren21 & cgs_wren21) |
                      (DMA1_wren20 & cgs_wren20) |
                      (DMA1_wren19 & cgs_wren19) |
                      (DMA1_wren18 & cgs_wren18) |
                      (DMA1_wren17 & cgs_wren17) |
                      (DMA1_wren16 & cgs_wren16) |
                      (DMA1_wren15 & cgs_wren15) |
                      (DMA1_wren14 & cgs_wren14) |
                      (DMA1_wren13 & cgs_wren13) |
                      (DMA1_wren12 & cgs_wren12) |
                      (DMA1_wren11 & cgs_wren11) |
                      (DMA1_wren10 & cgs_wren10) |
                      (DMA1_wren9  & cgs_wren9 ) |
                      (DMA1_wren8  & cgs_wren8 ) |
                      (DMA1_wren7  & cgs_wren7 ) |
                      (DMA1_wren6  & cgs_wren6 ) |
                      (DMA1_wren5  & cgs_wren5 ) |
                      (DMA1_wren4  & cgs_wren4 ) |
                      (DMA1_wren3  & cgs_wren3 ) |
                      (DMA1_wren2  & cgs_wren2 ) |
                      (DMA1_wren1  & cgs_wren1 ) |
                      (DMA1_wren0  & cgs_wren0 ) ;


RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_63(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren63),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren63 ? 1'b1 : DMA1_wren63),
    .wraddrsB (cgs_wren63 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren63 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden63 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata63),
    .rdenB    (cgs_rden63 ? 1'b1 : DMA0_rden63),
    .rdaddrsB (cgs_rden63 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_63 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_62(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren62),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren62 ? 1'b1 : DMA1_wren62),
    .wraddrsB (cgs_wren62 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren62 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden62 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata62),
    .rdenB    (cgs_rden62 ? 1'b1 : DMA0_rden62),
    .rdaddrsB (cgs_rden62 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_62 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_61(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren61),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren61 ? 1'b1 : DMA1_wren61),
    .wraddrsB (cgs_wren61 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren61 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden61 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata61),
    .rdenB    (cgs_rden61 ? 1'b1 : DMA0_rden61),
    .rdaddrsB (cgs_rden61 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_61 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_60(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren60),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren60 ? 1'b1 : DMA1_wren60),
    .wraddrsB (cgs_wren60 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren60 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden60 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata60),
    .rdenB    (cgs_rden60 ? 1'b1 : DMA0_rden60),
    .rdaddrsB (cgs_rden60 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_60 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_59(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren59),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren59 ? 1'b1 : DMA1_wren59),
    .wraddrsB (cgs_wren59 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren59 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden59 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata59),
    .rdenB    (cgs_rden59 ? 1'b1 : DMA0_rden59),
    .rdaddrsB (cgs_rden59 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_59 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_58(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren58),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren58 ? 1'b1 : DMA1_wren58),
    .wraddrsB (cgs_wren58 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren58 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden58 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata58),
    .rdenB    (cgs_rden58 ? 1'b1 : DMA0_rden58),
    .rdaddrsB (cgs_rden58 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_58 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_57(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren57),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren57 ? 1'b1 : DMA1_wren57),
    .wraddrsB (cgs_wren57 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren57 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden57 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata57),
    .rdenB    (cgs_rden57 ? 1'b1 : DMA0_rden57),
    .rdaddrsB (cgs_rden57 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_57 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_56(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren56),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren56 ? 1'b1 : DMA1_wren56),
    .wraddrsB (cgs_wren56 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren56 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden56 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata56),
    .rdenB    (cgs_rden56 ? 1'b1 : DMA0_rden56),
    .rdaddrsB (cgs_rden56 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_56 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_55(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren55),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren55 ? 1'b1 : DMA1_wren55),
    .wraddrsB (cgs_wren55 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren55 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden55 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata55),
    .rdenB    (cgs_rden55 ? 1'b1 : DMA0_rden55),
    .rdaddrsB (cgs_rden55 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_55 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_54(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren54),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren54 ? 1'b1 : DMA1_wren54),
    .wraddrsB (cgs_wren54 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren54 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden54 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata54),
    .rdenB    (cgs_rden54 ? 1'b1 : DMA0_rden54),
    .rdaddrsB (cgs_rden54 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_54 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_53(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren53),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren53 ? 1'b1 : DMA1_wren53),
    .wraddrsB (cgs_wren53 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren53 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden53 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata53),
    .rdenB    (cgs_rden53 ? 1'b1 : DMA0_rden53),
    .rdaddrsB (cgs_rden53 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_53 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_52(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren52),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren52 ? 1'b1 : DMA1_wren52),
    .wraddrsB (cgs_wren52 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren52 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden52 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata52),
    .rdenB    (cgs_rden52 ? 1'b1 : DMA0_rden52),
    .rdaddrsB (cgs_rden52 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_52 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_51(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren51),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren51 ? 1'b1 : DMA1_wren51),
    .wraddrsB (cgs_wren51 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren51 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden51 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata51),
    .rdenB    (cgs_rden51 ? 1'b1 : DMA0_rden51),
    .rdaddrsB (cgs_rden51 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_51 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_50(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren50),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren50 ? 1'b1 : DMA1_wren50),
    .wraddrsB (cgs_wren50 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren50 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden50 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata50),
    .rdenB    (cgs_rden50 ? 1'b1 : DMA0_rden50),
    .rdaddrsB (cgs_rden50 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_50 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_49(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren49),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren49 ? 1'b1 : DMA1_wren49),
    .wraddrsB (cgs_wren49 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren49 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden49 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata49),
    .rdenB    (cgs_rden49 ? 1'b1 : DMA0_rden49),
    .rdaddrsB (cgs_rden49 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_49 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_48(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren48),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren48 ? 1'b1 : DMA1_wren48),
    .wraddrsB (cgs_wren48 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren48 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden48 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata48),
    .rdenB    (cgs_rden48 ? 1'b1 : DMA0_rden48),
    .rdaddrsB (cgs_rden48 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_48 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_47(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren47),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren47 ? 1'b1 : DMA1_wren47),
    .wraddrsB (cgs_wren47 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren47 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden47 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata47),
    .rdenB    (cgs_rden47 ? 1'b1 : DMA0_rden47),
    .rdaddrsB (cgs_rden47 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_47 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_46(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren46),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren46 ? 1'b1 : DMA1_wren46),
    .wraddrsB (cgs_wren46 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren46 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden46 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata46),
    .rdenB    (cgs_rden46 ? 1'b1 : DMA0_rden46),
    .rdaddrsB (cgs_rden46 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_46 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_45(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren45),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren45 ? 1'b1 : DMA1_wren45),
    .wraddrsB (cgs_wren45 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren45 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden45 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata45),
    .rdenB    (cgs_rden45 ? 1'b1 : DMA0_rden45),
    .rdaddrsB (cgs_rden45 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_45 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_44(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren44),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren44 ? 1'b1 : DMA1_wren44),
    .wraddrsB (cgs_wren44 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren44 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden44 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata44),
    .rdenB    (cgs_rden44 ? 1'b1 : DMA0_rden44),
    .rdaddrsB (cgs_rden44 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_44 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_43(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren43),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren43 ? 1'b1 : DMA1_wren43),
    .wraddrsB (cgs_wren43 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren43 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden43 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata43),
    .rdenB    (cgs_rden43 ? 1'b1 : DMA0_rden43),
    .rdaddrsB (cgs_rden43 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_43 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_42(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren42),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren42 ? 1'b1 : DMA1_wren42),
    .wraddrsB (cgs_wren42 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren42 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden42 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata42),
    .rdenB    (cgs_rden42 ? 1'b1 : DMA0_rden42),
    .rdaddrsB (cgs_rden42 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_42 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_41(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren41),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren41 ? 1'b1 : DMA1_wren41),
    .wraddrsB (cgs_wren41 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren41 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden41 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata41),
    .rdenB    (cgs_rden41 ? 1'b1 : DMA0_rden41),
    .rdaddrsB (cgs_rden41 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_41 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_40(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren40),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren40 ? 1'b1 : DMA1_wren40),
    .wraddrsB (cgs_wren40 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren40 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden40 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata40),
    .rdenB    (cgs_rden40 ? 1'b1 : DMA0_rden40),
    .rdaddrsB (cgs_rden40 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_40 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_39(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren39),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren39 ? 1'b1 : DMA1_wren39),
    .wraddrsB (cgs_wren39 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren39 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden39 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata39),
    .rdenB    (cgs_rden39 ? 1'b1 : DMA0_rden39),
    .rdaddrsB (cgs_rden39 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_39 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_38(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren38),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren38 ? 1'b1 : DMA1_wren38),
    .wraddrsB (cgs_wren38 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren38 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden38 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata38),
    .rdenB    (cgs_rden38 ? 1'b1 : DMA0_rden38),
    .rdaddrsB (cgs_rden38 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_38 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_37(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren37),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren37 ? 1'b1 : DMA1_wren37),
    .wraddrsB (cgs_wren37 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren37 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden37 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata37),
    .rdenB    (cgs_rden37 ? 1'b1 : DMA0_rden37),
    .rdaddrsB (cgs_rden37 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_37 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_36(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren36),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren36 ? 1'b1 : DMA1_wren36),
    .wraddrsB (cgs_wren36 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren36 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden36 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata36),
    .rdenB    (cgs_rden36 ? 1'b1 : DMA0_rden36),
    .rdaddrsB (cgs_rden36 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_36 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_35(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren35),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren35 ? 1'b1 : DMA1_wren35),
    .wraddrsB (cgs_wren35 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren35 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden35 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata35),
    .rdenB    (cgs_rden35 ? 1'b1 : DMA0_rden35),
    .rdaddrsB (cgs_rden35 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_35 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_34(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren34),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren34 ? 1'b1 : DMA1_wren34),
    .wraddrsB (cgs_wren34 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren34 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden34 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata34),
    .rdenB    (cgs_rden34 ? 1'b1 : DMA0_rden34),
    .rdaddrsB (cgs_rden34 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_34 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_33(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren33),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren33 ? 1'b1 : DMA1_wren33),
    .wraddrsB (cgs_wren33 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren33 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden33 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata33),
    .rdenB    (cgs_rden33 ? 1'b1 : DMA0_rden33),
    .rdaddrsB (cgs_rden33 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_33 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_32(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren32),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren32 ? 1'b1 : DMA1_wren32),
    .wraddrsB (cgs_wren32 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren32 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden32 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata32),
    .rdenB    (cgs_rden32 ? 1'b1 : DMA0_rden32),
    .rdaddrsB (cgs_rden32 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_32 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_31(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren31),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren31 ? 1'b1 : DMA1_wren31),
    .wraddrsB (cgs_wren31 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren31 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden31 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata31),
    .rdenB    (cgs_rden31 ? 1'b1 : DMA0_rden31),
    .rdaddrsB (cgs_rden31 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_31 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_30(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren30),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren30 ? 1'b1 : DMA1_wren30),
    .wraddrsB (cgs_wren30 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren30 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden30 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata30),
    .rdenB    (cgs_rden30 ? 1'b1 : DMA0_rden30),
    .rdaddrsB (cgs_rden30 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_30 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_29(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren29),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren29 ? 1'b1 : DMA1_wren29),
    .wraddrsB (cgs_wren29 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren29 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden29 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata29),
    .rdenB    (cgs_rden29 ? 1'b1 : DMA0_rden29),
    .rdaddrsB (cgs_rden29 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_29 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_28(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren28),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren28 ? 1'b1 : DMA1_wren28),
    .wraddrsB (cgs_wren28 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren28 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden28 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata28),
    .rdenB    (cgs_rden28 ? 1'b1 : DMA0_rden28),
    .rdaddrsB (cgs_rden28 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_28 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_27(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren27),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren27 ? 1'b1 : DMA1_wren27),
    .wraddrsB (cgs_wren27 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren27 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden27 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata27),
    .rdenB    (cgs_rden27 ? 1'b1 : DMA0_rden27),
    .rdaddrsB (cgs_rden27 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_27 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_26(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren26),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren26 ? 1'b1 : DMA1_wren26),
    .wraddrsB (cgs_wren26 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren26 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden26 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata26),
    .rdenB    (cgs_rden26 ? 1'b1 : DMA0_rden26),
    .rdaddrsB (cgs_rden26 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_26 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_25(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren25),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren25 ? 1'b1 : DMA1_wren25),
    .wraddrsB (cgs_wren25 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren25 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden25 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata25),
    .rdenB    (cgs_rden25 ? 1'b1 : DMA0_rden25),
    .rdaddrsB (cgs_rden25 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_25 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_24(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren24),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren24 ? 1'b1 : DMA1_wren24),
    .wraddrsB (cgs_wren24 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren24 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden24 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata24),
    .rdenB    (cgs_rden24 ? 1'b1 : DMA0_rden24),
    .rdaddrsB (cgs_rden24 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_24 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_23(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren23),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren23 ? 1'b1 : DMA1_wren23),
    .wraddrsB (cgs_wren23 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren23 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden23 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata23),
    .rdenB    (cgs_rden23 ? 1'b1 : DMA0_rden23),
    .rdaddrsB (cgs_rden23 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_23 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_22(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren22),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren22 ? 1'b1 : DMA1_wren22),
    .wraddrsB (cgs_wren22 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren22 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden22 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata22),
    .rdenB    (cgs_rden22 ? 1'b1 : DMA0_rden22),
    .rdaddrsB (cgs_rden22 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_22 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_21(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren21),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren21 ? 1'b1 : DMA1_wren21),
    .wraddrsB (cgs_wren21 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren21 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden21 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata21),
    .rdenB    (cgs_rden21 ? 1'b1 : DMA0_rden21),
    .rdaddrsB (cgs_rden21 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_21 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_20(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren20),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren20 ? 1'b1 : DMA1_wren20),
    .wraddrsB (cgs_wren20 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren20 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden20 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata20),
    .rdenB    (cgs_rden20 ? 1'b1 : DMA0_rden20),
    .rdaddrsB (cgs_rden20 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_20 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_19(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren19),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren19 ? 1'b1 : DMA1_wren19),
    .wraddrsB (cgs_wren19 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren19 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden19 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata19),
    .rdenB    (cgs_rden19 ? 1'b1 : DMA0_rden19),
    .rdaddrsB (cgs_rden19 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_19 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_18(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren18),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren18 ? 1'b1 : DMA1_wren18),
    .wraddrsB (cgs_wren18 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren18 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden18 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata18),
    .rdenB    (cgs_rden18 ? 1'b1 : DMA0_rden18),
    .rdaddrsB (cgs_rden18 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_18 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_17(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren17),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren17 ? 1'b1 : DMA1_wren17),
    .wraddrsB (cgs_wren17 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren17 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden17 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata17),
    .rdenB    (cgs_rden17 ? 1'b1 : DMA0_rden17),
    .rdaddrsB (cgs_rden17 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_17 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_16(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren16),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren16 ? 1'b1 : DMA1_wren16),
    .wraddrsB (cgs_wren16 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren16 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden16 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata16),
    .rdenB    (cgs_rden16 ? 1'b1 : DMA0_rden16),
    .rdaddrsB (cgs_rden16 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_16 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_15(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren15),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren15 ? 1'b1 : DMA1_wren15),
    .wraddrsB (cgs_wren15 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren15 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden15 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata15),
    .rdenB    (cgs_rden15 ? 1'b1 : DMA0_rden15),
    .rdaddrsB (cgs_rden15 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_15 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_14(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren14),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren14 ? 1'b1 : DMA1_wren14),
    .wraddrsB (cgs_wren14 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren14 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden14 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata14),
    .rdenB    (cgs_rden14 ? 1'b1 : DMA0_rden14),
    .rdaddrsB (cgs_rden14 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_14 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_13(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren13),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren13 ? 1'b1 : DMA1_wren13),
    .wraddrsB (cgs_wren13 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren13 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden13 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata13),
    .rdenB    (cgs_rden13 ? 1'b1 : DMA0_rden13),
    .rdaddrsB (cgs_rden13 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_13 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_12(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren12),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren12 ? 1'b1 : DMA1_wren12),
    .wraddrsB (cgs_wren12 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren12 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden12 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata12),
    .rdenB    (cgs_rden12 ? 1'b1 : DMA0_rden12),
    .rdaddrsB (cgs_rden12 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_12 )
     );
     
RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_11(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren11),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren11 ? 1'b1 : DMA1_wren11),
    .wraddrsB (cgs_wren11 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren11 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden11 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata11),
    .rdenB    (cgs_rden11 ? 1'b1 : DMA0_rden11),
    .rdaddrsB (cgs_rden11 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_11 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_10(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren10),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren10 ? 1'b1 : DMA1_wren10),
    .wraddrsB (cgs_wren10 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren10 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden10 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata10),
    .rdenB    (cgs_rden10 ? 1'b1 : DMA0_rden10),
    .rdaddrsB (cgs_rden10 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_10 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_9(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren9),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren9 ? 1'b1 : DMA1_wren9),
    .wraddrsB (cgs_wren9 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren9 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden9 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata9),
    .rdenB    (cgs_rden9 ? 1'b1 : DMA0_rden9),
    .rdaddrsB (cgs_rden9 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_9 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_8(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren8),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren8 ? 1'b1 : DMA1_wren8),
    .wraddrsB (cgs_wren8 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren8 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden8 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata8),
    .rdenB    (cgs_rden8 ? 1'b1 : DMA0_rden8),
    .rdaddrsB (cgs_rden8 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_8 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_7(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren7),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren7 ? 1'b1 : DMA1_wren7),
    .wraddrsB (cgs_wren7 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren7 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden7 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata7),
    .rdenB    (cgs_rden7 ? 1'b1 : DMA0_rden7),
    .rdaddrsB (cgs_rden7 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_7 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_6(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren6),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren6 ? 1'b1 : DMA1_wren6),
    .wraddrsB (cgs_wren6 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren6 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden6 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata6),
    .rdenB    (cgs_rden6 ? 1'b1 : DMA0_rden6),
    .rdaddrsB (cgs_rden6 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_6 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_5(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren5),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren5 ? 1'b1 : DMA1_wren5),
    .wraddrsB (cgs_wren5 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren5 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden5 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata5),
    .rdenB    (cgs_rden5 ? 1'b1 : DMA0_rden5),
    .rdaddrsB (cgs_rden5 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_5 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_4(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren4),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren4 ? 1'b1 : DMA1_wren4),
    .wraddrsB (cgs_wren4 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren4 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden4 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata4),
    .rdenB    (cgs_rden4 ? 1'b1 : DMA0_rden4),
    .rdaddrsB (cgs_rden4 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_4 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_3(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren3),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren3 ? 1'b1 : DMA1_wren3),
    .wraddrsB (cgs_wren3 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren3 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden3 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata3),
    .rdenB    (cgs_rden3 ? 1'b1 : DMA0_rden3),
    .rdaddrsB (cgs_rden3 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_3 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_2(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren2),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren2 ? 1'b1 : DMA1_wren2),
    .wraddrsB (cgs_wren2 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren2 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden2 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata2),
    .rdenB    (cgs_rden2 ? 1'b1 : DMA0_rden2),
    .rdaddrsB (cgs_rden2 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_2 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_1(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren1),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren1 ? 1'b1 : DMA1_wren1),
    .wraddrsB (cgs_wren1 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren1 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden1 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata1),
    .rdenB    (cgs_rden1 ? 1'b1 : DMA0_rden1),
    .rdaddrsB (cgs_rden1 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_1 )
     );

RAM_tdp_dpool #(.ADDRS_WIDTH(10), .DATA_WIDTH(32))
    datapool_0(      // 1k x 32
    .CLKA      (CLKA ),
    .CLKB      (CLKB ),
    .wrenA    (SYS_wren0),
    .wraddrsA (SYS_wraddrs[9:0]),
    .wrdataA  (SYS_wrdata),
    .wrenB    (cgs_wren0 ? 1'b1 : DMA1_wren0),
    .wraddrsB (cgs_wren0 ? cgs_wraddrs[9:0] : DMA1_wraddrs[9:0]),
    .wrdataB  (cgs_wren0 ? cgs_wrdata : DMA1_wrdata),
    .rdenA    (SYS_rden0 ),
    .rdaddrsA (SYS_rdaddrs[9:0]),
    .rddataA  (SYS_rddata0),
    .rdenB    (cgs_rden0 ? 1'b1 : DMA0_rden0),
    .rdaddrsB (cgs_rden0 ? cgs_rdaddrs[9:0] : DMA0_rdaddrs[9:0]),
    .rddataB  (rddataB_0 )
     );


always @(posedge CLKA) begin
    SYS_rdaddrs_q1[5:0]  <= SYS_rdaddrs[15:10];
end

always @(posedge CLKB) begin
    DMA0_rdaddrs_q1[5:0] <= DMA0_rdaddrs[15:10];
    cgs_rdaddrs_q1[5:0]  <= cgs_rdaddrs[15:10];
end

always @(*)
    case(DMA0_rdaddrs_q1)
        6'b000000 : DMA0_rddata = rddataB_0;
        6'b000001 : DMA0_rddata = rddataB_1;
        6'b000010 : DMA0_rddata = rddataB_2;
        6'b000011 : DMA0_rddata = rddataB_3;
        6'b000100 : DMA0_rddata = rddataB_4;
        6'b000101 : DMA0_rddata = rddataB_5;
        6'b000110 : DMA0_rddata = rddataB_6;
        6'b000111 : DMA0_rddata = rddataB_7;
        6'b001000 : DMA0_rddata = rddataB_8;
        6'b001001 : DMA0_rddata = rddataB_9;
        6'b001010 : DMA0_rddata = rddataB_10;
        6'b001011 : DMA0_rddata = rddataB_11;
        6'b001100 : DMA0_rddata = rddataB_12;
        6'b001101 : DMA0_rddata = rddataB_13;
        6'b001110 : DMA0_rddata = rddataB_14;
        6'b001111 : DMA0_rddata = rddataB_15;
        6'b010000 : DMA0_rddata = rddataB_16;
        6'b010001 : DMA0_rddata = rddataB_17;
        6'b010010 : DMA0_rddata = rddataB_18;
        6'b010011 : DMA0_rddata = rddataB_19;
        6'b010100 : DMA0_rddata = rddataB_20;
        6'b010101 : DMA0_rddata = rddataB_21;
        6'b010110 : DMA0_rddata = rddataB_22;
        6'b010111 : DMA0_rddata = rddataB_23;
        6'b011000 : DMA0_rddata = rddataB_24;
        6'b011001 : DMA0_rddata = rddataB_25;
        6'b011010 : DMA0_rddata = rddataB_26;
        6'b011011 : DMA0_rddata = rddataB_27;
        6'b011100 : DMA0_rddata = rddataB_28;
        6'b011101 : DMA0_rddata = rddataB_29;
        6'b011110 : DMA0_rddata = rddataB_30;
        6'b011111 : DMA0_rddata = rddataB_31;
        6'b100000 : DMA0_rddata = rddataB_32;
        6'b100001 : DMA0_rddata = rddataB_33;
        6'b100010 : DMA0_rddata = rddataB_34;
        6'b100011 : DMA0_rddata = rddataB_35;
        6'b100100 : DMA0_rddata = rddataB_36;
        6'b100101 : DMA0_rddata = rddataB_37;
        6'b100110 : DMA0_rddata = rddataB_38;
        6'b100111 : DMA0_rddata = rddataB_39;
        6'b101000 : DMA0_rddata = rddataB_40;
        6'b101001 : DMA0_rddata = rddataB_41;
        6'b101010 : DMA0_rddata = rddataB_42;
        6'b101011 : DMA0_rddata = rddataB_43;
        6'b101100 : DMA0_rddata = rddataB_44;
        6'b101101 : DMA0_rddata = rddataB_45;
        6'b101110 : DMA0_rddata = rddataB_46;
        6'b101111 : DMA0_rddata = rddataB_47;
        6'b110000 : DMA0_rddata = rddataB_48;
        6'b110001 : DMA0_rddata = rddataB_49;
        6'b110010 : DMA0_rddata = rddataB_50;
        6'b110011 : DMA0_rddata = rddataB_51;
        6'b110100 : DMA0_rddata = rddataB_52;
        6'b110101 : DMA0_rddata = rddataB_53;
        6'b110110 : DMA0_rddata = rddataB_54;
        6'b110111 : DMA0_rddata = rddataB_55;
        6'b111000 : DMA0_rddata = rddataB_56;
        6'b111001 : DMA0_rddata = rddataB_57;
        6'b111010 : DMA0_rddata = rddataB_58;
        6'b111011 : DMA0_rddata = rddataB_59;
        6'b111100 : DMA0_rddata = rddataB_60;
        6'b111101 : DMA0_rddata = rddataB_61;
        6'b111110 : DMA0_rddata = rddataB_62;
        6'b111111 : DMA0_rddata = rddataB_63;
    endcase
    
always @(*)
    case(cgs_rdaddrs_q1)
        6'b000000 : cgs_rddata = rddataB_0;
        6'b000001 : cgs_rddata = rddataB_1;
        6'b000010 : cgs_rddata = rddataB_2;
        6'b000011 : cgs_rddata = rddataB_3;
        6'b000100 : cgs_rddata = rddataB_4;
        6'b000101 : cgs_rddata = rddataB_5;
        6'b000110 : cgs_rddata = rddataB_6;
        6'b000111 : cgs_rddata = rddataB_7;
        6'b001000 : cgs_rddata = rddataB_8;
        6'b001001 : cgs_rddata = rddataB_9;
        6'b001010 : cgs_rddata = rddataB_10;
        6'b001011 : cgs_rddata = rddataB_11;
        6'b001100 : cgs_rddata = rddataB_12;
        6'b001101 : cgs_rddata = rddataB_13;
        6'b001110 : cgs_rddata = rddataB_14;
        6'b001111 : cgs_rddata = rddataB_15;
        6'b010000 : cgs_rddata = rddataB_16;
        6'b010001 : cgs_rddata = rddataB_17;
        6'b010010 : cgs_rddata = rddataB_18;
        6'b010011 : cgs_rddata = rddataB_19;
        6'b010100 : cgs_rddata = rddataB_20;
        6'b010101 : cgs_rddata = rddataB_21;
        6'b010110 : cgs_rddata = rddataB_22;
        6'b010111 : cgs_rddata = rddataB_23;
        6'b011000 : cgs_rddata = rddataB_24;
        6'b011001 : cgs_rddata = rddataB_25;
        6'b011010 : cgs_rddata = rddataB_26;
        6'b011011 : cgs_rddata = rddataB_27;
        6'b011100 : cgs_rddata = rddataB_28;
        6'b011101 : cgs_rddata = rddataB_29;
        6'b011110 : cgs_rddata = rddataB_30;
        6'b011111 : cgs_rddata = rddataB_31;
        6'b100000 : cgs_rddata = rddataB_32;
        6'b100001 : cgs_rddata = rddataB_33;
        6'b100010 : cgs_rddata = rddataB_34;
        6'b100011 : cgs_rddata = rddataB_35;
        6'b100100 : cgs_rddata = rddataB_36;
        6'b100101 : cgs_rddata = rddataB_37;
        6'b100110 : cgs_rddata = rddataB_38;
        6'b100111 : cgs_rddata = rddataB_39;
        6'b101000 : cgs_rddata = rddataB_40;
        6'b101001 : cgs_rddata = rddataB_41;
        6'b101010 : cgs_rddata = rddataB_42;
        6'b101011 : cgs_rddata = rddataB_43;
        6'b101100 : cgs_rddata = rddataB_44;
        6'b101101 : cgs_rddata = rddataB_45;
        6'b101110 : cgs_rddata = rddataB_46;
        6'b101111 : cgs_rddata = rddataB_47;
        6'b110000 : cgs_rddata = rddataB_48;
        6'b110001 : cgs_rddata = rddataB_49;
        6'b110010 : cgs_rddata = rddataB_50;
        6'b110011 : cgs_rddata = rddataB_51;
        6'b110100 : cgs_rddata = rddataB_52;
        6'b110101 : cgs_rddata = rddataB_53;
        6'b110110 : cgs_rddata = rddataB_54;
        6'b110111 : cgs_rddata = rddataB_55;
        6'b111000 : cgs_rddata = rddataB_56;
        6'b111001 : cgs_rddata = rddataB_57;
        6'b111010 : cgs_rddata = rddataB_58;
        6'b111011 : cgs_rddata = rddataB_59;
        6'b111100 : cgs_rddata = rddataB_60;
        6'b111101 : cgs_rddata = rddataB_61;
        6'b111110 : cgs_rddata = rddataB_62;
        6'b111111 : cgs_rddata = rddataB_63;
    endcase              
                  

always @(*)
    case(SYS_rdaddrs_q1)
        6'b000000 : SYS_rddata = SYS_rddata0;
        6'b000001 : SYS_rddata = SYS_rddata1;
        6'b000010 : SYS_rddata = SYS_rddata2;
        6'b000011 : SYS_rddata = SYS_rddata3;
        6'b000100 : SYS_rddata = SYS_rddata4;
        6'b000101 : SYS_rddata = SYS_rddata5;
        6'b000110 : SYS_rddata = SYS_rddata6;
        6'b000111 : SYS_rddata = SYS_rddata7;
        6'b001000 : SYS_rddata = SYS_rddata8;
        6'b001001 : SYS_rddata = SYS_rddata9;
        6'b001010 : SYS_rddata = SYS_rddata10;
        6'b001011 : SYS_rddata = SYS_rddata11;
        6'b001100 : SYS_rddata = SYS_rddata12;
        6'b001101 : SYS_rddata = SYS_rddata13;
        6'b001110 : SYS_rddata = SYS_rddata14;
        6'b001111 : SYS_rddata = SYS_rddata15;
        6'b010000 : SYS_rddata = SYS_rddata16;
        6'b010001 : SYS_rddata = SYS_rddata17;
        6'b010010 : SYS_rddata = SYS_rddata18;
        6'b010011 : SYS_rddata = SYS_rddata19;
        6'b010100 : SYS_rddata = SYS_rddata20;
        6'b010101 : SYS_rddata = SYS_rddata21;
        6'b010110 : SYS_rddata = SYS_rddata22;
        6'b010111 : SYS_rddata = SYS_rddata23;
        6'b011000 : SYS_rddata = SYS_rddata24;
        6'b011001 : SYS_rddata = SYS_rddata25;
        6'b011010 : SYS_rddata = SYS_rddata26;
        6'b011011 : SYS_rddata = SYS_rddata27;
        6'b011100 : SYS_rddata = SYS_rddata28;
        6'b011101 : SYS_rddata = SYS_rddata29;
        6'b011110 : SYS_rddata = SYS_rddata30;
        6'b011111 : SYS_rddata = SYS_rddata31;
        6'b100000 : SYS_rddata = SYS_rddata32;
        6'b100001 : SYS_rddata = SYS_rddata33;
        6'b100010 : SYS_rddata = SYS_rddata34;
        6'b100011 : SYS_rddata = SYS_rddata35;
        6'b100100 : SYS_rddata = SYS_rddata36;
        6'b100101 : SYS_rddata = SYS_rddata37;
        6'b100110 : SYS_rddata = SYS_rddata38;
        6'b100111 : SYS_rddata = SYS_rddata39;
        6'b101000 : SYS_rddata = SYS_rddata40;
        6'b101001 : SYS_rddata = SYS_rddata41;
        6'b101010 : SYS_rddata = SYS_rddata42;
        6'b101011 : SYS_rddata = SYS_rddata43;
        6'b101100 : SYS_rddata = SYS_rddata44;
        6'b101101 : SYS_rddata = SYS_rddata45;
        6'b101110 : SYS_rddata = SYS_rddata46;
        6'b101111 : SYS_rddata = SYS_rddata47;
        6'b110000 : SYS_rddata = SYS_rddata48;
        6'b110001 : SYS_rddata = SYS_rddata49;
        6'b110010 : SYS_rddata = SYS_rddata50;
        6'b110011 : SYS_rddata = SYS_rddata51;
        6'b110100 : SYS_rddata = SYS_rddata52;
        6'b110101 : SYS_rddata = SYS_rddata53;
        6'b110110 : SYS_rddata = SYS_rddata54;
        6'b110111 : SYS_rddata = SYS_rddata55;
        6'b111000 : SYS_rddata = SYS_rddata56;
        6'b111001 : SYS_rddata = SYS_rddata57;
        6'b111010 : SYS_rddata = SYS_rddata58;
        6'b111011 : SYS_rddata = SYS_rddata59;
        6'b111100 : SYS_rddata = SYS_rddata60;
        6'b111101 : SYS_rddata = SYS_rddata61;
        6'b111110 : SYS_rddata = SYS_rddata62;
        6'b111111 : SYS_rddata = SYS_rddata63;
    endcase              

endmodule