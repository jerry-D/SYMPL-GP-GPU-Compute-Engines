 // int_cntrl.v
 `timescale 1ns/100ps
 // FP324-AXI4  interrupt controller
 // For use in SYMPL FP324-AXI4 multi-thread multi-processing core only
 // Author:  Jerry D. Harthcock
 // Version:  1.01
 // July 27, 2015
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

module int_cntrl(
    CLK,
    RESET,
    PC,
    opcode_q2,
    thread,
    thread_q2,
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
    assigned_thread
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
input [1:0] thread; 
input [1:0] thread_q2;          
input [13:0] srcA_q2;
input [13:0] dest_q2;
output [11:0] vector;
output ld_vector;
output NMI_ack;
output EXC_ack;
output IRQ_ack;
input [1:0] assigned_thread;
input wrcycl;

parameter MOV_ = 4'b0000;
parameter PC_ADDRS = 14'h006F;
parameter PC_COPY = 14'h006E;
parameter NMI_PC_SAVE = 14'h0020;
parameter EXC_PC_SAVE = 14'h0021;
parameter IRQ_PC_SAVE = 14'h0022;
parameter NMI_VECTOR = 12'h101;
parameter FPEXC_VECTOR = 12'h102;
parameter IRQ_VECTOR = 12'h103;

reg [11:0] vector;
reg ld_vector;

reg NMI_ackq;
reg NMI_in_service;

reg EXC_ackq;
reg EXC_in_service;

reg IRQ_ackq;
reg IRQ_in_service;

reg [2:0] state;

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

assign NMI_ack = NMI_ackq & (PC==NMI_VECTOR) & (thread==assigned_thread);
assign EXC_ack = EXC_ackq & (PC==FPEXC_VECTOR) & (thread==assigned_thread);
assign IRQ_ack = IRQ_ackq & (PC==IRQ_VECTOR) & (thread==assigned_thread);

assign NMI_RETI = NMI_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==NMI_PC_SAVE) & (thread_q2==assigned_thread) & wrcycl;
assign EXC_RETI = EXC_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==EXC_PC_SAVE) & (thread_q2==assigned_thread) & wrcycl;
assign IRQ_RETI = IRQ_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==IRQ_PC_SAVE) & (thread_q2==assigned_thread) & wrcycl;


assign saving_NMI_PC_COPY = NMI_in_service & (opcode_q2==MOV_) & (dest_q2==NMI_PC_SAVE) & (srcA_q2==PC_COPY) & (thread_q2==assigned_thread) & wrcycl;
assign saving_EXC_PC_COPY = EXC_in_service & (opcode_q2==MOV_) & (dest_q2==EXC_PC_SAVE) & (srcA_q2==PC_COPY) & (thread_q2==assigned_thread) & wrcycl;
assign saving_IRQ_PC_COPY = IRQ_in_service & (opcode_q2==MOV_) & (dest_q2==IRQ_PC_SAVE) & (srcA_q2==PC_COPY) & (thread_q2==assigned_thread) & wrcycl;

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
        ld_vector <= 1'b0;
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
        case(state)
            3'b000 : if (NMIg) begin
                        NMI_ackq <= 1'b1;
                        ld_vector <= 1'b1;
                        vector <= 12'h101;
                        state <= 3'b001;
                     end
            3'b001 : begin                                                                                         
                        ld_vector <= 1'b0;                                                                         
                        if (NMI_ackq && (PC==NMI_VECTOR) && (thread==assigned_thread)) begin
                          NMI_ackq <= 1'b0;
                          NMI_in_service <= 1'b1;
                          state <= 3'b010;                
                        end
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
                        ld_vector <= 1'b1;
                        vector <= 12'h102;
                        state <= 3'b001;
                     end
                     else if (IRQg) begin
                        IRQ_ackq <= 1'b1;
                        ld_vector <= 1'b1;
                        vector <= 12'h103;
                        state <= 3'b001;
                     end                                                                                           
            3'b001 : begin                                                                                         
                        ld_vector <= 1'b0;                                                                         
                        if (EXC_ackq && (PC==FPEXC_VECTOR) && (thread==assigned_thread)) begin
                            EXC_ackq <= 1'b0;
                            EXC_in_service <= 1'b1;
                          state <= 3'b010;                
                        end 
                        else if (IRQ_ackq && (PC==IRQ_VECTOR) && (thread==assigned_thread)) begin
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
               
                