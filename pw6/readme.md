# Embedded System Design - PW6 Streaming Interface

## Content of zip files
Three separate zip files were handled, one per task, whose content will be described below.

### Task 1 - Zip file
 The edited file is 'grayscale.c', which has the goal of leveraging DMA transfers to speed up the process of grayscale conversion performed by the custom module 'rgb565GrayscaleIse'. 

### Task 2 - Zip file 
In the first implementation, data coming from the camera were read and used to create a four bytes signal 's_pixelWord', containing two RGB565 color pixels.

This process was modified so that the returned pixels were in a grayscale format. The module 'rgb565Grayscale' was responsible to collect a 16 bits colored pixel and return an 8 bit grayscale one.
Because of the shorter length of the latter, reconstruction to re-obtain 16 bits long pixels was thus needed.

The effect of this procedure was to achieve grayscale conversion maintaining the same 15 frames-per-second as it was with the colored data. It is crucial to notice the inefficiency of this chosen procedure. Half of the sent bits have no purpose anymore, therefore wasting transmissions.

For what it concerns the C program, the provided code was used.

### Task 3 - Zip file
The above waste was solved in the current implementation of task 3. To fill the 32 bits available output, instead of processing two bits and creating a signal made of 16 grayscale data bits + 16 reconstruction bits, four pixels were processed and merged in the output [4* 8-bits grayscale signal].
To obtain this result the same color-to-grayscale converter 'rgb565Grayscale' was imported and used.

The same C code cited in Task 2 was used.

## Question - Task 1

