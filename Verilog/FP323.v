`timescale 1ns/100ps
// Author:  Jerry D. Harthcock
// Version:  1.02  January 18, 2016
// Copyright (C) 2016.  All rights reserved.
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

module FP323 (
    CLKA,
    CLKB,
    RESET,
    WREN,
    WRADDRS,
    WRDATA,
    RDEN,
    RDADDRS,
    RDDATA,
    DONE
    );       

input CLKA;
input CLKB;
input RESET;
input WREN;
input [15:0] WRADDRS;
input [31:0] WRDATA;
input RDEN;
input [15:0] RDADDRS;
output [31:0] RDDATA;
output DONE;

reg [31:0] cgs_rddataA;
reg [31:0] DMA1wrdata;
reg [31:0] command;  //command/semaphore
reg cgs_command_ack;
    
reg command_ready;
reg [31:0] command_q;
reg [1:0] command_stateA;
reg [1:0] command_stateB;

reg [2:0] cgs_sel_q1;
reg [1:0] DMA1_sel_q1;

//CGS wires
wire [11:0] cgs_PC;         
wire [31:0] cgs_instr;      
wire [31:0] cgs_tabl_data;  
wire        cgs_rdprog;     
wire [23:0] cgs_srcA;
wire [23:0] cgs_srcB;
wire [23:0] cgs_dest_q2;
wire [11:0] cgs_pre_PC;
wire [31:0] cgs_prvt_rddataA;
wire [31:0] cgs_prvt_rddataB;
wire [31:0] cgs_resultout;
wire        cgs_rdsrcA;
wire        cgs_rdsrcB;
wire        cgs_rdconstA;
wire        cgs_wrcycl;
wire        DONE;
wire        DMA1wren;
wire [23:0] DMA1wraddrs;
wire        DMA1rden;
wire [23:0] DMA1rdaddrs;
wire        DMA0wren;
wire [23:0] DMA0wraddrs;
wire        DMA0rden;
wire [23:0] DMA0rdaddrs;
wire        shdr1_RESET;
wire        shdr0_RESET;
wire [15:0] frc_IRQ_thread;
wire [15:0] done_thread;

// shader1 wires
wire [11:0] shdr1_PC;                
wire [31:0] shdr1_instr;             
wire [31:0] shdr1_tabl_data;
wire        shdr1_rdprog;
wire [13:0] shdr1_srcA;
wire [13:0] shdr1_srcB;
wire [13:0] shdr1_dest_q2;
wire [11:0] shdr1_pre_PC;
wire [31:0] shdr1_prvt_rddataA;
wire [31:0] shdr1_prvt_rddataB;   
wire [31:0] shdr1_resultout;         
wire        shdr1_rdsrcA;
wire        shdr1_rdsrcB;
wire        shdr1_rdconstA;
wire        shdr1_wrcycl;
wire [1:0]  shdr1_thread_q0;
wire [1:0]  shdr1_thread_q2;

// shader0 wires
wire [11:0] shdr0_PC;                
wire [31:0] shdr0_instr;             
wire [31:0] shdr0_tabl_data;
wire        shdr0_rdprog;
wire [13:0] shdr0_srcA;
wire [13:0] shdr0_srcB;
wire [13:0] shdr0_dest_q2;
wire [11:0] shdr0_pre_PC;
wire [31:0] shdr0_prvt_rddataA;
wire [31:0] shdr0_prvt_rddataB;   
wire [31:0] shdr0_resultout;         
wire        shdr0_rdsrcA;
wire        shdr0_rdsrcB;
wire        shdr0_rdconstA;
wire        shdr0_wrcycl;
wire [1:0]  shdr0_thread_q0;
wire [1:0]  shdr0_thread_q2;

wire [31:0] cgs_datapool_rddata;
wire [31:0] DMA0_datapool_rddata;
wire [31:0] RDDATA;
wire DMA0_datapool_collide;
wire DMA1_datapool_collide;

wire [31:0] shdr1_PDB_rddataA;
wire [31:0] shdr1_PDB_rddataB;
wire [31:0] DMA1_PDB_rddata1;
wire [31:0] cgs_PDB_rddata1;

wire [31:0] shdr0_PDB_rddataA;
wire [31:0] shdr0_PDB_rddataB;
wire [31:0] DMA1_PDB_rddata0;
wire [31:0] cgs_PDB_rddata0;

// shader ROM write enables
wire DMA0_rom_wren;     //DMA0 -> cgs_rom
wire DMA0_rom1_wren;
wire DMA0_rom0_wren;
wire DMA0_romAll_wren;

//CGS ROM write enable
wire cgs_rom_wren;      //cgs -> cgs_rom
wire cgs_rom1_wren;
wire cgs_rom0_wren;
wire cgs_romAll_wren;
 
wire cgs_rden_PDB1;
wire cgs_rden_PDB0;
wire cgs_rden_DPL;

wire DMA1_rden_PDB1;
wire DMA1_rden_PDB0;

wire DMA1collide;
wire DMA1_PDB_collide1;
wire DMA1_PDB_collide0;

wire DMA0collide;
wire DMA0_PDB_collide1;
wire DMA0_PDB_collide0;
wire DMA0_rom_collide;
wire DMA0_rom1_collide;
wire DMA0_rom0_collide;
wire DMA0_romAll_collide; 

wire byte_swap_wr;
wire byte_swap_rd;

wire [31:0] DMA1_wrdata_swapped;
wire [31:0] DMA0_rddata_swapped;    

assign DMA0_rom_collide = cgs_rom_wren & DMA0_rom_wren;
assign DMA0_rom1_collide = cgs_rom1_wren & DMA0_rom1_wren;
assign DMA0_rom0_collide = cgs_rom0_wren & DMA0_rom0_wren;

assign DMA1collide = DMA1_datapool_collide | DMA1_PDB_collide1 | DMA1_PDB_collide0;
assign DMA0collide = DMA0_datapool_collide | DMA0_PDB_collide1 | DMA0_PDB_collide0 | DMA0_rom_collide | DMA0_rom1_collide | DMA0_rom0_collide | DMA0_romAll_collide;

assign DMA0_romAll_collide = cgs_romAll_wren & DMA0_romAll_wren;

assign cgs_rden_PDB1 = cgs_rdsrcA & (cgs_srcA[23:13]==11'b0000_0001_001);
assign cgs_rden_PDB0 = cgs_rdsrcA & (cgs_srcA[23:13]==11'b0000_0001_000);
assign cgs_rden_DPL = cgs_rdsrcA & (cgs_srcA[23:16]==8'b0000_0010);

assign DMA1_rden_PDB1 = DMA1rden & (DMA1rdaddrs[23:13]==11'b0000_0001_001);
assign DMA1_rden_PDB0 = DMA1rden & (DMA1rdaddrs[23:13]==11'b0000_0001_000);

assign cgs_rom1_wren  = cgs_wrcycl & ((cgs_dest_q2[23:12]==12'h019) | (cgs_dest_q2[23:12]==12'h01C));
assign cgs_rom0_wren  = cgs_wrcycl & ((cgs_dest_q2[23:12]==12'h018) | (cgs_dest_q2[23:12]==12'h01C));

assign cgs_rom_wren   = cgs_wrcycl & (cgs_dest_q2[23:12]==12'h01D);
assign DMA0_rom_wren = DMA0wren & (DMA0wraddrs[23:12]==12'h01D);

assign cgs_romAll_wren  = cgs_wrcycl & (cgs_dest_q2[23:12]==12'h01C);
assign DMA0_romAll_wren = DMA0wren & (DMA0wraddrs[23:12]==12'h01C);

assign DMA0_rom1_wren = DMA0wren & ((DMA0wraddrs[23:12]==12'h019) | (DMA0wraddrs[23:12]==12'h01C)); 
assign DMA0_rom0_wren = DMA0wren & ((DMA0wraddrs[23:12]==12'h018) | (DMA0wraddrs[23:12]==12'h01C)); 

assign done_thread[15:8] = 8'h00;
assign DMA1_wrdata_swapped = {DMA1wrdata[7:0], DMA1wrdata[15:8], DMA1wrdata[23:16], DMA1wrdata[31:24]};
assign DMA0_rddata_swapped = {DMA0_datapool_rddata[7:0], DMA0_datapool_rddata[15:8], DMA0_datapool_rddata[23:16], DMA0_datapool_rddata[31:24]};

CGS cgs(
     .PC             (cgs_PC         ),
     .P_DATAi        (cgs_instr      ),
     .ROM_4k_rddataA (cgs_tabl_data  ),
     .rdprog         (cgs_rdprog     ),
     .srcA           (cgs_srcA       ),
     .srcB           (cgs_srcB       ),
     .dest_q2        (cgs_dest_q2    ),
     .pre_PC         (cgs_pre_PC     ),
     .private_2048_rddataA(cgs_rddataA),
     .private_2048_rddataB(32'h0000_0000),
     .resultout      (cgs_resultout  ),
     .rdsrcA         (cgs_rdsrcA     ),
     .rdsrcB         (cgs_rdsrcB     ),                          
     .rdconstA       (cgs_rdconstA   ),                          
     .wrcycl         (cgs_wrcycl     ),
     .CLK            (CLKB           ),
     .RESET_IN       (RESET          ),
     .CGS_done       (DONE           ),
     .DMA1wren       (DMA1wren       ),
     .DMA1wraddrs    (DMA1wraddrs    ),
     .DMA1rden       (DMA1rden       ),
     .DMA1rdaddrs    (DMA1rdaddrs    ),
     .DMA1collide    (DMA1collide    ),
     .DMA0wren       (DMA0wren       ),
     .DMA0wraddrs    (DMA0wraddrs    ),
     .DMA0rden       (DMA0rden       ),
     .DMA0rdaddrs    (DMA0rdaddrs    ),
     .DMA0collide    (DMA0collide    ),
     .shdr3_RESET    (    ),
     .shdr2_RESET    (    ),
     .shdr1_RESET    (shdr1_RESET    ),
     .shdr0_RESET    (shdr0_RESET    ),
     .frc_IRQ_thread (frc_IRQ_thread ),
     .done_thread    (done_thread[15:0]),
     .swbrkdet_thread(16'h0000       ),
     .command        (command_q      ),
     .SWBRKdet       (               )
     );

gpu gpu1(
     .PC                 (shdr1_PC                ),
     .P_DATAi            (shdr1_instr             ),
     .ROM_4k_rddataA     (shdr1_tabl_data         ),     
     .rdprog             (shdr1_rdprog            ),
     .srcA               (shdr1_srcA              ),
     .srcB               (shdr1_srcB              ),
     .dest_q2            (shdr1_dest_q2           ), 
     .pre_PC             (shdr1_pre_PC            ),        
     .prvt_2k_rddataA    (shdr1_PDB_rddataA       ),  
     .prvt_2k_rddataB    (shdr1_PDB_rddataB       ),
     .resultout          (shdr1_resultout         ),
     .rdsrcA             (shdr1_rdsrcA            ),
     .rdsrcB             (shdr1_rdsrcB            ),
     .rdconstA           (shdr1_rdconstA          ),         
     .wrcycl             (shdr1_wrcycl            ),
     .CLK                (CLKB                    ),
     .RESET_IN           (shdr1_RESET             ),
     .tr3_done           (done_thread[7]          ),
     .tr2_done           (done_thread[6]          ),
     .tr1_done           (done_thread[5]          ),
     .tr0_done           (done_thread[4]          ),
     .newthreadq         (shdr1_thread_q0         ),
     .thread_q2          (shdr1_thread_q2         ),
                                  
     .tr3_IRQ            (frc_IRQ_thread[7]       ),
     .tr2_IRQ            (frc_IRQ_thread[6]       ),
     .tr1_IRQ            (frc_IRQ_thread[5]       ),
     .tr0_IRQ            (frc_IRQ_thread[4]       )
      );

gpu gpu0(
     .PC                 (shdr0_PC                ),
     .P_DATAi            (shdr0_instr             ),
     .ROM_4k_rddataA     (shdr0_tabl_data         ),     
     .rdprog             (shdr0_rdprog            ),
     .srcA               (shdr0_srcA              ),
     .srcB               (shdr0_srcB              ),
     .dest_q2            (shdr0_dest_q2           ), 
     .pre_PC             (shdr0_pre_PC            ),        
     .prvt_2k_rddataA    (shdr0_PDB_rddataA       ),  
     .prvt_2k_rddataB    (shdr0_PDB_rddataB       ),
     .resultout          (shdr0_resultout         ),
     .rdsrcA             (shdr0_rdsrcA            ),
     .rdsrcB             (shdr0_rdsrcB            ),
     .rdconstA           (shdr0_rdconstA          ),         
     .wrcycl             (shdr0_wrcycl            ),
     .CLK                (CLKB                    ),
     .RESET_IN           (shdr0_RESET             ),
     .tr3_done           (done_thread[3]          ),
     .tr2_done           (done_thread[2]          ),
     .tr1_done           (done_thread[1]          ),
     .tr0_done           (done_thread[0]          ),
     .newthreadq         (shdr0_thread_q0         ),
     .thread_q2          (shdr0_thread_q2         ),
                                  
     .tr3_IRQ            (frc_IRQ_thread[3]       ),
     .tr2_IRQ            (frc_IRQ_thread[2]       ),
     .tr1_IRQ            (frc_IRQ_thread[1]       ),
     .tr0_IRQ            (frc_IRQ_thread[0]       )
      );    

datapool_64kx32 datapool(
    .CLKA         (CLKA ),
    .CLKB         (CLKB ),
    .cgs_wren     (cgs_wrcycl & (cgs_dest_q2[23:16]==8'b0000_0010)),
    .cgs_wraddrs  (cgs_dest_q2[15:0]),
    .cgs_wrdata   (cgs_resultout ),
    .cgs_rden     (cgs_rden_DPL),
    .cgs_rdaddrs  (cgs_srcA[15:0]),
    .cgs_rddata   (cgs_datapool_rddata),
    .DMA1_wren    (DMA1wren & (DMA1wraddrs[23:16]==8'b0000_0010)),
    .DMA1_wraddrs (DMA1wraddrs[15:0]),
    .DMA1_wrdata  (DMA1wrdata ),
    .DMA0_rden    (DMA0rden & (DMA0rdaddrs[23:16]==8'b0000_0010)),
    .DMA0_rdaddrs (DMA0rdaddrs[15:0]),
    .DMA0_rddata  (DMA0_datapool_rddata),
    .SYS_wren     (WREN ),
    .SYS_wraddrs  (WRADDRS ),
    .SYS_wrdata   (WRDATA ),
    .SYS_rden     (RDEN ),
    .SYS_rdaddrs  (RDADDRS ),
    .SYS_rddata   (RDDATA ),
    .DMA1_collide (DMA1_datapool_collide),
    .DMA0_collide (DMA0_datapool_collide)
    );

PDB_1kx32_IRB PDB_IRB1(      //PDB(s) and IRB for shader 1
    .CLK           (CLKB ),  
    .thread        (shdr1_thread_q0 ),
    .thread_q2     (shdr1_thread_q2 ),  
    .cgs_wren      (cgs_wrcycl & (cgs_dest_q2[23:13]==11'b0000_0001_001)),
    .cgs_wraddrs   (cgs_dest_q2[12:0]),  
    .cgs_wrdata    (cgs_resultout),
    .cgs_rden      (cgs_rden_PDB1),
    .cgs_rdaddrs   (cgs_srcA[12:0]),
    .cgs_rddata    (cgs_PDB_rddata1),
    .DMA0_wren     (DMA0wren & (DMA0wraddrs[23:13]==11'b0000_0001_001)),
    .DMA0_wraddrs  (DMA0wraddrs[12:0]),
    .DMA0_wrdata   (DMA0_datapool_rddata),
    .DMA1_rden     (DMA1_rden_PDB1),
    .DMA1_rdaddrs  (DMA1rdaddrs[12:0]),
    .DMA1_rddata   (DMA1_PDB_rddata1),
    .shdr_wren     (shdr1_wrcycl & ((shdr1_dest_q2[13:10]==4'b0010) | (shdr1_dest_q2[13:12]==2'b01))),
    .shdr_wraddrs  (shdr1_dest_q2[12:0]),
    .shdr_wrdata   (shdr1_resultout),
    .shdr_rdenA    (shdr1_rdsrcA & ((shdr1_srcA[13:10]==4'b0010) | (shdr1_srcA[13:12]==2'b01))),
    .shdr_rdaddrsA (shdr1_srcA[12:0]),
    .shdr_rddataA  (shdr1_PDB_rddataA),
    .shdr_rdenB    (shdr1_rdsrcB & ((shdr1_srcB[13:10]==4'b0010) | (shdr1_srcB[13:12]==2'b01))),
    .shdr_rdaddrsB (shdr1_srcB[12:0]),
    .shdr_rddataB  (shdr1_PDB_rddataB),
    .DMA0_collide  (DMA0_PDB_collide1),
    .DMA1_collide  (DMA1_PDB_collide1)
    );
    
PDB_1kx32_IRB PDB_IRB0(      //PDB(s) and IRB for shader 0
    .CLK           (CLKB ),  
    .thread        (shdr0_thread_q0 ),
    .thread_q2     (shdr0_thread_q2 ),  
    .cgs_wren      (cgs_wrcycl & (cgs_dest_q2[23:13]==11'b0000_0001_000)),
    .cgs_wraddrs   (cgs_dest_q2[12:0]),  
    .cgs_wrdata    (cgs_resultout),
    .cgs_rden      (cgs_rden_PDB0),
    .cgs_rdaddrs   (cgs_srcA[12:0]),
    .cgs_rddata    (cgs_PDB_rddata0),
    .DMA0_wren     (DMA0wren & (DMA0wraddrs[23:13]==11'b0000_0001_000)),
    .DMA0_wraddrs  (DMA0wraddrs[12:0]),
    .DMA0_wrdata   (DMA0_datapool_rddata),
    .DMA1_rden     (DMA1_rden_PDB0),
    .DMA1_rdaddrs  (DMA1rdaddrs[12:0]),
    .DMA1_rddata   (DMA1_PDB_rddata0),
    .shdr_wren     (shdr0_wrcycl & ((shdr0_dest_q2[13:10]==4'b0010) | (shdr0_dest_q2[13:12]==2'b01))),
    .shdr_wraddrs  (shdr0_dest_q2[12:0]),
    .shdr_wrdata   (shdr0_resultout),
    .shdr_rdenA    (shdr0_rdsrcA & ((shdr0_srcA[13:10]==4'b0010) | (shdr0_srcA[13:12]==2'b01))),
    .shdr_rdaddrsA (shdr0_srcA[12:0]),
    .shdr_rddataA  (shdr0_PDB_rddataA),
    .shdr_rdenB    (shdr0_rdsrcB & ((shdr0_srcB[13:10]==4'b0010) | (shdr0_srcB[13:12]==2'b01))),
    .shdr_rdaddrsB (shdr0_srcB[12:0]),
    .shdr_rddataB  (shdr0_PDB_rddataB),
    .DMA0_collide  (DMA0_PDB_collide0),
    .DMA1_collide  (DMA1_PDB_collide0)
    );
                                             
//
// CGS program memory
//
cgsROM #(.ADDRS_WIDTH(12), .DATA_WIDTH(32))
    rom4096_cgs(      //program memory for cgs
    .CLK       (CLKB              ),
    .wren      (cgs_rom_wren ? 1'b1 : DMA0_rom_wren),
    .wraddrs   (cgs_rom_wren ? cgs_dest_q2[11:0] : DMA0wraddrs[11:0]),
    .wrdata    (cgs_rom_wren ? cgs_resultout : DMA0_datapool_rddata),
    .rdenA     (cgs_rdprog        ),
    .rdaddrsA  (cgs_pre_PC        ),
    .rddataA   (cgs_instr         ),
    .rdenB     (cgs_rdconstA | (cgs_srcA[23:12]==12'b0000_0000_0010)),
    .rdaddrsB  (cgs_srcA[11:0]    ),
    .rddataB   (cgs_tabl_data     )
    );        

//
// shader program memories
//
shdrROM #(.ADDRS_WIDTH(12), .DATA_WIDTH(32))
    rom4096_shdr1(      //program memory for core1
    .CLK       (CLKB                ),
    .wren      (cgs_rom1_wren ? 1'b1 : DMA0_rom1_wren),
    .wraddrs   (cgs_rom1_wren ? cgs_dest_q2[11:0] : DMA0wraddrs[11:0]),
    .wrdata    (cgs_rom1_wren ? cgs_resultout : DMA0_datapool_rddata),
    .rdenA     (shdr1_rdprog        ),
    .rdaddrsA  (shdr1_pre_PC        ),
    .rddataA   (shdr1_instr         ),
    .rdenB     (shdr1_rdconstA | (shdr1_srcA[13:12]==2'b01)),
    .rdaddrsB  (shdr1_srcA[11:0]    ),
    .rddataB   (shdr1_tabl_data     )
    );        

shdrROM #(.ADDRS_WIDTH(12), .DATA_WIDTH(32))
    rom4096_shdr0(      //program memory for core0
    .CLK       (CLKB                ),
    .wren      (cgs_rom0_wren ? 1'b1 : DMA0_rom0_wren),
    .wraddrs   (cgs_rom0_wren ? cgs_dest_q2[11:0] : DMA0wraddrs[11:0]),
    .wrdata    (cgs_rom0_wren ? cgs_resultout : DMA0_datapool_rddata),
    .rdenA     (shdr0_rdprog        ),
    .rdaddrsA  (shdr0_pre_PC        ),
    .rddataA   (shdr0_instr         ),
    .rdenB     (shdr0_rdconstA | (shdr0_srcA[13:12]==2'b01)),
    .rdaddrsB  (shdr0_srcA[11:0]    ),
    .rddataB   (shdr0_tabl_data     )
    );        

always @(posedge CLKA or posedge RESET) begin                                     
    if (RESET) begin
        command_stateA <= 2'b00;
        command_ready <= 1'b0;
        command <= 32'h0000_0000;
    end 
    else begin
        case(command_stateA)
            2'b00 : if (WREN && (WRADDRS==15'h0000) && ~|command) begin
                        command <= WRDATA;
                        command_stateA <= 2'b01;
                    end
            2'b01 : begin 
                        command_ready <= 1'b1;
                        command_stateA <= 2'b10;                        
                    end
            2'b10 : if (cgs_command_ack) command_stateA <= 2'b11;
            2'b11 : begin
                        command <= 32'h0000_0000;
                        command_ready <= 1'b0;
                        command_stateA <= 2'b00; 
                    end
        endcase
    end
end                                           

always @(posedge CLKB or posedge RESET) begin
    if (RESET) begin
        cgs_command_ack <= 1'b0;
        command_q <= 32'h0000_0000;
        command_stateB <= 2'b00;
    end    
    else begin
        case (command_stateB)
            2'b00 : if (command_ready && ((cgs_rdsrcA && (cgs_srcA[23:0]==23'h00_0064)) || (cgs_rdsrcB && (cgs_srcB[23:0]==23'h00_0064)))) begin
                        command_q <= command;
                        command_stateB <= 2'b01;
                    end
            2'b01 :  begin
                        cgs_command_ack <= 1'b1;
                        command_stateB <= 2'b10;
                    end
            2'b10,
            2'b11 : if (~command_ready) begin
                        command_q <= 32'h0000_0000;
                        cgs_command_ack <= 1'b0;
                        command_stateB <= 2'b00;
                    end
        endcase                            
    end
end                            
             
always @(posedge CLKB or posedge RESET) begin
    if (RESET) cgs_sel_q1[2:0] <= 3'b000;
    else cgs_sel_q1[2:0] <= {cgs_rden_DPL, cgs_rden_PDB1, cgs_rden_PDB0};
end

always @(posedge CLKB or posedge RESET) begin
    if (RESET) DMA1_sel_q1[1:0] <= 2'b00;
    else  DMA1_sel_q1[1:0] <= {DMA1_rden_PDB1, DMA1_rden_PDB0};
end

always @(*) begin
    casex(cgs_sel_q1)
         3'bxx1 : cgs_rddataA = cgs_PDB_rddata0;
         3'bx1x : cgs_rddataA = cgs_PDB_rddata1;              
         3'b1xx : cgs_rddataA = cgs_datapool_rddata;
        default : cgs_rddataA = 32'h0000_0000;
     endcase   
end

always @(*) begin
    casex(DMA1_sel_q1)
        2'bx1 : DMA1wrdata = DMA1_PDB_rddata0;                        
        2'b1x : DMA1wrdata = DMA1_PDB_rddata1;                        
      default : DMA1wrdata = 32'h0000_0000;
    endcase  
end                
                   
endmodule          

