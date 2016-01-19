           CPU  "SYMPL_IL.TBL"
           HOF  "MOT32"
           WDLN 4
; SYMPL RISC CPU 3D TRANSFORM driver
; version 1.02   January 12, 2016
; Author:  Jerry D. Harthcock
; Copyright (C) 2016.  All rights reserved without prejudice.
           
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
work_1:         EQU     0x01                    
work_2:         EQU     0x02
work_3:         EQU     0x03
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
GPUs:           EQU     0x0D                    ;this location will contain the initial number of quad-shader GPUs available for this implementation                                                
                                                
;constant immediate value equates
sign_mask:      EQU     0x0E                    ;0x80000000 goes here--used for setting, clearing, toggling sign bit
triangles:      EQU     0x0F                    ;total number of triangles to process
XFORM_XYZ:      EQU     0x010B                  ;this is the command to issue to the GPU to execute from                        
DONE_BIT:       EQU     0x20                    ;bit [5] is DONE Bit in status registes
 
offset:         EQU     0x00800000              ;offset needed to access program memory space decode

                org     0x00000000              ;program memory starts here
CLRgpuRSTmask:  dfl     0xF0FFFFFF              ;use this mask to clear all four GPU resets

datapool_list:  dfl     GPU0_datapool + offset  ;pointer to first GPU datapool
firstTri_list:  dfl     FIRSTtriGPU0 + offset   ;pointer to first GPU first triangle
              
;pointer table for data memory access to ("filtered") .stl file in program/data memory
stl_file: 	    dfl     stl_start + offset      ;pointer to the start of the .stl file that has been loaded into program/data memory
trans_param:    dfl     parameters + offset     ;pointer to parameters for this particular 3D transform
stl_tri_count:  dfl     tri_count + offset      ;pointer to location in .stl file containing number of triangles in the file
stl_first_tri:  dfl     first_tri + offset      ;pointer to first x1 in first triangle vector, i.e., (x1, y1, z1, x2, y2, z2, x3, y3, z3)
            
            org     0x0FE              

Constants:  DFL     start                       ;program memory locations 0x000 - 0x0FF reserved for look-up table
        
prog_len:   DFL     progend - Constants
              
;           type  dest = OP:(srcA, srcB) 

            org     0x00000100
RST_VECT:   w     PC = #start              ;reset vector
NMI_VECT:   w     PC = #NMI_               ;NMI vector
INV_VECT:   w     PC = #INV_               ;invalid operation exception vector location
DIVx0_VECT: w     PC = #DIVx0_             ;divide by 0 exception vector location
OVFL_VECT:  w     PC = #OVFL_              ;overflow exception vector location
UNFL_VECT:  w     PC = #UNFL_              ;underflow exception vector location
INEXT_VECT: w     PC = #INEXT_             ;inexact exception vector location
IRQ_VECT:   w     PC = #IRQ_               ;maskable general-purpose interrupt vector

    ;entry point to the 3D transform CGS routine                
    ;determines number of threads available
    
;           type  dest = OP:(srcA, srcB) 
    
start:     
            w     AR0 = @stl_tri_count                   ;load AR0 with pointer to total number of triangles to process
            w     AR1 = @datapool_list                   ;load AR1 with pointer to pointer to first location of GPU0 datapool (from the list)
            w     TIMER = #40000                         ;load time-out timer with sufficient time to get the job done 
            w     STATUS = xor:(STATUS, #DONE_BIT)       ;clear CPU done bit to signal test bench processing has started
            w     triangles = *AR0                       ;get total triangle count and save in "triangles" and update AR0 to point to rotX in parameter list 
            w     src_save = @stl_first_tri              ;initialize src_save with pointer to first source triangle X1 location
is_it_4:          
                  if (INTEN:[19]==0) GOTO: is_it_2       ;test done bit for GPU3.  If==1 then 4 GPUs (16 shaders) avialable
            w     GPUs = #4
            w     triDivXn = SHIFT:(triangles, RIGHT, 2) ;divide total triangles x4 to determine number of triangles per GPU
                  GOTO initialize          
is_it_2:          
                  if (INTEN:[17]==0) GOTO: its_1         ;test done bit for GPU2.   If==1 then 2 GPUs (8 shaders) available.
            w     GPUs = #2                 
            w     triDivXn = SHIFT:(triangles, RIGHT, 1) ;divide total triangles x2 to determine number of triangles per GPU
                  GOTO  initialize          
its_1:      w     GPUs = #1                              ;else there is only one GPU (4 shaders) available
            w     triDivXn = triangles             
initialize:       
                  for (LPCNT0 = GPUs) (                  ;load loop counter 0 with number of GPUs that need to be passed parameters and data
            w       work_2 = mul:(triDivXn, GPUs)        ;multiply result to get integer multiple
            w       STATUS = and:(@CLRgpuRSTmask, STATUS);clear GPU3, 2, 1, 0 reset lines
            w       remndr = sub:(triangles, work_2)     ;get remainder to be distributied one additional triangle per GPU until remainder depleated
            w       work_3 = remndr                      ;save original remainder 
                                   
xferLoop:   w       AR0 = @trans_param                   ;load AR0 with pointer to parameter list
            w       AR2 = add:(*AR1, #1)                 ;load AR2 with pointer to current datapool (+1) to receive the transfer of parameters and data
                                                         ;so that AR2 is pointing to triangle count for that thread's datapool 
            w       work_1 = triDivXn                    ;might need to do some math with triDivXn so make a copy
            w       remndr = remndr                      ;copy/save remndr to itself to check for zero
                    if (Z==1) GOTO:  no_add              ;if remainder is zero then don't add one more this time
            w       work_1 = add:(work_1, #1)            ;else add one to it to get total triangles for this thread and store in LPCNT1
            w       remndr = sub:(remndr, #1)            ;and subtract one from remainder
;
;--------------transfer parameters to each GPU's datapool --------------------------------------------------------
;
no_add:     w       AR3 = mul:(work_1, #9)               ;load AR3 with number of triangles for the current GPU
            w       *AR2++ = work_1                      ;copy into this GPU's datapool the number of triangles this GPU is to process 
            w       AR3 = sub:(AR3, #1)                  ;adjust AR3 for use as immediate value for rpt (rpt does not include the first execute, since it is "repeat")
                    REPEAT #8                            ;copy the qty (9) 3D transform parameters to current PDB using repeat instruction
            w       *AR2++ = *AR0++                      ;copy SCALX, SCALY, SCALZ, ROTX, ROTY, ROTZ, TRANSX, TRANSY, TRANSZ to this GPU's datapool
                                                         ;after execution of RPT, AR2 is now pointing to first X1 dest and AR0 is now pointing to first X1 source
            w       AR0 = src_save                       ;load AR0 with source pointer to first triangle
                    nop                                  ;give AR0 time to load before use two more clocks downstream from here
;            
;--------------transfer vector data from program memory to each GPU's datapool -----------------------------------            
;
triLoop:            REPEAT [AR3]                         ;copy contents of AR3 into repeat counter [...] means immediately available
            w       *AR2++ = *AR0++                      ;transfer input vector (ie, X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3)
            
            w       src_save = AR0                       ;save pointer to next triangle source location
            w       AR2 = *AR1++                         ;point back to first location in this GPU's datapool (command input register)
                                                         ;after execution, AR1 is now pointing to next GPU's datapool pointer
            w       *AR2 = #XFORM_XYZ                    ;write start address (command semaphore) to current datapool                                              
                NEXT LPCNT0 GOTO: xferLoop )             ;xfer next group of parameters and data to next PDB until entire 3D object is loaded
wait1:          
                if (INTEN:[16]==1) GOTO: wait1           ;wait for GPU0 done bit to go low indicating it has begun processing
;
;--------------transfer results from datapool(s) back to program memory-------------------------------------------
;
            w   remndr = work_3                          ;copy work_3 into remainder to restore it
                for (LPCNT0 = GPUs) (                    ;load LPCNT0 with number of PDBs to copy back to program memory
wait2:  
                  if (INTEN:[16]==0) GOTO: wait2         ;wait until GPU0 is done then pull results from each GPU datapool and store in program memory at original locations
            w     AR1 = @firstTri_list                   ;load AR1 with pointer to pointer for first triangle of current GPU datapool to be read out
            w     AR2 = @stl_first_tri                   ;load AR2 with pointer to first triangle dest location of .stl file in program memory
nextDPool:  
            w     work_1 = triDivXn                      ;copy number of triangles per thread to work_1
            w     remndr = remndr                        ;see if remainder is zero
                  if (Z==1) GOTO: copyDPool              ;if zero then don't add one more from remainder
            w     work_1 = add:(work_1, #1)
            w     remndr = sub:(remndr, #1)              ;sub 1
copyDPool:  
            w     AR3 = mul:(work_1, #9)                 ;determine length of transfer
            w     AR0 = *AR1++                           ;copy pointer for GPU0 datapool first triangle location to AR0 then make AR1 point to next datapool for next pass (if any) 
            w     AR3 = sub:(AR3, #1)                    ;subtract 1 since RPT following instruction is executed then repeated n times
                  nop                                    ;sub needs time to execute before AR3 results are available for use by RPT
                  REPEAT [AR3]                           ;execute the following instruction, then repeat the execution specified times after that
            w     *AR2++ = *AR0++                        ;transfer result vector (ie, X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3) 
                NEXT LPCNT0 GOTO: nextDPool )            ;pull next datapool results (if any)
            w   STATUS = or:(STATUS, #DONE_BIT)          ;set CPU done bit to signal test bench processing has completed
done:       
            w   PC = #done                               ;spin here  
          
; ---------------------- interrupt/exception service routines ---------------------------------------------        
NMI_:       w   *SP-- = PC_COPY                         ;save return address from non-maskable interrupt (time-out timer in this instance)
            w   TIMER = #10000                          ;put a new value in the timer
            w   PC = *SP++                              ;return from interrupt
        
INV_:       w   *SP-- = PC_COPY                         ;save return address from floating-point invalid operation exception, which is maskable
            w   TIMER = #10000                          ;put a new value in the timer
            w   work_5 = SQRT_1                         ;retrieve the NaN with payload (this quiet NaN replaced the signaling NaN that caused the INV exc)
            w   PC = *SP++                              ;return from interrupt
            
DIVx0_:     w   *SP-- = PC_COPY                         ;save return address from floating-point divide by 0 exception, which is maskable
            w   capt0_save = CAPTURE0                   ;read out CAPTURE0 register and save it
            w   capt1_save = CAPTURE1                   ;read out CAPTURE1 register and save it
            w   capt2_save = CAPTURE2                   ;read out CAPTURE2 register and save it
            w   capt3_save = CAPTURE3                   ;read out CAPTURE3 register and save it
            w   TIMER = #10000                          ;put a new value in the timer
            w   PC = *SP++                              ;return from interrupt

OVFL_:      w   *SP-- = PC_COPY                         ;save return address from floating-point overflow exception, which is maskable
            w   TIMER = #10000                          ;put a new value in the timer
            w   PC = *SP++                              ;return from interrupt

UNFL_:      w   *SP-- = PC_COPY                         ;save return address from floating-point underflow exception, which is maskable
            w   TIMER = #10000                          ;put a new value in the timer
            w   PC = *SP++                              ;return from interrupt

INEXT_:     w   *SP-- = PC_COPY                         ;save return address from floating-point inexact exception, which is maskable
            w   TIMER = #10000                          ;put a new value in the timer
            w   PC = *SP++                              ;return from interrupt

IRQ_:       w   *SP-- = PC_COPY                         ;save return address (general-purpose, maskable interrupt)
            w   TIMER = #10000                          ;put a new value in the timer
            w   PC = *SP++                              ;return from interrupt
            

                org     $                   ;this is the offset in data memory where these pointers can be accessed from program memory
GPU0_datapool:  dfl     0x00FC0000          ;First location of GPU0 datapool (also the command register for GPU0
GPU1_datapool:  dfl     0x00FD0000          ;First location of GPU1 datapool (also the command register for GPU1
GPU2_datapool:  dfl     0x00FE0000          ;First location of GPU2 datapool (also the command register for GPU2
GPU3_datapool:  dfl     0x00FF0000          ;First location of GPU3 datapool (also the command register for GPU3

FIRSTtriGPU0:   dfl     0x00FC000B          ;this is the location in GPU0 datapool containing first triangle X1
FIRSTtriGPU1:   dfl     0x00FD000B          ;this is the location in GPU1 datapool containing first triangle X1
FIRSTtriGPU2:   dfl     0x00FE000B          ;this is the location in GPU2 datapool containing first triangle X1
FIRSTtriGPU3:   dfl     0x00FF000B          ;this is the location in GPU3 datapool containing first triangle X1


stl_start:  org     0x00000200              ; test .stl file and parameters are loaded starting at this address
tri_count:  org     $+1
;parameters for this particular 3D transform test run
parameters: org     $+1
rotx:       dfl     29                      ;rotate around x axis in integer degrees  
roty:       dfl     44                      ;rotate around y axis in integer degrees  
rotz:       dfl     75                      ;rotate around z axis in integer degrees  
scalx:      dff     2.0                     ;scale X axis amount real
scaly:      dff     2.0                     ;scale y axis amount real
scalz:      dff     2.25                    ;scale Z axis amount real
transx:     dff     4.75                    ;translate on X axis amount real
transy:     dff     3.87                    ;translate on Y axis amount real
transz:     dff     2.237                   ;translate on Z axis amount real

;rotx:      dfl     0                       ;rotate around x axis in integer degrees  
;roty:      dfl     0                       ;rotate around y axis in integer degrees  
;rotz:      dfl     0                       ;rotate around z axis in integer degrees  
;scalx:     dff     1.0                     ;scale X axis amount real
;scaly:     dff     1.0                     ;scale y axis amount real
;scalz:     dff     1.0                     ;scale Z axis amount real
;transx:    dff     0.0                     ;translate on X axis amount real
;transy:    dff     0.0                     ;translate on Y axis amount real
;transz:    dff     0.0                     ;translate on Z axis amount real
first_tri:  org     $



progend:        
            end



