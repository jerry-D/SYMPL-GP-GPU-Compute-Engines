;-------------------------------------------------------------------------------------------
; RISC-V (VASCALE RTL version) with SYMPL GP-GPU demo program written in pure assembly
; Version 1.01  December 10, 2015
; Author:  Jerry D. Harthcock
; Original version December 6, 2015
; Assembled using Cross-32 Universal Cross-Assembler and custom instruction table
; The RSIC-V (RV-32I) instruction table is included in the non-commercial distribution package.
; Copyright (c) 2015. All rights reserved.
;
; DESCRIPTION
; RISC-V  executes this program to push 3D transformation parameters, triangle count, and 
; triangle xyz vertices(all extracted from a .stl file by the test bench) into the SYMPL GP-GPU  
; datapool memory and then issues a command to the coarse-grained scheduler (CGS) of the 
; GP-GPU to perform the 3D transformation according the parameters submitted.  Parameters include 
; scale, rotate, and translate on all three axis.
;
; After submitting the parameters, triangle count, triangles and command, the RISC-V simply
; polls the semaphore location in GP-GPU datapool memory waiting for the "C001FEED" response,
; which tells the RISC-V that processing has been completed.  Once such response is issued,
; the RISC-V then pulls the results from the GP-GPU datapool back into its system memory space.
;
; The test bench detects that processing is complete when when the RISC-V writes "C001FEED" to
; location 0x8000 (32-bit aligned) in its system memory.  Once detected the test bench then 
; pulls the results from RISC-V system memory and writes the results to disk in .stl format
; so the transformed 3D object can be displayed using any .stl file viewer.
;
; It should be noted that the VSCALE RTL version of RISC-V, as of this writting, appears to 
; have a bug in the pipeline logic, as some patches in this assembly code were necessary  
; to get the VSCALE to generate a write in certain situations where the data memory
; write signal appears to be killed pre-maturely.
;
; A copy of Cross-32 can be purchased from:
; Data-Sync Engineering at: http://www.cdadapter.com/cross32.htm  sales@datasynceng.com
; A copy of the Cross-32 manual can be viewed online here:  
;          http://www.cdadapter.com/download/cross32.pdf

           CPU  "RISC_V.tbl"
           HOF "BIN32"
           WDLN 1

transform:  equ     0x10B                 ;transform command issued to CGS (GP-GPU)

            org 0x00000200
start:      mvi     x1, stl_tri_count     ;load pointer to pointer for triangle count into x1
            lw      x1,  0(x1)            ;load x1 with pointer to triangle count
            lw      x3,  0(x1)            ;get triangle count
            mv      x31, x3               ;save original triangle count in x31
            
;----------------- push parameters for the 3D transform -------------------------------------        
            mvi     x2, dpool_tri_count   ;load pointer to pointer for storing triangle count in GP-GPU datapool
            lw      x2, 0(x2)             ;get pointer to where triangle count will be stored in datapool
            sw      0(x2), x31            ;store triangle count in datapool
        
            mvi     x4, parameters        ;get pointer to parameters 
            lw      x5, 0(x4)             ;get rotate x amount parameter 
            sw      4(x2), x5             ;store rotate x amount in datapool
            lw      x5, 4(x4)             ;get rotate y amount
            sw      8(x2), x5             ;store rotate y amount in datapool
            lw      x5, 8(x4)             ;get rotate z amount
            sw      12(x2), x5            ;store rotate z amount in datapool
        
            lw      x5, 12(x4)            ;get scale x amount
            sw      16(x2), x5            ;store scale x amount in datapool
            lw      x5, 16(x4)            ;get scale y amount
            sw      20(x2), x5            ;store scale y amount in datapool
            lw      x5, 20(x4)            ;get scale z amount
            sw      24(x2), x5            ;store scale z amount in datapool
        
            lw      x5, 24(x4)            ;get translate x amount
            sw      28(x2), x5            ;store translate x amount in datapool
            lw      x5, 28(x4)            ;get translate y amount
            sw      32(x2), x5            ;store translate y amount in datapool
            lw      x5, 32(x4)            ;get translate z amount
            sw      36(x2), x5            ;store translate y amount in datapool
            
;----------------- push triangles --------------------------------------------------        
;push triangles section copies triangles from RISC-V memory over to datapool         
            mvi     x1, stl_first_tri     ;load pointer to pointer for first triangle in RISC-V .stl memory buf
            lw      x1,  0(x1)            ;get pointer to first triangle in RISC-V .stl memory buf
            mvi     x2, dpool_frst_tri    ;get point to pointer for first triangle x1 storage location in datapool
            lw      x2, 0(x2)             ;x2 is now pointing to where first x1 will be stored in datapool

push_xyz1:  lw      x5, 0(x1)             ;get x1 .stl buf
            sw      0(x2), x5             ;store x1 in datapool
            lw      x5, 4(x1)             ;get y1 .stl buf
            sw      4(x2), x5             ;store y1 in datapool
            lw      x5, 8(x1)             ;get z1 .stl buf
            sw      8(x2), x5             ;store z1 in datapool

push_xyz2:  lw      x5, 12(x1)            ;get x2 .stl buf
            sw      12(x2), x5            ;store x2 in datapool
            lw      x5, 16(x1)            ;get y2 .stl buf
            sw      16(x2), x5            ;store y2 in datapool
            lw      x5, 20(x1)            ;get z2 .stl buf
            sw      20(x2), x5            ;store z2 in datapool

push_xyz3:  lw      x5, 24(x1)            ;get x3 .stl buf
            sw      24(x2), x5            ;store x3 in datapool
            lw      x5, 28(x1)            ;get y3 .stl buf
            sw      28(x2), x5            ;store y3 in datapool
            lw      x5, 32(x1)            ;get z3 .stl buf
            sw      32(x2), x5            ;store z3 in datapool

            addi    x1, x1, 36            ;point to next triangle x1 in RISC-V memory
            addi    x2, x2, 36            ;point to next triangle destination location where vector will be written in datapool
            decr    x3                    ;decrement triangle count
            bnz     x3, push_xyz1         ;if not zero then push next triangle, else give command to GP-GPU to transform 3D object
            
;--------------- issue 3D transform command -------------------------------------------------- 
;note: the last 3 instruction are a patch.  If not included RISC-V appears to kill the write of the command.         
giv_cmnd:   mvi     x6, dpool_command     ;get pointer to pointer to datapool command register
            lw      x6, 0(x6)             ;x6 now has pointer to datapool command register
            mvi     x7, transform         ;load x7 with command telling GP-GPU to transform the 3D object according to the parameters given
            sw      0(x6), x7             ;place the transform command into the GP-GPU command buffer
            lw      x20, 0(x6)            ;dummy ld 
            sw      0(x6), x7             ;place the transform command into the GP-GPU command buffer
            sw      0(x6), x7             ;place the transform command into the GP-GPU command buffer
                       
;--------------- pull results preparation ----------------------------------------------------
            mvi     x2, stl_first_tri     ;point to pointer for location in RISC-V memory to read first triangle x1 transformed result
            lw      x2, 0(x2)             ;get the pointer
            mvi     x1, dpool_frst_tri    ;point to pointer for location in GP-GPU datapool to store first triangle x1 transformed result        
            lw      x1, 0(x1)             ;get the pointer
            mvi     x4, cool_feed         ;get pointer to cool_feed response value to be used as semaphore
            lw      x4, 0(x4)             ;load x4 with 0xC001_FEED
            mv      x3, x31               ;load loop counter x3 with number of triangles previously saved
                                          
;--------------- wait for the GP-GPU to complete transformation ------------------------------
 wait:      lw      x7, 0(x6)             ;read command register and see if CGS responded with the "C001FEED" semaphore
            bne     x4, x7, wait
            
;--------------- pull results from datapool and place in original RISC-V .stl file buffer ----
pull_xyz1:  lw      x5, 0(x1)             ;get x1  from datapool
            sw      0(x2), x5             ;store x1 in .stl buf            
            lw      x5, 4(x1)             ;get y1 from datapool
            sw      4(x2), x5             ;store y1 in .stl buf
            lw      x5, 8(x1)             ;get z1 from datapool
            sw      8(x2), x5             ;store z1 in .stl buf

pull_xyz2:  lw      x5, 12(x1)            ;get x2 from datapool
            sw      12(x2), x5            ;store x2 in .stl buf
            lw      x5, 16(x1)            ;get y2 from datapool
            sw      16(x2), x5            ;store y2 in .stl buf
            lw      x5, 20(x1)            ;get z2 from datapool
            sw      20(x2), x5            ;store z2 in .stl buf

pull_xyz3:  lw      x5, 24(x1)            ;get x3 from datapool
            sw      24(x2), x5            ;store x3 in .stl buf
            lw      x5, 28(x1)            ;get y3 from datapool
            sw      28(x2), x5            ;store y3 in .stl buf
            lw      x5, 32(x1)            ;get z3 from datapool
            sw      32(x2), x5            ;store z3 in .stl buf

            addi    x1, x1, 36            ;update pointer to next triangle x1 starting location in GP-GPU datapool
            addi    x2, x2, 36            ;update pointer to where the vector will be written in RISC-V memory
            decr    x3                    ;decrement triangle count
            bnz     x3, pull_xyz1         ;if done pushing, give command
            
            mvi      x10, stl_file        ;get pointer to pointer to start of .stl file
            lw       x10, 0(x10)          ;point to .stl file first location
            sw       0(x10), x4           ;store coo1_feed semaphore there to signal done
done:       lw       x4, 0(x10)           ;read back to expose coo1_feed semaphore for easy test bench detection
            bra     done                  ;spin here when done
            
                  org $
;pointer table for data memory access to ("filtered") .stl file in RISC-V memory 
stl_file: 	      dfl 0x00020000     ;pointer (byte address) to the start of the .stl file that has been loaded into data memory
stl_tri_count:    dfl 0x00020004     ;pointer (byte address) to location in .stl file containing number of triangles in the file
stl_first_tri:    dfl 0x0002002C     ;pointer (byte address) to first x1 in first triangle vector, i.e., (x1, y1, z1, x2, y2, z2, x3, y3, z3)

;pointer table for data memory access to GP-GPU datapool memory which is also mapped (via true dual-port SRAM) to RISC-V memory
dpool_command:    dfl 0x00040000     ;pointer to the command register of the GP-GPU 64k-word (256k byte) data pool
dpool_tri_count:  dfl 0x00040004     ;pointer to where the triangle count will be written to the GP-GPU datapool
dpool_scalx:      dfl 0x00040008     ;pointer to where the scalx parameter will be written to the GP-GPU datapool
dpool_scaly:      dfl 0x0004000C     ;pointer to scaly data pool address
dpool_scalz:      dfl 0x00040010     ;pointer to scalz 
dpool_rotx:       dfl 0x00040014     ;pointer to rotate x amount (in integer degrees)
dpool_roty:       dfl 0x00040018     ;pointer to rotate y amount
dpool_rotz:       dfl 0x0004001C     ;pointer to rotate z amount
dpool_transx:     dfl 0x00040020     ;pointer to translate x amount
dpool_transy:     dfl 0x00040024     ;pointer to translate y amount
dpool_transz:     dfl 0x00040028     ;pointer to translate z amount
dpool_frst_tri:   dfl 0x0004002C     ;pointer to the first x1 of first vertex in the data pool

;parameters for this particular 3D transform test run
parameters:       org  $
rotx:             dfl  29            ;rotate around x axis in integer degrees  
roty:             dfl  44            ;rotate around y axis in integer degrees  
rotz:             dfl  75            ;rotate around z axis in integer degrees  
scalx:            dff  2.0           ;scale X axis amount real
scaly:            dff  2.0           ;scale y axis amount real
scalz:            dff  2.25          ;scale Z axis amount real
transx:           dff  4.75          ;translate on X axis amount real
transy:           dff  3.87          ;translate on Y axis amount real
transz:           dff  2.237         ;translate on Z axis amount real

;GP-GPU reply semaphors
cool_feed:        dfl  0xC001FEED    ;this response indicates GP-GPU has completed the task successfully
bad_feed:         dfl  0x0BADFEED    ;this response indicates GP-GPU has terminated the task prematurely for the reason specified in the response buffer


        end
        
        