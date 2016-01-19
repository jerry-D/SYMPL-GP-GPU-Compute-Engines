 // shader int_cntrl.v
 `timescale 1ns/100ps
 // Author:  Jerry D. Harthcock
 // Version:  1.03  January 18, 2016
 // July 27, 2015
 // Copyright (C) 2015-2016.  All rights reserved.
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

module CGS_int_cntrl(
    CLK,
    RESET,
    PC,
    opcode_q2,
    srcA_q2,
    dest_q2,
    NMI,
    EXC,
    EXC_IE,
    IRQ,
    IRQ_IE,
    vector,
    ld_vector,
    NMI_ack,
    EXC_ack,
    IRQ_ack,
    wrcycl, 
    pipe_flush
    );
    
input CLK; 
input RESET; 
input NMI; 
input EXC; 
input EXC_IE; 
input IRQ; 
input IRQ_IE;
input [11:0] PC;
input [3:0] opcode_q2;
input [23:0] srcA_q2;
input [23:0] dest_q2;
output [11:0] vector;
output ld_vector;
output NMI_ack;
output EXC_ack;
output IRQ_ack;
input wrcycl;
input pipe_flush;

parameter STACK_PUSH = 24'h00006B;
parameter STACK_POP =  24'h00006A;

parameter MOV_ = 4'b0000;
parameter PC_ADDRS = 24'h0006F;
parameter PC_COPY = 24'h0006E;
parameter NMI_PC_SAVE = 24'h00001;
parameter EXC_PC_SAVE = 24'h00002;
parameter IRQ_PC_SAVE = 24'h00003;
parameter NMI_VECTOR = 12'h101;
parameter FPEXC_VECTOR = 12'h102;
parameter IRQ_VECTOR = 12'h103;

reg [11:0] vector;
reg ld_vector_q;
reg ld_vector_q1;

reg NMI_ackq;
reg NMI_in_service;

reg EXC_ackq;
reg EXC_in_service;

reg IRQ_ackq;
reg IRQ_in_service;

reg [2:0] state;

wire ld_vector;

wire NMIg;
wire NMI_ack;
wire NMI_RETI;
wire saving_NMI_PC_COPY;

wire EXCg;
wire EXC_ack;
wire EXC_RETI;
wire saving_EXC_PC_COPY;

wire IRQg;
wire IRQ_ack;
wire IRQ_RETI;
wire saving_IRQ_PC_COPY;

assign ld_vector = ~pipe_flush & ld_vector_q & ~ld_vector_q1;

assign NMI_ack = NMI_ackq & (PC==NMI_VECTOR);
assign EXC_ack = EXC_ackq & (PC==FPEXC_VECTOR);
assign IRQ_ack = IRQ_ackq & (PC==IRQ_VECTOR);

assign NMI_RETI = NMI_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==STACK_POP) & wrcycl;
assign EXC_RETI = EXC_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==STACK_POP) & wrcycl;
assign IRQ_RETI = IRQ_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==STACK_POP) & wrcycl;
                                                                                       

assign saving_NMI_PC_COPY = NMI_in_service & (opcode_q2==MOV_) & (dest_q2==STACK_PUSH) & (srcA_q2==PC_COPY) & wrcycl;
assign saving_EXC_PC_COPY = EXC_in_service & (opcode_q2==MOV_) & (dest_q2==STACK_PUSH) & (srcA_q2==PC_COPY) & wrcycl;
assign saving_IRQ_PC_COPY = IRQ_in_service & (opcode_q2==MOV_) & (dest_q2==STACK_PUSH) & (srcA_q2==PC_COPY) & wrcycl;

assign NMIg = NMI & ~NMI_ack & ~NMI_in_service;                                                                                                                                              
assign EXCg = EXC & EXC_IE & ~EXC_ack & ~EXC_in_service & ~NMIg;                                                                                                                                              
assign IRQg = IRQ & IRQ_IE & ~IRQ_ack & ~IRQ_in_service & ~NMIg & ~EXCg;                                                                                                                                              


//interrupt prioritizer with corresponding IACK and IN_SERVICE generator
// NMI can interrupt EXC and IRQ while they are in service
// EXC has priority over IRQ but cannot interrupt IRQ or NMI while they are in service
// all interrupt sources must be held active until acknowledged, at which time they may be released
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        vector <= 12'h000;
        ld_vector_q <= 1'b0;
        ld_vector_q1 <= 1'b0;
        state <= 3'b000;
        
        NMI_ackq <= 1'b0;
        NMI_in_service <= 1'b0;
        
        EXC_ackq <= 1'b0;
        EXC_in_service <= 1'b0;
        
        IRQ_ackq <= 1'b0;
        IRQ_in_service <= 1'b0;
        
    end
//NMI    
    else begin
        ld_vector_q1 <= ld_vector;
        case(state)
            3'b000 : if (NMIg) begin
                        NMI_ackq <= 1'b1;
                        ld_vector_q <= 1'b1;
                        vector <= 12'h101;
                        if (~pipe_flush) state <= 3'b001;
                     end
            3'b001 : begin                                                                                         
                        ld_vector_q <= 1'b0;                                                                         
                          NMI_ackq <= 1'b0;
                          NMI_in_service <= 1'b1;
                          state <= 3'b010;                
                     end
            3'b010 : begin
                        if (NMI_in_service && saving_NMI_PC_COPY) begin
                            state <= 3'b011;
                        end
                     end   
            3'b011 : begin
                        if (NMI_RETI) begin
                            NMI_in_service <= 1'b0;
                            state <= 3'b110;
                        end
                     end
            3'b100 : state <= 3'b000;   //allow one fetch before allowing another interrupt
           default : state <= 3'b000;
        endcase
        
        case(state)
            3'b000 : if (EXCg) begin
                        EXC_ackq <= 1'b1;
                        ld_vector_q <= 1'b1;
                        vector <= 12'h102;
                        state <= 3'b001;
                     end
                     else if (IRQg) begin
                        IRQ_ackq <= 1'b1;
                        ld_vector_q <= 1'b1;
                        vector <= 12'h103;
                        state <= 3'b001;
                     end                                                                                           
            3'b001 : begin                                                                                         
                        ld_vector_q <= 1'b0;                                                                         
                        if (EXC_ackq) begin
                            EXC_ackq <= 1'b0;
                            EXC_in_service <= 1'b1;
                          state <= 3'b010;                
                        end 
                        else if (IRQ_ackq) begin
                            IRQ_ackq <= 1'b0;
                            IRQ_in_service <= 1'b1;
                          state <= 3'b010;                
                        end 
                     end
            3'b010 : begin
                        if ((EXC_in_service && saving_EXC_PC_COPY) || (IRQ_in_service && saving_IRQ_PC_COPY)) begin
                            state <= 3'b011;
                        end
                     end   
            3'b011 : begin
                        if (EXC_RETI) begin
                            EXC_in_service <= 1'b0;
                            state <= 3'b110;
                        end
                        else if (IRQ_RETI) begin
                            IRQ_in_service <= 1'b0;
                            state <= 3'b110;
                        end
                     end
            3'b100 : state <= 3'b000;   //allow one fetch before allowing another interrupt
           default : state <= 3'b000;
        endcase
        
    end                
end                     
                        
endmodule        
               
                