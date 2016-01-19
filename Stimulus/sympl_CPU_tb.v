
`timescale 1ns/100ps

module sympl_CPU_tb();

   reg clk;
   reg reset;


   reg [7:0]  STL_mem8[131071:0];       //8-bit memory initially loaded with .stl file
    
   wire CPU_done;
         
   integer triangle_count;
   integer tri_remaining;
   integer stl_addrs;
   integer risc_addrs;
   integer r, file;
   
   // the following wires and assigns are just for simulation visibility
   wire [31:0] x1;
   wire [31:0] y1;
   wire [31:0] z1;
   wire [31:0] x2;
   wire [31:0] y2;
   wire [31:0] z2;
   wire [31:0] x3;
   wire [31:0] y3;
   wire [31:0] z3;

   wire [31:0] x1stl_ram;
   wire [31:0] y1stl_ram;
   wire [31:0] z1stl_ram;
   wire [31:0] x2stl_ram;
   wire [31:0] y2stl_ram;
   wire [31:0] z2stl_ram;
   wire [31:0] x3stl_ram;
   wire [31:0] y3stl_ram;
   wire [31:0] z3stl_ram;
   
   
   assign x1 = t.rom4096_cpu.triportRAMB[risc_addrs]  ;   //x1 
   assign y1 = t.rom4096_cpu.triportRAMB[risc_addrs+1];   //y1 
   assign z1 = t.rom4096_cpu.triportRAMB[risc_addrs+2];   //z1 
   assign x2 = t.rom4096_cpu.triportRAMB[risc_addrs+3];   //x2 
   assign y2 = t.rom4096_cpu.triportRAMB[risc_addrs+4];   //y2 
   assign z2 = t.rom4096_cpu.triportRAMB[risc_addrs+5];   //z2 
   assign x3 = t.rom4096_cpu.triportRAMB[risc_addrs+6];   //x3 
   assign y3 = t.rom4096_cpu.triportRAMB[risc_addrs+7];   //y3 
   assign z3 = t.rom4096_cpu.triportRAMB[risc_addrs+8];   //z3 
   
   assign x1stl_ram = {STL_mem8[stl_addrs+3],  STL_mem8[stl_addrs+2],  STL_mem8[stl_addrs+1],  STL_mem8[stl_addrs]}   ;   //x1 
   assign y1stl_ram = {STL_mem8[stl_addrs+7],  STL_mem8[stl_addrs+6],  STL_mem8[stl_addrs+5],  STL_mem8[stl_addrs+4]} ;   //y1 
   assign z1stl_ram = {STL_mem8[stl_addrs+11], STL_mem8[stl_addrs+10], STL_mem8[stl_addrs+9],  STL_mem8[stl_addrs+8]} ;   //z1 
   assign x2stl_ram = {STL_mem8[stl_addrs+15], STL_mem8[stl_addrs+14], STL_mem8[stl_addrs+13], STL_mem8[stl_addrs+12]};   //x2 
   assign y2stl_ram = {STL_mem8[stl_addrs+19], STL_mem8[stl_addrs+18], STL_mem8[stl_addrs+17], STL_mem8[stl_addrs+16]};   //y2 
   assign z2stl_ram = {STL_mem8[stl_addrs+23], STL_mem8[stl_addrs+22], STL_mem8[stl_addrs+21], STL_mem8[stl_addrs+20]};   //z2 
   assign x3stl_ram = {STL_mem8[stl_addrs+27], STL_mem8[stl_addrs+26], STL_mem8[stl_addrs+25], STL_mem8[stl_addrs+24]};   //x3 
   assign y3stl_ram = {STL_mem8[stl_addrs+31], STL_mem8[stl_addrs+30], STL_mem8[stl_addrs+29], STL_mem8[stl_addrs+28]};   //y3 
   assign z3stl_ram = {STL_mem8[stl_addrs+35], STL_mem8[stl_addrs+34], STL_mem8[stl_addrs+33], STL_mem8[stl_addrs+32]};   //z3 
      
   SYMPL_CPU t(
              .CLK (clk),
              .RESET (reset),
              .CPU_done (CPU_done)
              );

   initial begin
      clk = 0;
      reset = 1;
   end

   always #5 clk = !clk;

   initial begin
 
        file = $fopen("olive.stl", "rb");   
        r = $fread(STL_mem8[0], file);       // "olive.stl" loaded into 8-bit test bench memory
        $fclose(file);  

        triangle_count = {STL_mem8[83],  STL_mem8[82],  STL_mem8[81],  STL_mem8[80]};
        stl_addrs = 96;  //first byte of first x1 of first triangle location (byte address) in STL_mem8
        risc_addrs = 20'h0020B;  //first x1 of first triangle location (32-bit aligned) in risc memory
        tri_remaining = triangle_count;
        t.rom4096_cpu.triportRAMB[20'h00201] = triangle_count;      
        while (tri_remaining) begin
         #1
            t.rom4096_cpu.triportRAMB[risc_addrs]   = {STL_mem8[stl_addrs+3],  STL_mem8[stl_addrs+2],  STL_mem8[stl_addrs+1],  STL_mem8[stl_addrs]};     //x1
            t.rom4096_cpu.triportRAMB[risc_addrs+1] = {STL_mem8[stl_addrs+7],  STL_mem8[stl_addrs+6],  STL_mem8[stl_addrs+5],  STL_mem8[stl_addrs+4]};   //y1
            t.rom4096_cpu.triportRAMB[risc_addrs+2] = {STL_mem8[stl_addrs+11], STL_mem8[stl_addrs+10], STL_mem8[stl_addrs+9],  STL_mem8[stl_addrs+8]};   //z1
       
            t.rom4096_cpu.triportRAMB[risc_addrs+3] = {STL_mem8[stl_addrs+15], STL_mem8[stl_addrs+14], STL_mem8[stl_addrs+13], STL_mem8[stl_addrs+12]};  //x2
            t.rom4096_cpu.triportRAMB[risc_addrs+4] = {STL_mem8[stl_addrs+19], STL_mem8[stl_addrs+18], STL_mem8[stl_addrs+17], STL_mem8[stl_addrs+16]};  //y2
            t.rom4096_cpu.triportRAMB[risc_addrs+5] = {STL_mem8[stl_addrs+23], STL_mem8[stl_addrs+22], STL_mem8[stl_addrs+21], STL_mem8[stl_addrs+20]};  //z2
       
            t.rom4096_cpu.triportRAMB[risc_addrs+6] = {STL_mem8[stl_addrs+27], STL_mem8[stl_addrs+26], STL_mem8[stl_addrs+25], STL_mem8[stl_addrs+24]};  //x3
            t.rom4096_cpu.triportRAMB[risc_addrs+7] = {STL_mem8[stl_addrs+31], STL_mem8[stl_addrs+30], STL_mem8[stl_addrs+29], STL_mem8[stl_addrs+28]};  //y3
            t.rom4096_cpu.triportRAMB[risc_addrs+8] = {STL_mem8[stl_addrs+35], STL_mem8[stl_addrs+34], STL_mem8[stl_addrs+33], STL_mem8[stl_addrs+32]};  //z3
           
            tri_remaining = tri_remaining - 1;
            stl_addrs = stl_addrs + 50;      //skip over 16-bit attribute and norm part of vector
            risc_addrs = risc_addrs + 9;
         end 
         
         #100 reset = 0;
         
         #1 wait (~CPU_done);
         #1 wait (CPU_done);
         
         #1
         stl_addrs = 96;  //first byte of first x1 of first triangle location (byte address) in STL_mem8
         risc_addrs = 20'h0020B;  //first x1 of first triangle location (32-bit aligned) in risc memory
         tri_remaining = triangle_count;
         #1       
         while (tri_remaining) begin
         #1        
            {STL_mem8[stl_addrs+3],  STL_mem8[stl_addrs+2],  STL_mem8[stl_addrs+1],  STL_mem8[stl_addrs]}    = t.rom4096_cpu.triportRAMB[risc_addrs]  ;   //x1 
            {STL_mem8[stl_addrs+7],  STL_mem8[stl_addrs+6],  STL_mem8[stl_addrs+5],  STL_mem8[stl_addrs+4]}  = t.rom4096_cpu.triportRAMB[risc_addrs+1];   //y1 
            {STL_mem8[stl_addrs+11], STL_mem8[stl_addrs+10], STL_mem8[stl_addrs+9],  STL_mem8[stl_addrs+8]}  = t.rom4096_cpu.triportRAMB[risc_addrs+2];   //z1 
                                                                                                                                                       
            {STL_mem8[stl_addrs+15], STL_mem8[stl_addrs+14], STL_mem8[stl_addrs+13], STL_mem8[stl_addrs+12]} = t.rom4096_cpu.triportRAMB[risc_addrs+3];   //x2 
            {STL_mem8[stl_addrs+19], STL_mem8[stl_addrs+18], STL_mem8[stl_addrs+17], STL_mem8[stl_addrs+16]} = t.rom4096_cpu.triportRAMB[risc_addrs+4];   //y2 
            {STL_mem8[stl_addrs+23], STL_mem8[stl_addrs+22], STL_mem8[stl_addrs+21], STL_mem8[stl_addrs+20]} = t.rom4096_cpu.triportRAMB[risc_addrs+5];   //z2 
                                                                                                                                                      
            {STL_mem8[stl_addrs+27], STL_mem8[stl_addrs+26], STL_mem8[stl_addrs+25], STL_mem8[stl_addrs+24]} = t.rom4096_cpu.triportRAMB[risc_addrs+6];   //x3 
            {STL_mem8[stl_addrs+31], STL_mem8[stl_addrs+30], STL_mem8[stl_addrs+29], STL_mem8[stl_addrs+28]} = t.rom4096_cpu.triportRAMB[risc_addrs+7];   //y3 
            {STL_mem8[stl_addrs+35], STL_mem8[stl_addrs+34], STL_mem8[stl_addrs+33], STL_mem8[stl_addrs+32]} = t.rom4096_cpu.triportRAMB[risc_addrs+8];   //z3 

            tri_remaining = tri_remaining - 1;
            stl_addrs = stl_addrs + 50;      //skip over 16-bit attribute and norm part of vector
            risc_addrs = risc_addrs + 9;
         end 
         #1
         stl_addrs = 0;        
         file = $fopen("olive_trans.stl", "wb");            
         while(r) begin
             $fwrite(file, "%c", STL_mem8[stl_addrs]);
             #1 stl_addrs = stl_addrs + 1;
             r = r - 1;
         end 
         #1
         $fclose(file);
         
         $finish;                  
   end 

endmodule 

