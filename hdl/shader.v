 // SYMPL shader with AXI4 burst-mode DMA hooks
 `timescale 1ns/100ps
 // For use with SYMPL FP324-AXI4 multi-thread multi-processing core only
 // Author:  Jerry D. Harthcock
 // Version:  1.001 July 7, 2015
 // July 7, 2015
 // Copyright (C) 2015.  All rights reserved without prejudice.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                           SYMPL FP324-AXI4 32-Bit Mult-Thread Multi-Processor                                 //
//                              Evaluation and Product Development License                                       //
//                                                                                                               //
// Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"), //
// the original author and exclusive copyright owner of this SYMPL FP324-AXI4 32-Bit Mult-Thread Multi-Processor //
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


module shader #(parameter PKT_RAM_ADDRS_WIDTH = 10, IRB_RAM_ADDRS_WIDTH = 10)
    ( 
    CLK,
    RESET,
    dma_wre,
    dma_wraddrs,
    dma_wrdata,
    dma_rde,
    dma_rdaddrs,
    dma_rddata,
    tr3_done,
    tr2_done,
    tr1_done,
    tr0_done,
    ROM_BASE,
    RAM_BASE,
    IRB_BASE
    );
    
input CLK;
input RESET;
input dma_wre;
input [31:0] dma_wraddrs;
input [31:0] dma_wrdata;
input dma_rde;
input [31:0] dma_rdaddrs;
output [31:0] dma_rddata;
output tr3_done;
output tr2_done;
output tr1_done;
output tr0_done;
input [31:14] ROM_BASE;
input [31:17] RAM_BASE;
input [31:14] IRB_BASE;

reg [31:0] rddataA;
reg [31:0] rddataB;

reg [4:0] rddataA_sel_q;
reg [4:0] rddataB_sel_q;

wire [1:0] thread_q0;
wire [1:0] thread_q2;

wire [12:0] muxd_slave_wraddrs_tr3;    
wire [12:0] muxd_slave_wraddrs_tr2;    
wire [12:0] muxd_slave_wraddrs_tr1;    
wire [12:0] muxd_slave_wraddrs_tr0; 
   
wire [12:0] muxd_slave_rdaddrs_tr3; 
wire [12:0] muxd_slave_rdaddrs_tr2; 
wire [12:0] muxd_slave_rdaddrs_tr1; 
wire [12:0] muxd_slave_rdaddrs_tr0; 

wire [31:0] muxd_slave_wrdata_tr3;
wire [31:0] muxd_slave_wrdata_tr2;
wire [31:0] muxd_slave_wrdata_tr1;
wire [31:0] muxd_slave_wrdata_tr0;

wire muxd_slave_wre_tr0;
wire muxd_slave_wre_tr1;
wire muxd_slave_wre_tr2;
wire muxd_slave_wre_tr3;

wire muxd_slave_rdeB_tr0;
wire muxd_slave_rdeB_tr1;
wire muxd_slave_rdeB_tr2;
wire muxd_slave_rdeB_tr3;

wire muxd_slave_wre_irb;
wire muxd_slave_rdeB_irb;
wire [12:0] muxd_slave_wraddrs_irb;
wire [12:0] muxd_slave_rdaddrs_irb;
wire [31:0] muxd_slave_wrdata_irb;

wire rdeA_tr0;
wire rdeA_tr1;
wire rdeA_tr2;
wire rdeA_tr3;
wire rdeA_irb;

wire rdenA;
wire rdenB;
wire rdconstA;
wire wren;
wire [13:0] srcA;
wire [13:0] srcB;
wire [13:0] dest_q2;
wire [31:0] wrdata;

wire [3:0] rddataA_sel;
wire [3:0] rddataB_sel;

wire [31:0] rddataA_tr3;
wire [31:0] rddataA_tr2;
wire [31:0] rddataA_tr1;
wire [31:0] rddataA_tr0;

wire [31:0] rddataB_tr3;
wire [31:0] rddataB_tr2;
wire [31:0] rddataB_tr1;
wire [31:0] rddataB_tr0;

wire [31:0] rddataA_irb;
wire [31:0] rddataB_irb;

wire [11:0] PC;
wire [11:0] pre_PC;
wire [31:0] P_DATAi;
wire [31:0] ROM_4k_rddataA;
wire [1:0] const;

wire [31:0] dma_rddata;

wire ram_wr_sel;
wire ram_rd_sel;
wire rom_wr_sel;
wire irb_wr_sel;
wire irb_rd_sel;

wire tr3_IRQ;
wire tr2_IRQ;
wire tr1_IRQ;
wire tr0_IRQ;

assign tr3_IRQ = 1'b0;
assign tr2_IRQ = 1'b0;
assign tr1_IRQ = 1'b0;
assign tr0_IRQ = 1'b0;

assign const = P_DATAi[29:28];

assign ram_wr_sel = (dma_wraddrs[31:17]==RAM_BASE);
assign ram_rd_sel = (dma_rdaddrs[31:17]==RAM_BASE);
assign rom_wr_sel = (dma_wraddrs[31:14]==ROM_BASE) | (dma_wraddrs[31:16]=={ROM_BASE[31:17], 1'b1}); 
   
assign irb_wr_sel = (dma_wraddrs[31:14]==IRB_BASE);
assign irb_rd_sel = (dma_rdaddrs[31:14]==IRB_BASE);

assign dma_rddata = rddataB;

assign rdeA_tr3 = rdenA & (thread_q0 == 2'b11) & (srcA[13:11]==3'b001);
assign rdeA_tr2 = rdenA & (thread_q0 == 2'b10) & (srcA[13:11]==3'b001);
assign rdeA_tr1 = rdenA & (thread_q0 == 2'b01) & (srcA[13:11]==3'b001);
assign rdeA_tr0 = rdenA & (thread_q0 == 2'b00) & (srcA[13:11]==3'b001);

assign rdeA_irb = rdenA & (srcA[13:11]==3'b100);    //global intermediat result buffer

assign rddataA_sel = {rdeA_irb, rdeA_tr3, rdeA_tr2, rdeA_tr1, rdeA_tr0};
assign rddataB_sel = {muxd_slave_rdeB_irb, muxd_slave_rdeB_tr3, muxd_slave_rdeB_tr2, muxd_slave_rdeB_tr1, muxd_slave_rdeB_tr0};

assign muxd_slave_wre_tr3 = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b11)) ? 1'b1 : (thread_q2 == 2'b11) & wren & (dest_q2[13:11]==3'b001);
assign muxd_slave_wre_tr2 = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b10)) ? 1'b1 : (thread_q2 == 2'b10) & wren & (dest_q2[13:11]==3'b001);
assign muxd_slave_wre_tr1 = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b01)) ? 1'b1 : (thread_q2 == 2'b01) & wren & (dest_q2[13:11]==3'b001);
assign muxd_slave_wre_tr0 = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b00)) ? 1'b1 : (thread_q2 == 2'b00) & wren & (dest_q2[13:11]==3'b001);

assign muxd_slave_wre_irb = (dma_wre & irb_wr_sel & (dma_wraddrs[16:14]==IRB_BASE[16:14])) ? 1'b1 : wren & (dest_q2[13:11]==3'b100);
assign muxd_slave_wraddrs_tr3[12:0] = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b11)) ? dma_wraddrs[14:2] : dest_q2[12:0];    
assign muxd_slave_wraddrs_tr2[12:0] = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b10)) ? dma_wraddrs[14:2] : dest_q2[12:0];    
assign muxd_slave_wraddrs_tr1[12:0] = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b01)) ? dma_wraddrs[14:2] : dest_q2[12:0];    
assign muxd_slave_wraddrs_tr0[12:0] = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b00)) ? dma_wraddrs[14:2] : dest_q2[12:0];    

assign muxd_slave_wraddrs_irb[12:0] = (dma_wre & irb_wr_sel & (dma_wraddrs[16:14]==IRB_BASE[16:14])) ? dma_wraddrs[14:2] : dest_q2[12:0];    

assign muxd_slave_rdaddrs_tr3[12:0] = (dma_rde & ram_rd_sel & (dma_wraddrs[16:15]==2'b11)) ? dma_rdaddrs[14:2] : srcB[12:0]; 
assign muxd_slave_rdaddrs_tr2[12:0] = (dma_rde & ram_rd_sel & (dma_wraddrs[16:15]==2'b10)) ? dma_rdaddrs[14:2] : srcB[12:0]; 
assign muxd_slave_rdaddrs_tr1[12:0] = (dma_rde & ram_rd_sel & (dma_wraddrs[16:15]==2'b01)) ? dma_rdaddrs[14:2] : srcB[12:0]; 
assign muxd_slave_rdaddrs_tr0[12:0] = (dma_rde & ram_rd_sel & (dma_wraddrs[16:15]==2'b00)) ? dma_rdaddrs[14:2] : srcB[12:0]; 

assign muxd_slave_rdaddrs_irb[12:0] = (dma_rde & irb_rd_sel & (dma_wraddrs[16:14]==IRB_BASE[16:14])) ? dma_rdaddrs[14:2] : srcB[12:0]; 

assign muxd_slave_wrdata_tr3[31:0]  = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b11)) ? dma_wrdata[31:0] : wrdata[31:0];
assign muxd_slave_wrdata_tr2[31:0]  = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b10)) ? dma_wrdata[31:0] : wrdata[31:0];
assign muxd_slave_wrdata_tr1[31:0]  = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b01)) ? dma_wrdata[31:0] : wrdata[31:0];
assign muxd_slave_wrdata_tr0[31:0]  = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b00)) ? dma_wrdata[31:0] : wrdata[31:0];

assign muxd_slave_wrdata_irb[31:0]  = (dma_wre & irb_wr_sel & (dma_wraddrs[16:14]==IRB_BASE[16:14])) ? dma_wrdata[31:0] : wrdata[31:0];

assign muxd_slave_rdeB_tr3 = (dma_rde & ram_rd_sel & (dma_rdaddrs[16:15]==2'b11)) ? 1'b1 : (thread_q0 == 2'b11) & rdenB & (srcB[13:11]==3'b001);
assign muxd_slave_rdeB_tr2 = (dma_rde & ram_rd_sel & (dma_rdaddrs[16:15]==2'b10)) ? 1'b1 : (thread_q0 == 2'b10) & rdenB & (srcB[13:11]==3'b001);
assign muxd_slave_rdeB_tr1 = (dma_rde & ram_rd_sel & (dma_rdaddrs[16:15]==2'b01)) ? 1'b1 : (thread_q0 == 2'b01) & rdenB & (srcB[13:11]==3'b001);
assign muxd_slave_rdeB_tr0 = (dma_rde & ram_rd_sel & (dma_rdaddrs[16:15]==2'b00)) ? 1'b1 : (thread_q0 == 2'b00) & rdenB & (srcB[13:11]==3'b001);

assign muxd_slave_rdeB_irb = (dma_rde & irb_rd_sel & (dma_rdaddrs[16:14]==IRB_BASE[16:14])) ? 1'b1 : rdenB & (srcB[13:11]==3'b100);


core core(
    .PC                  (PC             ),   
    .P_DATAi             (P_DATAi        ),   
    .ROM_4k_rddataA      (ROM_4k_rddataA ),   
    .rdprog              (rdprog         ),   
    .srcA                (srcA           ),   
    .srcB                (srcB           ),   
    .dest_q2             (dest_q2        ),   
    .pre_PC              (pre_PC         ),     
    .prvt_2k_rddataA     (rddataA        ),
    .prvt_2k_rddataB     (rddataB        ),
    .RAM_4k_IRB_rddataA  (rddataA_irb    ),
    .RAM_4k_IRB_rddataB  (rddataB_irb    ),
    .resultout           (wrdata         ),  
    .rdsrcA              (rdenA          ),   
    .rdsrcB              (rdenB          ),    
    .rdconstA            (rdconstA       ),     
    .wrcycl              (wren           ),   
    .CLK                 (CLK            ), 
    .RESET_IN            (RESET          ),     
    .tr3_done            (tr3_done       ),     
    .tr2_done            (tr2_done       ),     
    .tr1_done            (tr1_done       ),     
    .tr0_done            (tr0_done       ),
    .newthreadq          (thread_q0      ),
    .thread_q2           (thread_q2      ),    
    .SWBRKdet            (               ),
    .OUTBOX              (               ),
    .tr3_IRQ             (tr3_IRQ        ),
    .tr2_IRQ             (tr2_IRQ        ),
    .tr1_IRQ             (tr1_IRQ        ),
    .tr0_IRQ             (tr0_IRQ        )
    );

RAM_tp #(.ADDRS_WIDTH(12), .DATA_WIDTH(32))
    rom4096(      //program memory for core 
    .CLK       (CLK             ),
    .wren      (rom_wr_sel & dma_wre),
    .wraddrs   (dma_wraddrs[13:2]),
    .wrdata    (dma_wrdata),
    .rdenA     (rdprog),
    .rdaddrsA  (pre_PC),
    .rddataA   (P_DATAi      ),
    .rdenB     (rdconstA | (srcA[13:12]==2'b01)),
    .rdaddrsB  (srcA[11:0]     ),
    .rddataB   (ROM_4k_rddataA  ));        

RAM_tp #(.ADDRS_WIDTH(PKT_RAM_ADDRS_WIDTH), .DATA_WIDTH(32)) // ADDRS_WIDTH of 10 = 1024 native words deep
    prvt_2k3(               // private DATA RAM for thread3 packet
    .CLK        ( CLK       ),
    .wren       (muxd_slave_wre_tr3),
    .wraddrs    (muxd_slave_wraddrs_tr3[PKT_RAM_ADDRS_WIDTH-1:0]),
    .wrdata     (muxd_slave_wrdata_tr3),
    .rdenA      (rdeA_tr3),
    .rdaddrsA   (srcA[PKT_RAM_ADDRS_WIDTH-1:0] ),
    .rddataA    (rddataA_tr3),
    .rdenB      (muxd_slave_rdeB_tr3),
    .rdaddrsB   (muxd_slave_rdaddrs_tr3[PKT_RAM_ADDRS_WIDTH-1:0]),    
    .rddataB    (rddataB_tr3));  

RAM_tp #(.ADDRS_WIDTH(PKT_RAM_ADDRS_WIDTH), .DATA_WIDTH(32)) // ADDRS_WIDTH of 10 = 1024 native words deep
    prvt_2k2(               // private DATA RAM for thread2 packet
    .CLK        ( CLK       ),
    .wren       (muxd_slave_wre_tr2),
    .wraddrs    (muxd_slave_wraddrs_tr2[PKT_RAM_ADDRS_WIDTH-1:0]),
    .wrdata     (muxd_slave_wrdata_tr2),
    .rdenA      (rdeA_tr2),
    .rdaddrsA   (srcA[PKT_RAM_ADDRS_WIDTH-1:0] ),
    .rddataA    (rddataA_tr2),
    .rdenB      (muxd_slave_rdeB_tr2),
    .rdaddrsB   (muxd_slave_rdaddrs_tr2[PKT_RAM_ADDRS_WIDTH-1:0]),    
    .rddataB    (rddataB_tr2));  

RAM_tp #(.ADDRS_WIDTH(PKT_RAM_ADDRS_WIDTH), .DATA_WIDTH(32)) // ADDRS_WIDTH of 10 = 1024 native words deep
    prvt_2k1(               // private DATA RAM for thread1 packet
    .CLK        ( CLK       ),
    .wren       (muxd_slave_wre_tr1),
    .wraddrs    (muxd_slave_wraddrs_tr1[PKT_RAM_ADDRS_WIDTH-1:0]),
    .wrdata     (muxd_slave_wrdata_tr1),
    .rdenA      (rdeA_tr1),
    .rdaddrsA   (srcA[PKT_RAM_ADDRS_WIDTH-1:0] ),
    .rddataA    (rddataA_tr1),
    .rdenB      (muxd_slave_rdeB_tr1),
    .rdaddrsB   (muxd_slave_rdaddrs_tr1[PKT_RAM_ADDRS_WIDTH-1:0]),    
    .rddataB    (rddataB_tr1));  

RAM_tp #(.ADDRS_WIDTH(PKT_RAM_ADDRS_WIDTH), .DATA_WIDTH(32)) // ADDRS_WIDTH of 10 = 1024 native words deep
    prvt_2k0(               // private DATA RAM for thread1 packet
    .CLK        ( CLK       ),
    .wren       (muxd_slave_wre_tr0),
    .wraddrs    (muxd_slave_wraddrs_tr0[PKT_RAM_ADDRS_WIDTH-1:0]),
    .wrdata     (muxd_slave_wrdata_tr0),
    .rdenA      (rdeA_tr0),
    .rdaddrsA   (srcA[PKT_RAM_ADDRS_WIDTH-1:0] ),
    .rddataA    (rddataA_tr0),
    .rdenB      (muxd_slave_rdeB_tr0),
    .rdaddrsB   (muxd_slave_rdaddrs_tr0[PKT_RAM_ADDRS_WIDTH-1:0]),    
    .rddataB    (rddataB_tr0));  

//intermediate result buffer RAM
RAM_tp #(.ADDRS_WIDTH(IRB_RAM_ADDRS_WIDTH), .DATA_WIDTH(32)) // ADDRS_WIDTH of 10 = 1024 native words deep
    irb_ram0(               // private DATA RAM for thread1 packet
    .CLK        ( CLK       ),
    .wren       (muxd_slave_wre_irb),
    .wraddrs    (muxd_slave_wraddrs_irb[IRB_RAM_ADDRS_WIDTH-1:0]),
    .wrdata     (muxd_slave_wrdata_irb),
    .rdenA      (rdeA_irb),
    .rdaddrsA   (srcA[IRB_RAM_ADDRS_WIDTH-1:0] ),
    .rddataA    (rddataA_irb),
    .rdenB      (muxd_slave_rdeB_irb),
    .rdaddrsB   (muxd_slave_rdaddrs_irb[IRB_RAM_ADDRS_WIDTH-1:0]),    
    .rddataB    (rddataB_irb));  

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        rddataA_sel_q <= 5'b00000;
        rddataB_sel_q <= 5'b00000;
    end
    else begin
        rddataA_sel_q <= rddataA_sel;
        rddataB_sel_q <= rddataA_sel;
    end
end            
        
always @(*) begin
    casex (rddataA_sel_q)
        5'bxxxx1 : rddataA = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b00)) ? 32'h0000_0000 : rddataA_tr0;
        5'bxxx1x : rddataA = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b01)) ? 32'h0000_0000 : rddataA_tr1;
        5'bxx1xx : rddataA = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b10)) ? 32'h0000_0000 : rddataA_tr2;
        5'bx1xxx : rddataA = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b11)) ? 32'h0000_0000 : rddataA_tr3;
        5'b1xxxx : rddataA = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b00)) ? 32'h0000_0000 : rddataA_irb;
        default : rddataA = 32'h0000_0000;
    endcase
end         

always @(*) begin
    casex (rddataB_sel_q)
        5'bxxxx1 : rddataB = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b00)) ? 32'h0000_0000 : rddataB_tr0;
        5'bxxx1x : rddataB = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b01)) ? 32'h0000_0000 : rddataB_tr1;
        5'bxx1xx : rddataB = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b10)) ? 32'h0000_0000 : rddataB_tr2;
        5'bx1xxx : rddataB = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b11)) ? 32'h0000_0000 : rddataB_tr3;
        5'b1xxxx : rddataB = (dma_wre & ram_wr_sel & (dma_wraddrs[16:15]==2'b00)) ? 32'h0000_0000 : rddataB_irb;
         default : rddataB = 32'h0000_0000;
    endcase
end         

endmodule