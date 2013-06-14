Processor
=========

basic 4-bit RISC Processor

by Site Mao, Kevin Albers

This was a project for the class ECE152B at UCSB ( No longer offered )

This is a 2-bus design meant for use with the Altera EPF6016 FPGA. Part of the FLEX6000 family. 

Our design does operations on both the posedge and negedge, and because of that, has a maximum clocking speed of 6.2MHz before errors start to occur.

The design is designed to work with everything instatiated inside the FPGA but connected to a physical SRAM, ALU, and EEPROM.
We used the CY7C130, SN74LS181, and X2816C respectively.

We included 2 raw binary files for direct pushing into the FPGA.
The first has all modules in verilog. working_verilog.rbf
The second has most modules in verilog, but needs to be connected. final_working.rbf