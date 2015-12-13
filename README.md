![](https://github.com/jerry-D/SYMPL-FP324-AXI4-GP-GPU/blob/master/web_logo.jpg)

With SYMPL GP-GPU-Compute Engines, adding a single, dual or quad-shader GP-GPU-compute core to your RISC-V is no more difficult than it is to add a 64-k word, block SRAM to your design (see block diagrams below).  With the single-shader version (four interleaving threads), you can boost performance of your application by up to 125 MFLOPs @ 125Mhz.  With the dual-shader version (eight interleaving threads), you get up to 250 MFLOPs @125Mhz.  With the quad-shader (sixteen interleaving threads), you get up to 500 MFLOPs @125 Mhz, when implemented in Kintex 7 (-3 speed-grade) devices.

Block diagrams for each can be viewed by clicking on the corresponding thumb image below:

[Single-Shader Version](https://github.com/jerry-D/SYMPL-FP324-AXI4-GP-GPU/blob/master/SYMPL_GP_GPU1.jpg)

![](https://github.com/jerry-D/SYMPL-FP324-AXI4-GP-GPU/blob/master/SYMPL_GP_GPU1_thumb.jpg)

[Dual-Shader Version](https://github.com/jerry-D/SYMPL-FP324-AXI4-GP-GPU/blob/master/SYMPL_GP_GPU2.jpg)

![](https://github.com/jerry-D/SYMPL-FP324-AXI4-GP-GPU/blob/master/SYMPL_GP_GPU2_thumb.jpg)

[Quad-Shader Version](https://github.com/jerry-D/SYMPL-FP324-AXI4-GP-GPU/blob/master/SYMPL_GP_GPU4.jpg)

![](https://github.com/jerry-D/SYMPL-FP324-AXI4-GP-GPU/blob/master/SYMPL_GP_GPU4_thumb.jpg)

SYMPL GP-GPU-Compute engines presently employ FloPoCo-generated, 32-bit, single-precision operators have additional logic to make them IEEE754-2008 compliant.   For example, additional logic was added to implement the default round-to-nearest as well as round to positive infinity, negative infinity and zero.  Both quiet and signaling NaNs are now properly handled.  Subnormals are not flushed to zero, but are allowed to gradually underflow, pursuant to the IEEE754-2008 standard.  Default, alternate immediate and alternate delayed exception handling is also supported.

For more information regarding the FloPoCo library and generator, read the article at the link provided below:
Florent de Dinechin and Bogdan Pasca.  Designing custom arithmetic data paths with FloPoCo.  IEEE Design & Test of Computers, 28(4):18—27, July 2011.

http://perso.citi-lab.fr/fdedinec/recherche/publis/2011-DaT-FloPoCo.pdf

FloPoCo website:   http://flopoco.gforge.inria.fr

All SYMPL GP-GPU-Compute engines feature the following operators:
FADD, FSUB, FMUL, FMA, FDIV, DOT, SQRT, LOG, EXP, ITOF, FTOI, SIN, COS, TAN, COT and RCP.   FMA (fused-multiply-add) is dual-mode in that it can be used as a conventional FMA and/or used to perform long series DOT-product operations in that the significand has been enlarged to thirty-eight bits, wherein it can absorb underflows for extra long series computations, results all being held in forty-eight-bit, fat accumulators, the results of each computation never being rounded until finally read out of their individual result buffers (there are sixty-four of them per shader).

Presently, SYMPL GP-GPU-Compute engines are available in the form of a single, dual, or quad-shaders, each comprising four, interleaving threads, with each thread having its own private, 1k-word deep, parameter-data buffer (PDB) and a 4k-word, global intermediate result buffer (IRB), where each thread can temporarily store intermediate results and/or share with the other threads in the shader.

Additionally, each core also includes a software-programmable coarse-grained scheduler (CGS), whose function it is to distribute the workload among the available threads.  Specifically, operating under its own micro-kernel, it pulls parameters and data from the integral 64k-word data pool that is connected to the CPU and distributes the workload by pushing a portion of the data (including required parameters) into the PDBs of each thread for processing.  As the threads complete processing, the CGS then begins to pull results from the respective thread's PDB and then pushes such results back into the data pool for retrieval by the CPU, which can be a RISC-V, ARM or just about any processor, including another GP-GPU.

Included with this distribution package is an example test case which can be simulated on Xilinx “free” version of Vivado.  The example test case takes a 3D representation of an olive in binary .stl file format and performs a 3D transformation on all three axis, which includes:  scale(x, y, z), rotate(x, y, x) and translate(x, y, z).   The “olive” was created using the OpenSCAD, free open source 3D modeling environment and was exported in ASCII .stl file format.  To convert to binary, the “olive.stl” file was imported into “Blender” free open source 3D modeling environment and immediately exported back to .stl format, which, for Blender is binary format.  Below is the “before” and “after” 3D rendering of the olive as viewed with OpenSCAD.  Note that the number of faces were kept to a minimum to facilitate faster simulation.

The “Olive” Before and After
![](https://github.com/jerry-D/SYMPL-FP324-AXI4-GP-GPU/blob/master/Olive_3_rotates.jpg)

To run this simulation using Vivado, download or clone the SYMPL GP-GPU-Compute engine in this repository.  Next, you will need to click on the VSCALE (RISC-V) repository link below and download or clone those files as well.  Note that to run this simulation, you will not need any of the files in the VSCALE “test” folder—you only need the design files in the VSCALE “verilog” folder.  All the other files you need are in the SYMPL GP-GPU-Compute package.

https://github.com/ucb-bar/vscale

For the simulation, you need to make sure that the following four files are in the Vivado working directory.  These are the little programs and .stl file that the CGS, shader theads and RISC-V run to carry out their function and can be found in the “ASM” folder:

“CGS_olive_dma.v”   
“risc_v_test.HEX”
“Shader_olive.v”
“olive.stl”

“CGS_olive_dma.v” is the coarse-grained scheduler's micro-kernel in Verilog-formatted  ASCII hex that is automatically loaded by the CGS ROM “initial” block at the beginning of the simulation.  Likewise, “Shader_olive.v” is the routine in Verilog-formatted ASCII hex that is automatically loaded by the Shader ROM “initial” block at the start of the simulation.
The file “risc_v_test.HEX” is a binary image of the program that the RISC-V executes to push the parameters and .stl file data into the data pool for processing by the GP-GPU and then pull results out and store them in its own system memory.  The supplied test bench explicitly performs the loading of both the RISC-V's program and the “olive.stl” file.

Assembly language source for the CGS, Shaders and RISC-V above-named programs, along with respective assembled object listing files, can be found in the ASM folder.  Additionally, instruction tables for all three instruction-sets can also be found there.  Note that the CGS and Shaders have the same instruction set, except the CGS has no floats.  The above-mentioned instruction tables are used by the Cross-32 Universal Cross-Assembler, which is a table-driven cross-assembler available for purchase at the following link:

http://wwwcdadapter.com/cross32.htm

The user manual in .pdf format for Cross-32 can be downloaded here:

http://www.cdadapter.com/download/cross32.pdf

It should be noted that all three implementations of the SYMPL  GP-GPU run the exact same unaltered identical code and thus there is no need to load different programs for different configurations.  

In this example, the SYMPL GP-GPU-Compute engine is instantiated in the file named, “vscale_dp_hasti_sram.v” and can be found in the “stimulus” folder of this SYMPL GP-GPU distribution package.   The quad-shader version is currently specified in the “vscale_dp_hasti_sram.v” module as the instantiated GP-GPU.  To change the GP-GPU from quad to dual or single shader, simply open said file up and remove the comments in front of the one that you want, shown as follows:

//   FP3211 gp_gpu1 ( //single-shader version (4 threads)
   FP323 gp_gpu1 (  //dual-shader version (8 threads)
//   FP325 gp_gpu1 (  //quad-shader version (16 threads)
                  .CLKA   (hclk        ),  //for RISC-V side of DP SRAM
                  .CLKB   (hclk        ),  //for GPU clock and GPU side of DP SRAM (ie, clocks can run at different freq)
                  .RESET  (~hresetn    ),
                  .WREN   (dpool_wren  ),
                  .WRADDRS(dpool_addrs),
                  .WRDATA ((mem[p0_word_waddr] & ~p0_wmask) | (p0_wdata & p0_wmask)),
                  .RDEN   (dpool_rden  ),
                  .RDADDRS(dpool_addrs),
                  .RDDATA (dpool_rddata),
                  .DONE   (gpu_done    )  
                  );

Finally, you should be aware that for a single shader GP-GPU, the simulation will require roughly 425 usec to complete and that the test bench does have a $finish.  Just before the $finish, the test bench will write the transformed “olive_trans.stl” file to the working directory.  You can view this file using any online .stl file viewer, OpenSCAD, or Blender.

In the above case, with just a single shader, roughly 164 usec of the 412 usec is consumed by the RISC-V pushing parameters/data into the data pool and pulling them back out again, meaning that the four shader threads consume roughly 226 usec to do the transformation (@100 MHz).

The dual-shader version of the SYMPL GP-GPU does the transformation in roughly 124 usec @ 100Mhz.  The quad-shader version can do the transformation in roughtly 75.7 usec @ 100MHz, meaning that both the dual and quad shader GP-GPUs can compute the entire3D  transform faster than the RISC-V (VSCALE version) can push/pull the data.  This can be improved somewhat by incorporating a DMA channel between the RISC-V system memory and the data pool.

If you have any questions or need assistance getting your simulation running, please don't hesitate to contact me at:  SYMPL.gpu@gmail.com



