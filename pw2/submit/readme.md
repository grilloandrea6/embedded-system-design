In the submitted tarball there is the whole virtualPrototype directory.

We have defined 2 custom instructions. The first one processes 1 pixel at a time and the second one processes 4 pixels at a time.
The first instruction and its relative grayscale program can be found at the following paths:
 - virtual_prototype/modules/grayscale/rgb565Grayscalelse.v
 - virtual_prototype/programms/grayscaleAccelerated

The second instruction and its relative grayscale program can be found at the following paths:
 - virtual_prototype/modules/grayscale/rgb565Grayscalelse_faster.v
 - virtual_prototype/programms/grayscaleVeryAccelerated

The results that we've measured are summarized below (sample of the profiling counters output):
Original software version:
CPU cycles   :	 30692197
Stall cycles :	 19011850
Bus idle     :	 16930976

Accelerated - 1 pixel at a time - results:
CPU cycles   :	 24496384
Stall cycles :	 18345637
Bus idle     :	 11561057

Accelerated - 4 pixels at a time - results:
CPU cycles   :	  9973675
Stall cycles :	  8276847
Bus idle     :	  3715543

Therefore, we have had a substantial improvement across the versions.
Starting from 11 millions work cycles per frame we brought it to 6 millions with the accelerated version that processes 1 pixel, and then to just 1,5 millions for the version that processes 4 pixels.


Andrea Grillo, Riccardo Lionetto
