# Embedded System Design - PW6 Streaming Interface

## Content of zip file
In the zip file we handed in there are 3 different directories, one per task, whose content will be described below.

### Task 1
The modified program can be found in the 'grayscaleDMA' directory, which has the goal of leveraging DMA transfers to speed up the process of grayscale conversion performed by the custom module 'rgb565GrayscaleIse'.
The 2K memory included in the DMA module is used as a ping-pong buffer, to which the data is transferred in parallel as the computation of the grayscale pixels by means of the 'rgb565GrayscaleIse' custom instruction.
One thing to note, is that it is important to optimize the C code of the conversion part to use the bus as little as possible. This is because, if the bus is requested during the conversion, it "clashes" with the DMA transfer, and hence it causes a lot of CPU idle cycles, in which the CPU is just waiting for the BUS.
The final results we obtained are (an average of 15 measurements from the profiling counters, representative of the average performance):
CPU cycles: 5857638,5
Stall cycles: 4661753,5
Idle cycles: 1999432,21428571


### Task 2
In the first implementation, data coming from the camera were read and used to create a four bytes signal 's_pixelWord', containing two RGB565 color pixels.

This process was modified so that the returned pixels were in a grayscale format. The module 'rgb565Grayscale' was responsible to collect a 16 bits colored pixel and return an 8 bit grayscale one.
Because of the shorter length of the latter, reconstruction to re-obtain 16 bits long pixels was thus needed.

The effect of this procedure was to achieve grayscale conversion maintaining the same 15 frames-per-second as it was with the colored data. It is crucial to notice the inefficiency of this chosen procedure. Half of the sent bits have no purpose anymore, therefore wasting transmissions.

For what it concerns the C program, the provided code was used.

### Task 3
The above waste was solved in the current implementation of task 3. To fill the 32 bits available output, instead of processing two bits and creating a signal made of 16 grayscale data bits + 16 reconstruction bits, four pixels were processed and merged in the output [4* 8-bits grayscale signal].
To obtain this result the same color-to-grayscale converter 'rgb565Grayscale' was imported and used.

The same C code cited in Task 2 was used, after the modification of the constant "__RGB565\__"
