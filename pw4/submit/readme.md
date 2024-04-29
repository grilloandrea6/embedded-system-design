The zip file contains the whole virtual_prototype directory.

The module developed is containes at the following path: modules/dma.
The memory.v file contains the dual ported SSRAM, the ramDmaCi.v the whole module, and tb_ramDmaCi.v contains a testbench we have used during development.
We have also written a C program to test the functionality of the module. The C program can be found inside programms/DMAtest. It contains 3 different tests to be run, one for each part of the pw. The first one tests the custom instruction to read and write from the memory. The second one tests the read from the bus, and the last one the write to the bus.

Andrea Grillo, Riccardo Lionetto

