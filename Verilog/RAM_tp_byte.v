 // tri-port 1 write-side and 2 read-side (byte-addressable) and no alignment required for 16 and 32-bit accesses
 // mis-aligned 16 and 32-bit accesses work just fine, all in one clock cycle
 `timescale 1ns/1ns
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

// byte address width is 15 [14:0]  (32k bytes or 8k words)
module RAM_tp_byte (
    CLK,
    RESET,
    dsize,
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
input  RESET;
input  [1:0] dsize;    // 00 = 32 bits, 01 = 16 bits, 10 = 8 bits, 11 = 32-bits (endian-ness inverted)
input  wren;
input  [14:0] wraddrs;
input  [31:0] wrdata;
input  rdenA;
input  [14:0] rdaddrsA;
output [31:0] rddataA;
input  rdenB;    
input  [14:0] rdaddrsB;
output [31:0] rddataB;


reg    [7:0] RAMA0HH[4095:0];       //side A even 4k-words  (16k-bytes) 
reg    [7:0] RAMA0HL[4095:0];       //side A even 4k-words  (16k-bytes) 
reg    [7:0] RAMA0LH[4095:0];       //side A even 4k-words  (16k-bytes) 
reg    [7:0] RAMA0LL[4095:0];       //side A even 4k-words  (16k-bytes) 

reg    [7:0] RAMA1HH[4095:0];       //side A odd  4k-words  (16k-bytes) 
reg    [7:0] RAMA1HL[4095:0];       //side A odd  4k-words  (16k-bytes) 
reg    [7:0] RAMA1LH[4095:0];       //side A odd  4k-words  (16k-bytes) 
reg    [7:0] RAMA1LL[4095:0];       //side A odd  4k-words  (16k-bytes) 

reg    [7:0] RAMB0HH[4095:0];       //side B even 4k-words  (16k-bytes)
reg    [7:0] RAMB0HL[4095:0];       //side B even 4k-words  (16k-bytes)
reg    [7:0] RAMB0LH[4095:0];       //side B even 4k-words  (16k-bytes)
reg    [7:0] RAMB0LL[4095:0];       //side B even 4k-words  (16k-bytes)
 
reg    [7:0] RAMB1HH[4095:0];       //side B odd  4k-words  (16k-bytes) 
reg    [7:0] RAMB1HL[4095:0];       //side B odd  4k-words  (16k-bytes) 
reg    [7:0] RAMB1LH[4095:0];       //side B odd  4k-words  (16k-bytes) 
reg    [7:0] RAMB1LL[4095:0];       //side B odd  4k-words  (16k-bytes) 

integer i;

initial begin
//   i = (2**ADDRS_WIDTH)-1;
   i = 4095;
   while(i) 
    begin
        {RAMA0HH[i], RAMA0HL[i], RAMA0LH[i], RAMA0LL[i]} = 0;
        {RAMA1HH[i], RAMA1HL[i], RAMA1LH[i], RAMA1LL[i]} = 0;
        {RAMB0HH[i], RAMB0HL[i], RAMB0LH[i], RAMB0LL[i]} = 0;
        {RAMB1HH[i], RAMB1HL[i], RAMB1LH[i], RAMB1LL[i]} = 0;
        i = i - 1;
    end
    {RAMA0HH[i], RAMA0HL[i], RAMA0LH[i], RAMA0LL[i]} = 0;
    {RAMA1HH[i], RAMA1HL[i], RAMA1LH[i], RAMA1LL[i]} = 0;
    {RAMB0HH[i], RAMB0HL[i], RAMB0LH[i], RAMB0LL[i]} = 0;
    {RAMB1HH[i], RAMB1HL[i], RAMB1LH[i], RAMB1LL[i]} = 0;
end


/* this is for the instantiation commented-out at the bottome of this module (appears to be unsupported by Vivado synthesis)
reg    [31:0] RAMA0[4095:0];       //side A even 4k-words  (16k-bytes) 
reg    [31:0] RAMA1[4095:0];       //side A odd  4k-words  (16k-bytes) 
reg    [31:0] RAMB0[4095:0];       //side B even 4k-words  (16k-bytes)
reg    [31:0] RAMB1[4095:0];       //side B odd  4k-words  (16k-bytes) 

integer i;

initial begin
//   i = 2**ADDRS_WIDTH;
   i = 4095;
   while(i) 
    begin
        RAMA0[i] = 0;
        RAMA1[i] = 0;
        RAMB0[i] = 0;
        RAMB1[i] = 0;
        i = i - 1;
    end
    RAMA0[i] = 0;
    RAMA1[i] = 0;
    RAMB0[i] = 0;
    RAMB1[i] = 0;
end
*/

reg [31:0] rddataA0q;
reg [31:0] rddataA1q;
reg [31:0] rddataB0q;
reg [31:0] rddataB1q;

reg [31:0] rddataAq;
reg [31:0] rddataBq;

reg [31:0] rddataA_collision;
reg [31:0] rddataB_collision;

reg rdenAq;
reg rdenBq;

reg [1:0] dsizeq2;
reg [1:0] dsizeq1;

wire [31:0] rddataA;
wire [31:0] rddataB;

wire [63:0] rddataA01;
wire [63:0] rddataB01;

reg [3:0] word_rd_selA;
reg [3:0] word_rd_selB;
reg rdaddrsA_a2;
reg rdaddrsB_a2;

wire [3:0] word_wr_sel;

wire wren_evnHH;
wire wren_evnHL;
wire wren_evnLH;
wire wren_evnLL;

wire wren_oddHH;
wire wren_oddHL;
wire wren_oddLH;
wire wren_oddLL;

reg [63:0] wrdata01; 
reg [7:0] byte_sel;

wire [11:0] rdaddrsAevn;
wire [11:0] rdaddrsAodd;       
wire [11:0] rdaddrsBevn;
wire [11:0] rdaddrsBodd;  
wire [11:0] wraddrsevn;
wire [11:0] wraddrsodd;     

assign  rdaddrsAevn = rdaddrsA[14:3] + rdaddrsA[2];
assign  rdaddrsAodd = rdaddrsA[14:3];

assign  rdaddrsBevn = rdaddrsB[14:3] + rdaddrsB[2];
assign  rdaddrsBodd = rdaddrsB[14:3];

assign  wraddrsevn = wraddrs[14:3] + wraddrs[2];
assign  wraddrsodd = wraddrs[14:3];

assign word_wr_sel  = {dsizeq2[1:0],  wraddrs[1:0]}; 

always @(posedge CLK or posedge RESET)
    if (RESET) begin
        word_rd_selA <= 4'b0000; 
        word_rd_selB <= 4'b0000;
        rdaddrsA_a2 <= 1'b0;
        rdaddrsB_a2 <= 1'b0;
    end
    else begin
        word_rd_selA <= {dsize[1:0], rdaddrsA[1:0]}; 
        word_rd_selB <= {dsize[1:0], rdaddrsB[1:0]};
        rdaddrsA_a2 <= rdaddrsA[2];
        rdaddrsB_a2 <= rdaddrsB[2];
    end

assign rddataA = (rdenAq) ? rddataA_collision : rddataAq;
assign rddataB = (rdenBq) ? rddataB_collision : rddataBq;

assign rddataA01 = rdaddrsA_a2 ? {rddataA1q, rddataA0q} : {rddataA0q, rddataA1q};
assign rddataB01 = rdaddrsB_a2 ? {rddataB1q, rddataB0q} : {rddataB0q, rddataB1q};

assign wren_evnHH = wren & (wraddrs[2] ? byte_sel[3] : byte_sel[7]);
assign wren_evnHL = wren & (wraddrs[2] ? byte_sel[2] : byte_sel[6]);
assign wren_evnLH = wren & (wraddrs[2] ? byte_sel[1] : byte_sel[5]);
assign wren_evnLL = wren & (wraddrs[2] ? byte_sel[0] : byte_sel[4]);

assign wren_oddHH = wren & (wraddrs[2] ? byte_sel[7] : byte_sel[3]);
assign wren_oddHL = wren & (wraddrs[2] ? byte_sel[6] : byte_sel[2]);
assign wren_oddLH = wren & (wraddrs[2] ? byte_sel[5] : byte_sel[1]);
assign wren_oddLL = wren & (wraddrs[2] ? byte_sel[4] : byte_sel[0]);

always@(*)
    case(word_rd_selA)
        4'b0000 : rddataAq = rddataA01[63:32];               // 32-bit aligned data
        4'b0001 : rddataAq = rddataA01[55:24];               // 32-bit mis-aligned by 1 byte
        4'b0010 : rddataAq = rddataA01[47:16];               // 32-bit mis-aligned by 2 bytes
        4'b0011 : rddataAq = rddataA01[39:8 ];               // 32-bit mis-aligned by 3 bytes
        4'b0100 : rddataAq = {{16{rddataA01[63]}}, rddataA01[63:48]};   // 16-bit aligned (read sign-extended)
        4'b0101 : rddataAq = {{16{rddataA01[55]}}, rddataA01[55:40]};   // 16-bit mis-aligned by 1 byte 
        4'b0110 : rddataAq = {{16{rddataA01[47]}}, rddataA01[47:32]};   // 16-bit mis-aligned by 2 bytes
        4'b0111 : rddataAq = {{16{rddataA01[39]}}, rddataA01[39:24]};   // 16-bit mis-aligned by 3 bytes
        4'b1000 : rddataAq = {{24{rddataA01[63]}}, rddataA01[63:56]}; // byte address + 0
        4'b1001 : rddataAq = {{24{rddataA01[55]}}, rddataA01[55:48]}; // byte address + 1
        4'b1010 : rddataAq = {{24{rddataA01[47]}}, rddataA01[47:40]}; // byte address + 2
        4'b1011 : rddataAq = {{24{rddataA01[39]}}, rddataA01[39:32]}; // byte address + 3
        4'b1100 : rddataAq = {rddataA01[39:32], rddataA01[47:40], rddataA01[55:48], rddataA01[63:56]}; //32-bit aligned data, endianness swapped
        4'b1101 : rddataAq = {rddataA01[31:24], rddataA01[39:32], rddataA01[47:40], rddataA01[55:48]}; //32-bit mis-aligned data by 1 byte, endianness swapped
        4'b1110 : rddataAq = {rddataA01[23:16], rddataA01[31:24], rddataA01[39:32], rddataA01[47:40]}; //32-bit mis-aligned data by 2 bytes, endianness swapped
        4'b1111 : rddataAq = {rddataA01[15:8 ], rddataA01[23:16], rddataA01[31:24], rddataA01[39:32]}; //32-bit mis-aligned data by 2 bytes, endianness swapped
    endcase

always@(*)
    case(word_rd_selB)
        4'b0000 : rddataBq = rddataB01[63:32];               // 32-bit aligned data
        4'b0001 : rddataBq = rddataB01[55:24];               // 32-bit mis-aligned by 1 byte
        4'b0010 : rddataBq = rddataB01[47:16];               // 32-bit mis-aligned by 2 bytes
        4'b0011 : rddataBq = rddataB01[39:8 ];               // 32-bit mis-aligned by 3 bytes
        4'b0100 : rddataBq = {{16{rddataB01[63]}}, rddataB01[63:48]};   // 16-bit aligned (read sign-extended)
        4'b0101 : rddataBq = {{16{rddataB01[55]}}, rddataB01[55:40]};   // 16-bit mis-aligned by 1 byte
        4'b0110 : rddataBq = {{16{rddataB01[47]}}, rddataB01[47:32]};   // 16-bit mis-aligned by 2 bytes
        4'b0111 : rddataBq = {{16{rddataB01[39]}}, rddataB01[39:24]};   // 16-bit mis-aligned by 3 bytes
        4'b1000 : rddataBq = {{24{rddataB01[63]}}, rddataB01[63:56]}; // byte address + 0
        4'b1001 : rddataBq = {{24{rddataB01[55]}}, rddataB01[55:48]}; // byte address + 1
        4'b1010 : rddataBq = {{24{rddataB01[47]}}, rddataB01[47:40]}; // byte address + 2
        4'b1011 : rddataBq = {{24{rddataB01[39]}}, rddataB01[39:32]}; // byte address + 3
        4'b1100 : rddataBq = {rddataB01[39:32], rddataB01[47:40], rddataB01[55:48], rddataB01[63:56]}; //32-bit aligned data, endianness swapped
        4'b1101 : rddataBq = {rddataB01[31:24], rddataB01[39:32], rddataB01[47:40], rddataB01[55:48]}; //32-bit mis-aligned data by 1 byte, endianness swapped
        4'b1110 : rddataBq = {rddataB01[23:16], rddataB01[31:24], rddataB01[39:32], rddataB01[47:40]}; //32-bit mis-aligned data by 2 bytes, endianness swapped
        4'b1111 : rddataBq = {rddataB01[15:8 ], rddataB01[23:16], rddataB01[31:24], rddataB01[39:32]}; //32-bit mis-aligned data by 2 bytes, endianness swapped
    endcase

always@(*)
    case(word_wr_sel)
        4'b0000 : wrdata01 = {wrdata[31:0], 32'h0000_0000};             // 32-bit aligned data
        4'b0001 : wrdata01 = {8'h00, wrdata[31:0], 24'h00_0000};        // 32-bit mis-aligned by 1 byte
        4'b0010 : wrdata01 = {16'h0000, wrdata[31:0], 16'h0000};        // 32-bit mis-aligned by 2 bytes
        4'b0011 : wrdata01 = {24'h0000_00, wrdata[31:0], 8'h00};        // 32-bit mis-aligned by 3 bytes
        4'b0100 : wrdata01 = {wrdata[15:0], 48'h0000_0000_0000};        // 16-bit aligned
        4'b0101 : wrdata01 = {8'h00, wrdata[15:0], 40'h00_0000_0000};   // 16-bit mis-aligned by 1 byte
        4'b0110 : wrdata01 = {16'h0000, wrdata[15:0], 32'h0000_0000};   // 16-bit mis-aligned by 2 bytes
        4'b0111 : wrdata01 = {24'h0000_00, wrdata[15:0], 24'h00_0000};  // 16-bit mis-aligned by 3 bytes
        4'b1000 : wrdata01 = {wrdata[7:0], 56'h00_0000_0000_0000};      // byte address + 0
        4'b1001 : wrdata01 = {8'h00, wrdata[7:0], 48'h0000_0000_0000};  // byte address + 1
        4'b1010 : wrdata01 = {16'h0000, wrdata[7:0], 40'h00_0000_0000}; // byte address + 2
        4'b1011 : wrdata01 = {24'h000000, wrdata[7:0], 32'h0000_0000};  // byte address + 3
      
        4'b1100 : wrdata01 = {wrdata[7:0], wrdata[15:8], wrdata[23:16], wrdata[31:24], 32'h0000_0000};      //32-bit aligned data, endianness swapped
        4'b1101 : wrdata01 = {8'h00, wrdata[7:0], wrdata[15:8], wrdata[23:16], wrdata[31:24], 24'h00_0000}; //32-bit mis-aligned data by 1 byte, endianness swapped
        4'b1110 : wrdata01 = {16'h0000, wrdata[7:0], wrdata[15:8], wrdata[23:16], wrdata[31:24], 16'h0000}; //32-bit mis-aligned data by 2 bytes, endianness swapped
        4'b1111 : wrdata01 = {24'h0000_00, wrdata[7:0], wrdata[15:8], wrdata[23:16], wrdata[31:24], 8'h00}; //32-bit mis-aligned data by 2 bytes, endianness swapped
/*
// inversion of endian-ness only occurs on the read-side (with word_wr_sel[4:3]==2'b11)
        4'b1100 : wrdata01 = {wrdata[31:0], 32'h0000_0000};             // 32-bit aligned data
        4'b1101 : wrdata01 = {8'h00, wrdata[31:0], 24'h00_0000};        // 32-bit mis-aligned by 1 byte
        4'b1110 : wrdata01 = {16'h0000, wrdata[31:0], 16'h0000};        // 32-bit mis-aligned by 2 bytes
        4'b1111 : wrdata01 = {24'h0000_00, wrdata[31:0], 8'h00};        // 32-bit mis-aligned by 3 bytes
*/
    endcase
    
always@(*)
    case(word_wr_sel)
        4'b0000 : byte_sel = 8'b1111_0000;  // 32-bit aligned data
        4'b0001 : byte_sel = 8'b0111_1000;  // 32-bit mis-aligned by 1 byte
        4'b0010 : byte_sel = 8'b0011_1100;  // 32-bit mis-aligned by 2 bytes
        4'b0011 : byte_sel = 8'b0001_1110;  // 32-bit mis-aligned by 3 bytes
        4'b0100 : byte_sel = 8'b1100_0000;  // 16-bit aligned
        4'b0101 : byte_sel = 8'b0110_0000;  // 16-bit mis-aligned by 1 byte
        4'b0110 : byte_sel = 8'b0011_0000;  // 16-bit mis-aligned by 2 bytes
        4'b0111 : byte_sel = 8'b0001_1000;  // 16-bit mis-aligned by 3 bytes
        4'b1000 : byte_sel = 8'b1000_0000;  // byte address + 0
        4'b1001 : byte_sel = 8'b0100_0000;  // byte address + 1
        4'b1010 : byte_sel = 8'b0010_0000;  // byte address + 2
        4'b1011 : byte_sel = 8'b0001_0000;  // byte address + 3
        4'b1100 : byte_sel = 8'b1111_0000;  //32-bit aligned data, endianness swapped
        4'b1101 : byte_sel = 8'b0111_1000;  //32-bit mis-aligned data by 1 byte, endianness swapped
        4'b1110 : byte_sel = 8'b0011_1100;  //32-bit mis-aligned data by 2 bytes, endianness swapped
        4'b1111 : byte_sel = 8'b0001_1110;  //32-bit mis-aligned data by 2 bytes, endianness swapped
    endcase

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        dsizeq1 <= 2'b00;
        dsizeq2 <= 2'b00;
    end
    else begin        
        dsizeq1 <= dsize;
        dsizeq2 <= dsizeq1;
    end    
end    

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        rddataA_collision <= 32'h0000_0000;
        rddataB_collision <= 32'h0000_0000;
        rdenAq <= 1'b0;
        rdenBq <= 1'b0;
    end    
    else begin
        if ((wraddrs==rdaddrsA) && wren && rdenA) begin
            rddataA_collision <= wrdata;
            rdenAq <= rdenA;
        end    
        else rdenAq <= 1'b0;
           
        if ((wraddrs==rdaddrsB) && wren && rdenB) begin
            rddataB_collision <= wrdata;
            rdenBq <= rdenB;
        end    
        else rdenBq <= 1'b0;
    end        
end

always @(posedge CLK) begin   //side-A even
    if (rdenA) rddataA0q <=  {RAMA0HH[rdaddrsAevn], RAMA0HL[rdaddrsAevn], RAMA0LH[rdaddrsAevn], RAMA0LL[rdaddrsAevn]};
end
always @(posedge CLK) begin   //side-A odd
    if (rdenA) rddataA1q <=  {RAMA1HH[rdaddrsAodd], RAMA1HL[rdaddrsAodd], RAMA1LH[rdaddrsAodd], RAMA1LL[rdaddrsAodd]};
end
always @(posedge CLK) begin   //side-B even
    if (rdenB) rddataB0q <=  {RAMB0HH[rdaddrsBevn], RAMB0HL[rdaddrsBevn], RAMB0LH[rdaddrsBevn], RAMB0LL[rdaddrsBevn]};
end
always @(posedge CLK) begin   //side-B odd
    if (rdenB) rddataB1q <=  {RAMB1HH[rdaddrsBodd], RAMB1HL[rdaddrsBodd], RAMB1LH[rdaddrsBodd], RAMB1LL[rdaddrsBodd]};
end

always @(posedge CLK) begin   //side-A even
    if (wren_evnHH) RAMA0HH[wraddrsevn] <= wraddrs[2] ? wrdata01[31:24] : wrdata01[63:56];
    if (wren_evnHL) RAMA0HL[wraddrsevn] <= wraddrs[2] ? wrdata01[23:16] : wrdata01[55:48];
    if (wren_evnLH) RAMA0LH[wraddrsevn] <= wraddrs[2] ? wrdata01[15:8 ] : wrdata01[47:40];
    if (wren_evnLL) RAMA0LL[wraddrsevn] <= wraddrs[2] ? wrdata01[ 7:0 ] : wrdata01[39:32];
end
always @(posedge CLK) begin   //side-A odd
    if (wren_oddHH) RAMA1HH[wraddrsodd] <= wraddrs[2] ? wrdata01[63:56] : wrdata01[31:24];
    if (wren_oddHL) RAMA1HL[wraddrsodd] <= wraddrs[2] ? wrdata01[55:48] : wrdata01[23:16];
    if (wren_oddLH) RAMA1LH[wraddrsodd] <= wraddrs[2] ? wrdata01[47:40] : wrdata01[15:8 ];
    if (wren_oddLL) RAMA1LL[wraddrsodd] <= wraddrs[2] ? wrdata01[39:32] : wrdata01[ 7:0 ];
end
always @(posedge CLK) begin   //side-B even
    if (wren_evnHH) RAMB0HH[wraddrsevn] <= wraddrs[2] ? wrdata01[31:24] : wrdata01[63:56];
    if (wren_evnHL) RAMB0HL[wraddrsevn] <= wraddrs[2] ? wrdata01[23:16] : wrdata01[55:48];
    if (wren_evnLH) RAMB0LH[wraddrsevn] <= wraddrs[2] ? wrdata01[15:8 ] : wrdata01[47:40];
    if (wren_evnLL) RAMB0LL[wraddrsevn] <= wraddrs[2] ? wrdata01[ 7:0 ] : wrdata01[39:32];
end
always @(posedge CLK) begin   //side-B odd
    if (wren_oddHH) RAMB1HH[wraddrsodd] <= wraddrs[2] ? wrdata01[63:56] : wrdata01[31:24];
    if (wren_oddHL) RAMB1HL[wraddrsodd] <= wraddrs[2] ? wrdata01[55:48] : wrdata01[23:16];
    if (wren_oddLH) RAMB1LH[wraddrsodd] <= wraddrs[2] ? wrdata01[47:40] : wrdata01[15:8 ];
    if (wren_oddLL) RAMB1LL[wraddrsodd] <= wraddrs[2] ? wrdata01[39:32] : wrdata01[ 7:0 ];
end

// the code below is sort of what the Xilinx synthesis guide suggested, but the Xilinx tool faild to recognize it as a
// valid templet.  It looks like it should work though
/*
parameter NB_COL = 4;
parameter CW = 8;   //column width

wire [3:0] wren_evn;
wire [3:0] wren_odd;

assign wren_evn = {wren_evnHH, wren_evnHL, wren_evnLH, wren_evnLL};
assign wren_odd = {wren_oddHH, wren_oddHL, wren_oddLH, wren_oddLL};

always @(posedge CLK) begin   //side-A even
    if (rdenA) rddataA0q <=  RAMA0[rdaddrsAevn];
end
always @(posedge CLK) begin   //side-A odd
    if (rdenA) rddataA1q <=  RAMA1[rdaddrsAodd];
end
always @(posedge CLK) begin   //side-B even
    if (rdenB) rddataB0q <=  RAMB0[rdaddrsBevn];
end
always @(posedge CLK) begin   //side-B odd
    if (rdenB) rddataB1q <=  RAMB1[rdaddrsBodd];
end

generate genvar j;
    for (j = 0; j < NB_COL; j = j+1) begin
        
        always @(posedge CLK) begin   //side-A even
            if (wren_evn[j]) RAMA0[wraddrsevn] [(j+1)*CW-1:j*CW] <= wraddrs[2] ? wrdata01[(j+1)*CW-1:j*CW] : wrdata01[((j+1)*CW-1)+32:(j*CW)+32];
        end
        always @(posedge CLK) begin   //side-A odd
            if (wren_odd[j]) RAMA1[wraddrsodd] [(j+1)*CW-1:j*CW] <= wraddrs[2] ? wrdata01[((j+1)*CW-1)+32:(j*CW)+32] : wrdata01[(j+1)*CW-1:j*CW];
        end
        always @(posedge CLK) begin   //side-B even
            if (wren_evn[j]) RAMB0[wraddrsevn] [(j+1)*CW-1:j*CW] <= wraddrs[2] ? wrdata01[(j+1)*CW-1:j*CW] : wrdata01[((j+1)*CW-1)+32:(j*CW)+32];
        end
        always @(posedge CLK) begin   //side-B odd
            if (wren_odd[j]) RAMB1[wraddrsodd] [(j+1)*CW-1:j*CW] <= wraddrs[2] ? wrdata01[((j+1)*CW-1)+32:(j*CW)+32] : wrdata01[(j+1)*CW-1:j*CW];
        end
    end
endgenerate
*/

endmodule    

