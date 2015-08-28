 // fp321_axi.v  top-level single-core multi-thread processor with AXI4 burst-mode slave DMA interface
 `timescale 1ns/100ps
 // SYMPL FP324-AXI4 top level RTL
 // SYMPL FP324-AXI4 multi-thread, multi-processing core
 // Author:  Jerry D. Harthcock
 // Version:  1.102
 // August 27, 2015
 // Copyright (C) 2015.  All rights reserved without prejudice.
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


module fp321_axi (
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
    
    INTREQ,
    
    BASE,
    AWPROT_mode,
    ARPROT_mode
    );
            
input  ACLK;                                  
input  ARESETn;                   
                                              
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

input [31:17] BASE;     //shader base address with granularity of 128k bytes (32k double-words)
input [2:0] AWPROT_mode;
input [2:0] ARPROT_mode;

parameter CSRq_BASE = 15'b1_1111_1111_1111_11; // bits [16:2] of address bus, CSRq is control/status register
parameter ROM_BASE  = 15'b1_0xxx_xxxx_xxxx_xx; // bits [16:2] of address bus
parameter IRB_BASE  = 15'b0_1xxx_xxxx_xxxx_xx; // (up to) 32k byte (8k double-word) intermediate result result buffer
parameter tr3_BASE  = 15'b0_011x_xxxx_xxxx_xx; // thread 3 parameter/data buffer (up to) 8k bytes (2k double-words)
parameter tr2_BASE  = 15'b0_010x_xxxx_xxxx_xx; // thread 2 parameter/data buffer (up to) 8k bytes (2k double-words)
parameter tr1_BASE  = 15'b0_001x_xxxx_xxxx_xx; // thread 1 parameter/data buffer (up to) 8k bytes (2k double-words)   
parameter tr0_BASE  = 15'b0_000x_xxxx_xxxx_xx; // thread 0 parameter/data buffer (up to) 8k bytes (2k double-words)

reg [16:2] slave_rdaddrs_q1;
reg [31:17] base_q1;
reg [31:0] RDATA;
reg [7:0] CSRq;        //{GLOBAL_INT_EN, SHADER_STEP[3:0], SHADER_BRK[3:0], SHADER_RST[3:0]} 

wire RESET;
wire INTREQ;

wire slave_wre;
wire slave_rde;

wire [31:0] slave_wraddrs;
wire [31:0] slave_rdaddrs;

//shader0 wires
wire [31:0] rddata_shader0;
wire tr3_done;
wire tr2_done;
wire tr1_done;
wire tr0_done;
wire tr3_int_en;
wire tr2_int_en;
wire tr1_int_en;
wire tr0_int_en;
wire INT_EN;  //global interrupt enablewire step_shader0;
wire break_shader0;
wire reset_shader0;

wire [31:0] CSR;    //control status register

assign tr3_int_en = CSRq[7];
assign tr2_int_en = CSRq[6];
assign tr1_int_en = CSRq[5];
assign tr0_int_en = CSRq[4];
assign INT_EN        = CSRq[3];  //global interrupt enable
assign step_shader0  = CSRq[2];
assign break_shader0 = CSRq[1];
assign reset_shader0 = CSRq[0];

assign CSR = {20'h0000_0,
              tr3_done,
              tr2_done,
              tr1_done,
              tr0_done,
              tr3_int_en,
              tr2_int_en,
              tr1_int_en,
              tr0_int_en,
              INT_EN,  //global interrupt enable
              step_shader0,
              break_shader0,
              reset_shader0
             };    
                                           
assign RESET = ~ARESETn;

assign INTREQ = (( tr3_int_en  &  tr3_done)  | 
                 ( tr2_int_en  &  tr2_done)  |
                 ( tr1_int_en  &  tr1_done)  | 
                 ( tr0_int_en  &  tr0_done)) & 
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
    
    .BASE   (BASE   ),      //strapped upper 15-bit base address
    .awprot_mode   (AWPROT_mode),     //strapped 3-bit AWPROT_mode
    .arprot_mode   (ARPROT_mode),     //strapped 3-bit ARPROT_mode
    
    .slave_wraddrs (slave_wraddrs),
    .slave_wre     (slave_wre),

    .slave_rdaddrs (slave_rdaddrs),
    .slave_rde     (slave_rde)    
    );

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
    .BASE       (BASE            )
    );


always @(posedge ACLK or posedge RESET) begin
    if (RESET) begin
        slave_rdaddrs_q1 <= 15'b0_0000_0000_0000_00;
        base_q1 <= 15'b0000_0000_0000_000;
    end    
    else if (slave_rde) begin
        slave_rdaddrs_q1 <= slave_rdaddrs[16:2];
        base_q1 <= slave_rdaddrs[31:17];
    end    
end 
    
// AXI4 read data select    
always @(*) begin
    if (base_q1==BASE)
    casex (slave_rdaddrs_q1)
        CSRq_BASE : RDATA = CSR;
        ROM_BASE, 
        IRB_BASE, 
        tr3_BASE, 
        tr2_BASE, 
        tr1_BASE, 
        tr0_BASE  : RDATA = rddata_shader0;
        default   : RDATA = 32'h0000_0000; 
    endcase
    else RDATA = 32'h0000_0000;
 end   
   
always @(posedge ACLK or posedge RESET) begin
    if (RESET) CSRq <= 12'h001; // initialize with shader reset active
    else if (slave_wre && (slave_wraddrs[31:2] == {BASE, CSRq_BASE})) CSRq <= WDATA[7:0];
end
    
endmodule
