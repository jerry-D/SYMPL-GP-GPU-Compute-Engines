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

module SYMPL_CPU (
    CLK,
    RESET,
    CPU_done
    );
    
input CLK;
input RESET;
output CPU_done;

reg gpu_datapool_sel;

wire [19:0] PC;
wire [31:0] instr;
wire [31:0] cpu_rdtabl_data;
wire rdprog;
wire [23:0] srcA;
wire [23:0] srcB;
wire [23:0] dest_q2;
wire [19:0] pre_PC;
wire [31:0] upper_rddataA;  
wire [31:0] tpRAM_1_rddataA;
wire [31:0] tpRAM_1_rddataB;
wire [31:0] resultout;      
wire rdsrcA;         
wire rdsrcB;         
wire rdconstA;       
wire wrcycl;         
wire CLK;            
wire RESET_IN;       
wire CPU_done;       
wire [1:0] dsize;          

wire DMA0wren;       
wire [23:0] DMA0wraddrs;    
wire DMA0rden;       
wire [23:0] DMA0rdaddrs;    
wire DMA0collide;    
wire DMA0_IRQ;       

wire GPU3_RESET;     
wire GPU2_RESET;     
wire GPU1_RESET;     
wire GPU0_RESET; 

wire [3:0] GPU_RESET;    

wire [15:0] IRQ_in;

wire [31:0] gpu_rddataA;
wire [3:0] GPU_done;

assign IRQ_in = {12'h000, GPU_done};
assign upper_rddataA = gpu_datapool_sel ? gpu_rddataA : cpu_rdtabl_data; 
assign GPU_RESET = {GPU3_RESET, GPU2_RESET, GPU1_RESET, GPU0_RESET};
assign DMA0collide = 1'b0;

CPU cpu(
         .PC              (PC              ),
         .P_DATAi         (instr           ),
         .PRAM_rddataA    (upper_rddataA   ),     
         .rdprog          (rdprog          ),
         .srcA            (srcA            ),
         .srcB            (srcB            ),
         .dest_q2         (dest_q2         ), 
         .pre_PC          (pre_PC          ),        
         .tpRAM_1_rddataA (tpRAM_1_rddataA ),  
         .tpRAM_1_rddataB (tpRAM_1_rddataB ),
         .resultout       (resultout       ),
         .rdsrcA          (rdsrcA          ),
         .rdsrcB          (rdsrcB          ),
         .rdconstA        (rdconstA        ),         
         .wrcycl          (wrcycl          ),
         .CLK             (CLK             ),
         .RESET_IN        (RESET           ),
         .CPU_done        (CPU_done        ),
         .dsize           (dsize           ),
         
         .DMA0wren        (DMA0wren        ),
         .DMA0wraddrs     (DMA0wraddrs     ),
         .DMA0rden        (DMA0rden        ),
         .DMA0rdaddrs     (DMA0rdaddrs     ),
         .DMA0collide     (DMA0collide     ),
         .DMA0_IRQ        (DMA0_IRQ        ),
         
         .GPU3_RESET      (GPU3_RESET      ),         
         .GPU2_RESET      (GPU2_RESET      ),         
         .GPU1_RESET      (GPU1_RESET      ),         
         .GPU0_RESET      (GPU0_RESET      ),
         
         .IRQ_in          (IRQ_in          ),
         
         .SWBRKdet        (        ),
         .byte_swap       (        )
         );
    
cpuROM #(.ADDRS_WIDTH(12), .DATA_WIDTH(32))
    rom4096_cpu(      //program memory for cgs
    .CLK       (CLK           ),
//    .wren      (rom_wren ? 1'b1 : DMA0_rom_wren),
//    .wraddrs   (rom_wren ? dest_q2[11:0] : DMA0wraddrs[11:0]),
//    .wrdata    (rom_wren ? resultout : DMA0_datapool_rddata),
    .wren      (wrcycl & (dest_q2[23:22]==2'b10)),
    .wraddrs   (dest_q2[11:0]),
    .wrdata    (resultout     ),
    .rdenA     (rdprog        ),
    .rdaddrsA  (pre_PC[11:0]  ),
    .rddataA   (instr         ),
    .rdenB     (rdconstA | (srcA[23:22]==2'b10)),  //table-read program memory mapped at upper half of data memory
    .rdaddrsB  (srcA[11:0]    ),
    .rddataB   (cpu_rdtabl_data)
    );        


RAM_tp_byte RAM_0_32kbytes(
    .CLK     (CLK    ),
    .RESET   (RESET  ),
    .dsize   (dsize  ),
    .wren    (wrcycl & (dest_q2[23:15]==9'b0000_0000_1)),    //8th 32k bytes (8th 8k-word block)
    .wraddrs (dest_q2[14:0]),
    .wrdata  (resultout     ),
    .rdenA   (rdsrcA & (srcA[23:15]==9'b0000_0000_1)),
    .rdaddrsA(srcA[14:0]   ),
    .rddataA (tpRAM_1_rddataA),
    .rdenB   (rdsrcB & (srcB[23:15]==9'b0000_0000_1)),
    .rdaddrsB(srcB[14:0]   ),
    .rddataB (tpRAM_1_rddataB)
    );   

    
_1_shader  gpu0(   // one-shader GPU (4 interleaving threads)
//_2_shader  gpu0(   // two-shader GPU (8 interleaving threads)
//_4_shader  gpu0(   // four-shader GPU (16 interleaving threads)
//_8_shader  gpu0(    // eight-shader GPU (32 interleaving threads)
//_16_shader gpu0(    // sixteen-shader GPU (64 interleaving threads)
    .CLKA    (CLK   ),   //CPU-side clock
    .CLKB    (CLK   ),   //GPU-side clock
    .RESET   (GPU_RESET),
    .WREN    (wrcycl & (dest_q2[23:18]==6'b1111_11)),
    .WRADDRS (dest_q2[17:0]),
    .WRDATA  (resultout),
    .RDEN    (rdsrcA & (srcA[23:18]==6'b1111_11)),
    .RDADDRS (srcA[17:0]),
    .RDDATA  (gpu_rddataA),
    .DONE    (GPU_done)
    );


//assign gpu_rddataA = 32'h0000_0000;
//assign GPU_done = 4'b0000;
    
always @(posedge CLK or posedge RESET)
    if (RESET) gpu_datapool_sel <= 1'b0;    
    else if (rdsrcA & (srcA[23:18]==6'b1111_11)) gpu_datapool_sel <= 1'b1;
    else gpu_datapool_sel <= 1'b0;             
         
endmodule
