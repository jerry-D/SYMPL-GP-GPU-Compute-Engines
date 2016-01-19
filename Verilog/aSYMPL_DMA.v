 `timescale 1ns/100ps
 // Author:  Jerry D. Harthcock
 // Version:  1.04  January 18, 2016
 // Copyright (C) 2015-2016.  All rights reserved without prejudice.
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

 module aSYMPL_DMA (
    CLK,
    RESET,
    wren,
    wraddrs,
    wrdata,
    rdenA,
    rdenB,
    rdaddrsA,
    rdaddrsB,
    rddataA,
    rddataB,
    DMAwren,
    DMAwraddrs,
    DMArden,
    DMArdaddrs,
    DMAcollide,
    DMA_IRQ,
    byte_swap
    );
    
input CLK;
input RESET;
input wren;
input [1:0] wraddrs;
input [31:0] wrdata;
input rdenA;
input rdenB;
input [1:0] rdaddrsA;
input [1:0] rdaddrsB;
output [31:0] rddataA;
output [31:0] rddataB;
output DMArden; 
output [23:0] DMArdaddrs;
output DMAwren;
output [23:0] DMAwraddrs;
input  DMAcollide;
output DMA_IRQ;
output byte_swap;

reg [23:0] DMAwraddrs;
reg [23:0] DMArdaddrs;
reg DMAwren;
reg DMArden;
reg [23:0] count;
reg [1:0] state;
reg dma_done;
reg DMA_INTen;
reg [31:0] rddataA;
reg [31:0] rddataB;
reg [1:0] rdaddrsA_q1;
reg [1:0] rdaddrsB_q1;
reg byte_swap;   // setting to one swaps bytes so that LSBs are swapped with MSBs and middle bytes are swapped as well 

wire [31:0] DMACSR;
wire DMA_IRQ;

assign DMA_IRQ = DMA_INTen & dma_done;

assign DMACSR = {dma_done, DMA_INTen, byte_swap, 5'b0_0000, count[23:0]};
                  
always @(*) begin
        case (rdaddrsA_q1)
            2'b00 : rddataA = {8'h00, DMAwraddrs};
            2'b01 : rddataA = {8'h00, DMArdaddrs};
            2'b10 : rddataA = DMACSR;
          default : rddataA = 32'h0000_0000;
        endcase
end        

always @(*) begin
        case (rdaddrsB_q1)
            2'b00 : rddataB = {8'h00, DMAwraddrs};
            2'b01 : rddataB = {8'h00, DMArdaddrs};
            2'b10 : rddataB = DMACSR;
          default : rddataB = 32'h0000_0000;
        endcase
end        
                                                             
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        count <= 24'h00_0000;
        DMAwraddrs <= 24'h00_0000;
        DMArdaddrs <= 24'h00_0000; 
        dma_done <= 1'b1;
        DMAwren <= 1'b0;
        DMArden <= 1'b0;
        DMA_INTen <= 1'b0;
        state    <= 2'b00;
        rdaddrsA_q1 <= 2'b00;
        rdaddrsB_q1 <= 2'b00;
        byte_swap <= 1'b0;
    end 
    else begin
    
    rdaddrsA_q1 <=rdaddrsA; 
    rdaddrsB_q1 <=rdaddrsB;
     
    if (wren) begin
        case (wraddrs)
         2'b00 : DMAwraddrs <= wrdata;
         2'b01 : DMArdaddrs <= wrdata;
         2'b10,
         2'b11 : {dma_done, DMA_INTen, byte_swap, count[23:0]} <= {~|wrdata[23:0], wrdata[30], wrdata[29], wrdata[23:0]};
        endcase
    end         
    else begin                         
        if (~DMAcollide && ~dma_done) begin 
            case (state)
                2'b00 : begin
                            DMArden <= 1'b1;
                            state <= 2'b01;
                        end
                2'b01 : begin
                            DMAwren <= 1'b1;
                            if (|count) begin
                                DMArdaddrs <= DMArdaddrs + 1'b1;
                                if (DMAwren) DMAwraddrs <= DMAwraddrs + 1'b1;
                                count <= count - 1'b1;
                            end
                            else begin
                                DMAwraddrs <= DMAwraddrs + 1'b1;
                                DMArden <= 1'b0;
                                state <= 2'b10;
                            end    
                        end
                2'b10 : begin
                            DMAwren <= 1'b0;
                            dma_done <= 1'b1;
                            state <= 2'b00;
                        end 
            endcase
        end   
    end
end    
end        
        
endmodule        
                
    
    
    
    