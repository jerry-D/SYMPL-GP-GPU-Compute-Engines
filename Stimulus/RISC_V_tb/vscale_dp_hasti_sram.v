//Copyright (c) 2015-2015, The Regents of the University of California
//(Regents).  All Rights Reserved.
//
//Redistribution and use in source and binary forms, with or without
//modification, are permitted provided that the following conditions are met:
//1. Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//2. Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//3. Neither the name of the Regents nor the
//   names of its contributors may be used to endorse or promote products
//   derived from this software without specific prior written permission.
//
//IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
//SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING
//OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF REGENTS HAS
//BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//REGENTS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
//THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
//PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED
//HEREUNDER IS PROVIDED "AS IS". REGENTS HAS NO OBLIGATION TO PROVIDE
//MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.


`include "vscale_hasti_constants.vh"

module vscale_dp_hasti_sram(
                            input                          hclk,
                            input                          hresetn,
                            input [`HASTI_ADDR_WIDTH-1:0]  p0_haddr,
                            input                          p0_hwrite,
                            input [`HASTI_SIZE_WIDTH-1:0]  p0_hsize,
                            input [`HASTI_BURST_WIDTH-1:0] p0_hburst,
                            input                          p0_hmastlock,
                            input [`HASTI_PROT_WIDTH-1:0]  p0_hprot,
                            input [`HASTI_TRANS_WIDTH-1:0] p0_htrans,
                            input [`HASTI_BUS_WIDTH-1:0]   p0_hwdata,
                            output [`HASTI_BUS_WIDTH-1:0]  p0_hrdata,
                            output                         p0_hready,
                            output                         p0_hresp,
                            input [`HASTI_ADDR_WIDTH-1:0]  p1_haddr,
                            input                          p1_hwrite,
                            input [`HASTI_SIZE_WIDTH-1:0]  p1_hsize,
                            input [`HASTI_BURST_WIDTH-1:0] p1_hburst,
                            input                          p1_hmastlock,
                            input [`HASTI_PROT_WIDTH-1:0]  p1_hprot,
                            input [`HASTI_TRANS_WIDTH-1:0] p1_htrans,
                            input [`HASTI_BUS_WIDTH-1:0]   p1_hwdata,
                            output [`HASTI_BUS_WIDTH-1:0]  p1_hrdata,
                            output                         p1_hready,
                            output                         p1_hresp
                            );

   parameter nwords = 65536;

   localparam s_w1 = 0;
   localparam s_w2 = 1;

   reg [`HASTI_BUS_WIDTH-1:0]                              mem [nwords-1:0];

   // p0

   // flops
   reg [`HASTI_ADDR_WIDTH-1:0]                             p0_waddr;
   reg [`HASTI_BUS_WIDTH-1:0]                              p0_wdata;
   reg                                                     p0_wvalid;
   reg [`HASTI_SIZE_WIDTH-1:0]                             p0_wsize;
   reg                                                     p0_state;

   wire [`HASTI_BUS_NBYTES-1:0]                            p0_wmask_lut = (p0_wsize == 0) ? `HASTI_BUS_NBYTES'h1 : (p0_wsize == 1) ? `HASTI_BUS_NBYTES'h3 : `HASTI_BUS_NBYTES'hf;
   wire [`HASTI_BUS_NBYTES-1:0]                            p0_wmask_shift = p0_wmask_lut << p0_waddr[1:0];
   wire [`HASTI_BUS_WIDTH-1:0]                             p0_wmask = {{8{p0_wmask_shift[3]}},{8{p0_wmask_shift[2]}},{8{p0_wmask_shift[1]}},{8{p0_wmask_shift[0]}}};
   wire [`HASTI_ADDR_WIDTH-1:0]                            p0_word_waddr = p0_waddr >> 2;

   wire [`HASTI_ADDR_WIDTH-1:0]                            p0_raddr = p0_haddr >> 2;
   wire                                                    p0_ren = (p0_htrans == `HASTI_TRANS_NONSEQ && !p0_hwrite);
   reg                                                     p0_bypass;
   reg [`HASTI_ADDR_WIDTH-1:0]                             p0_reg_raddr;


   //-----------------------------------------------------------------------------------------------------------------------------  
   //         SYMPL GP-GPU, from the outside looking in, looks like an ordinary 64k x 32 sync SRAM to RISC-V 
   //         Single (4 threads), double (8 threads), and quad-shader (16 threads) versions have identical 64k x 32 SRAM footprint
   //         Instantiate one of the three GP-GPUs given below like you would an ordinary 64k x 32 block SRAM
   //         Each shader can provide 1 FLOP per clock or 125 MFLOPs @125 MHz (single-shader)
   //         Thus, a quad-shader, SYMPL GP-GPU can provide 4 FLOPS per clock or 500 MFLOPS @125 MHz
   
   reg dpool_rden_q;
   
   wire [31:0] dpool_rddata;
   wire dpool_rden;
   wire dpool_wren; 
   wire gpu_done;  // can be used to generate interrupts to RISC-V 
   wire [15:0] dpool_addrs;
   
   assign dpool_rden = ~dpool_wren & (p0_haddr[31:18]==14'b0000_0000_0000_01);     
   assign dpool_wren = p0_wvalid & (p0_haddr[31:18]==14'b0000_0000_0000_01) & p0_hwrite;   
   assign dpool_addrs = dpool_wren ? p0_word_waddr : p0_raddr;
                          
//   FP3211 gp_gpu1 ( //single-shader version (4 threads)
//   FP323 gp_gpu1 (  //dual-shader version (8 threads)
   FP325 gp_gpu1 (  //quad-shader version (16 threads)
                  .CLKA   (hclk        ),  //for RISC-V side of DP SRAM
                  .CLKB   (hclk        ),  //for GPU clock and GPU side of DP SRAM (ie, clocks can run at different freq)
                  .RESET  (~hresetn    ),
                  .WREN   (dpool_wren  ),
                  .WRADDRS(dpool_addrs),
                  .WRDATA ((mem[p0_word_waddr] & ~p0_wmask) | (p0_wdata & p0_wmask)),
                  .RDEN   (dpool_rden  ),
                  .RDADDRS(dpool_addrs),
                  .RDDATA (dpool_rddata),
                  .DONE   (gpu_done    )  
                  );
  //
  //
  //-----------------------------------------------------------------------------------------------------------------------------
  
   always @(posedge hclk) begin
      p0_reg_raddr <= p0_raddr;
      if (!hresetn) begin
         p0_state <= s_w1;
         p0_wvalid <= 1'b0;
         p0_bypass <= 1'b0;
         p0_waddr <= 0;
         p0_wdata <= 0;
         p0_reg_raddr <= 0;
         dpool_rden_q <= 1'b0;   //mod by JDH Dec. 8 2015
      end else begin
         dpool_rden_q <= dpool_rden;
         if (p0_state == s_w2) begin
            p0_wdata <= p0_hwdata;
            p0_state <= s_w1;
         end
         if (p0_htrans == `HASTI_TRANS_NONSEQ) begin
            if (p0_hwrite) begin
               p0_waddr <= p0_haddr;
               p0_wsize <= p0_hsize;
               p0_wvalid <= 1'b1;
//               if (p0_wvalid) begin
               if (p0_wvalid && ~dpool_wren) begin  // mod by JDH Dec. 8, 2015
                  mem[p0_word_waddr] <= (mem[p0_word_waddr] & ~p0_wmask) | (p0_wdata & p0_wmask);
               end
               p0_state <= s_w2;
            end else begin
               p0_bypass <= p0_wvalid && p0_word_waddr == p0_raddr;
            end
         end // if (p0_htrans == `HASTI_TRANS_NONSEQ)
      end
   end

   wire [`HASTI_BUS_WIDTH-1:0] p0_rdata = mem[p0_reg_raddr];
   wire [`HASTI_BUS_WIDTH-1:0] p0_rmask = {32{p0_bypass}} & p0_wmask;
 //  assign p0_hrdata = (p0_wdata & p0_rmask) | (p0_rdata & ~p0_rmask);
   assign p0_hrdata = dpool_rden_q ? dpool_rddata : (p0_wdata & p0_rmask) | (p0_rdata & ~p0_rmask);  // mod by JDH Dec. 8 2015
   assign p0_hready = 1'b1;
   assign p0_hresp = `HASTI_RESP_OKAY;
                                
   // p1

   wire [`HASTI_ADDR_WIDTH-1:0] p1_raddr = p1_haddr >> 2;
   wire                         p1_ren = (p1_htrans == `HASTI_TRANS_NONSEQ && !p1_hwrite);
   reg                          p1_bypass;
   reg [`HASTI_ADDR_WIDTH-1:0]  p1_reg_raddr;

   always @(posedge hclk) begin
      p1_reg_raddr <= p1_raddr;
      if (!hresetn) begin
         p1_bypass <= 0;
      end else begin
         if (p1_htrans == `HASTI_TRANS_NONSEQ) begin
            if (p1_hwrite) begin
            end else begin
               p1_bypass <= p0_wvalid && p0_word_waddr == p1_raddr;
            end
         end // if (p1_htrans == `HASTI_TRANS_NONSEQ)
      end
   end

   wire [`HASTI_BUS_WIDTH-1:0] p1_rdata = mem[p1_reg_raddr];
   wire [`HASTI_BUS_WIDTH-1:0] p1_rmask = {32{p1_bypass}} & p0_wmask;
   assign p1_hrdata = (p0_wdata & p1_rmask) | (p1_rdata & ~p1_rmask);
   assign p1_hready = 1'b1;
   assign p1_hresp = `HASTI_RESP_OKAY;

endmodule // vscale_dp_hasti_sram

