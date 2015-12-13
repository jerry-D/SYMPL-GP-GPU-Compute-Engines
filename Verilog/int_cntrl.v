 // int_cntrl.v
 `timescale 1ns/100ps
 // Shader interrupt controller
 // For use in SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-Compute Engine
 // Author:  Jerry D. Harthcock
 // Version:  1.06  Dec. 12, 2015
 // July 27, 2015
 // Copyright (C) 2015.  All rights reserved without prejudice.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                   SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-Compute Engine                           //
//                              Evaluation and Product Development License                                       //
//                                                                                                               //
// Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"), //
// the original author and exclusive copyright owner of the SYMPL 32-Bit Multi-Thread, Multi-Processing GP-GPU-  //
// Compute Engine Verilog RTL IP core family and instruction-set architecture ("this IP"), hereby grants to      //
// recipient of this IP ("licensee"), a world-wide, paid-up, non-exclusive license to use this IP for the        //
// non-commercial purposes of evaluation, education, and development of end products and related development     //
// tools only. For a license to use this IP in commercial products intended for sale, license, lease or any      //
// other form of barter, contact licensor at:  SYMPL.gpu@gmail.com                                               //
//                                                                                                               //
// Any customization, modification, or derivative work of this IP must include an exact copy of this license     //
// and original copyright notice at the very top of each source file and derived netlist, and, in the case of    //
// binaries, a printed copy of this license and/or a text format copy in a separate file distributed with said   //
// netlists or binary files having the file name, "LICENSE.txt".  You, the licensee, also agree not to remove    //
// any copyright notices from any source file covered under this Evaluation and Product Development License.     //
//                                                                                                               //
// THIS IP IS PROVIDED "AS IS".  LICENSOR DOES NOT WARRANT OR GUARANTEE THAT YOUR USE OF THIS IP WILL NOT        //
// INFRINGE THE RIGHTS OF OTHERS OR THAT IT IS SUITABLE OR FIT FOR ANY PURPOSE AND THAT YOU, THE LICENSEE, AGREE //
// TO HOLD LICENSOR HARMLESS FROM ANY CLAIM BROUGHT BY YOU OR ANY THIRD PARTY FOR YOUR SUCH USE.                 //                               
//                                                                                                               //
// Licensor reserves all his rights without prejudice, including, but in no way limited to, the right to change  //
// or modify the terms and conditions of this Evaluation and Product Development License anytime without notice  //
// of any kind to anyone. By using this IP for any purpose, you agree to all the terms and conditions set forth  //
// in this Evaluation and Product Development License.                                                           //
//                                                                                                               //
// This Evaluation and Product Development License does not include the right to sell products that incorporate  //
// this IP or any IP derived from this IP.  If you would like to obtain such a license, please contact Licensor. //                                                                                            //
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
    inexact_exc,  
    underflow_exc,
    overflow_exc, 
    divby0_exc,   
    invalid_exc,  
    IRQ,
    IRQ_IE,
    vector,
    ld_vector,
    NMI_ack,
    EXC_ack,
    IRQ_ack,
    EXC_in_service,
    invalid_in_service,
    divby0_in_service, 
    overflow_in_service, 
    underflow_in_service,
    inexact_in_service,
    wrcycl,
    pipe_flush,
    assigned_thread
    );
    
input CLK; 
input RESET; 
input NMI; 
input inexact_exc;  
input underflow_exc;
input overflow_exc; 
input divby0_exc;   
input invalid_exc;  
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
output EXC_in_service;
output invalid_in_service;
output divby0_in_service; 
output overflow_in_service; 
output underflow_in_service;
output inexact_in_service;


input [1:0] assigned_thread;
input pipe_flush;
input wrcycl;

parameter MOV_ = 4'b0000;
parameter PC_ADDRS = 14'h006F;
parameter PC_COPY = 14'h006E;

//RETI trigger addresses
parameter NMI_PC_SAVE = 14'h0001;
parameter invalid_PC_SAVE = 14'h0002;
parameter divby0_PC_SAVE = 14'h0003;
parameter overflow_PC_SAVE = 14'h0004;
parameter underflow_PC_SAVE = 14'h0005;
parameter inexact_PC_SAVE = 14'h0006;
parameter IRQ_PC_SAVE = 14'h0007;

//interrupt vectors
parameter NMI_VECTOR = 12'h101;
parameter invalid_VECTOR = 12'h102;
parameter divby0_VECTOR = 12'h103;
parameter overflow_VECTOR = 12'h104;
parameter underflow_VECTOR = 12'h105;
parameter inexact_VECTOR = 12'h106;
parameter IRQ_VECTOR = 12'h107;

reg [11:0] vector;
reg ld_vector;

reg NMI_ackq;
reg NMI_in_service;

reg EXC_ackq;
reg EXC_in_service;

reg IRQ_ackq;
reg IRQ_in_service;

reg inexactq; 
reg underflowq;
reg overflowq;
reg divby0q;  
reg invalidq; 
 
reg [2:0] state;

reg [1:0] thread_q1; 

wire EXC;

wire NMIg;
wire NMI_ack;
wire NMI_RETI;
wire saving_NMI_PC_COPY;

wire EXCg;
wire EXC_ack;
wire EXC_RETI;
wire saving_EXC_PC_COPY;
wire [4:0] EXC_sel;

wire IRQg;
wire IRQ_ack;
wire IRQ_RETI;
wire saving_IRQ_PC_COPY;

wire invalid_RETI; 
wire divby0_RETI;  
wire overflow_RETI; 
wire underflow_RETI;
wire inexact_RETI; 

wire invalid_in_service;
wire divby0_in_service;
wire overflow_in_service;
wire underflow_in_service;
wire inexact_in_service;


assign EXC_sel = {inexactq, underflowq, overflowq, divby0q, invalidq};  

assign NMI_ack = NMI_ackq & (PC==NMI_VECTOR) & (thread==assigned_thread);
assign EXC_ack = EXC_ackq & ((PC==invalid_VECTOR) | (PC==divby0_VECTOR) | (PC==overflow_VECTOR) | (PC==underflow_VECTOR) | (PC==inexact_VECTOR)) & (thread==assigned_thread);
assign IRQ_ack = IRQ_ackq & (PC==IRQ_VECTOR) & (thread==assigned_thread);

assign NMI_RETI = NMI_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==NMI_PC_SAVE) & (thread_q2==assigned_thread) & wrcycl;

assign invalid_in_service = EXC_in_service & invalidq;
assign divby0_in_service = EXC_in_service & divby0q;
assign overflow_in_service = EXC_in_service & overflowq;
assign underflow_in_service = EXC_in_service & underflowq;
assign inexact_in_service = EXC_in_service & inexactq;

assign invalid_RETI = invalid_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==invalid_PC_SAVE) & (thread_q2==assigned_thread) & wrcycl;
assign divby0_RETI = divby0_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==divby0_PC_SAVE) & (thread_q2==assigned_thread) & wrcycl;
assign overflow_RETI = overflow_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==overflow_PC_SAVE) & (thread_q2==assigned_thread) & wrcycl;
assign underflow_RETI = underflow_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==underflow_PC_SAVE) & (thread_q2==assigned_thread) & wrcycl;
assign inexact_RETI = inexact_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==inexact_PC_SAVE) & (thread_q2==assigned_thread) & wrcycl;

assign EXC_RETI = invalid_RETI | divby0_RETI | overflow_RETI | underflow_RETI | inexact_RETI;

assign IRQ_RETI = IRQ_in_service & (opcode_q2==MOV_) & (dest_q2==PC_ADDRS) & (srcA_q2==IRQ_PC_SAVE) & (thread_q2==assigned_thread) & wrcycl;

assign saving_NMI_PC_COPY = NMI_in_service & (opcode_q2==MOV_) & (dest_q2==NMI_PC_SAVE) & (srcA_q2==PC_COPY) & (thread_q2==assigned_thread) & wrcycl;
assign saving_EXC_PC_COPY = EXC_in_service & (opcode_q2==MOV_) & ((dest_q2==invalid_PC_SAVE) | (dest_q2==divby0_PC_SAVE) | (dest_q2==overflow_PC_SAVE) | (dest_q2==underflow_PC_SAVE) | (dest_q2==inexact_PC_SAVE)) & (srcA_q2==PC_COPY) & (thread_q2==assigned_thread) & wrcycl;
assign saving_IRQ_PC_COPY = IRQ_in_service & (opcode_q2==MOV_) & (dest_q2==IRQ_PC_SAVE) & (srcA_q2==PC_COPY) & (thread_q2==assigned_thread) & wrcycl;

assign NMIg = NMI & ~NMI_ack & ~NMI_in_service  & (thread_q1==assigned_thread);                                                                                                                                              
assign EXCg = (inexactq | underflowq | overflowq | divby0q | invalidq) & ~EXC_ack & ~EXC_in_service & (thread_q1==assigned_thread);                                                                                                                                              
//assign EXCg = 1'b0;
assign IRQg = IRQ & IRQ_IE & ~IRQ_ack & ~IRQ_in_service & ~NMIg & ~EXCg  & (thread_q1==assigned_thread);                                                                                                                                               

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        inexactq   <= 1'b0; 
        underflowq <= 1'b0;
        overflowq  <= 1'b0;
        divby0q    <= 1'b0; 
        invalidq   <= 1'b0;
    end
    else begin
        if (invalid_RETI) invalidq <= 1'b0;
        else if (~invalidq) invalidq <= invalid_exc;

        if (divby0_RETI) divby0q <= 1'b0;
        else if (~divby0q) divby0q <= divby0_exc;
        
        if (overflow_RETI) overflowq <= 1'b0;
        else if (~overflowq) overflowq <= overflow_exc;
        
        if (underflow_RETI) underflowq <= 1'b0;
        else if (~underflowq) underflowq <= underflow_exc;

        if (inexact_RETI) inexactq <= 1'b0;
        else if (~inexactq) inexactq <= inexact_exc;
    end
end        
        
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
        
        thread_q1 <= 2'b00;
        
    end
//NMI    
    else begin
        thread_q1 <= thread;
        case(state)
            3'b000 : if (NMIg) begin
                        NMI_ackq <= 1'b1;
                        ld_vector <= 1'b1;
                        vector <= NMI_VECTOR;
                        if (~pipe_flush) state <= 3'b001;
                        state <= 3'b001;
                     end
                     else if (EXCg) begin
                        EXC_ackq <= 1'b1;
                        ld_vector <= 1'b1;
                        casex (EXC_sel)
                            5'bxxxx1 : vector <= invalid_VECTOR;
                            5'bxxx1x : vector <= divby0_VECTOR;
                            5'bxx1xx : vector <= overflow_VECTOR;
                            5'bx1xxx : vector <= underflow_VECTOR;
                            5'b1xxxx : vector <= inexact_VECTOR;
                            default  : vector <= invalid_VECTOR;
                        endcase    
                        if (~pipe_flush) state <= 3'b001;
                        state <= 3'b001;
                     end
                     else if (IRQg) begin
                        IRQ_ackq <= 1'b1;
                        ld_vector <= 1'b1;
                        vector <= IRQ_VECTOR;
                        if (~pipe_flush) state <= 3'b001;
                        state <= 3'b001;
                     end                                
            3'b001 : begin                                                                                         
                        ld_vector <= 1'b0;                                                                         
                        if (NMI_ackq) begin
                          NMI_ackq <= 1'b0;
                          NMI_in_service <= 1'b1;
                          state <= 3'b010;                
                        end
                        else if (EXC_ackq) begin          
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
                        if (NMI_in_service && saving_NMI_PC_COPY) begin
                            state <= 3'b011;
                        end
                        else if ((EXC_in_service && saving_EXC_PC_COPY) || (IRQ_in_service && saving_IRQ_PC_COPY)) begin
                            state <= 3'b011;
                        end
                     end   
            3'b011 : begin
                        if (NMI_RETI) begin
                            NMI_in_service <= 1'b0;
                            state <= 3'b100;
                        end
                        else if (EXC_RETI) begin
                            EXC_in_service <= 1'b0;
                            state <= 3'b100;
                        end
                        else if (IRQ_RETI) begin
                            IRQ_in_service <= 1'b0;
                            state <= 3'b100;
                        end
                     end
            3'b100 : state <= 3'b000;   //allow one fetch before allowing another interrupt
           default : state <= 3'b000;
        endcase        
    end                
end                     
                        
endmodule        
               
                