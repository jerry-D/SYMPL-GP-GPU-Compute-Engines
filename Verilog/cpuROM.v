 `timescale 1ns/1ns
 // Author:  Jerry D. Harthcock
 // Version:  1.205  January 18, 2016
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

module cpuROM #(parameter ADDRS_WIDTH = 12, parameter DATA_WIDTH = 32) (
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


reg    [DATA_WIDTH-1:0] triportRAMA[(2**ADDRS_WIDTH)-1:0];
reg    [DATA_WIDTH-1:0] triportRAMB[(2**ADDRS_WIDTH)-1:0];


integer i;

initial begin
   i = (2**ADDRS_WIDTH)-1;
   while(i) 
    begin
        triportRAMA[i] = 0;
        triportRAMB[i] = 0;
        i = i - 1;
    end
    triportRAMA[0] = 0;
    triportRAMB[0] = 0;
    #1 
//    $readmemh("MP_RISC.v",triportRAMA);    
//    $readmemh("MP_RISC.v",triportRAMB);          
//    $readmemh("mem_test.v",triportRAMA);    
//    $readmemh("mem_test.v",triportRAMB);          

    $readmemh("MP_RISC_SIL.v",triportRAMA);    
    $readmemh("MP_RISC_SIL.v",triportRAMB);          

end

reg [DATA_WIDTH-1:0] rddataA;
reg [DATA_WIDTH-1:0] rddataB;

always @(posedge CLK) begin
    if (rdenA) rddataA <=  triportRAMA[rdaddrsA];
end
always @(posedge CLK) begin
    if (wren) triportRAMA[wraddrs] <= wrdata;
end
always @(posedge CLK) begin
    if (rdenB) rddataB <=  triportRAMB[rdaddrsB];  
end
always @(posedge CLK) begin
    if (wren) triportRAMB[wraddrs] <= wrdata;
end
endmodule    