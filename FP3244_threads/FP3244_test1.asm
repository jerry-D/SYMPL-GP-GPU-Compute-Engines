           CPU  "aSYMPL32.TBL"
           HOF  "MOT32"
           WDLN 4
; FP324-AXI4 test1
; version 1.01   July 30, 2015
; Author:  Jerry D. Harthcock
; Copyright (C) 2015.  All rights reserved without prejudice.
           
;--------------------------------------------------------------------------           
;         internal memory-mapped h/w registers
;--------------------------------------------------------------------------
AR3:        EQU     0x73                    ;Auxiliary Reg 3
AR2:        EQU     0x72                    ;Auxiliary Reg 2
AR1:        EQU     0x71                    ;Auxiliary Reg 1
AR0:        EQU     0x70                    ;Auxiliary Reg 0
PC:         EQU     0x6F                    ;Program Counter
PC_COPY:    EQU     0x6E
STATUS:     EQU     0x6D                    ;Statis Register
SCHED:      EQU     0x6C                    ;scheduler
SCHEDCMP:   EQU     0x6B                    ;scheduler max count values
OUTBOX:     EQU     0x6A                    ;out box
LPCNT1:     EQU	    0x69		   	        ;dedicated loop counter 1 
LPCNT0:	    EQU	    0x68 			        ;dedicated loop counter 0
TIMER:      EQU     0x67                    ;timer
RPT:        EQU     0x64                    ;repeat counter location

;zero-page storage
NMI_PC_save EQU     0x20                    ;save PC_COPY here immediately upon entry to NMI service routine
EXC_PC_save EQU     0x21                    ;save PC_COPY here immediately upon entry to FP EXC service routine
IRQ_PC_save EQU     0x22                    ;save PC_COPY here immediately upon entry to IRQ service routine
FGS_save:   EQU     0x23                    ;location for saving original Fine-Grain scheduler
work_1:     EQU     0x24                    
work_2:     EQU     0x25
work_3:     EQU     0x26
work_4:     EQU     0x27
lst_len:    EQU     0x28                    ;length of list goes here
constA:     EQU     0x29                    ;constant A goes here
constB:     EQU     0x2A                    ;constant B goes here
constC:     EQU     0x2B                    ;constant C goes here

packet:     EQU     0x0800                  ;start location of the data packet to be processed

;constant immediate value equates
DONE_BIT:   EQU     0x20                    ;bit [5] is DONE Bit in status register

     
;this thread performs the following integer calculation on each 32-bit entry in the submitted list and written back over the submitted value
; result = AX^2 + BX + C    
  
            
            org     0x0FE              

Constants:  DFL     start                   ;program memory locations 0x000 - 0x0FF reserved for look-up table
        
prog_len:   DFL     progend - Constants
              
;           func    dest, srcA, srcB 

            org     0x00000100
RST_VECT:   mov     PC, #done               ;reset vector
NMI_VECT:   mov     PC, #NMI_               ;NMI vector
EXC_VECT:   mov     PC, #EXC_               ;maskable FP exception vector
IRQ_VECT:   mov     PC, #IRQ_               ;maskable general-purpose interrupt vector

done:       mov     AR3, #packet            ;point to start of packet which is both a semaphor and entry point for thread
semphr:     or      STATUS, STATUS, #DONE_BIT   ; signal external CPU (load-balancer/coarse-grain scheduler) process is done
                                            ;note that the DONE_BIT is already set upon initial entry but is cleared three instruction below "start"
                                            ;to signal CPU thread has started (ie, not done)        
spin:       or      work_1, *AR3, #0        ;see if first location (the semaphor and routine entry point) of packet is non-zero
                                            ;during this time the CPU is pushing packet into Shader memory and, as a final step,
                                            ;and will write the non-zero PC entry point to the location pointed to by AR3 when AXI4 DMA xfer is complete
            bcnd    spin, Z                 ;if semaphr is 0 then wait for this value to become non-zero in the packet RAM block
            mov     *AR3, #0                ;clear the semaphor now so we don't fall through again when we get done and come back here
            mov     PC, work_1              ;else perform the specified thread pointed to by contents of work_1, in this case, "start"
        
start:  
            mov     TIMER, #100             ;load time-out timer with small value to induce timeout NMI before completion (for testing/simulation purposes)
            mov     AR3, #packet + 1        ;load AR3 with pointer to list length in parameter/data packet just received                                 
            and     STATUS, STATUS, #0xDF   ;clear the DONE bit
            mov     LPCNT0, *AR3++          ;copy list length into hardware loop counter LPCNT0 
            mov     constA, *AR3++          ;copy constA from packet
            mov     constB, *AR3++          ;copy constB
            mov     constC, *AR3++          ;copy constC, after which, AR3 should now be pointing at the 1st element in the list
        
            mov     FDIV_4, constA, constB  ;float-divide constA by constB (integers deliberately loaded for FP flag testing here)
;sema:       btbc    sema, 5, FDIV_4         ;test semaphor bit for FDIV_4 (bit 5) and try again if cleared (for H/W simulation purposes in this instance)
            mov     work_4, FDIV_4          ;note that the above btbc instruction is superfluous because a MOV read operation from
                                            ;any float operator address will rewind the PC automatically if the ready semaphor for that
                                            ;operator location is not set (ie, not ready).  Technically speaking, the instruction pipeline never stalls, because
                                            ;no opcode ever consumes more than one clock regardless of the state of a given FP operator semaphor, because
                                            ; the PC is automatically rewound to re-fetch if not ready
        
loop:       mul     work_1, *AR3, *AR3      ;square X
            mul     work_1, work_1, constA  ;multiply X^2 * constA
            mul     work_2, *AR3, constB    ;multiply X * constB
            add     work_3, work_1, work_2  ;add AX^2 + BX
            add     *AR3++, work_3, constC  ;get final answer and write back over original value X
            dbnz    loop, LPCNT0            ;decrement dedicated hardware loop counter 0 and, if not zero, then do next value in the list
                                            ;note that dbnz is an alias of BTBS, with bit 15 of LPCNT0 being tested for "1" condition (ie, Zero)
                                            ;also note that LPCNT0 and LPCNT1 h/w decrement counters are actually only 13-bits wide, allowing their dedicated
                                            ;Zero flags to occupy bit 15 at the same address when read by the alias BTBS instruction, DBNZ
            mov     PC, #done               ;jump to done, semphr test and spin for next packet
; interrupt service routines        
NMI_:       mov     NMI_PC_save, PC_COPY    ;save return address from non-maskable interrupt (time-out timer in this instance)
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, NMI_PC_save         ;return from interrupt
        
EXC_:       mov     EXC_PC_save, PC_COPY    ;save return address from floating-point exception, which is maskable
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, EXC_PC_save         ;return from interrupt

IRQ_:       mov     IRQ_PC_save, PC_COPY    ;save return address (general-purpose, maskable interrupt)
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, IRQ_PC_save         ;return from interrupt
                                     
progend:        
            end
          
    
