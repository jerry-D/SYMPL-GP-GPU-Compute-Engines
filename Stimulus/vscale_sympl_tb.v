`include "vscale_ctrl_constants.vh"
`include "vscale_csr_addr_map.vh"

`timescale 1ns/100ps

module vscale_sympl_tb();

   reg clk;
   reg reset;

   wire htif_pcr_resp_valid;
   wire [`HTIF_PCR_WIDTH-1:0] htif_pcr_resp_data;

   reg [7:0]  STL_mem8[131071:0];       //8-bit memory initially loaded with .stl file
   
   wire [31:0] COOL_FEED;
   
   assign COOL_FEED = DUT.hasti_mem.gp_gpu1.datapool.SYS_wrdata;
   
   integer triangle_count;
   integer tri_remaining;
   integer stl_addrs;
   integer riscV_addrs;
   integer r, file;
   
   vscale_sim_top DUT(
                      .clk(clk),
                      .reset(reset),
                      .htif_pcr_req_valid(1'b1),
                      .htif_pcr_req_ready(),
                      .htif_pcr_req_rw(1'b0),
                      .htif_pcr_req_addr(`CSR_ADDR_TO_HOST),
                      .htif_pcr_req_data(`HTIF_PCR_WIDTH'b0),
                      .htif_pcr_resp_valid(htif_pcr_resp_valid),
                      .htif_pcr_resp_ready(1'b1),
                      .htif_pcr_resp_data(htif_pcr_resp_data)
                      );

   initial begin
      clk = 0;
      reset = 1;
   end

   always #5 clk = !clk;

   initial begin
   
        file = $fopen("risc_v_test.hex", "rb");   
        r = $fread(DUT.hasti_mem.mem[0], file, 16'h0080);    // load RISC V program memory with its program, starting at byte address 0x0200 
        $fclose(file);
   
        file = $fopen("olive.stl", "rb");   
        r = $fread(STL_mem8[0], file);       // "olive.stl" loaded into 8-bit test bench memory
        $fclose(file);  

        triangle_count = {STL_mem8[83],  STL_mem8[82],  STL_mem8[81],  STL_mem8[80]};
        stl_addrs = 96;  //first byte of first x1 of first triangle location (byte address) in STL_mem8
        riscV_addrs = 16'h800B;  //first x1 of first triangle location (32-bit aligned) in riscV memory
        tri_remaining = triangle_count;
        DUT.hasti_mem.mem[16'h8001] = triangle_count;      
        while (tri_remaining) begin
         #1
            DUT.hasti_mem.mem[riscV_addrs]   = {STL_mem8[stl_addrs+3],  STL_mem8[stl_addrs+2],  STL_mem8[stl_addrs+1],  STL_mem8[stl_addrs]};     //x1
            DUT.hasti_mem.mem[riscV_addrs+1] = {STL_mem8[stl_addrs+7],  STL_mem8[stl_addrs+6],  STL_mem8[stl_addrs+5],  STL_mem8[stl_addrs+4]};   //y1
            DUT.hasti_mem.mem[riscV_addrs+2] = {STL_mem8[stl_addrs+11], STL_mem8[stl_addrs+10], STL_mem8[stl_addrs+9],  STL_mem8[stl_addrs+8]};   //z1
       
            DUT.hasti_mem.mem[riscV_addrs+3] = {STL_mem8[stl_addrs+15], STL_mem8[stl_addrs+14], STL_mem8[stl_addrs+13], STL_mem8[stl_addrs+12]};  //x2
            DUT.hasti_mem.mem[riscV_addrs+4] = {STL_mem8[stl_addrs+19], STL_mem8[stl_addrs+18], STL_mem8[stl_addrs+17], STL_mem8[stl_addrs+16]};  //y2
            DUT.hasti_mem.mem[riscV_addrs+5] = {STL_mem8[stl_addrs+23], STL_mem8[stl_addrs+22], STL_mem8[stl_addrs+21], STL_mem8[stl_addrs+20]};  //z2
       
            DUT.hasti_mem.mem[riscV_addrs+6] = {STL_mem8[stl_addrs+27], STL_mem8[stl_addrs+26], STL_mem8[stl_addrs+25], STL_mem8[stl_addrs+24]};  //x3
            DUT.hasti_mem.mem[riscV_addrs+7] = {STL_mem8[stl_addrs+31], STL_mem8[stl_addrs+30], STL_mem8[stl_addrs+29], STL_mem8[stl_addrs+28]};  //y3
            DUT.hasti_mem.mem[riscV_addrs+8] = {STL_mem8[stl_addrs+35], STL_mem8[stl_addrs+34], STL_mem8[stl_addrs+33], STL_mem8[stl_addrs+32]};  //z3
           
            tri_remaining = tri_remaining - 1;
            stl_addrs = stl_addrs + 50;      //skip over 16-bit attribute and norm part of vector
            riscV_addrs = riscV_addrs + 9;
         end 
         
         #100 reset = 0;
         
         wait (COOL_FEED==32'hC001FEED);
         
         #1
         stl_addrs = 96;  //first byte of first x1 of first triangle location (byte address) in STL_mem8
         riscV_addrs = 16'h800B;  //first x1 of first triangle location (32-bit aligned) in riscV memory
         tri_remaining = triangle_count;
        
         while (tri_remaining) begin
         #1
            {STL_mem8[stl_addrs+3],  STL_mem8[stl_addrs+2],  STL_mem8[stl_addrs+1],  STL_mem8[stl_addrs]}    = DUT.hasti_mem.mem[riscV_addrs]  ;   //x1 
            {STL_mem8[stl_addrs+7],  STL_mem8[stl_addrs+6],  STL_mem8[stl_addrs+5],  STL_mem8[stl_addrs+4]}  = DUT.hasti_mem.mem[riscV_addrs+1];   //y1 
            {STL_mem8[stl_addrs+11], STL_mem8[stl_addrs+10], STL_mem8[stl_addrs+9],  STL_mem8[stl_addrs+8]}  = DUT.hasti_mem.mem[riscV_addrs+2];   //z1 
                                                                                                                                                       
            {STL_mem8[stl_addrs+15], STL_mem8[stl_addrs+14], STL_mem8[stl_addrs+13], STL_mem8[stl_addrs+12]} = DUT.hasti_mem.mem[riscV_addrs+3];   //x2 
            {STL_mem8[stl_addrs+19], STL_mem8[stl_addrs+18], STL_mem8[stl_addrs+17], STL_mem8[stl_addrs+16]} = DUT.hasti_mem.mem[riscV_addrs+4];   //y2 
            {STL_mem8[stl_addrs+23], STL_mem8[stl_addrs+22], STL_mem8[stl_addrs+21], STL_mem8[stl_addrs+20]} = DUT.hasti_mem.mem[riscV_addrs+5];   //z2 
                                                                                                                                                      
            {STL_mem8[stl_addrs+27], STL_mem8[stl_addrs+26], STL_mem8[stl_addrs+25], STL_mem8[stl_addrs+24]} = DUT.hasti_mem.mem[riscV_addrs+6];   //x3 
            {STL_mem8[stl_addrs+31], STL_mem8[stl_addrs+30], STL_mem8[stl_addrs+29], STL_mem8[stl_addrs+28]} = DUT.hasti_mem.mem[riscV_addrs+7];   //y3 
            {STL_mem8[stl_addrs+35], STL_mem8[stl_addrs+34], STL_mem8[stl_addrs+33], STL_mem8[stl_addrs+32]} = DUT.hasti_mem.mem[riscV_addrs+8];   //z3 
            
            tri_remaining = tri_remaining - 1;
            stl_addrs = stl_addrs + 50;      //skip over 16-bit attribute and norm part of vector
            riscV_addrs = riscV_addrs + 9;
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

