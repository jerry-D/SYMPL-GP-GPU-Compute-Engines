# SYMPL-FP324-AXI4
Update (Sept. 29, 2015):  The SYMPL FP32X-AXI4 n-Shader GP-GPU-Compute engine is now (or will soon be) IEEE754-2008 compliant, featuring new fused-multiply-add (FMA) and Dot (sum-of-products) operators, per-spec default exception handling, alternate immediate & delayed exception handling, default and directed rounding, delivery of (quiet) NaNs with diagnostic payload for invalid operations, etc.  The new design, when implemented in Kintex 7 (-3 speed grade) will clock in the range of 125 MHz.  If you'd like a beta copy of the RTL, email me.

Update (Aug. 28, 2015):  The SYMPL FP32X-AXI4 n-Shader GP-GPU-Compute engine now features FloPoCo-generated floating-point operators.  The single-Shader design is now an AXI4 component that can be replicated "n" number of times in your custom design, with the maximum "n" determined by the number of available AXI4 slave channels available in your AXI4 interconnect and, of course, the amount of fabric available in your FPGA.  

The FloPoCo website can be found here:

http://flopoco.gforge.inria.fr/

This SYMPL FP32X-AXI4 design supercedes and replaces the original SYMPL FP3250 quad-core 32-bit multi-thread multi-processor published last year.  The FP32X-AXI4 incorporates numerous bug fixes, enhancements and, most noteably, an AXI4 burst-mode slave DMA interface.

For more information on the FP32X-AXI4, including architectural overview, instruction-set, register descriptions, block diagrams, and example test case, read the SYMPL FP32X-AXI4 user's guide, which can be downloaded at this link:

https://github.com/jerry-D/SYMPL-FP324-AXI4/blob/master/SYMPL_FP32X_AXI4.pdf

Presently the only cross-assembler available for generating object code is CROSS-32, universal cross-assembler, which can be purchased at a reasonable price at the following link:  

http://www.cdadapter.com/cross32.htm

A .pdf copy of the Cross-32 user's manual can be downloaded here:  http://www.cdadapter.com/download/cross32.pdf

A custom FP324-AXI4 instruction table and example test case for simulations is provided in the FP3244_threads folder in this repository.  Also included is a working Verilog test fixture in the stimulus folder in this repository.
If you have questions or need assitance, please don't hesitate to contact me:  SYMPL.gpu@gmail.com

Below is a block diagram of the design:

![](https://github.com/jerry-D/SYMPL-FP324-AXI4/blob/master/FP32X_AXI4_single.jpg)

The AXI4 DMA protocol specification V2.0 can be downloaded here:

http://home.mit.bme.hu/~feher/MSC_RA/ARM/AMBA_APB_v2_protocol_spec.pdf
