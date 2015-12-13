           CPU  "aSYMPL32.TBL"
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
LPCNT1:         EQU     0x69                    ;H/W loop counter 1
LPCNT0:         EQU     0x68                    ;H/W loop counter 0
TIMER:          EQU     0x67                    ;timer
RPT:            EQU     0x64                    ;repeat counter location
DMA1_CSR:       EQU     0x62                    ;DMA_Done is DMAn_CSR[21], interrupt enable is DMAn_CSR[20], 20-bit count value {DMAn_CSR[19:0]} 
DMA1_RDADDRS:   EQU     0x61                    ;DMA1 reads from GPU
DMA1_WRADDRS:   EQU     0x60                    ;DMA1 writes to DataPool
FRC_IRQ:        EQU     0x5F
DMA0_CSR:       EQU     0x5E                    ;DMA_Done is DMAn_CSR[21], interrupt enable is DMAn_CSR[20], 20-bit count value {DMAn_CSR[19:0]}
DMA0_RDADDRS:   EQU     0x5D                    ;DMA0 reads from DataPool
DMA0_WRADDRS:   EQU     0x5C                    ;DMA0 writes to GPU
DONE_IE:        EQU     0x5B                    ;thread[15:0] Done & interrupt enable register
COMMAND:        EQU     0x5A                    ;command register


;zero-page storage
NMI_save        EQU     0x01                    ;save PC_COPY here immediately upon entry to NMI service routine
EXC_save        EQU     0x02                    ;save PC_COPY here immediately upon entry to EXC service routine
IRQ_PC_save     EQU     0x03                    ;save PC_COPY here immediately upon entry to general-purpose IRQ service routine
work_1:         EQU     0x14                    
work_2:         EQU     0x15
work_3:         EQU     0x16
work_4:         EQU     0x17
triDivXn:       EQU     0x18                    ;number of triangles per thread, not counting remainder
remndr:         EQU     0x19                    ;remainder of total triangles/n threads, must add one additional triangle to 
                                                ;the triangles/n amount for each thread until the remainder runs out
threads:        EQU     0x1A                    ;this location will contain the initial number of threads available for this implementation                                                
                                                
sign_mask:      EQU     0x1E                    ;0x80000000 goes here--used for setting, clearing, toggling sign bit

;for storage of parameters for 3D transform
cmnd_save:      EQU     0x1F                    ;command save location
triangles:      EQU     0x20                    ;total number of triangles to process
PDB_list:       EQU     0x2000                  ;pointer to start of PDB list in CGS ROM via indirect table-read

XFORM_XYZ:      EQU     0x010E                  ;this is the command to issue to the shader threads to execute from
                                                ;to carry out the 3D transform on all three axis, which includes
                                                ;scale_xyz, rotate_xyz, translate_xyz

;constant immediate value equates
DONE_BIT:   EQU     0x20                        ;bit [5] is DONE Bit in status register 
DONE_15:    EQU     31                          ;done bit position in DONE_IE register.  When tested, if==1, then this is a four-shader implementation
DONE_7:     EQU     23                          ;done bit position in DONE_IE register.  When tested, if==1, then this is a two-shader implementation
                                                ;assuming DONE_15 is 0

;pointers to first location in each PDB
                org     0x0000
PDB0:           DFL     0x00010000              ;parameter-data buffer shader0 thread0
PDB1:           DFL     0x00010400              ;parameter-data buffer shader0 thread1
PDB2:           DFL     0x00010800              ;parameter-data buffer shader0 thread2
PDB3:           DFL     0x00010C00              ;parameter-data buffer shader0 thread3
PDB4:           DFL     0x00012000              ;parameter-data buffer shader1 thread0
PDB5:           DFL     0x00012400              ;parameter-data buffer shader1 thread1
PDB6:           DFL     0x00012800              ;parameter-data buffer shader1 thread2
PDB7:           DFL     0x00012C00              ;parameter-data buffer shader1 thread3
PDB8:           DFL     0x00014000              ;parameter-data buffer shader2 thread0
PDB9:           DFL     0x00014400              ;parameter-data buffer shader2 thread1
PDB10:          DFL     0x00014800              ;parameter-data buffer shader2 thread2
PDB11:          DFL     0x00014C00              ;parameter-data buffer shader2 thread3
PDB12:          DFL     0x00016000              ;parameter-data buffer shader3 thread0
PDB13:          DFL     0x00016400              ;parameter-data buffer shader3 thread1
PDB14:          DFL     0x00016800              ;parameter-data buffer shader3 thread2
PDB15:          DFL     0x00016C00              ;parameter-data buffer shader3 thread3

;SYSTEM memory (data pool) pointers
SYSMEMstart:    DFL     0x00020000              ;system memory start location mapped to CGS physical location 0x00010000
TOTALtri:       DFL     0x00020001              ;total number of triangles to count
SCALX:          DFL     0x00020002              ;scale X, first in the list of the 9 xformation parameters
FIRSTtri:       DFL     0x0002000B              ;this is the location in SYSMEM containing first X1 of first triangle
CLRshdrRSTmask: DFL     0xFFFF0FFF              ;use this mask to clear all Shader resets
swapDMAbytes:   DFL     0x20000000              ;use this mask to set DMA "swap_bytes" bit to convert from little endian to big
cool_feed:      DFL     0xC001FEED              ;semaphore for tell CPU we are done processing

;DESCRIPTION
;This coarse-grained scheduler (CGS) routine simply polls the COMMAND register for a value that is not zero.
;If the value is not zero, it is a command.  Presently, the convention is that the command value is the entry-point
;for the routine that will carry it out.  Once the CGS receives a command, it loads the PC with that value, which is
;the entry point for the routine.  Since this example has only one command, no need to refer to a look-up table
;for corresponding entry-points for the shader threads to run to carry out the command.  In this instance, the 
;command that the shader threads must execute to carry out the overall command is "0x010E, which is their respective
;entry-point.
;
;So, now that the CGS has received the command, it then does a simple calculation to determine how many triangles 
;each shader thread is to receive.  This is done by dividing the triangle count in the datapool parameter buffer
;by the number of available threads.  For example, in this instance, there are 252 triangles that make up the "olive".
;Thus, for a single shader with four available threads, this means that each thread will receive 64 triangles to process.
;For two shaders with eight available threads, this means that four threads will receive 32 triangles and four will
;receive 31 triangles.
;
;Once this calulation is made, the CGS then pushes into each thread's private parameter-data buffer (PDB) the triangle count,
;all nine parameters and then the triangles, each comprising a vector made up of nine single-precision, 32-bit floats
;for {x1,y1,z1,x2,y2,z2,x3,y3,z3}.  For the parameters and triangle count, the CGS does this itself.  For the actual
;triangle vectors, it employs DMA channel 0 to transfer triangle vectors from datapool to individual thread PDBs.
;
;Once the triangle count, parameters, and vectors are pushed into each thread's PDB, it issues each thread a command.
;Note that latency can be reduced by issuing a command to the respective thread immediately after that thread's push
;has been completed, rather than wait until after all threads have been pushed.  In fact, in this instance, the command
;can be given immediately after a given thread's parameters have been pushed, because the triangle vectors are pushed
;using DMA0 and the thread will not be able to out-read (i.e., outrun), the DMA writes.
;
;Once the triangles are pushed and the commands issued, the CGS then polls the DONE flags for each thread.  When determined
;that a particular thread is finished processing, the CGS then uses DMA channel 1 to pull results out of that particular
;thread's PDB and transfer them back to the datapool at the same locations the originals came from.
;
;Finally, once all thread processing is complete, the CGS then writes the value "0xC001FEED" to datapool location 0x0000
;to signal the CPU that results are available.  It then jumps back to the beginning of the program and begins polling the 
;command register for another command to process.
;
;It should be noted here that the COMMAND buffer (external system) write-side is mapped to datapool physical location 0x0000.  
;The read-side is mapped to CGS location 0x005A.  The CGS COMMAND register is a separate, physical register that shadows
;location 0x0000 of the datapool and is automatically self-cleared when the CGS reads it.  Thus, when the CGS writes to 
;location 0x0000 with the 0xC001FEED (processing complete) semaphore, it is written to datapool SRAM location 0x0000 and not  
;the COMMAND register, thus the CGS will not fall through again when it makes its jump back to DONE.
            
            org     0x0FE              

Constants:  DFL     start                       ;program memory locations 0x000 - 0x0FF reserved for look-up table
        
prog_len:   DFL     progend - Constants
              
;           func    dest, srcA, srcB 

            org     0x00000100
RST_VECT:   mov     PC, #done                   ;reset vector
NMI_VECT:   mov     PC, #NMI_                   ;NMI vector
EXC_VECT:   mov     PC, #EXC_                   ;EXC_VECT
IRQ_VECT:   mov     PC, #IRQ_                   ;maskable general-purpose interrupt vector
done:       or      STATUS, STATUS, #DONE_BIT   ; signal external CPU (load-balancer/coarse-grain scheduler) process is done
                                                ;note that the DONE_BIT is already set upon initial entry but is cleared three instructions below "start"
                                                ;to signal CPU thread has started (ie, not done)        
spin:       mov     cmnd_save, COMMAND          ;read CGS command register located at 0x05A and save it 
            bcnd    spin, Z                     ;if command is 0 then wait for this value to become non-zero
            mov     TIMER, #40000               ;load time-out timer with sufficient time to get the job done 
            mov     AR3, @SYSMEMstart           ;point to first location in datapool memory
            mov     *AR3, #0                    ;clear this location to signal CPU that command is acknowledged and processing has begun 
            mov     PC, cmnd_save               ;write the received command to PC, this is the command entry point
            
    ;entry point to the 3D transform CGS routine            
start:      mov     cmnd_save, #XFORM_XYZ       ;this is the command that will be issued to each thread of each shader
    ;determine number of threads available
            mov     AR0, @TOTALtri              ;point to total number of triangles to process
            mov     AR1, #PDB_list              ;load AR1 with pointer to PDB list (via CGS indirect table-read) 
            xor     STATUS, STATUS, #DONE_BIT   ;clear done bit to indicate command received and is now being processed--execution order is important to give load AR0 time to execute before use
            mov     triangles, *AR0++           ;get total triangle count and save in "triangles" and update AR0 to point to SCALX in parameter list 
is_it_16:   btbc    is_it_8, DONE_15, DONE_IE   ;test done bit for thread15.  If==1 then 16 threads avialable (four-shader version) 
            mov     threads, #16
            shft    triDivXn, triangles, RIGHT, 4    ;divide total triangles x16 to determine number of triangles per thread
            bcnd    initialize, ALWAYS          
is_it_8:    btbc    its_4, DONE_7, DONE_IE      ;test done bit for thread7.   If==1 then 8 theads available (two-shader version).
            mov     threads, #8                 
            shft    triDivXn, triangles, RIGHT, 3    ;divide total triangles x8 to determine number of triangles per thread
            bcnd    initialize, ALWAYS          
its_4:      mov     threads, #4                 ;else there are 4 threads available (one-shader version)
            shft    triDivXn, triangles, RIGHT, 2    ;divide total triangles x4 to determine number of triangles per thread
initialize: mov     LPCNT0, threads             ;load loop counter 0 with number of threads that need to be passed parameters and data
            mul     work_2, triDivXn, threads   ;multiply result to get integer multiple
            and     STATUS, @CLRshdrRSTmask, STATUS ;clear shader3, 2, 1, 0 reset lines
            sub     remndr, triangles, work_2   ;get remainder to be distributied one additional triangle per thread until remainder depleated
            mov     DMA0_RDADDRS, @FIRSTtri     ;point to first triangle in datapool
            mov     work_3, remndr              ;save original remainder                      
xferLoop:   add     AR2, *AR1, #1               ;load AR2 with pointer to current PDB (+1) to receive the transfer of parameters and data
                                                ;so that AR2 is pointing to triangle count for that thread's PDB
            mov     work_1, triDivXn            ;might need to do some math with triDivXn so make a copy
            mov     remndr, remndr              ;copy/save remndr to itself to check for zero
            bcnd    no_add, Z                   ;if remainder is zero then don't add one more this time
            add     work_1, work_1, #1          ;else add one to it to get total triangles for this thread and store in LPCNT1
            sub     remndr, remndr, #1          ;and subtract one from remainder
;
;--------------transfer parameters to each thread's PDB --------------------------------------------------------
;
no_add:     mov     *AR2++, work_1              ;copy number of triangles this thread is to process
            rpt     #8                          ;copy the qty (9) 3D transform parameters to current PDB using repeat instruction
            mov     *AR2++, *AR0++              ;copy SCALX to current PDB
;            mov     *AR2++, *AR0++              ;copy SCALY to current PDB
;            mov     *AR2++, *AR0++              ;copy SCALZ to current PDB
;            mov     *AR2++, *AR0++              ;copy ROTX to current PDB
;            mov     *AR2++, *AR0++              ;copy ROTY to current PDB
;            mov     *AR2++, *AR0++              ;copy ROTZ to current PDB
;            mov     *AR2++, *AR0++              ;copy TRANSX to current PDB
;            mov     *AR2++, *AR0++              ;copy TRANSY to current PDB
;            mov     *AR2++, *AR0++              ;copy TRANSZ to current PDB
            mov     AR0, @SCALX                 ;re-initialize AR0 to point to back to parameter portion of the job request 
;            
;--------------transfer vector data from data pool to each thread's PDB -------------------------------------------            
;
triLoop:    mov     DMA0_WRADDRS, AR2           ;point to destination in thread's private PDB for first X1 of first triangle
            mul     work_4, work_1, #9          ;determine length of DMA transfer
;            or      DMA0_CSR, @swapDMAbytes, work_4  ;transfer entire vector for all triangles for current PDB, little endian 
            mov      DMA0_CSR, work_4           ;transfer entire vector for all triangles for current PDB, endian-ness unchanged 
            mov     AR2, *AR1++                 ;point back to first location in PDB, which is that thread's start address and semaphore location
wait0:      btbc    wait0, 31, DMA0_CSR         ;wait for transfer to complete
            mov     *AR2, cmnd_save             ;write start address (semaphore) to current PDB                                              
            dbnz    xferLoop, LPCNT0            ;xfer next group of parameters and data to next PDB until entire 3D object is loaded
;
;--------------transfer results from PDBs back to data pool---------------------------------------------------------
;
            mov     remndr, work_3              ;copy work_3 into remainder to restore it
            mov     LPCNT0, threads             ;load LPCNT0 with number of PDBs to copy back to SYSMEM
wait1:      btbc    wait1, 18, DONE_IE          ;wait until thread1 is done then pull results from each PDB and store in SYStem memory
            mov     AR1, #PDB_list              ;point to first location in first PDB (PDB0) 
            mov     DMA1_WRADDRS, @FIRSTtri     ;datapool destination address
nextPDB:    add     DMA1_RDADDRS, *AR1++, #11   ;thread private PDB address
            mov     work_1, triDivXn            ;copy number of triangles per thread to work_1
            mov     remndr, remndr              ;see if remainder is zero
            bcnd    copyPDB, Z                  ;if zero then don't add one more from remainder
            add     work_1, work_1, #1
            sub     remndr, remndr, #1          ;sub 1
copyPDB:    mul     work_4, work_1, #9          ;determine length of DMA transfer
;            or      DMA1_CSR, @swapDMAbytes, work_4  ;transfer entire result vector from PDB back to datapool, big endian
            mov      DMA1_CSR,  work_4          ;transfer entire result vector from PDB back to datapool, endian-ness unchanged
wait2:      btbc    wait2, 31, DMA1_CSR         ;wait for transfer to complete
            dbnz    nextPDB, LPCNT0             ;pull next PDB
            mov     AR3, @SYSMEMstart           ;point to first location in datapool
            mov     *AR3, @cool_feed            ;tell CPU we are done processing  
            mov     PC, #done                   ;jump to done, semphr test and spin for next packet
            
; interrupt service routines        
NMI_:       mov     NMI_save, PC_COPY           ;save return address from non-maskable interrupt (time-out timer in this instance)
            mov     TIMER, #10000               ;put a new value in the timer
            mov     PC, NMI_save                ;return from interrupt
        
EXC_:       mov     EXC_save, PC_COPY           ;save return address
            mov     TIMER, #10000               ;put a new value in the timer
            mov     PC, EXC_save                ;return from interrupt

IRQ_:       mov     IRQ_PC_save, PC_COPY        ;save return address (general-purpose, maskable interrupt)
            mov     TIMER, #10000               ;put a new value in the timer
            mov     PC, IRQ_PC_save             ;return from interrupt            
progend:        
            end
          
    
