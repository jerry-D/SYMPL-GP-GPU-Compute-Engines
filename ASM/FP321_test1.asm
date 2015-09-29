           CPU  "aSYMPL32.TBL"
           HOF  "MOT32"
           WDLN 4
; FP321-AXI4 test1
; version 1.03   Sept 17, 2015
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
C_reg:      EQU     0x6A                    ;FMA C register
LPCNT1:     EQU	    0x69		   	        ;dedicated loop counter 1 
LPCNT0:	    EQU	    0x68 			        ;dedicated loop counter 0
TIMER:      EQU     0x67                    ;timer
QOS:        EQU     0x66                    ;quality of service exception counters
DOT:        EQU     0x65                    ;DOT operator
RPT:        EQU     0x64                    ;repeat counter location
CAPTURE3:   EQU     0x63                    ;alternate delayed exception capture register 3
CAPTURE2:   EQU     0x62                    ;alternate delayed exception capture register 2
CAPTURE1:   EQU     0x61                    ;alternate delayed exception capture register 1
CAPTURE0:   EQU     0x60                    ;alternate delayed exception capture register 0

;zero-page storage
NMI_save    EQU     0x01                    ;save PC_COPY here immediately upon entry to NMI service routine
INV_save    EQU     0x02                    ;invalid exception PC_COPY save location
DIVx0_save  EQU     0x03                    ;divide by 0 exception PC_COPY save location
OVFL_save   EQU     0x04                    ;overflow exception PC_COPY save location
UNFL_save   EQU     0x05                    ;underflow exception PC_COPY save location
INEX_save   EQU     0x06                    ;inexact exception PC_COPY save location
IRQ_PC_save EQU     0x07                    ;save PC_COPY here immediately upon entry to general-purpose IRQ service routine
FGS_save:   EQU     0x08                    ;location for saving original Fine-Grain scheduler
work_1:     EQU     0x14                    
work_2:     EQU     0x15
work_3:     EQU     0x16
work_4:     EQU     0x17
work_5:     EQU     0x18
work_6:     EQU     0x19
capt0_save: EQU     0x1A                    ;alternate delayed exception capture register 0 save location
capt1_save: EQU     0x1B                    ;alternate delayed exception capture register 1 save location
capt2_save: EQU     0x1C                    ;alternate delayed exception capture register 2 save location
capt3_save: EQU     0x1D                    ;alternate delayed exception capture register 3 save location
lst_len:    EQU     0x1E                    ;length of list goes here
constA:     EQU     0x20                    ;constant A goes here
constB:     EQU     0x21                    ;constant B goes here
constC:     EQU     0x22                    ;constant C goes here

packet:     EQU     0x0800                  ;start location of the data packet to be processed

;constant immediate value equates
DONE_BIT:   EQU     0x20                    ;bit [5] is DONE Bit in status register

     
;this thread first loads all FP operators with some arbitrary value followed by a read of the resutls
;then performs the following integer calculation on each 32-bit entry in the submitted list and written back over the submitted value
; result = AX^2 + BX + C    
  
            
            org     0x0FD              

Constants:  DFL     start                   ;program memory locations 0x000 - 0x0FF reserved for look-up table
        
prog_len:   DFL     progend - Constants
pi:         DFF     3.14159
              
;           func    dest, srcA, srcB 

            org     0x00000100
RST_VECT:   mov     PC, #done               ;reset vector
NMI_VECT:   mov     PC, #NMI_               ;NMI vector
INV_VECT:   mov     PC, #INV_               ;invalid operation exception vector location
DIVx0_VECT: mov     PC, #DIVx0_             ;divide by 0 exception vector location
OVFL_VECT:  mov     PC, #OVFL_              ;overflow exception vector location
UNFL_VECT:  mov     PC, #UNFL_              ;underflow exception vector location
INEXT_VECT: mov     PC, #INEXT_             ;inexact exception vector location
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
            mov     TIMER, #30              ;load time-out timer with small value to induce timeout NMI before completion (for testing/simulation purposes)
            mov     AR3, #packet + 1        ;load AR3 with pointer to list length in parameter/data packet just received                                 
            and     STATUS, STATUS, #0xDF   ;clear the DONE bit
            mov     LPCNT0, *AR3++          ;copy list length into hardware loop counter LPCNT0 
            mov     constA, *AR3++          ;copy constA from packet
            mov     constB, *AR3++          ;copy constB
            mov     constC, *AR3++          ;copy constC, after which, AR3 should now be pointing at the 1st element in the list
        
inv_test:   mov     work_6, #0x2180         ;mask for status register to enable alternate delayed exception handling for divide by 0 and
            shft    STATUS, work_6, LEFT, 4 ;alternate immedate exception handling for invalid operation respectively
            mov     work_6, #0x7FBF         ;create "signaling" NaN to test invalid operation using SQRT operator
            shft    work_6, work_6, LEFT, 16 ;note that a table-read of a 32-bit constant can be used in lieu of this
            mov     SQRT_1, work_6          ;write signaling NaN to SQRT_1 to induce alternate-immediate-invalid operation exception
divx0_test: mov     FDIV_2,  constC, #0     ; setup for divide by 0 alternate-delayed-exception. Note that, for alternate-dealyed exception,
                                            ; the results must be read before the interrupt will be generated                
               
loop:       mul     work_1, *AR3, *AR3      ;square X
            mul     work_1, work_1, constA  ;multiply X^2 * constA
            mul     work_2, *AR3, constB    ;multiply X * constB
            add     work_3, work_1, work_2  ;add AX^2 + BX
            add     *AR3++, work_3, constC  ;get final answer and write back over original value X
            dbnz    loop, LPCNT0            ;decrement dedicated hardware loop counter 0 and, if not zero, then do next value in the list
                                            ;note that dbnz is an alias of BTBS, with bit 15 of LPCNT0 being tested for "1" condition (ie, Zero)
                                            ;also note that LPCNT0 and LPCNT1 h/w decrement counters are actually only 13-bits wide, allowing their dedicated
                                            ;Zero flags to occupy bit 15 at the same address when read by the alias BTBS instruction, DBNZ
divx0_cont: mov     work_6, FDIV_2          ;now that the previous FDIV_2 operation has had time to complete, read result buffer to induce
                                            ;the corresponding div by 0 alternate delayed exception handler
;the following instructins don't really anthing useful except for exercising the floating-point operators for test/simulation purposes
            mov     ITOF_6, #2              ;convert integer 2 to float 2.0
            mov     work_5, @pi             ;read pi out of ROM and store it in direct memory work_5
            mov     work_4, ITOF_6          ;move result of ITOF to directly addressable RAM location work_4
            mov     FDIV_4, work_5, work_4  ;FDIV pi by 2.0
;sema:       btbc    sema, 5, FDIV_4         ;test semaphor bit for FDIV_4 (bit 5) and try again if cleared (for H/W simulation purposes in this instance)
                                            ;note that the above btbc instruction is superfluous because a MOV read operation from
                                            ;any float operator address will rewind the PC automatically if the ready semaphor for that
                                            ;operator location is not set (ie, not ready).  Technically speaking, the instruction pipeline never stalls, because
                                            ;no opcode ever consumes more than one clock regardless of the state of a given FP operator semaphor, because
                                            ; the PC is automatically rewound to re-fetch if not ready

            mov     LOG_1,  work_4          ;get the log of 2.0
            mov     FADD_2, @pi, work_4     ;FADD pi + 2.0   (FADD_2, work_4, work_4 will yeild the same result)
            mov     FSUB_7, work_5, work_4  ;FSUB 2 from pi
            mov     FMUL_9, work_4, work_4  ;get the square of 2.0
            mov     DOT, work_4, work_4     ;square 2 
            mov     C_reg, @pi
            mov     FMA_3, work_4, work_4
            mov     EXP_3, LOG_1            ;convert log of 2.0 back to 2.0
            mov     DOT, work_4, work_4
            mov     SQRT_8, FMUL_9          ;get the SQRT of 4.0
            mov     *AR3++, FDIV_4          ;read out reslts from FDIV_4 and store in next location in parameter/data buffer
            mov     *AR3++, FADD_2          ;same for FADD_2 (should be 5.14159)
            mov     *AR3++, EXP_3           ;same for EXP_3 (should be 2.0)
            mov     *AR3++, FSUB_7          ;same for FSUB_7 (should be 1.14149)
            mov     FTOI_5, SQRT_8          ;read out results from SQRT_8 and convert to integer (results should be 2)
            mov     work_5, DOT
                                            
            mov     PC, #done               ;jump to done, semphr test and spin for next packet
; interrupt service routines        
NMI_:       mov     NMI_save, PC_COPY       ;save return address from non-maskable interrupt (time-out timer in this instance)
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, NMI_save            ;return from interrupt
        
INV_:       mov     INV_save, PC_COPY       ;save return address from floating-point invalid operation exception, which is maskable
            mov     TIMER, #10000           ;put a new value in the timer
            mov     work_6, SQRT_1          ;retrieve the NaN with payload (this quiet NaN replaced the signaling NaN that caused the INV exc)
            mov     PC, INV_save            ;return from interrupt
            
DIVx0_:     mov     DIVx0_save, PC_COPY     ;save return address from floating-point divide by 0 exception, which is maskable
            mov     capt0_save, CAPTURE0    ;read out CAPTURE0 register and save it
            mov     capt1_save, CAPTURE1    ;read out CAPTURE1 register and save it
            mov     capt2_save, CAPTURE2    ;read out CAPTURE2 register and save it
            mov     capt3_save, CAPTURE3    ;read out CAPTURE3 register and save it
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, DIVx0_save          ;return from interrupt

OVFL_:      mov     OVFL_save, PC_COPY      ;save return address from floating-point overflow exception, which is maskable
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, OVFL_save           ;return from interrupt

UNFL_:      mov     UNFL_save, PC_COPY      ;save return address from floating-point underflow exception, which is maskable
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, UNFL_save           ;return from interrupt

INEXT_:     mov     INEX_save, PC_COPY      ;save return address from floating-point inexact exception, which is maskable
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, INEX_save           ;return from interrupt

IRQ_:       mov     IRQ_PC_save, PC_COPY    ;save return address (general-purpose, maskable interrupt)
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, IRQ_PC_save         ;return from interrupt            
progend:        
            end
          
    
