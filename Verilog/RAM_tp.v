 // parameterized tri-port 1 write-side and 2 read-side
 `timescale 1ns/1ns
 // For use in SYMPL FP324-AXI4 multi-thread multi-processing core only
 // Author:  Jerry D. Harthcock
 // Version:  1.203  August 27, 2015
 // Copyright (C) 2014-2015.  All rights reserved without prejudice.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 //                                                                                                               //
 //                              SYMPL FP32X-AXI4 32-Bit Mult-Thread RISC                                         //
 //                              Evaluation and Product Development License                                       //
 //                                                                                                               //
 // Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"), //
 // the original author and exclusive copyright owner of this SYMPL FP32X-AXI4 32-Bit Mult-Thread RISC            //
 // Verilog RTL IP core ("this IP"), hereby grants to recipient of this IP ("licensee"), a world-wide, paid-up,   //
 // non-exclusive license to use this IP for the purposes of evaluation, education, and development of end        //
 // products and related development tools only.                                                                  //
 //                                                                                                               //
 // Also subject to the terms and conditions set forth herein, Jerry D. Harthcock, exlusive inventor and owner    //
 // of US Patent No. 7,073,048, entitled "CASCADED MICROCOMPUTER ARRAY AND METHOD", issue date July 4, 2006       //
 // ("the '048 patent"), hereby grants a world-wide, paid-up, non-exclusive license under the '048 patent to use  //
 // this IP for the purposes of evaluation, education, and development of end products and related development    //
 // tools only.                                                                                                   //
 //                                                                                                               //
 // Any customization, modification, or derivative work of this IP must include an exact copy of this license     //
 // and original copyright notice at the very top of each source file and derived netlist, and, in the case of    //
 // binaries, a printed copy of this license and/or a text format copy in a separate file distributed with said   //
 // netlists or binary files having the file name, "LICENSE.txt".  You, the licensee, also agree not to remove    //
 // any copyright notices from any source file covered under this Evaluation and Product Development License.     //
 //                                                                                                               //
 // LICENSOR DOES NOT WARRANT OR GUARANTEE THAT YOUR USE OF THIS IP WILL NOT INFRINGE THE RIGHTS OF OTHERS OR     //
 // THAT IT IS SUITABLE OR FIT FOR ANY PURPOSE AND THAT YOU, THE LICENSEE, AGREE TO HOLD LICENSOR HARMLESS FROM   //
 // ANY CLAIM BROUGHT BY YOU OR ANY THIRD PARTY FOR YOUR SUCH USE.                                                //
 //                                                                                                               //
 // Licensor reserves all his rights without prejudice, including, but in no way limited to, the right to change  //
 // or modify the terms and conditions of this Evaluation and Product Development License anytime without notice  //
 // of any kind to anyone. By using this IP for any purpose, you agree to all the terms and conditions set forth  //
 // in this Evaluation and Product Development License.                                                           //
 //                                                                                                               //
 // This Evaluation and Product Development License does not include the right to sell products that incorporate  //
 // this IP, any IP derived from this IP, or the '048 patent.  If you would like to obtain such a license, please //
 // contact Licensor.                                                                                             //
 //                                                                                                               //
 // Licensor can be contacted at:  SYMPL.gpu@gmail.com                                                            //
 //                                                                                                               //
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module RAM_tp #(parameter ADDRS_WIDTH = 8, parameter DATA_WIDTH = 32) (
    CLK,
    wren,
    wraddrs,
    wrdata,
    rdenA,
    rdaddrsA,
    rddataA,
    rdenB,
    rdaddrsB,
    rddataB);    

input  CLK;
input  wren;
input  [ADDRS_WIDTH-1:0] wraddrs;
input  [DATA_WIDTH-1:0] wrdata;
input  rdenA;
input  [ADDRS_WIDTH-1:0] rdaddrsA;
output [DATA_WIDTH-1:0] rddataA;
input  rdenB;    
input  [ADDRS_WIDTH-1:0] rdaddrsB;
output [DATA_WIDTH-1:0] rddataB;


reg    [DATA_WIDTH-1:0] triportRAM[(2**ADDRS_WIDTH)-1:0];

integer i;

initial begin
   i = 2**ADDRS_WIDTH;
   while(i) 
    begin
        triportRAM[i] = 0;
        i = i - 1;
    end
    triportRAM[0] = 0;
end

reg [DATA_WIDTH-1:0] rddataAq;
reg [DATA_WIDTH-1:0] rddataBq;

reg [DATA_WIDTH-1:0] rddataA_collision;
reg [DATA_WIDTH-1:0] rddataB_collision;

reg rdenAq;
reg rdenBq;

wire [DATA_WIDTH-1:0] rddataA;
wire [DATA_WIDTH-1:0] rddataB;

assign rddataA = (rdenAq) ? rddataA_collision : rddataAq;
assign rddataB = (rdenBq) ? rddataB_collision : rddataBq;

always @(posedge CLK) begin
    if ((wraddrs==rdaddrsA) && wren && rdenA) begin
        rddataA_collision <= wrdata;
        rdenAq <= rdenA;
    end    
    else rdenAq <= 1'b0;
       
    if (wraddrs==rdaddrsB && wren && rdenB) begin
        rddataB_collision <= wrdata;
        rdenBq <= rdenB;
    end    
    else rdenBq <= 1'b0;
end
    
///// the following RTL between the two commented lines can be replaced with actual RAM Block instantiation 
always @(posedge CLK) begin
    if (wren) triportRAM[wraddrs] <= wrdata;
    if (rdenA) rddataAq <=  triportRAM[rdaddrsA];
    if (rdenB) rddataBq <=  triportRAM[rdaddrsB];  
end
///////////////////////
endmodule    