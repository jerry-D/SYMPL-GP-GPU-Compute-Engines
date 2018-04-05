![](https://github.com/jerry-D/SYMPL-FP324-AXI4-GP-GPU/blob/master/web_logo.jpg)

(Update:  April 5, 2018)  After further study and input from various users, it has been brought to my attention that this design's hardware is not fully IEEE 754-2008 compliant.  Accordingly, all references to such have been deleted with apologies for any inconvence this may have caused you.  If you'd like to try a another GP-GPU Compute Unit that I believe "is" IEEE 754-2008 compliant, check out this one:  https://github.com/jerry-D/IEEE-754-2008-Emulator

(Update:  January 18, 2016)  The SYMPL GP-GPU-Compute Engine repository now includes the SYMPL 32-bit RISC CPU.  It executes the same instruction set as the GP-GPU and Coarse-Grained Scheduler (CGS).  Also included with this update is a new instruction table that allows you to write your programs and threads in the new SYMPL Intermediate Language (SYMPL IL) and/or assembly.  SYMPL IL is similar to a primative form of the BASIC programming language.  In the "ASM" folder, you will find the example thread source files and object listing files used for the simulation described below, one verision is in SYMPL assembly language and the other is written in SYMPL IL.  The object code produced by the assembler is identical.

The new test case for the SYMPL version now allows you to choose from one to sixteen GP-GPUs in your design.  There is no need to re-write your programs for one or the other, as the CPU and CGSs automatically figure out how many GP-GPUs are connected to it and distribute the workload accordingly. Below is a screen capture showing how to select the number of GP-GPUs for a particular test run. Simply remove the comments from in front of the source line to expose the desired configuration.  That's all there is to it.  You also need to make sure that the following files are in the working directory after you do your compile, as they are the hex files that are automatically loaded into the CPU, CGS and GP-GPU program memories when the simulation is run.  

The files can be found in the ASM folder:  "CGS_olive_dma_SIL.v", "MP_RISC_SIL.v" and "Shader_olive_SIL.v".  "olive.stl" also needs to be in the working directory for simulation, as this is the 3D object in .stl file format that gets transformed by the GP-GPU.  Results from the 3D transformation will be written the working directory upon completion of the simulation with the file name, "olive_trans.stl" and can be viewed in 3D using any online .stl file viewer.

For the SYMPL RISC version, the file containing the following instantiation is "SYMPL_CPU.v" and is the top level of the design.

![](https://github.com/jerry-D/SYMPL-GP-GPU-Compute-Engines/blob/0cfa6ef1360efe26c08f0c166dc08d52f22c6964/CPU_GP-GPU_inst.png)

With SYMPL GP-GPU-Compute Engines, adding a single, dual or quad-shader GP-GPU-compute core to your SYMPL RISC CPU or RISC-V is no more difficult than it is to add a 64-k word, block SRAM to your design (see block diagrams below).  With the single-shader version (four interleaving threads), you can boost performance of your application by up to 125 MFLOPs @ 125Mhz.  With the dual-shader version (eight interleaving threads), you get up to 250 MFLOPs @125Mhz.  With the quad-shader (sixteen interleaving threads), you get up to 500 MFLOPs @125 Mhz, when implemented in Kintex 7 (-3 speed-grade) devices.  The sixteen-shader version can have results ready for pulling from the data-pool in roughtly 8usec from the time the last triangle is written into the last GP-GPU data-pool by the CPU.

Block diagrams in .png format can be downloaded by clicking on the corresponding link below:

[SYMPL RISC CPU with Sixteen-GP-GPU-Compute Engine (64 threads)](https://github.com/jerry-D/SYMPL-GP-GPU-Compute-Engines/blob/master/SYMPL_16_Shader_CPU_GPGPU_COMBO_96.png)

![](https://github.com/jerry-D/SYMPL-GP-GPU-Compute-Engines/blob/master/SYMPL_16_Shader_CPU_GPGPU_COMBO_96.png)

[SYMPL RISC CPU with Eight-GP-GPU-Compute Engine (32 threads)](https://github.com/jerry-D/SYMPL-GP-GPU-Compute-Engines/blob/master/SYMPL_8_Shader_CPU_GPGPU_COMBO_pub.pdf)

![](https://github.com/jerry-D/SYMPL-GP-GPU-Compute-Engines/blob/master/SYMPL_8_Shader_CPU_GPGPU_COMBO_pub.png)

[SYMPL RISC CPU with Four-GP-GPU-Compute Engine (16 threads)](https://github.com/jerry-D/SYMPL-GP-GPU-Compute-Engines/blob/master/SYMPL_4_Shader_CPU_GPGPU_COMBO_pub.pdf)

![](https://github.com/jerry-D/SYMPL-GP-GPU-Compute-Engines/blob/master/SYMPL_4_Shader_CPU_GPGPU_COMBO_pub.png)

[SYMPL RISC CPU with Two-GP-GPU-Compute Engine (8 threads)](https://github.com/jerry-D/SYMPL-GP-GPU-Compute-Engines/blob/master/SYMPL_2_Shader_CPU_GPGPU_COMBO_pub.pdf)

![](https://github.com/jerry-D/SYMPL-GP-GPU-Compute-Engines/blob/master/SYMPL_2_Shader_CPU_GPGPU_COMBO_pub.png)

SYMPL GP-GPU-Compute engines presently employ FloPoCo-generated, 32-bit, single-precision operators have additional logic.   For example, additional logic was added to implement the default round-to-nearest as well as round to positive infinity, negative infinity and zero.  Both quiet and signaling NaNs are now properly handled.    Default, alternate immediate and alternate delayed exception handling is also supported.

For more information regarding the FloPoCo library and generator, read the article at the link provided below:
Florent de Dinechin and Bogdan Pasca.  Designing custom arithmetic data paths with FloPoCo.  IEEE Design & Test of Computers, 28(4):18—27, July 2011.

http://perso.citi-lab.fr/fdedinec/recherche/publis/2011-DaT-FloPoCo.pdf

FloPoCo website:   http://flopoco.gforge.inria.fr

All SYMPL GP-GPU-Compute engines feature the following operators:
FADD, FSUB, FMUL, FMA, FDIV, DOT, SQRT, LOG, EXP, ITOF, FTOI, SIN, COS, TAN, COT and RCP.   FMA (fused-multiply-add) is dual-mode in that it can be used as a conventional FMA and/or used to perform long series DOT-product operations in that the significand has been enlarged to thirty-eight bits, wherein it can absorb underflows for extra long series computations, results all being held in forty-eight-bit, fat accumulators, the results of each computation never being rounded until finally read out of their individual result buffers (there are sixty-four of them per shader).

Presently, SYMPL GP-GPU-Compute engines are available in the form of single, dual, quad, eight and sixteen shaders, each comprising four, interleaving threads, with each thread having its own private, 1k-word deep, parameter-data buffer (PDB) and a 4k-word, global intermediate result buffer (IRB), where each thread can temporarily store intermediate results and/or share with the other threads in the shader.

Additionally, each GP-GPU-Compute engine also includes a dedicated, software-programmable, coarse-grained scheduler (CGS), whose function it is to distribute the workload among the available threads.  Specifically, operating under its own micro-kernel, it pulls parameters and data from the integral 64k-word data pool that is connected to the CPU and distributes the workload by pushing a portion of the data (including required parameters) into the PDBs of each thread for processing.  As the threads complete processing, the CGS then begins to pull results from the respective thread's PDB and then pushes such results back into the data pool for retrieval by the CPU, which can be a SYMPL RISC, RISC-V, ARM or just about any processor, including another GP-GPU.

Included with this distribution package is an example test case, which can be simulated on Xilinx “free” version of Vivado.  The example test case takes a 3D representation of an olive in binary .stl file format and performs a 3D transformation on all three axis, which includes:  scale(x, y, z), rotate(x, y, x) and translate(x, y, z).   The “olive” was created using the OpenSCAD, free open source 3D modeling environment and was exported in ASCII .stl file format.  To convert to binary, the “olive.stl” file was imported into “Blender”, free open source 3D modeling environment, and immediately exported back to .stl format, which, for Blender, is binary format.  Below is the “before” and “after” 3D rendering of the olive as viewed with OpenSCAD.  Note that the number of faces were kept to a minimum to facilitate faster simulation.

The “Olive” Before and After

![](https://github.com/jerry-D/SYMPL-FP324-AXI4-GP-GPU/blob/master/olive_trans_both.gif.gif)

To run this simulation for the RISC-V using Vivado, download or clone the SYMPL GP-GPU-Compute engine in this repository.  Next, you will need to click on the VSCALE (RISC-V) repository link below and download or clone those files as well.  Note that to run this simulation, you will not need any of the files in the VSCALE “test” folder--you only need the design files in the VSCALE “verilog” folder.  All the other files you need are in the SYMPL GP-GPU-Compute package.

https://github.com/ucb-bar/vscale

For the simulation, you need to make sure that the following four files are in the Vivado working directory.  These are the little programs and .stl file that the CGS, shader threads and RISC-V run to carry out their function and can be found in the “ASM” folder:

"CGS_olive_dma_SIL.v" is the coarse-grained scheduler's micro-kernel in Verilog-formatted  ASCII hex that is automatically loaded by the CGS ROM “initial” block at the beginning of the simulation.  Likewise, "Shader_olive_SIL.v" is the routine in Verilog-formatted ASCII hex that is automatically loaded by the Shader ROM “initial” block at the start of the simulation.
The file “risc_v_test.HEX” is a binary image of the program that the RISC-V executes to push the parameters and .stl file data into the data pool for processing by the GP-GPU and then pull results out and store them in its own system memory.  The supplied test bench explicitly performs the loading of both the RISC-V's program and the “olive.stl” binary files.

Assembly language source for the CGS, Shaders and RISC-V above-named programs, along with respective assembled object listing files, can be found in the ASM folder.  Additionally, instruction tables for all three instruction-sets can also be found there.  Note that the CGS and Shaders have the same instruction set, except the CGS has no floats.  The above-mentioned instruction tables are used by the Cross-32 Universal Cross-Assembler, which is a table-driven cross-assembler available for purchase at the following link:

http://wwwcdadapter.com/cross32.htm

The user manual in .pdf format for Cross-32 can be downloaded here:

http://www.cdadapter.com/download/cross32.pdf

It should be noted that all three implementations of the SYMPL GP-GPU run the exact same unaltered identical code and thus there is no need to load different programs for different configurations.  

In this example, the SYMPL GP-GPU-Compute engine is instantiated in the file named, “vscale_dp_hasti_sram.v” and can be found in the “stimulus” folder of this SYMPL GP-GPU distribution package.   The quad-shader version is currently specified in the “vscale_dp_hasti_sram.v” module as the instantiated GP-GPU.  To change the GP-GPU from quad to dual or single shader, simply open said file up and remove the comments in front of the one that you want, shown as follows:

![](https://github.com/jerry-D/SYMPL-GP-GPU-Compute-Engines/blob/master/RISC_V_GP-GPU_inst.png)

Finally, you should be aware that for a single shader GP-GPU, the simulation will require roughly 425 usec to complete and that the test bench does have a "$finish" at the end.  Just before the $finish, the test bench will write the transformed “olive_trans.stl” file to the working directory.  You can view this file using any online .stl file viewer (including the one at GitHub), OpenSCAD, or Blender.  You can view both the "olive.stl" and "olive_trans.stl" file now by simply opening the "olive_stl" folder in this repository and clicking on the image you want to view.  GitHub will then automatically launch its .stl viewer so you can view the selected object from any angle.

In the above case, with just a single shader, roughly 164 usec of the 412 usec is consumed by the RISC-V pushing parameters/data into the data pool and pulling them back out again, meaning that the four threads in the single-shader version consume roughly 226 usec to do the transformation (@100 MHz).

The dual-shader version of the SYMPL GP-GPU does the transformation in roughly 124 usec @ 100Mhz.  The quad-shader version can do the transformation in roughtly 75.7 usec @ 100MHz, meaning that both the dual and quad shader GP-GPUs can compute the entire 3D transform in less time than the RISC-V (VSCALE version) can push/pull the data.  This can be improved somewhat by incorporating a DMA channel between the RISC-V system memory and the data pool.  Since the "olive.stl" file in this instance comprises exactly 252 triangles, for the quad-shader version, this equates to roughly 300ns (or 30 clocks) per triangle (@ 100 MHz) to compute the transform, which is scale, rotate and translate on all three axes. 

However, if you want to know the exact number of clocks a single thread requires to transform a single triangle on all three axis, which includes pulling in the triangle from its private parameter-data buffer, computing the transform and writing it back out again, the number is:  72 clocks per thread per triangle--total.  This is one clock per floating-point operation even though the pipes involved are deeper than one stage (actually, there are only 63 floating-point operations involved, in that 9 clocks are consumed writing the results back out to PDB.  Reading in the vector is free, because such read is combined with the first operation, due to the nature of this particular "mover" architecture).  This is achived by use of interleaving threads (to help hide latency) and by decoupling the operators from the shader's main instruction pipe.  The other important factor that helps is employing a "mover" architecture (especially one with self-modifying pointers and REPEAT instruction) rather than load-store architecture.

If you have any questions or need assistance getting your simulation running, please don't hesitate to contact me at:  SYMPL.gpu@gmail.com



