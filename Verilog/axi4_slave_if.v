 `timescale 1ns/100ps 
 // AXI4 burst-mode wrapper for SYMPL FP32X core
 // For use with SYMPL FP32X-AXI4 multi-thread RISC only
 // Author:  Jerry D. Harthcock
 // Version:  1.01   August 27, 2015
 // June 29, 2015
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

module axi4_slave_if (
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
    RRESP,
    RLAST,
    RVALID,
    RREADY,
    
    BASE,     //strapped upper 13-bit base address
    awprot_mode,    //strapped 3-bit AWPROT_mode
    arprot_mode,    //strapped 3-bit ARPROT_mode
    
    slave_wraddrs,
    slave_wre,

    slave_rdaddrs,
    slave_rde    
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
input  WLAST;                                 
input  WVALID;                                
output WREADY;                                
                                              
output [3:0] BID;                             
output [1:0] BRESP;                           
output BVALID;                                
input  BREADY;                               
                                              
input [3:0] ARID;                             
input [31:0] ARADDR;                          
input [3:0] ARLEN;                           
input [2:0] ARSIZE;                           
input [1:0] ARBURST;                          
input [1:0] ARLOCK;                           
input [3:0] ARCACHE;                          
input [2:0] ARPROT;                           
input ARVALID;                                
output ARREADY;                               
                                              
output [3:0] RID;                            
output [1:0] RRESP;                           
output RLAST;                                 
output RVALID;                                
input RREADY;                                

//
// these signals go to/from the target circuit         
//
input [31:17] BASE;
input [2:0] awprot_mode;
input [2:0] arprot_mode;

output [31:0] slave_wraddrs;
output slave_wre;

output [31:0] slave_rdaddrs;
output slave_rde;

parameter OKAY = 2'b00;
parameter EXOKAY = 2'b01;
parameter SLVERR = 2'b10;
parameter DECERR = 2'b11;

reg [31:0] slave_wraddrs;
reg [31:0] slave_rdaddrs;
reg [3:0] AWID_save;
reg wr_state;
reg [3:0] ARID_save;
reg rd_state;
reg slave_wreq;
reg slave_rde;
reg [3:0] rd_count;

reg RVALID;
reg BVALID;
reg [1:0] BRESP;
reg [3:0] BID;
reg [1:0] RRESP;
reg [3:0] RID;
reg RLAST;

wire slave_wre;

wire slave_CSRwr_sel;
wire slave_CSRrd_sel;

wire slave_INT_ENwr_sel;
wire slave_INT_ENrd_sel;

wire slave_global_IRBwr_sel;
wire slave_global_IRBrd_sel;

wire slave_global_romwr_sel;
 
wire slave_cr0_romrd_sel;
wire slave_cr0_romwr_sel;
wire slave_cr1_romrd_sel;
wire slave_cr1_romwr_sel;
wire slave_cr2_romrd_sel;
wire slave_cr2_romwr_sel;
wire slave_cr3_romrd_sel;
wire slave_cr3_romwr_sel;

wire slave_cr0_thread0wr_sel;
wire slave_cr0_thread0rd_sel;
wire slave_cr0_thread1wr_sel;
wire slave_cr0_thread1rd_sel;
wire slave_cr0_thread2wr_sel;
wire slave_cr0_thread2rd_sel;
wire slave_cr0_thread3wr_sel;
wire slave_cr0_thread3rd_sel;
 
wire RESET;
wire CLK;
wire AWREADY;
wire WREADY;

wire AXI4_slave_base_rd_sel;
wire AXI4_slave_base_wr_sel;


assign slave_wre = slave_wreq & WVALID;

assign AXI4_slave_base_wr_sel = (AWADDR[31:17]==BASE) & AWVALID & (AWPROT==awprot_mode);
assign AXI4_slave_base_rd_sel = (ARADDR[31:17]==BASE) & ARVALID & (ARPROT==arprot_mode);

assign CLK = ACLK;
assign RESET = ~ARESETn;
assign WREADY = slave_wre & WVALID;

assign slave_CSRwr_sel = AXI4_slave_base_wr_sel & (AWADDR[16:0]==17'h1_FFFC);  // 0xnnnbbb1_FFFF
assign slave_CSRrd_sel = AXI4_slave_base_rd_sel & (ARADDR[16:0]==17'h1_FFFC);
 
assign slave_cr0_romwr_sel = AXI4_slave_base_wr_sel & (AWADDR[16:15]==4'b10);  // 0xnnnbbb1_7FFC - 0xnnnbbb1_0000
assign slave_cr0_romrd_sel = AXI4_slave_base_rd_sel & (ARADDR[16:15]==4'b10);  

assign slave_global_IRBwr_sel = AXI4_slave_base_wr_sel & (AWADDR[16:15]==2'b01);  // 0xnnnbbb0_FFFC - 0xnnnbbb0_8000
assign slave_global_IRBrd_sel = AXI4_slave_base_rd_sel & (AWADDR[16:15]==2'b01);  

assign slave_cr0_thread3wr_sel = AXI4_slave_base_wr_sel & (AWADDR[16:13]==4'b0011);  // 0xnnnbbb0_7FFC - 0xnnnbbb0_6000
assign slave_cr0_thread3rd_sel = AXI4_slave_base_rd_sel & (ARADDR[16:13]==4'b0011);  
assign slave_cr0_thread2wr_sel = AXI4_slave_base_wr_sel & (AWADDR[16:13]==4'b0010);  // 0xnnnbbb0_5FFC - 0xnnnbbb0_4000
assign slave_cr0_thread2rd_sel = AXI4_slave_base_rd_sel & (ARADDR[16:13]==4'b0010);  
assign slave_cr0_thread1wr_sel = AXI4_slave_base_wr_sel & (AWADDR[16:13]==4'b0001);  // 0xnnnbbb0_3FFC - 0xnnnbbb0_2000
assign slave_cr0_thread1rd_sel = AXI4_slave_base_rd_sel & (ARADDR[16:13]==4'b0001);  
assign slave_cr0_thread0wr_sel = AXI4_slave_base_wr_sel & (AWADDR[16:13]==4'b0000);  // 0xnnnbbb0_1FFC - 0xnnnbbb0_0000
assign slave_cr0_thread0rd_sel = AXI4_slave_base_rd_sel & (ARADDR[16:13]==4'b0000);  

assign AWREADY = slave_CSRwr_sel         |
                 
                 slave_cr0_romwr_sel     |
                                  
                 slave_global_IRBwr_sel  |
                 
                 slave_cr0_thread0wr_sel |          
                 slave_cr0_thread1wr_sel |          
                 slave_cr0_thread2wr_sel |          
                 slave_cr0_thread3wr_sel           
                 ;

assign ARREADY = slave_CSRrd_sel         |

                 slave_cr0_romrd_sel     |          

                 slave_global_IRBrd_sel  |
                 
                 slave_cr0_thread0rd_sel |          
                 slave_cr0_thread1rd_sel |          
                 slave_cr0_thread2rd_sel |          
                 slave_cr0_thread3rd_sel           
                 ;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        slave_wraddrs <= 32'h0000_0000;
        slave_wreq <= 1'b0;
        wr_state <= 1'b0;
        AWID_save <= 4'h0;
        BVALID <= 1'b0;
        BRESP <= 2'b00;
        BID <= 4'h0;
    end
    else begin
       case (wr_state)
           1'b0 : begin
                       BID <= AWID_save ^ 4'b1111;
                       BRESP <= SLVERR;
                       BVALID <= 1'b0;
           
                       if (AWVALID) begin
                           slave_wraddrs <= AWADDR[31:0];  //all data are 32-bit (double-word) and must be aligned as such
                           slave_wreq <= 1'b1;  
                           AWID_save <= AWID;
                           wr_state <= 1'b1;
                       end
                   end
           1'b1 : begin
                      if ((WID==AWID_save) && WVALID && ~WLAST) begin
                          slave_wraddrs <= slave_wraddrs + 3'h4;
                      end    
                      else if ((WID==AWID_save) && WVALID && WLAST && BREADY) begin
                         slave_wreq <= 1'b0;
                         BID <= AWID_save;
                         BRESP <= OKAY;
                         BVALID <= 1'b1;
                         wr_state <= 1'b0;
                      end
                  end
       endcase                       
    end
end                                
                            

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        slave_rdaddrs <= 32'h0000_0000;
        slave_rde <= 1'b0;
        rd_state <= 1'b0;
        ARID_save <= 4'h0;
        RVALID <= 1'b0;
        RRESP <= 2'b00;
        RID <= 4'h0;
        rd_count <= 4'h0;
        RVALID <= 1'b0;
        RLAST <= 1'b0;
    end
    else begin
       case (rd_state)
           1'b0 : begin
                       RID <= ARID_save ^ 4'b1111;
                       RRESP <= SLVERR;
                       RVALID <= 1'b0;
                       RLAST <= 1'b0;
           
                       if (ARVALID) begin
                           slave_rdaddrs <= ARADDR[31:0];  //all data are 32-bit (double-word) and must be aligned as such
                           slave_rde <= 1'b1;  
                           ARID_save <= ARID;
                           rd_count <= ARLEN;
                           rd_state <= 1'b1;
                       end
                   end
           1'b1 : begin    //assert RVALID simultaneously with the availability of first read data
                       RVALID <= 1'b1;
                       RID <= ARID_save;
                       if (RREADY && ~(rd_count==4'b0000)) begin
                          slave_rdaddrs <= slave_rdaddrs + 3'h4;
                          rd_count <= rd_count - 1'b1;
                       end    
                       else if (RREADY  && (rd_count==4'b0000)) begin
                          slave_rde <= 1'b0;
                          RRESP <= OKAY;
                          RLAST <= 1'b1;
                          rd_count <= 4'h0;
                          rd_state <= 1'b0;
                       end
                   end
       endcase                       
    end
end                                

endmodule
