# SYMPL-FP324-AXI4
Update (Aug. 19, 2015):  A version of the design is presently being modified to include FloPoCo FP operators.  Please check back here for status and updated RTL.  The FloPoCo website can be found here:

http://flopoco.gforge.inria.fr/

This SYMPL FP324-AXI4 design supercedes and replaces the original SYMPL FP3250 quad-core 32-bit multi-thread multi-processor published last year.  The FP324-AXI4 incorporates numerous bug fixes, enhancements and, most noteably, an AXI4 burst-mode slave DMA interface.

For more information on the FP324-AXI4, including architectural overview, instruction-set, register descriptions, block diagrams, and example test case, read the SYMPL FP324-AXI4 user's guide, which can be downloaded at this link:

https://github.com/jerry-D/SYMPL-FP324-AXI4/blob/master/SYMPL_FP324_AXI4.pdf

Presently the only cross-assembler available for generating object code is CROSS-32, universal cross-assembler, which can be purchased at a reasonable price at the following link:  

http://www.cdadapter.com/cross32.htm

A .pdf copy of the Cross-32 user's manual can be downloaded here:  http://www.cdadapter.com/download/cross32.pdf

A custom FP324-AXI4 instruction table and example test case for simulations is provided in the FP3244_threads folder in this repository.  Also included is a working Verilog test fixture in the stimulus folder in this repository.
If you have questions or need assitance, please don't hesitate to contact me:  SYMPL.gpu@gmail.com

Below is a block diagram of the design:

![](https://github.com/jerry-D/SYMPL-FP324-AXI4/blob/master/FP3244_scalable_graphic1.jpg)

The AXI4 DMA protocol specification V2.0 can be downloaded here:

http://home.mit.bme.hu/~feher/MSC_RA/ARM/AMBA_APB_v2_protocol_spec.pdf
