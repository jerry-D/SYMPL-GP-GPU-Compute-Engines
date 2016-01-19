           CPU  "SYMPL_IL.TBL"
           HOF  "MOT32"
           WDLN 4
; CGS FP3211 test1
; version 1.01   Nov 29, 2015
; Author:  Jerry D. Harthcock
; Copyright (C) 2015.  All rights reserved without prejudice.
           
;--------------------------------------------------------------------------           
;         internal memory-mapped h/w registers
;--------------------------------------------------------------------------
AR3:            EQU     0x73                    ;Auxiliary Reg 3
AR2:            EQU     0x72                    ;Auxiliary Reg 2
AR1:            EQU     0x71                    ;Auxiliary Reg 1
AR0:            EQU     0x70                    ;Auxiliary Reg 0
PC:             EQU     0x6F                    ;Program Counter
PC_COPY:        EQU     0x6E
STATUS:         EQU     0x6D                    ;Statis Register
RPT:            EQU     0x6C                    ;repeat counter location
SPSH:           EQU     0x6B                    ;stack push
SPOP:           EQU     0x6A                    ;stack pop
SNOP:           EQU     0x69                    ;stack read or write without SP modification
SP:             EQU     0x68
LPCNT1:         EQU     0x67                    ;H/W loop counter 1
LPCNT0:         EQU     0x66                    ;H/W loop counter 0
TIMER:          EQU     0x65                    ;timer
CREG:           EQU     0x64                    ;CREG for FMA and DOT
CAPTURE3:       EQU     0x63                    ;alternate delayed exception capture register 3
CAPTURE2:       EQU     0x62                    ;alternate delayed exception capture register 2
CAPTURE1:       EQU     0x61                    ;alternate delayed exception capture register 1
CAPTURE0:       EQU     0x60                    ;alternate delayed exception capture register 0
INTEN:          EQU     0x5F                    ;IRQ_in[15:0] (first 16 MSBs) & interrupt enable register (lower 16 LSBs)
DMA0_CSR:       EQU     0x5E                    ;DMA_Done is DMAn_CSR[21], interrupt enable is DMAn_CSR[20], 20-bit count value {DMAn_CSR[19:0]}
DMA0_RDADDRS:   EQU     0x5D                    ;DMA0 reads from DataPool
DMA0_WRADDRS:   EQU     0x5C                    ;DMA0 writes to GPU
VECTOR:         EQU     0x5B                    ;2 MSBs contain GPU count and 4 LSBs contain interrupt vector offset

;zero-page storage
byte:           EQU     0x01                    
short:          EQU     0x02
word:           EQU     0x03
work_4:         EQU     0x04
work_5:         EQU     0x05
capt0_save:     EQU     0x06                    ;alternate delayed exception capture register 0 save location
capt1_save:     EQU     0x07                    ;alternate delayed exception capture register 1 save location
capt2_save:     EQU     0x08                    ;alternate delayed exception capture register 2 save location
capt3_save:     EQU     0x09                    ;alternate delayed exception capture register 3 save location
src_save:       EQU     0x0A                    ;used to save source pointer
triDivXn:       EQU     0x0B                    ;number of triangles per quad-shader GPU, not counting remainder
remndr:         EQU     0x0C                    ;remainder of total triangles/n threads, must add one additional triangle to 
                                                ;the triangles/n amount for each thread until the remainder runs out                                                
sign_mask:      EQU     0x0E                    ;0x80000000 goes here--used for setting, clearing, toggling sign bit
                                                                                                                                
;constant immediate value equates
DONE_BIT:       EQU     0x20                    ;bit [5] is DONE Bit in status register 


offset:         EQU     0x00800000              ;offset needed to access program memory space decode

                org     0x00000000              ;program memory starts here
CLRgpuRSTmask:  dfl     0xF0FFFFFF              ;use this mask to clear all four GPU resets

test_RAM_start: dfl     0x00008000              ;start of test RAM
test_RAM_depth: dfl     0x00001000              ;depth of test RAM in bytes
test_byte:      dfl     0x000000A5              ;value for testing bytes
test_short:     dfl     0x00005A6E              ;value for testing short integer
test_word:      dfl     0xA5EC5321              ;value for testing word
word_incr:      dfl     0x04000000              ;word increment amount for byte memory
short_incr:     dfl     0x02000000              ;short increment amount for byte memory
byte_incr:      dfl     0x01000000              ;byte increment amount for byte memory
fill_Fs_8:      dfl     0x000000FF              
fill_Fs_16:     dfl     0x0000FFFF
fill_Fs_32:     dfl     0xFFFFFFFF
fill_0s_8:      dfl     0xFFFFFF00
fill_0s_16:     dfl     0xFFFF0000
fill_0s_32:     dfl     0x00000000        
            
            org     0x0FE              

Constants:  DFL     start                       ;program memory locations 0x000 - 0x0FF reserved for look-up table
        
prog_len:   DFL     progend - Constants
              
;           func    dest, srcA, srcB 

            org     0x00000100
RST_VECT:   mov     PC, #start              ;reset vector
NMI_VECT:   mov     PC, #NMI_               ;NMI vector
INV_VECT:   mov     PC, #INV_               ;invalid operation exception vector location
DIVx0_VECT: mov     PC, #DIVx0_             ;divide by 0 exception vector location
OVFL_VECT:  mov     PC, #OVFL_              ;overflow exception vector location
UNFL_VECT:  mov     PC, #UNFL_              ;underflow exception vector location
INEXT_VECT: mov     PC, #INEXT_             ;inexact exception vector location
IRQ_VECT:   mov     PC, #IRQ_               ;maskable general-purpose interrupt vector

start:     
            
    ;entry point to the 3D transform CGS routine                
    ;determine number of threads available
            mov     SP, #0x3F
            mov     AR0, @byte_incr
            mov     AR0, @test_RAM_start
            xor     STATUS, STATUS, #DONE_BIT                   
            mov     byte, @test_byte
            mov     short, @test_short
            mov     word, @test_word
            mov     LPCNT0, #0x080
byte_loop:  mov.b     *AR0, byte
            nop
            nop
            mov.b     work_4, *AR0        ;read it back and store in work_4
            nop
            nop
            and     work_4, work_4, #0x000000FF
            sub     work_4, work_4, byte
            btbc    fail_1, 0, STATUS
            mov.b     *AR0, @fill_Fs_8
            nop
            nop
            mov.b     work_4, *AR0++
            nop
            nop            
            and     work_4, work_4, #0x000000FF
            sub     work_4, @fill_Fs_8, work_4
            btbc    fail_1, 0, STATUS
            dbnz    byte_loop, LPCNT0
            
            mov     AR0, @byte_incr
            mov     AR0, @test_RAM_start
            nop            
            mov     LPCNT0, #0x080
short_loop: mov.h     *AR0, short
            nop
            nop
            mov.h     work_4, *AR0        ;read it back and store in work_4
            nop
            nop
            sub     work_4, work_4, short
            btbc    fail_1, 0, STATUS
            mov.h     *AR0, @fill_0s_16
            nop
            nop
            mov.h     work_4, *AR0++
            nop
            nop
            sub     work_4, work_4, #0
            btbc    fail_1, 0, STATUS
            dbnz    short_loop, LPCNT0

            mov     AR0, @byte_incr
            mov     AR0, @test_RAM_start
            nop            
            mov     LPCNT0, #0x080
word_loop:  mov     *AR0, word
            nop
            nop
            mov     work_4, *AR0        ;read it back and store in work_4
            nop
            nop
            sub     work_4, work_4, word
            btbc    fail_1, 0, STATUS
            mov     *AR0, @fill_Fs_32
            nop
            nop
            mov     work_4, *AR0++
            nop
            nop            
            sub     work_4, @fill_Fs_32, work_4
            btbc    fail_1, 0, STATUS
            dbnz    word_loop, LPCNT0

            
fail_1:     or      STATUS, STATUS, #DONE_BIT       ;set CPU done bit to signal test bench processing has completed
            bcnd    fail_1, ALWAYS
            
done:       or      STATUS, STATUS, #DONE_BIT       ;set CPU done bit to signal test bench processing has completed
            mov     PC, #done                       ;spin here  
          
; ---------------------- interrupt/exception service routines ---------------------------------------------        
NMI_:       mov     *SP--, PC_COPY               ;save return address from non-maskable interrupt (time-out timer in this instance)
            mov     TIMER, #10000                   ;put a new value in the timer
            mov     PC, *SP++                    ;return from interrupt
        
INV_:       mov     *SP--, PC_COPY       ;save return address from floating-point invalid operation exception, which is maskable
            mov     TIMER, #10000           ;put a new value in the timer
            mov     work_5, SQRT_1          ;retrieve the NaN with payload (this quiet NaN replaced the signaling NaN that caused the INV exc)
            mov     PC, *SP++            ;return from interrupt
            
DIVx0_:     mov     *SP--, PC_COPY     ;save return address from floating-point divide by 0 exception, which is maskable
            mov     capt0_save, CAPTURE0    ;read out CAPTURE0 register and save it
            mov     capt1_save, CAPTURE1    ;read out CAPTURE1 register and save it
            mov     capt2_save, CAPTURE2    ;read out CAPTURE2 register and save it
            mov     capt3_save, CAPTURE3    ;read out CAPTURE3 register and save it
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, *SP++          ;return from interrupt

OVFL_:      mov     *SP--, PC_COPY      ;save return address from floating-point overflow exception, which is maskable
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, *SP++           ;return from interrupt

UNFL_:      mov     *SP--, PC_COPY      ;save return address from floating-point underflow exception, which is maskable
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, *SP++           ;return from interrupt

INEXT_:     mov     *SP--, PC_COPY      ;save return address from floating-point inexact exception, which is maskable
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, *SP++           ;return from interrupt

IRQ_:       mov     *SP--, PC_COPY    ;save return address (general-purpose, maskable interrupt)
            mov     TIMER, #10000           ;put a new value in the timer
            mov     PC, *SP++         ;return from interrupt
            
pointers:       org $ 
            

text_in:        org     $200                   ;this is where the text file is first loaded by test bench
                
                
text_out:       org     $300                   ;this is where results are written back from 8-bit aligned memory

progend:        
            end



