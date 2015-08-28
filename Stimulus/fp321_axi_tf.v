 `timescale 1ns/100ps

// SYMPL test fixture for FP321 with AXI4
// Author:  Jerry D. Harthcock
// June 29, 2015
// Version:  1.3   August 28, 2015
//
//
// Copyright (C) 2014-2105.  All rights reserved without prejudice.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                              SYMPL FP32X-AXI4 32-Bit Mult-Thread RISC                                         //
//                              Evaluation and Product Development License                                       //
//                                                                                                               //
// Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"), //
// the original author and exclusive copyright owner of this SYMPL FP32X-AXI4 32-Bit Mult-Thread RISC            //
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

module t;

parameter CSR = 32'hFFFF_FFFC;               //shader0 control/status register address

parameter rom0_base = 32'hFFFF_0000;         //shader0 ROM base address

parameter shader0_IRB_base = 32'hFFFE_8000;  //IRB base address 

parameter thread3_ram_base = 32'hFFFE_6000;  //shader0 thread 3 parameter/data buffer base address
parameter thread2_ram_base = 32'hFFFE_4000;  //shader0 thread 2 parameter/data buffer base address
parameter thread1_ram_base = 32'hFFFE_2000;  //shader0 thread 1 parameter/data buffer base address
parameter thread0_ram_base = 32'hFFFE_0000;  //shader0 thread 0 parameter/data buffer base address

parameter packet3_result_start  = 32'h000A_8000;
parameter packet2_result_start  = 32'h000A_0000;
parameter packet1_result_start  = 32'h0009_8000;
parameter packet0_result_start  = 32'h0009_0000;

parameter packet3_submit_start  = 32'h0002_8000;
parameter packet2_submit_start  = 32'h0002_0000;
parameter packet1_submit_start  = 32'h0001_8000;
parameter packet0_submit_start  = 32'h0001_0000;
  
integer		clk_high_time;						// high time for CPU clock	

reg clk;
reg reset;

reg [31:0] SYSTEM_mem[262143:0];
reg [31:0] SYSTEM_memP[4095:0];

reg [31:0] packet3[511:0];
reg [31:0] packet2[511:0];
reg [31:0] packet1[511:0];
reg [31:0] packet0[511:0];

reg [11:0] i;
reg [17:0] j;
reg [12:0] k;

reg [17:0] sys3j;
reg [17:0] sys2j;
reg [17:0] sys1j;
reg [17:0] sys0j;

reg [12:0] p0k;
reg [12:0] p1k;
reg [12:0] p2k;
reg [12:0] p3k;

reg [31:0] prog_len;
reg [31:0] prog_start;

reg [3:0] AWID;                             
reg [31:0] AWADDR;                          
reg [3:0] AWLEN;                            
reg [2:0] AWSIZE;                           
reg [1:0] AWBURST;                          
reg [1:0] AWLOCK;                           
reg [3:0] AWCACHE;                          
reg [2:0] AWPROT;                           
reg  AWVALID;

reg [3:0]  WID;                             
reg [31:0] WDATA;                           
reg  WLAST;                                 
reg  WVALID;                                
reg  BREADY;                               
                                              
reg [3:0] ARID;                             
reg [31:0] ARADDR;                          
reg [3:0]  ARLEN;                           
reg [2:0] ARSIZE;                           
reg [1:0] ARBURST;                          
reg [1:0] ARLOCK;                           
reg [3:0] ARCACHE;                          
reg [2:0] ARPROT;                           
reg ARVALID;
reg  RREADY;

reg [31:0] rd_shader_data;

wire AWREADY;

wire WREADY;                                
                                              
wire [3:0] BID;                             
wire [1:0] BRESP;                           
wire BVALID;                                
                                
wire ARREADY;                               
                                              
wire [3:0]  RID;                            
wire [31:0] RDATA;                          
wire [1:0] RRESP;                           
wire RLAST;                                 
wire RVALID;                                
   
wire CLK;                
wire RESET; 
wire INTREQ;

wire [31:17] BASE_shader0;
wire [2:0] AWPROT_mode;
wire [2:0] ARPROT_mode;

assign BASE_shader0 = 15'b1111_1111_1111_111; //base address of shader0
assign AWPROT_mode = 3'b010;
assign ARPROT_mode = 3'b010;

assign CLK = clk;
assign RESET = reset;

fp321_axi fp321_axi(
    .ACLK    (CLK    ),
    .ARESETn (~RESET ),   //active low
    
    .AWID    (AWID    ),
    .AWADDR  (AWADDR  ),
    .AWLEN   (AWLEN   ),
    .AWSIZE  (AWSIZE  ),
    .AWBURST (AWBURST ),
    .AWLOCK  (AWLOCK  ),
    .AWCACHE (AWCACHE ),
    .AWPROT  (AWPROT  ),
    .AWVALID (AWVALID ),
    .AWREADY (AWREADY ),
    
    .WID     (WID     ),
    .WDATA   (WDATA   ),
    .WLAST   (WLAST   ),
    .WVALID  (WVALID  ),
    .WREADY  (WREADY  ),
                     
    .BID     (BID     ),
    .BRESP   (BRESP   ),
    .BVALID  (BVALID  ),
    .BREADY  (BREADY  ),
    
    .ARID    (ARID    ),
    .ARADDR  (ARADDR  ),
    .ARLEN   (ARLEN   ),
    .ARSIZE  (ARSIZE  ), 
    .ARBURST (ARBURST ),
    .ARLOCK  (ARLOCK  ),
    .ARCACHE (ARCACHE ),
    .ARPROT  (ARPROT  ),
    .ARVALID (ARVALID ),
    .ARREADY (ARREADY ),
                     
    .RID     (RID     ),
    .RDATA   (RDATA   ),
    .RRESP   (RRESP   ),
    .RLAST   (RLAST   ),
    .RVALID  (RVALID  ),
    .RREADY  (RREADY  ),
    
    .INTREQ  (INTREQ  ),
    
    .BASE    (BASE_shader0   ),
    .AWPROT_mode (AWPROT_mode),
    .ARPROT_mode (ARPROT_mode)
    );
                                  
  
    initial begin
         
		clk = 0;	   
		clk_high_time = 3.35;
        reset = 1'b1;

        AWID = 4'b0001;                             
        AWADDR = 32'h0000_0000;                          
        AWLEN = 4'b0000;   // burst length, 4'b0000 == 1 xfer, 4'b0001 == 2 xfers etc                            
        AWSIZE = 3'b010;   // code for 4 bytes (1 word) per transfer                        
        AWBURST = 2'b01;   // incrementing burst type                       
        AWLOCK = 2'b00;    // normal access for now                       
        AWCACHE = 4'b0000; //not bufferable and not cacheable                          
        AWPROT = AWPROT_mode;    //normal, unprotected                           
        AWVALID = 1'b0;

        WID = 4'b0001;                             
        WDATA = 32'h0000_0000;                           
        WLAST = 1'b0;                                 
        WVALID = 1'b0;                                
                                                      
        BREADY = 1'b0;                               
                                                  
        ARID = 4'b0001;                             
        ARADDR = 32'h0000_0000;                          
        ARLEN = 4'b0000;                           
        ARSIZE = 3'b010;                           
        ARBURST = 2'b01;                          
        ARLOCK = 2'b00;                           
        ARCACHE = 4'b0000;                          
        ARPROT = ARPROT_mode;                           
        ARVALID = 1'b0;                                
                                                  
        RREADY = 1'b0; 

        $readmemh("c:/aSYMPL/FP3244_threads/FP321_test1.v", SYSTEM_memP);
        prog_start = SYSTEM_memP[253];  //this is the entry point to the routine
        prog_len = SYSTEM_memP[254];
         i = 12'h0FD;
        j = 18'h110FD;    //the thread will be transfered to SYSTEM_mem starting at location 0x0110FD
        repeat (prog_len) begin
            SYSTEM_mem[j] = SYSTEM_memP[i];
            j = j + 1;
            i = i + 1;
        end 
// create 4 packets of random numbers to be submitted to the shader threads for processing        
// the first locations in the packets contain required parameters followed by the random numbers
// first initialze entire packet working memories to 0
        k = 0;
        repeat(512) begin
            packet3[k] = 0;
            packet2[k] = 0;
            packet1[k] = 0;
            packet0[k] = 0;
            k = k + 1;
        end  
// now build each packet to include the required parameters and random data to be submitted to each thread for processing
// for this first test case the number of data to be crunched on is set to 32
// the following initializes the parameters/operands to be used in the calculations

        packet3[0] = 32'h00000000;  //semaphor and entry point (PC value) for the thread 3 cleared to 0 during push of packet into block RAM
        packet3[1] = 32;            //number of data elements to be operated on
        packet3[2] = 5;             // constA
        packet3[3] = 27;            // constB
        packet3[4] = 255;           // constC

        packet2[0] = 32'h00000000;  //semaphor and entry point (PC value) for the thread 3 cleared to 0 during push of packet into block RAM
        packet2[1] = 32;            //number of data elements to be operated on
        packet2[2] = 88;            // constA
        packet2[3] = 12;            // constB
        packet2[4] = 34;            // constC

        packet1[0] = 32'h00000000;  //semaphor and entry point (PC value) for the thread 3 cleared to 0 during push of packet into block RAM 
        packet1[1] = 32;            //number of data elements to be operated on
        packet1[2] = 43;            // constA
        packet1[3] = 246;           // constB
        packet1[4] = 105;           // constC
 
        packet0[0] = 32'h00000000;  //semaphor and entry point (PC value) for the thread 3 cleared to 0 during push of packet into block RAM 
        packet0[1] = 32;            //number of data elements to be operated on
        packet0[2] = 756;           // constA
        packet0[3] = 99;            // constB
        packet0[4] = 345;           // constC
        
// the following builds the data section of each packet to be submitted

        k = 5;      //this is the displacement in the packet where the data starts
        repeat(32) begin
            packet3[k] = $random & 32'h0000_FFFF;    
            packet2[k] = $random & 32'h0000_FFFF;    
            packet1[k] = $random & 32'h0000_FFFF;    
            packet0[k] = $random & 32'h0000_FFFF;    
            k = k + 1;
        end 

//now copy the packets to SYSTEM_mem so they can be submitted by AXI4

        sys0j = packet0_submit_start;
        sys1j = packet1_submit_start;
        sys2j = packet2_submit_start;
        sys3j = packet3_submit_start;
        
        p0k = 0;
        p1k = 0;
        p2k = 0;
        p3k = 0;
        
        repeat(37) begin
           SYSTEM_mem[sys0j] = packet0[p0k];                        
           SYSTEM_mem[sys1j] = packet1[p1k];                        
           SYSTEM_mem[sys2j] = packet2[p2k];                        
           SYSTEM_mem[sys3j] = packet3[p3k];
           sys0j = sys0j + 1;                        
           sys1j = sys1j + 1;                        
           sys2j = sys2j + 1;                        
           sys3j = sys3j + 1;
           p0k = p0k + 1;
           p1k = p1k + 1;
           p2k = p2k + 1;
           p3k = p3k + 1;
       end     
                                  
                         
    #16	reset = 1'b0;
/////////////////////////////////////////////////////////
//// load program memory with thread to be executed /////
/////////////////////////////////////////////////////////
        @(posedge CLK);
        AXI_block_write (prog_len[11:0], 18'h110FD, rom0_base+(253*4)); //copy shader program into all 4 shader program memories simultaneously
        AXI_write (CSR, 32'h0000_0000); // clear forced-reset lines and allow threads to spin at DONE location
        
/////////////////////////////////////////////////////////
//// submit packets 0-3 to threads 0-3 respectively /////
/////////////////////////////////////////////////////////        
        AXI_block_write (37, packet1_submit_start, thread0_ram_base); //submit job0/packet0 to thread0 for processing
        AXI_write (thread0_ram_base, prog_start); // push PC start address into packet semaphor location to show its ready for processing

        AXI_block_write (37, packet1_submit_start, thread1_ram_base); //submit job1/packet1 to thread1 for processing
        AXI_write (thread1_ram_base, prog_start); // push PC start address into packet semaphor location to show its ready for processing
        AXI_block_write (37, packet2_submit_start, thread2_ram_base); //submit job2/packet2 to thread2 for processing
        AXI_write (thread2_ram_base, prog_start); // push PC start address into packet semaphor location to show its ready for processing
        AXI_block_write (37, packet3_submit_start, thread3_ram_base); //submit job3/packet3 to thread3 for processing
        AXI_write (thread3_ram_base, prog_start); // push PC start address into packet semaphor location to show its ready for processing    

////////////////////////////////////////////////////////////////////
//// retrieve result packets 0-3 from threads 0-3 respectively /////
////////////////////////////////////////////////////////////////////        
        AXI_write (CSR, 32'h0000_0018);  //enable thread0-done interrupt and global interrupt enable
        wait(INTREQ);
        AXI_block_read (41, thread0_ram_base, packet0_result_start); // read results from thread0 when done
        
        AXI_write (CSR, 32'h0000_0028);  //enable thread1-done interrupt and global interrupt enable
        wait(INTREQ);       
        AXI_block_read (41, thread1_ram_base, packet1_result_start); // read results from thread1 when done
        
        AXI_write (CSR, 32'h0000_0048);  //enable thread2-done interrupt and global interrupt enable
        wait(INTREQ);       
        AXI_block_read (41, thread2_ram_base, packet2_result_start); // read results from thread2 when done
        
        AXI_write (CSR, 32'h0000_0088);  //enable thread3-done interrupt and global interrupt enable
        wait(INTREQ);       
        AXI_block_read (41, thread3_ram_base, packet3_result_start); // read results from thread3 when done

        
    #33750

$finish;										  

end	      

task AXI_read;         // for a single transfer (read from target thread RAM)
    input [31:0] rdaddr;
       
    begin
#1
        ARLEN = 4'b0000;   //qty (1) 32-bit write
        ARADDR = rdaddr; 
        ARVALID = 1'b1;
        RREADY = 1'b0;
        wait (ARREADY);
        @(posedge CLK);
#1
        ARVALID = 1'b0;
        RREADY = 1'b1;
        @(posedge CLK);
        @(posedge CLK);
#1
        RREADY = 1'b0;
        rd_shader_data = RDATA;
        @(posedge CLK);
    end    
endtask 

task AXI_burst_read;   // for maximum of 16 transfers read from target core/thread and write to system memory 
    input [3:0] len;
    input [31:0] src_start_addrs;
    input [31:0] dest_start_addrs;
    
    reg [3:0] count;
    reg [31:0] write_pointer;
    
    begin
#1
        write_pointer = dest_start_addrs[17:0];
        ARADDR = src_start_addrs; 
        ARVALID = 1'b1;
        count = len;
        ARLEN = len;   
        RREADY = 1'b0;
        wait (ARREADY);  //ARVALID is in a term in ARREADY from slave
        @(posedge CLK);
#1
        ARVALID = 1'b0;           
        RREADY = 1'b1;
        @(posedge CLK);        
#1
        while(count) begin
            @(posedge CLK);
#1
            SYSTEM_mem[write_pointer[17:0]] = RDATA;
            rd_shader_data = RDATA;
            if (~(count==0))  write_pointer = write_pointer + 3'h1; 
            count = count - 1'b1; 
        end 
        @(posedge CLK);
#1
        RREADY = 1'b0; 
        @(posedge CLK);
    end
endtask                                                                      

task AXI_block_read;  // for transfers > 16 up to 64k (4 bytes per transfer for a total of 256k bytes max)
                      // block transfers FROM slave TO system memory
    input [15:0] len;
    input [31:0] src_start_addrs;
    input [31:0] dest_start_addrs;
    
    reg [3:0] burst_len; // for a given instance in the loop
    reg [31:0] src_pointer;
    reg [31:0] dest_pointer;
    reg [15:0] remaining;   //number of 32-bit words remaining in the overall transaction
    
    begin
#1
        src_pointer = src_start_addrs;
        dest_pointer = dest_start_addrs;
        remaining = len;
        @(posedge CLK);
#1       
        while (remaining) begin
            if (remaining < 16) begin
                burst_len = remaining[3:0] - 1;
                remaining = 0;
                AXI_burst_read (burst_len, src_pointer, dest_pointer);
            end    
            else begin
                burst_len = 15;
                remaining = remaining - 16;
                AXI_burst_read (burst_len, src_pointer, dest_pointer);
                src_pointer = src_pointer + 64;
                dest_pointer = dest_pointer + 16;
            end    
        end
    end
endtask                        


task AXI_block_write;  // for transfers > 16 up to 64k (4 bytes per transfer)
                       // block transfers FROM system memory TO target slave
    input [15:0] len;
    input [31:0] src_start_addrs;
    input [31:0] dest_start_addrs;
    
    reg [3:0] burst_len; // for a given instance in the loop
    reg [31:0] src_pointer;
    reg [31:0] dest_pointer;
    reg [15:0] remaining;   //number of 32-bit words remaining in the overall transaction
    
    begin
#1
        src_pointer = src_start_addrs;
        dest_pointer = dest_start_addrs;
        remaining = len;
        @(posedge CLK);
#1       
        while (remaining) begin
            if (remaining < 16) begin
                burst_len = remaining[3:0] - 1;
                remaining = 0;
                AXI_burst_write (burst_len, src_pointer, dest_pointer);
            end    
            else begin
                burst_len = 15;
                remaining = remaining - 16;
                AXI_burst_write (burst_len, src_pointer, dest_pointer);
                src_pointer = src_pointer + 16;
                dest_pointer = dest_pointer + 64;
            end    
        end
    end
endtask                                
        
task AXI_burst_write;   // for maximum of 16 transfers
    input [3:0] len;
    input [31:0] src_start_addrs;
    input [31:0] dest_start_addrs;
    
    reg [3:0] count;
    reg [31:0] read_pointer;
    
    begin
#1
        read_pointer = src_start_addrs;
        count = len;
        AWLEN = len;   
        AWADDR = dest_start_addrs; 
        AWVALID = 1'b1;
        wait (AWREADY);
        while(count) begin
            @(posedge CLK);
#1
                BREADY = 1'b1;        
                WVALID = 1'b1;
                AWVALID = 1'b0;
                WDATA = SYSTEM_mem[read_pointer[17:0]];
                read_pointer = read_pointer + 3'h1;  
                count = count - 1'b1;
        end     
        @(posedge CLK);
#1
        WDATA = SYSTEM_mem[read_pointer[17:0]];
        WLAST = 1'b1;
        @(posedge CLK);
#1        
        BREADY = 1'b0;    
        WVALID = 1'b0;
        WLAST = 1'b0;
        @(posedge CLK);
    end
endtask                                                                      

task AXI_write;         // for a single transfer
    input [31:0] waddr;
    input [31:0] wdata;
       
    begin
#1
        AWLEN = 4'b0000;   //qty (1) 32-bit write
        AWADDR = waddr; 
        AWVALID = 1'b1;
        wait (AWREADY);
        @(posedge CLK);
#1
        BREADY = 1'b1;        
        AWVALID = 1'b0;
        WLAST = 1'b1;
        WDATA = wdata;
        WVALID = 1'b1;
        @(posedge CLK);
#1
        WVALID = 1'b0;
        WLAST = 1'b0;
        @(posedge CLK);
#1
        BREADY = 1'b0;
        @(posedge CLK);
    end    
endtask  
                                                
always
	begin
		#clk_high_time 
			clk = ~clk;					   
	end
endmodule





































                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           