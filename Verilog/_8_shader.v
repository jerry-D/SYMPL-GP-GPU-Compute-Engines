`timescale 1ns/100ps

 // Author:  Jerry D. Harthcock
 // Version:  1.204  January 18, 2016
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

module _8_shader (
    CLKA,
    CLKB,
    RESET,
    WREN,
    WRADDRS,
    WRDATA,
    RDEN,
    RDADDRS,
    RDDATA,
    DONE
    );

input CLKA;
input CLKB;
input [3:0] RESET;
input WREN;
input [17:0] WRADDRS;
input [31:0] WRDATA;
input RDEN;
input [17:0] RDADDRS;
output [31:0] RDDATA;
output [3:0] DONE;

reg gpu1_sel;

wire gpu0_done;
wire gpu1_done;
wire [3:0] DONE;
wire [31:0] RDDATA_gpu0;
wire [31:0] RDDATA_gpu1;
wire [31:0] RDDATA;

assign DONE = {3'b00, gpu1_done, gpu0_done};
assign RDDATA = gpu1_sel ? RDDATA_gpu1 : RDDATA_gpu0;

FP325 gpu0(
    .CLKA    (CLKA   ),
    .CLKB    (CLKB   ),
    .RESET   (RESET[0]),
    .WREN    (WREN & (WRADDRS[17:16]==2'b00)),
    .WRADDRS (WRADDRS[15:0]),
    .WRDATA  (WRDATA),
    .RDEN    (RDEN & (RDADDRS[17:16]==2'b00)),
    .RDADDRS (RDADDRS[15:0]),
    .RDDATA  (RDDATA_gpu0),
    .DONE    (gpu0_done)
    );

FP325 gpu1(
    .CLKA    (CLKA   ),
    .CLKB    (CLKB   ),
    .RESET   (RESET[1]),
    .WREN    (WREN & (WRADDRS[17:16]==2'b01)),
    .WRADDRS (WRADDRS[15:0]),
    .WRDATA  (WRDATA),
    .RDEN    (RDEN & (RDADDRS[17:16]==2'b01)),
    .RDADDRS (RDADDRS[15:0]),
    .RDDATA  (RDDATA_gpu1),
    .DONE    (gpu1_done)
    );
always @(posedge CLKA)
    if (RDEN && (RDADDRS[17:16]==2'b01)) gpu1_sel <= 1'b1;
    else gpu1_sel <= 1'b0;

endmodule