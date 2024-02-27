module fifo #( parameter nrOfEntries = 16,
              parameter bitWidth = 32)
             ( input wire       clock,
                               reset,
                               push,
                               pop,
              input wire [bitWidth−1:0]   pushData,
              output wire                   full,
                                            empty,
              output wire [bitWidth−1:0]  popData);

    reg [bitwidth-1 : 0] memoryContent [nrOfEntries-1 : 0];

    reg [$clog(nrOfEntries) - 1 : 0] pushCounter = $clog(nrOfEntries)'b0;
    reg [$clog(nrOfEntries) - 1 : 0] popCounter  = $clog(nrOfEntries)'b0;
    
    always @(posedge clock)
    begin
        if(push == 1’b1)
        begin
            // write pushData into memoryContent(pushCounter)
            memoryContent[pushCounter] = pushData;
            // increment pushCounter
            pushCounter = pushCounter + $clog(nrOfEntries)'b1;
        end

        if(pop == 1’b1 and pushCounter > popCounter)
        begin
            // read memoryCounter(popData) into popData
            popData = memoryContent[popData];
            // increment popCounter
            popCounter = popCounter + $clog(nrOfEntries)'b1;
        end

        if (reset == 1’b1)
        begin
            memoryContent <= 0;  // ToDo check if ok
        end
    
    end

endmodule
