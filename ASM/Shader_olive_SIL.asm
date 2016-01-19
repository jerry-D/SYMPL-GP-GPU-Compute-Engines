           CPU  "SYMPL_IL.TBL"
           HOF  "MOT32"
           WDLN 4
; SYMPL GP-GPU Shader Demo 3D Transform Micro-Kernel
; version 1.03   January 12, 2016
; Author:  Jerry D. Harthcock
; Copyright (C) 2016.  All rights reserved without prejudice.
           
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
RPT:        EQU     0x6C                    ;repeat counter location
LPCNT1:     EQU	    0x67		   	        ;dedicated loop counter 1 
LPCNT0:	    EQU	    0x66 			        ;dedicated loop counter 0
TIMER:      EQU     0x65                    ;timer
C_reg:      EQU     0x64                    ;FMA C register
CAPTURE3:   EQU     0x63                    ;alternate delayed exception capture register 3
CAPTURE2:   EQU     0x62                    ;alternate delayed exception capture register 2
CAPTURE1:   EQU     0x61                    ;alternate delayed exception capture register 1
CAPTURE0:   EQU     0x60                    ;alternate delayed exception capture register 0
SCHED:      EQU     0x5F                    ;scheduler
SCHEDCMP:   EQU     0x5E                    ;scheduler max count values
QOS:        EQU     0x5D                    ;quality of service exception counters

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

sign_mask:  EQU     0x1E                    ;0x80000000 goes here--used for setting, clearing, toggling sign bit
;for storage of parameters for 3D transform
triangles:  EQU     0x20                    ;number of triangles to process
sin_thetaX: EQU     0x21                    ;sine of theta X for rotate X
cos_thetaX: EQU     0x22                    ;cosine of theta X for rotate X
sin_thetaY: EQU     0x23                    ;sine of theta Y for rotate Y
cos_thetaY: EQU     0x24                    ;cosine of theta Y for rotate Y
sin_thetaZ: EQU     0x25                    ;sine of theta X for rotate Z
cos_thetaZ: EQU     0x26                    ;cosine of theta X for rotate Z
scaleX:     EQU     0x27                    ;scale factor X axis
scaleY:     EQU     0x28                    ;scale factor Y axis
scaleZ:     EQU     0x29                    ;scale factor Z axis
transX:     EQU     0x2A                    ;translate amount X axis
transY:     EQU     0x2B                    ;translate amount Y axis
transZ:     EQU     0x2C                    ;translate amount Z axis

packet:     EQU     0x0800                  ;start location in parameter-data buffer (PDB) of the data packet to be processed

;constant immediate value equates
DONE_BIT:   EQU     0x20                    ;bit [5] is DONE Bit in status register  
            
            org     0x0FE              

Constants:  DFL     start                   ;program memory locations 0x000 - 0x0FF reserved for look-up table
        
prog_len:   DFL     progend - Constants
              
;           type    dest = OP:(srcA, srcB) 

            org     0x00000100
RST_VECT:   w       PC = #done                     ;reset vector
NMI_VECT:   w       PC = #NMI_                     ;NMI vector
INV_VECT:   w       PC = #INV_                     ;invalid operation exception vector location
DIVx0_VECT: w       PC = #DIVx0_                   ;divide by 0 exception vector location
OVFL_VECT:  w       PC = #OVFL_                    ;overflow exception vector location
UNFL_VECT:  w       PC = #UNFL_                    ;underflow exception vector location
INEXT_VECT: w       PC = #INEXT_                   ;inexact exception vector location
IRQ_VECT:   w       PC = #IRQ_                     ;maskable general-purpose interrupt vector

;           type    dest = OP:(srcA, srcB) 

done:       w       AR3 = #packet                  ;point to start of packet which is both a semaphor and entry point for thread
semphr:     w       STATUS = or:(STATUS, #DONE_BIT)   ; signal external CPU (load-balancer/coarse-grain scheduler) process is done
                                                   ;note that the DONE_BIT is already set upon initial entry but is cleared three instruction below "start"
                                                   ;to signal CPU thread has started (ie, not done)        
spin:       w       work_1 = or:(*AR3, #0)         ;see if first location (the semaphor and routine entry point) of packet is non-zero
                                                   ;during this time the CPU is pushing packet into Shader memory and, as a final step,
                                                   ;and will write the non-zero PC entry point to the location pointed to by AR3 when xfer is complete
;                    bcnd   spin, Z                 ;if semaphr is 0 then wait for this value to become non-zero in the packet RAM block
                    if (Z==1) GOTO: spin           ;if semaphr is 0 then wait for this value to become non-zero in the packet RAM block
            w       *AR3 = #0                      ;clear the semaphor now so we don't fall through again when we get done and come back here
            w       PC = work_1                    ;else perform the specified thread pointed to by contents of work_1, in this case, "start"
        
start:  
            w       TIMER = #10000                 ;load time-out timer with sufficient time to process before timeout
            w       AR3 = #packet + 1              ;load AR3 with pointer to list length in parameter/data packet just received--AR3 is read pointer                   
            w       STATUS = and:(STATUS, #0xDF)   ;clear the DONE bit to signal we are now busy
            w       triangles = *AR3++             ;save number of triangles 
            f       sin_thetaX = sin:(*AR3)        ;calculate sine of theta X and save
            f       cos_thetaX = cos:(*AR3++)      ;calculate cosine of theta X and save
            f       sin_thetaY = sin:(*AR3)        ;calculate sine of theta Y and save
            f       cos_thetaY = cos:(*AR3++)      ;calculate cosine of theta Y and save
            f       sin_thetaZ = sin:(*AR3)        ;calculate sine of theta Z and save
            f       cos_thetaZ = cos:(*AR3++)      ;calculate cosine of theta Z and save
            w       scaleX = *AR3++                ;save scale X factor
            w       scaleY = *AR3++                ;save scale Y factor
            w       scaleZ = *AR3++                ;save scale Z factor
            w       transX = *AR3++                ;save translate X axis amount
            w       transY = *AR3++                ;save translate Y axis amount
            w       transZ = *AR3++                ;save translate Z axis amount
                    ; AR3 is now pointing to first X of first triangle
            w       AR2 = AR3                      ;copy AR3 contents to AR2 so AR2 can be used as write pointer back to PDB for saving results
            
                    for (LPCNT0 = triangles) (     ;load loop counter 0 with number of triangles 
            
                    ;the following routine performs scaling on all three axis first, 
                    ;rotate on all three axis second, then translate on all three axis last 
                              
loop:   ;scale on X, Y, Z axis
            ;vertex 1
            f         FMUL_0 = fmul:(*AR3++, scaleX)
            f         FMUL_1 = fmul:(*AR3++, scaleY)
            f         FMUL_2 = fmul:(*AR3++, scaleZ)
            ;vertex 2
            f         FMUL_3 = fmul:(*AR3++, scaleX)
            f         FMUL_4 = fmul:(*AR3++, scaleY)
            f         FMUL_5 = fmul:(*AR3++, scaleZ)
            ;vertex 3
            f         FMUL_6 = fmul:(*AR3++, scaleX)
            f         FMUL_7 = fmul:(*AR3++, scaleY)
            f         FMUL_8 = fmul:(*AR3++, scaleZ)
            
;                     X1 is now in FMUL_0         
;                     Y1 is now in FMUL_1         
;                     Z1 is now in FMUL_2         
;                     X2 is now in FMUL_3         
;                     Y2 is now in FMUL_4         
;                     Z2 is now in FMUL_5         
;                     X3 is now in FMUL_6         
;                     Y3 is now in FMUL_7         
;                     Z3 is now in FMUL_8         
            
  ;rotate around X axis
       ;vertex 1
            ; (cos(xrot) * Y1) - (sin(xrot) * Z1) 
            f         FMUL_9 = fmul:(FMUL_1, cos_thetaX)      ; FMUL_9 = (cos(xrot) * Y1)
            f         FMUL_A = fmul:(FMUL_2, sin_thetaX)      ; FMUL_A = (sin(xrot) * Z1)
            ; (sin(xrot) * Y1) + (cos(xrot) * Z1) 
            f         FMUL_B = fmul:(FMUL_1, sin_thetaX)      ; FMUL_B = (sin(xrot) * Y1)
            f         FMUL_C = fmul:(FMUL_2, cos_thetaX)      ; FMUL_C = (cos(xrot) * Z1)
            
            f         FSUB_0 = fsub:(FMUL_9, FMUL_A)          ; FSUB_0 = (cos(xrot) * Y1) - (sin(xrot) * Z1)
            f         FADD_0 = fadd:(FMUL_B, FMUL_C)          ; FADD_0 = (sin(xrot) * Y1) + (cos(xrot) * Z1)

       ;vertex 2
            ; (cos(xrot) * Y2) - (sin(xrot) * Z2) 
            f         FMUL_1 = fmul:(FMUL_4, cos_thetaX)      ; FMUL_1 = (cos(xrot) * Y2)
            f         FMUL_2 = fmul:(FMUL_5, sin_thetaX)      ; FMUL_2 = (sin(xrot) * Z2)
            ; (sin(xrot) * Y2) + (cos(xrot) * Z2) 
            f         FMUL_D = fmul:(FMUL_4, sin_thetaX)      ; FMUL_D = (sin(xrot) * Y2)
            f         FMUL_E = fmul:(FMUL_5, cos_thetaX)      ; FMUL_E = (cos(xrot) * Z2)
            
            f         FSUB_1 = fsub:(FMUL_1, FMUL_2)          ; FSUB_1 = (cos(xrot) * Y2) - (sin(xrot) * Z2)
            f         FADD_1 = fadd:(FMUL_D, FMUL_E)          ; FADD_1 = (sin(xrot) * Y2) + (cos(xrot) * Z2)

       ;vertex 3
            ; (cos(xrot) * Y3) - (sin(xrot) * Z3) 
            f         FMUL_9 = fmul:(FMUL_7, cos_thetaX)      ; FMUL_9 = (cos(xrot) * Y3)
            f         FMUL_A = fmul:(FMUL_8, sin_thetaX)      ; FMUL_A = (sin(xrot) * Z3)
            ; (sin(xrot) * Y3) + (cos(xrot) * Z3) 
            f         FMUL_B = fmul:(FMUL_7, sin_thetaX)      ; FMUL_B = (sin(xrot) * Y3)
            f         FMUL_C = fmul:(FMUL_8, cos_thetaX)      ; FMUL_C = (cos(xrot) * Z3)
            
            f         FSUB_2 = fsub:(FMUL_9, FMUL_A)          ; FSUB_2 = (cos(xrot) * Y3) - (sin(xrot) * Z3)
            f         FADD_2 = fadd:(FMUL_B, FMUL_C)          ; FADD_2 = (sin(xrot) * Y3) + (cos(xrot) * Z3)            
            
            ;         X1 is now in FMUL_0
            ;         Y1 is now in FSUB_0
            ;         Z1 is now in FADD_0 
            ;         X2 is now in FMUL_3
            ;         Y2 is now in FSUB_1
            ;         Z2 is now in FADD_1
            ;         X3 is now in FMUL_6
            ;         Y3 is now in FSUB_2
            ;         Z3 is now in FADD_2      

  ;rotate around Y axis
       ;vertex 1
            ; (cos(yrot) * X1) + (sin(yrot) * Z1) 
            f         FMUL_1 = fmul:(FMUL_0, cos_thetaY)      ; FMUL_1 = (cos(yrot) * X1)
            f         FMUL_2 = fmul:(FADD_0, sin_thetaY)      ; FMUL_2 = (sin(yrot) * Z1)
            ; (cos(yrot) * Z1) - (sin(yrot) * X1)
            f         FMUL_4 = fmul:(FADD_0, cos_thetaY)      ; FMUL_4 = (cos(xrot) * Z1)
            f         FMUL_5 = fmul:(FMUL_0, sin_thetaY)      ; FMUL_5 = (sin(xrot) * X1)
            
            f         FADD_3 = fadd:(FMUL_1, FMUL_2)          ; FADD_3 = (cos(yrot) * X1) + (sin(yrot) * Z1)
            f         FSUB_3 = fsub:(FMUL_4, FMUL_5)          ; FSUB_3 = (cos(yrot) * Z1) - (sin(yrot) * X1)
       ;vertex 2
            ; (cos(yrot) * X2) + (sin(yrot) * Z2) 
            f         FMUL_7 = fmul:(FMUL_3, cos_thetaY)      ; FMUL_7 = (cos(yrot) * X2)
            f         FMUL_8 = fmul:(FADD_1, sin_thetaY)      ; FMUL_8 = (sin(yrot) * Z2)
            ; (cos(yrot) * Z2) - (sin(yrot) * X2)
            f         FMUL_9 = fmul:(FADD_1, cos_thetaY)      ; FMUL_9 = (cos(xrot) * Z2)
            f         FMUL_A = fmul:(FMUL_3, sin_thetaY)      ; FMUL_A = (sin(xrot) * X2)
            
            f         FADD_4 = fadd:(FMUL_7, FMUL_8)          ; FADD_4 = (cos(yrot) * X2) + (sin(yrot) * Z2)
            f         FSUB_4 = fmul:(FMUL_9, FMUL_A)          ; FSUB_4 = (cos(yrot) * Z2) - (sin(yrot) * X2)
            
       ;vertex 3
            ; (cos(yrot) * X3) + (sin(yrot) * Z3) 
            f         FMUL_B = fmul:(FMUL_6, cos_thetaY)      ; FMUL_B = (cos(yrot) * X3)
            f         FMUL_C = fmul:(FADD_2, sin_thetaY)      ; FMUL_C = (sin(yrot) * Z3)
            
            ; (cos(yrot) * Z3) - (sin(yrot) * X3)
            f         FMUL_D = fmul:(FADD_2, cos_thetaY)      ; FMUL_D = (cos(xrot) * Z3)
            f         FMUL_E = fmul:(FMUL_6, sin_thetaY)      ; FMUL_E = (sin(xrot) * X3)
            
            f         FADD_5 = fadd:(FMUL_B, FMUL_C)          ; FADD_5 = (cos(yrot) * X3) + (sin(yrot) * Z3)
            f         FSUB_5 = fsub:(FMUL_D, FMUL_E)          ; FSUB_5 = (cos(yrot) * Z3) - (sin(yrot) * X3)  
            
            ;         X1 is now in FADD_3
            ;         Y1 is now in FSUB_0
            ;         Z1 is now in FSUB_3
            ;         X2 is now in FADD_4
            ;         Y2 is now in FSUB_1
            ;         Z2 is now in FSUB_4
            ;         X3 is now in FADD_5
            ;         Y3 is now in FSUB_2 
            ;         Z3 is now in FSUB_5                      

  ;rotate around Z axis
       ;vertex 1
            ; (cos(zrot) * X1) - (sin(zrot) * Y1) 
            f         FMUL_0 = fmul:(FADD_3, cos_thetaZ)      ; FMUL_0 = (cos(zrot) * X1)
            f         FMUL_1 = fmul:(FSUB_0, sin_thetaZ)      ; FMUL_1 = (sin(xrot) * Y1)
            ; (sin(zrot) * X1) + (cos(zrot) * Y1) 
            f         FMUL_2 = fmul:(FADD_3, sin_thetaZ)      ; FMUL_2 = (sin(xrot) * X1)
            f         FMUL_3 = fmul:(FSUB_0, cos_thetaZ)      ; FMUL_3 = (cos(xrot) * Y1)
            
            f         FSUB_6 = fsub:(FMUL_0, FMUL_1)          ; FSUB_6 = (cos(zrot) * X1) - (sin(zrot) * Y1)
            f         FADD_6 = fadd:(FMUL_2, FMUL_3)          ; FADD_6 = (sin(zrot) * X1) + (cos(zrot) * Y1)

       ;vertex 2
            ; (cos(zrot) * X2) - (sin(zrot) * Y2) 
            f         FMUL_4 = fmul:(FADD_4, cos_thetaZ)      ; FMUL_4 = (cos(zrot) * X1)
            f         FMUL_5 = fmul:(FSUB_1, sin_thetaZ)      ; FMUL_5 = (sin(xrot) * Y1)
            ; (sin(zrot) * X2) + (cos(zrot) * Y2) 
            f         FMUL_6 = fmul:(FADD_4, sin_thetaZ)      ; FMUL_6 = (sin(xrot) * X2)
            f         FMUL_7 = fmul:(FSUB_1, cos_thetaZ)      ; FMUL_7 = (cos(xrot) * Y2)
            
            f         FSUB_7 = fsub:(FMUL_4, FMUL_5)          ; FSUB_7 = (cos(zrot) * X2) - (sin(zrot) * Y2)
            f         FADD_7 = fadd:(FMUL_6, FMUL_7)          ; FADD_7 = (sin(zrot) * X2) + (cos(zrot) * Y2)

       ;vertex 3
            ; (cos(zrot) * X3) - (sin(zrot) * Y3) 
            f         FMUL_8 = fmul:(FADD_5, cos_thetaZ)      ; FMUL_8 = (cos(zrot) * X3)
            f         FMUL_9 = fmul:(FSUB_2, sin_thetaZ)      ; FMUL_9 = (sin(xrot) * Y3)
            ; (sin(zrot) * X3) + (cos(zrot) * Y3)   
            f         FMUL_A = fmul:(FADD_5, sin_thetaZ)      ; FMUL_A = (sin(xrot) * X3)
            f         FMUL_B = fmul:(FSUB_2, cos_thetaZ)      ; FMUL_B = (cos(xrot) * Y3)
            
            f         FSUB_8 = fsub:(FMUL_8, FMUL_9)          ; FSUB_8 = (cos(zrot) * X3) - (sin(zrot) * Y3)
            f         FADD_8 = fadd:(FMUL_A, FMUL_B)          ; FADD_8 = (sin(zrot) * X3) + (cos(zrot) * Y3)            
            
            ;         X1 is now in FSUB_6
            ;         Y1 is now in FADD_6
            ;         Z1 is now in FSUB_3
            ;         X2 is now in FSUB_7
            ;         Y2 is now in FADD_7
            ;         Z2 is now in FSUB_4
            ;         X3 is now in FSUB_8
            ;         Y3 is now in FADD_8
            ;         Z3 is now in FSUB_5
       
    ;now translate on X, Y = Z axis
        ;vertex 1
            f         FADD_0 = fadd:(FSUB_6, transX)     
            f         FADD_1 = fadd:(FADD_6, transY)     
            f         FADD_2 = fadd:(FSUB_3, transZ)     
        ;vertex 2
            f         FADD_9 = fadd:(FSUB_7, transX)     
            f         FADD_A = fadd:(FADD_7, transY)     
            f         FADD_B = fadd:(FSUB_4, transZ)     
        ;vertex 3
            f         FADD_C = fadd:(FSUB_8, transX)     
            f         FADD_D = fadd:(FADD_8, transY)     
            f         FADD_E = fadd:(FSUB_5, transZ)     

    ;copy results of transformation back to original locations in PDB
            w         *AR2++ = FADD_0           ;copy translated X1 to PDB
            w         *AR2++ = FADD_1           ;copy translated Y1 to PDB
            w         *AR2++ = FADD_2           ;copy translated Z1 to PDB
            w         *AR2++ = FADD_9           ;copy translated X2 to PDB
            w         *AR2++ = FADD_A           ;copy translated Y2 to PDB
            w         *AR2++ = FADD_B           ;copy translated Z2 to PDB
            w         *AR2++ = FADD_C           ;copy translated X3 to PDB
            w         *AR2++ = FADD_D           ;copy translated Y3 to PDB
            w         *AR2++ = FADD_E           ;copy translated Z3 to PDB

                    NEXT LPCNT0 GOTO: loop)     ;continue until done

            w       PC = #done                  ;jump to done, semphr test and spin for next packet
            
; interrupt service routines        
NMI_:       w       NMI_save = PC_COPY          ;save return address from non-maskable interrupt (time-out timer in this instance)
            w       TIMER = #10000              ;put a new value in the timer
            w       PC = NMI_save               ;return from interrupt
        
INV_:       w       INV_save = PC_COPY          ;save return address from floating-point invalid operation exception, which is maskable
            w       TIMER = #10000              ;put a new value in the timer
            w       work_6 = SQRT_1             ;retrieve the NaN with payload (this quiet NaN replaced the signaling NaN that caused the INV exc)
            w       PC = INV_save               ;return from interrupt
            
DIVx0_:     w       DIVx0_save = PC_COPY        ;save return address from floating-point divide by 0 exception, which is maskable
            w       capt0_save = CAPTURE0       ;read out CAPTURE0 register and save it
            w       capt1_save = CAPTURE1       ;read out CAPTURE1 register and save it
            w       capt2_save = CAPTURE2       ;read out CAPTURE2 register and save it
            w       capt3_save = CAPTURE3       ;read out CAPTURE3 register and save it
            w       TIMER = #10000              ;put a new value in the timer
            w       PC = DIVx0_save             ;return from interrupt

OVFL_:      w       OVFL_save = PC_COPY         ;save return address from floating-point overflow exception, which is maskable
            w       TIMER = #10000              ;put a new value in the timer
            w       PC = OVFL_save              ;return from interrupt

UNFL_:      w       UNFL_save = PC_COPY         ;save return address from floating-point underflow exception, which is maskable
            w       TIMER = #10000              ;put a new value in the timer
            w       PC = UNFL_save              ;return from interrupt

INEXT_:     w       INEX_save = PC_COPY         ;save return address from floating-point inexact exception, which is maskable
            w       TIMER = #10000           ;put a new value in the timer
            w       PC = INEX_save           ;return from interrupt

IRQ_:       w       IRQ_PC_save = PC_COPY    ;save return address (general-purpose, maskable interrupt)
            w       TIMER = #10000           ;put a new value in the timer
            w       PC = IRQ_PC_save         ;return from interrupt            
progend:        
            end
          
    
