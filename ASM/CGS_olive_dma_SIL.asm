           CPU  "SYMPL_IL.TBL"
           HOF  "MOT32"
           WDLN 4
; CGS 3D TRANSFORM DEMO Micro-Kernel
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
COMMAND:        EQU     0x64                    ;command register
FRC_IRQ:        EQU     0x63
DMA1_CSR:       EQU     0x62                    ;DMA_Done is DMAn_CSR[21], interrupt enable is DMAn_CSR[20], 20-bit count value {DMAn_CSR[19:0]} 
DMA1_RDADDRS:   EQU     0x61                    ;DMA1 reads from GPU
DMA1_WRADDRS:   EQU     0x60                    ;DMA1 writes to DataPool
DONE_IE:        EQU     0x5F                    ;thread[15:0] Done & interrupt enable register
DMA0_CSR:       EQU     0x5E                    ;DMA_Done is DMAn_CSR[21], interrupt enable is DMAn_CSR[20], 20-bit count value {DMAn_CSR[19:0]}
DMA0_RDADDRS:   EQU     0x5D                    ;DMA0 reads from DataPool
DMA0_WRADDRS:   EQU     0x5C                    ;DMA0 writes to GPU


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

Constants:  DFL     start                                    ;program memory locations 0x000 - 0x0FF reserved for look-up table
        
prog_len:   DFL     progend - Constants
              
;           type  dest = OP:(srcA, srcB) 

            org   0x00000100
RST_VECT:   w     PC = #done                                 ;reset vector
NMI_VECT:   w     PC = #NMI_                                 ;NMI vector
EXC_VECT:   w     PC = #EXC_                                 ;EXC_VECT
IRQ_VECT:   w     PC = #IRQ_                                 ;maskable general-purpose interrupt vector
done:       w     STATUS = or:(STATUS, #DONE_BIT)            ;signal external CPU (load-balancer/coarse-grain scheduler) process is done
                                                             ;note that the DONE_BIT is already set upon initial entry but is cleared three instructions below "start"
                                                             ;to signal CPU thread has started (ie, not done)        
spin:       w     cmnd_save = COMMAND                        ;read CGS command register located at 0x064 and save it 
                  if (Z==1) GOTO: spin                       ;if command is 0 then wait for this value to become non-zero
            w     TIMER = #40000                             ;load time-out timer with sufficient time to get the job done 
            w     AR3 = @SYSMEMstart                         ;point to first location in datapool memory
            w     *AR3 = #0                                  ;clear this location to signal CPU that command is acknowledged and processing has begun 
            w     PC = cmnd_save                             ;write the received command to PC, this is the command entry point
            
                  ;entry point to the 3D transform CGS routine            
start:      
            w     cmnd_save = #XFORM_XYZ                     ;this is the command that will be issued to each thread of each shader
                  ;determine number of threads available
            w     AR0 = @TOTALtri                            ;point to total number of triangles to process
            w     AR1 = #PDB_list                            ;load AR1 with pointer to PDB list (via CGS indirect table-read) 
            w     STATUS = xor:(STATUS, #DONE_BIT)           ;clear done bit to indicate command received and is now being processed--execution order is important to give load AR0 time to execute before use
            w     triangles = *AR0++                         ;get total triangle count and save in "triangles" and update AR0 to point to SCALX in parameter list 

is_it_16:         if (DONE_IE:[31]==0) GOTO: is_it_8         ;test done bit for thread15.  If==1 then 16 threads avialable (four-shader version)
            w     threads = #16
            w     triDivXn = shift:(triangles, RIGHT, 4)     ;divide total triangles x16 to determine number of triangles per thread
                  GOTO initialize
                            
is_it_8:          if (DONE_IE:[23]==0) GOTO: its_4            ;test done bit for thread7.   If==1 then 8 theads available (two-shader version).
            w     threads = #8                 
            w     triDivXn = shift:(triangles, RIGHT, 3)     ;divide total triangles x8 to determine number of triangles per thread
                  GOTO  initialize          
its_4:      
            w     threads = #4                               ;else there are 4 threads available (one-shader version)
            w     triDivXn = shift:(triangles, RIGHT, 2)     ;divide total triangles x4 to determine number of triangles per thread
            
initialize:       
                  for (LPCNT0 = threads) (                   ;load loop counter 0 with number of threads that need to be passed parameters and data
            w         work_2 = mul:(triDivXn, threads)       ;multiply result to get integer multiple
            w         STATUS = and:(@CLRshdrRSTmask, STATUS) ;clear shader3, 2, 1, 0 reset lines
            w         remndr = sub: (triangles, work_2)      ;get remainder to be distributied one additional triangle per thread until remainder depleated
            w         DMA0_RDADDRS = @FIRSTtri               ;point to first triangle in datapool
            w         work_3 = remndr                        ;save original remainder
                                  
xferLoop:   w         AR2 = add:(*AR1, #1)                   ;load AR2 with pointer to current PDB (+1) to receive the transfer of parameters and data
                                                             ;so that AR2 is pointing to triangle count for that thread's PDB
            w         work_1 = triDivXn                      ;might need to do some math with triDivXn so make a copy
            w         remndr = remndr                        ;copy/save remndr to itself to check for zero
                      if (Z==1) GOTO: no_add                 ;if remainder is zero then don't add one more this time
            w         work_1 = add:(work_1, #1)              ;else add one to it to get total triangles for this thread and store in LPCNT1
            w         remndr = sub:(remndr, #1)              ;and subtract one from remainder
;
;--------------transfer parameters to each thread's PDB --------------------------------------------------------
;
no_add:     w         *AR2++ = work_1                        ;copy number of triangles this thread is to process
                      REPEAT #8                              ;copy the qty (9) 3D transform parameters to current PDB using repeat instruction
            w         *AR2++ = *AR0++                        ;copy {ROTX, ROTY, ROTZ, SCALX, SCALY, SCALZ, TRANSX, TRANSY, TRANSZ} to current PDB
            w         AR0 = @SCALX                           ;re-initialize AR0 to point to back to parameter portion of the job request 
;            
;--------------transfer vector data from data pool to each thread's PDB -------------------------------------------            
;
triLoop:    w         DMA0_WRADDRS = AR2                     ;point to destination in thread's private PDB for first X1 of first triangle
            w         work_4 = mul:(work_1, #9)              ;determine length of DMA transfer
            w         DMA0_CSR = work_4                      ;transfer entire vector for all triangles for current PDB, endian-ness unchanged 
            w         AR2 = *AR1++                           ;point back to first location in PDB, which is that thread's start address and semaphore location

wait0:                if (DMA0_CSR:[31]==0) GOTO: wait0      ;wait for transfer to complete
            w         *AR2 = cmnd_save                       ;write start address (semaphore) to current PDB                                              
                  NEXT LPCNT0 GOTO: xferLoop)                ;xfer next group of parameters and data to next PDB until entire 3D object is loaded
;
;--------------transfer results from PDBs back to data pool---------------------------------------------------------
;
            w     remndr = work_3                            ;copy work_3 into remainder to restore it
            
                  for (LPCNT0 = threads) (                   ;load LPCNT0 with number of PDBs to copy back to SYSMEM
wait1:                if (DONE_IE:[18]==0) GOTO: wait1       ;wait until thread1 is done then pull results from each PDB and store in SYStem memory
            w         AR1 = #PDB_list                        ;point to first location in first PDB (PDB0) 
            w         DMA1_WRADDRS = @FIRSTtri               ;datapool destination address
            
nextPDB:    w         DMA1_RDADDRS = add:(*AR1++, #11)       ;thread private PDB address
            w         work_1 = triDivXn                      ;copy number of triangles per thread to work_1
            w         remndr = remndr                        ;see if remainder is zero
                      if (Z==1) GOTO: copyPDB                ;if zero then don't add one more from remainder
            w         work_1 = add:(work_1, #1)
            w         remndr = sub:(remndr, #1)              ;sub 1
            
copyPDB:    w         work_4 = mul:(work_1, #9)              ;determine length of DMA transfer
            w         DMA1_CSR =  work_4                     ;transfer entire result vector from PDB back to datapool, endian-ness unchanged
wait2:                if (DMA1_CSR:[31]==0) GOTO: wait2      ;wait for transfer to complete
                  NEXT LPCNT0 GOTO: nextPDB )                ;pull next PDB
                  
            w     AR3 = @SYSMEMstart                         ;point to first location in datapool
            w     *AR3 = @cool_feed                          ;tell CPU we are done processing  
            w     PC = #done                                 ;jump to done, semphr test and spin for next packet
            
; interrupt service routines        
NMI_:       w     *SP-- = PC_COPY                            ;save return address (general-purpose, maskable interrupt)
            w     TIMER = #10000                             ;put a new value in the timer
            w     PC = *SP++                                 ;return from interrupt
        
EXC_:       w     *SP-- = PC_COPY                            ;save return address (general-purpose, maskable interrupt)
            w     TIMER = #10000                             ;put a new value in the timer
            w     PC = *SP++                                 ;return from interrupt

IRQ_:       w     *SP-- = PC_COPY                            ;save return address (general-purpose, maskable interrupt)
            w     TIMER = #10000                             ;put a new value in the timer
            w     PC = *SP++                                 ;return from interrupt
progend:        
            end
          
    
