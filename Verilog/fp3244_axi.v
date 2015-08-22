 // aSYMPL_top.v
 `timescale 1ns/100ps
 // SYMPL FP324-AXI4 top level RTL
 // SYMPL FP324-AXI4 multi-thread, multi-processing core
 // Author:  Jerry D. Harthcock
 // Version:  1.101
 // July 3, 2015
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


module fp3244_axi (
    ACLK,
    ARESETn,   //active low
    
    AWID,
    AWADDR,
    AWLEN,
    AWSIZE,
    AWBURST,
    AWLOCK,
    AWCACHE,
    AWPROT,
    AWVALID,
    AWREADY,
    
    WID,
    WDATA,
    WLAST,
    WVALID,
    WREADY,
    
    BID,
    BRESP,
    BVALID,
    BREADY,
    
    ARID,
    ARADDR,
    ARLEN,
    ARSIZE, 
    ARBURST,
    ARLOCK,
    ARCACHE,
    ARPROT,
    ARVALID,
    ARREADY,
    
    RID,
    RDATA,
    RRESP,
    RLAST,
    RVALID,
    RREADY,
    
    INTREQ
    );
            
input  ACLK;                                  
input  ARESETn;   //active low                
                                              
input [3:0] AWID;                             
input [31:0] AWADDR;                          
input [3:0] AWLEN;                            
input [2:0] AWSIZE;                           
input [1:0] AWBURST;                          
input [1:0] AWLOCK;                           
input [3:0] AWCACHE;                          
input [2:0] AWPROT;                           
input  AWVALID;                               
output AWREADY;                               
                                              
input [3:0]  WID;                             
input [31:0] WDATA;                           
input  WLAST;                                 
input  WVALID;                                
output WREADY;                                
                                              
output [3:0] BID;                             
output [1:0] BRESP;                           
output BVALID;                                
input  BREADY;                               
                                              
input [3:0] ARID;                             
input [31:0] ARADDR;                          
input [3:0]  ARLEN;                           
input [2:0] ARSIZE;                           
input [1:0] ARBURST;                          
input [1:0] ARLOCK;                           
input [3:0] ARCACHE;                          
input [2:0] ARPROT;                           
input ARVALID;                                
output ARREADY;                               
                                              
output [3:0]  RID;                            
output [31:0] RDATA;                          
output [1:0] RRESP;                           
output RLAST;                                 
output RVALID;                                
input  RREADY; 

output INTREQ;

parameter BASE_ADDRS = 12'hFFF; //strapped bits [31:20] of address bus form the base address used for decode
parameter AWPROT_mode = 3'b010; //strapped default AWPROT mode is {normal access, non-secure access, data access}
parameter ARPROT_mode = 3'b010; //strapped default ARPROT mode is {normal access, non-secure access, data access}

parameter CSRq_BASE = 20'hF_0004; // bits [19:0] of address bus, CSRq is control/status register
parameter THREAD_IER_BASE = 20'hF_0000; // bits [19:0] of address bus, shader interrupt enable and status register

parameter IRB3_BASE = 6'b1010_11;   //intermediate result buffer base address bits [19:14]
parameter IRB2_BASE = 6'b1010_10;
parameter IRB1_BASE = 6'b1010_01;
parameter IRB0_BASE = 6'b1010_00;

parameter ROM3_BASE = 6'b1000_11;  //bits [19:14] of address bus
parameter ROM2_BASE = 6'b1000_10;
parameter ROM1_BASE = 6'b1000_01;
parameter ROM0_BASE = 6'b1000_00;

parameter SHADER3_BASE  = 3'b011;       //bits [19:17] of address bus                       
parameter THREAD15_BASE = 5'b0111_1;    //bits [19:15] of address bus                          
parameter THREAD14_BASE = 5'b0111_0;                              
parameter THREAD13_BASE = 5'b0110_1;                              
parameter THREAD12_BASE = 5'b0110_0; 
                             
parameter SHADER2_BASE  = 3'b010;       //bits [19:17] of address bus                       
parameter THREAD11_BASE = 5'b0101_1;    //bits [19:15] of address bus                           
parameter THREAD10_BASE = 5'b0101_0;                              
parameter THREAD9_BASE  = 5'b0100_1;                              
parameter THREAD8_BASE  = 5'b0100_0;  
                            
parameter SHADER1_BASE  = 3'b001;       //bits [19:17] of address bus                       
parameter THREAD7_BASE  = 5'b0011_1;    //bits [19:15] of address bus                           
parameter THREAD6_BASE  = 5'b0011_0;                              
parameter THREAD5_BASE  = 5'b0010_1;                              
parameter THREAD4_BASE  = 5'b0010_0;

parameter SHADER0_BASE  = 3'b000;       //bits [19:17] of address bus                       
parameter THREAD3_BASE  = 5'b0001_1;    //bits [19:15] of address bus                           
parameter THREAD2_BASE  = 5'b0001_0;                              
parameter THREAD1_BASE  = 5'b0000_1;                              
parameter THREAD0_BASE  = 5'b0000_0;                              

reg [31:0] slave_rddata;
reg [31:0] slave_rdaddrs_q1;

reg [15:0] THREAD_IERq;
reg [12:0] CSRq;        //{GLOBAL_INT_EN, SHADER_STEP[3:0], SHADER_BRK[3:0], SHADER_RST[3:0]} 

wire RESET;

wire [31:0] RDATA;
wire INTREQ;

wire slave_wre;
wire slave_rde;

wire [31:0] slave_wraddrs;
wire [31:0] slave_rdaddrs;

//shader3 wires
wire [31:0] rddata_shader3;
wire tr15_done;
wire tr14_done;
wire tr13_done;
wire tr12_done;
wire step_shader3;
wire break_shader3;
wire reset_shader3;

//shader2 wires
wire [31:0] rddata_shader2;
wire tr8_inten;
wire tr11_done;
wire tr10_done;
wire  tr9_done;
wire  tr8_done;
wire step_shader2;
wire break_shader2;
wire reset_shader2;

//shader1 wires
wire [31:0] rddata_shader1;
wire  tr7_done;
wire  tr6_done;
wire  tr5_done;
wire  tr4_done;
wire step_shader1;
wire break_shader1;
wire reset_shader1;

//shader0 wires
wire [31:0] rddata_shader0;
wire tr3_done;
wire tr2_done;
wire tr1_done;
wire tr0_done;
wire step_shader0;
wire break_shader0;
wire reset_shader0;

wire [31:0] THREAD_IER;  //thread interrupt enable/status register

wire [31:0] CSR;    //control status register

wire INT_EN;  //global interrupt enable

assign INT_EN        = CSRq[12];  //global interrupt enable
assign step_shader3  = CSRq[11];
assign step_shader2  = CSRq[10];
assign step_shader1  = CSRq[9];
assign step_shader0  = CSRq[8];
assign break_shader3 = CSRq[7];
assign break_shader2 = CSRq[6];
assign break_shader1 = CSRq[5];
assign break_shader0 = CSRq[4];
assign reset_shader3 = CSRq[3];
assign reset_shader2 = CSRq[2];
assign reset_shader1 = CSRq[1];
assign reset_shader0 = CSRq[0];

assign CSR = {
              4'b0000, 
              4'b0000, 
              4'b0000, 
              4'b0000, 
              3'b000,
              INT_EN,  //global interrupt enable
              step_shader3,
              step_shader2,
              step_shader1,
              step_shader0,
              break_shader3,
              break_shader2,
              break_shader1,
              break_shader0,
              reset_shader3,
              reset_shader2,
              reset_shader1,
              reset_shader0
             };

assign THREAD_IER = {
                     tr15_done,  //msb
                     tr14_done,
                     tr13_done,
                     tr12_done,
                     tr11_done,
                     tr10_done,
                      tr9_done,
                      tr8_done,
                      tr7_done,
                      tr6_done,
                      tr5_done,
                      tr4_done,
                      tr3_done,
                      tr2_done,
                      tr1_done,
                      tr0_done,
                      THREAD_IERq[15],
                      THREAD_IERq[14],
                      THREAD_IERq[13],
                      THREAD_IERq[12],
                      THREAD_IERq[11],
                      THREAD_IERq[10],
                      THREAD_IERq[9] , 
                      THREAD_IERq[8] , 
                      THREAD_IERq[7] , 
                      THREAD_IERq[6] , 
                      THREAD_IERq[5] , 
                      THREAD_IERq[4] , 
                      THREAD_IERq[3] , 
                      THREAD_IERq[2] , 
                      THREAD_IERq[1] , 
                      THREAD_IERq[0]  
                      };       
                               
assign RDATA = slave_rddata;
              
assign RESET = ~ARESETn;

assign INTREQ = (
                 ( THREAD_IERq[15] & tr15_done)  | 
                 ( THREAD_IERq[14] & tr14_done)  | 
                 ( THREAD_IERq[13] & tr13_done)  | 
                 ( THREAD_IERq[12] & tr12_done)  | 
                 ( THREAD_IERq[11] & tr11_done)  | 
                 ( THREAD_IERq[10] & tr10_done)  | 
                 ( THREAD_IERq[9]  &  tr9_done)  | 
                 ( THREAD_IERq[8]  &  tr8_done)  | 
                 ( THREAD_IERq[7]  &  tr7_done)  | 
                 ( THREAD_IERq[6]  &  tr6_done)  | 
                 ( THREAD_IERq[5]  &  tr5_done)  | 
                 ( THREAD_IERq[4]  &  tr4_done)  | 
                 ( THREAD_IERq[3]  &  tr3_done)  | 
                 ( THREAD_IERq[2]  &  tr2_done)  |
                 ( THREAD_IERq[1]  &  tr1_done)  | 
                 ( THREAD_IERq[0]  &  tr0_done)) & 
                 INT_EN;

axi4_slave_if axi4_slave(
    .ACLK   (ACLK   ),
    .ARESETn(ARESETn),   //active low
    
    .AWID   (AWID   ),
    .AWADDR (AWADDR ),
    .AWLEN  (AWLEN  ),
    .AWSIZE (AWSIZE ),
    .AWBURST(AWBURST),
    .AWLOCK (AWLOCK ),
    .AWCACHE(AWCACHE),
    .AWPROT (AWPROT ),
    .AWVALID(AWVALID),
    .AWREADY(AWREADY),
    
    .WID    (WID    ),
    .WLAST  (WLAST  ),
    .WVALID (WVALID ),
    .WREADY (WREADY ),
    
    .BID    (BID    ),
    .BRESP  (BRESP  ),
    .BVALID (BVALID ),
    .BREADY (BREADY ),
    
    .ARID   (ARID   ),
    .ARADDR (ARADDR ),
    .ARLEN  (ARLEN  ),
    .ARSIZE (ARSIZE ), 
    .ARBURST(ARBURST),
    .ARLOCK (ARLOCK ),
    .ARCACHE(ARCACHE),
    .ARPROT (ARPROT ),
    .ARVALID(ARVALID),
    .ARREADY(ARREADY),
    
    .RID    (RID    ),
    .RRESP  (RRESP  ),
    .RLAST  (RLAST  ),
    .RVALID (RVALID ),
    .RREADY (RREADY ),
    
    .base_addrs    (BASE_ADDRS),      //strapped upper 12-bit base address
    .awprot_mode   (AWPROT_mode),     //strapped 3-bit AWPROT_mode
    .arprot_mode   (ARPROT_mode),     //strapped 3-bit ARPROT_mode
    
    .slave_wraddrs (slave_wraddrs),
    .slave_wre     (slave_wre),

    .slave_rdaddrs (slave_rdaddrs),
    .slave_rde     (slave_rde)    
    );
/* 
shader #(.PKT_RAM_ADDRS_WIDTH(8). IRB_RAM_ADDRS_WIDTH(10))
    shader3(
    .CLK        (ACLK            ),
    .RESET      (reset_shader3   ),
    .dma_wre    (slave_wre),  
    .dma_wraddrs(slave_wraddrs   ),
    .dma_wrdata (WDATA           ),
    .dma_rde    (slave_rde),
    .dma_rdaddrs(slave_rdaddrs   ),
    .dma_rddata (rddata_shader3  ),
    .tr3_done   (tr15_done       ),
    .tr2_done   (tr14_done       ),
    .tr1_done   (tr13_done       ),
    .tr0_done   (tr12_done       )
    .ROM_BASE   ({BASE_ADDRS, ROM3_BASE}),
    .RAM_BASE   ({BASE_ADDRS, SHADER3_BASE}),
    .IRB_BASE   ({BASE_ADDRS, IRB3_BASE})
    );
*/

    assign rddata_shader3 = 32'h0000_0000;    
    assign tr15_done = 1'b0;
    assign tr14_done = 1'b0;
    assign tr13_done = 1'b0;
    assign tr12_done = 1'b0;

/*
shader #(.PKT_RAM_ADDRS_WIDTH(8). IRB_RAM_ADDRS_WIDTH(10))
    shader2(
    .CLK        (ACLK            ),
    .RESET      (reset_shader2   ),
    .dma_wre    (slave_wre),  
    .dma_wraddrs(slave_wraddrs   ),
    .dma_wrdata (WDATA           ),
    .dma_rde    (slave_rde),
    .dma_rdaddrs(slave_rdaddrs   ),
    .dma_rddata (rddata_shader2  ),
    .tr3_done   (tr11_done       ),
    .tr2_done   (tr10_done       ),
    .tr1_done   (tr9_done        ),
    .tr0_done   (tr8_done        )
    .ROM_BASE   ({BASE_ADDRS, ROM2_BASE}),
    .RAM_BASE   ({BASE_ADDRS, SHADER2_BASE}),
    .IRB_BASE   ({BASE_ADDRS, IRB2_BASE})
    );
    */

    assign rddata_shader2 = 32'h0000_0000;    
    assign tr11_done = 1'b0;
    assign tr10_done = 1'b0;
    assign tr9_done  = 1'b0;
    assign tr8_done  = 1'b0;


/*
shader #(.PKT_RAM_ADDRS_WIDTH(8). IRB_RAM_ADDRS_WIDTH(10))
    shader1(
    .CLK        (ACLK            ),
    .RESET      (reset_shader1   ),
    .dma_wre    (slave_wre),  
    .dma_wraddrs(slave_wraddrs   ),
    .dma_wrdata (WDATA           ),
    .dma_rde    (slave_rde),
    .dma_rdaddrs(slave_rdaddrs   ),
    .dma_rddata (rddata_shader1  ),
    .tr3_done   (tr7_done        ),
    .tr2_done   (tr6_done        ),
    .tr1_done   (tr5_done        ),
    .tr0_done   (tr4_done        )
    .ROM_BASE   ({BASE_ADDRS, ROM1_BASE}),
    .RAM_BASE   ({BASE_ADDRS, SHADER1_BASE}),
    .IRB_BASE   ({BASE_ADDRS, IRB1_BASE})
    );
*/

    assign rddata_shader1 = 32'h0000_0000;    
    assign tr7_done = 1'b0;
    assign tr6_done = 1'b0;
    assign tr5_done = 1'b0;
    assign tr4_done = 1'b0;



shader #(.PKT_RAM_ADDRS_WIDTH(8), .IRB_RAM_ADDRS_WIDTH(10))
    shader0(
    .CLK        (ACLK            ),
    .RESET      (reset_shader0   ),
    .dma_wre    (slave_wre),  
    .dma_wraddrs(slave_wraddrs   ),
    .dma_wrdata (WDATA           ),
    .dma_rde    (slave_rde),
    .dma_rdaddrs(slave_rdaddrs   ),
    .dma_rddata (rddata_shader0  ),
    .tr3_done   (tr3_done        ),
    .tr2_done   (tr2_done        ),
    .tr1_done   (tr1_done        ),
    .tr0_done   (tr0_done        ),
    .ROM_BASE   ({BASE_ADDRS, ROM0_BASE}),
    .RAM_BASE   ({BASE_ADDRS, SHADER0_BASE}),
    .IRB_BASE   ({BASE_ADDRS, IRB0_BASE})
    );
/*
    assign rddata_shader0 = 32'h0000_0000;    
    assign tr3_done = 1'b0;
    assign tr2_done = 1'b0;
    assign tr1_done = 1'b0;
    assign tr0_done = 1'b0;
*/


always @(posedge ACLK or posedge RESET) begin
    if (RESET) slave_rdaddrs_q1 <= 32'h0000_0000;
    else if (slave_rde) slave_rdaddrs_q1 <= slave_rdaddrs;
end 
    
// AXI4 read data select    
always @(*) begin
    casex (slave_rdaddrs_q1)
                                                32'hFFFF_0004 : slave_rddata = CSR;
                                                32'hFFFF_0000 : slave_rddata = THREAD_IER;
/*_    
                  32'b1111_1111_1111_1010_11xx_xxxx_xxxx_xxxx,  //this address gets access to shader3 IRB 
                  32'b1111_1111_1111_011x_xxxx_xxxx_xxxx_xxxx : slave_rddata = rddata_shader3; 
                  32'b1111_1111_1111_1010_10xx_xxxx_xxxx_xxxx,  //this address gets access to shader2 IRB 
                  32'b1111_1111_1111_010x_xxxx_xxxx_xxxx_xxxx : slave_rddata = rddata_shader2; 
                  32'b1111_1111_1111_1010_01xx_xxxx_xxxx_xxxx,  //this address gets access to shader1 IRB 
                  32'b1111_1111_1111_001x_xxxx_xxxx_xxxx_xxxx : slave_rddata = rddata_shader1; 
*/
                  32'b1111_1111_1111_1010_00xx_xxxx_xxxx_xxxx,  //this address gets access to shader0 IRB 
                  32'b1111_1111_1111_000x_xxxx_xxxx_xxxx_xxxx : slave_rddata = rddata_shader0; 
                                                      default : slave_rddata = 32'h0000_0000;
    endcase 
end  
    
always @(posedge ACLK or posedge RESET) begin
    if (RESET) CSRq <= 13'h000F;
    else if (slave_wre && (slave_wraddrs[31:0] == {BASE_ADDRS, CSRq_BASE})) CSRq <= WDATA[12:0];
end

always @(posedge ACLK or posedge RESET) begin
    if (RESET) THREAD_IERq <= 16'h0000;
    else if (slave_wre && (slave_wraddrs[31:0] == {BASE_ADDRS, THREAD_IER_BASE})) THREAD_IERq <= WDATA[15:0];
end
    
endmodule
