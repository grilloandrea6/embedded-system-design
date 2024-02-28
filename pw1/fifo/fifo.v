module fifo #( parameter nrOfEntries = 16,
              parameter bitWidth = 32)
             ( input wire       clock,
                               reset,
                               push,
                               pop,
              input wire [bitWidth-1:0]   pushData,
              output wire                   full,
                                            empty,
              output wire [bitWidth-1:0]  popData);

    reg [bitWidth-1 : 0] memoryContent [nrOfEntries-1 : 0];

    localparam nrOfBits = $clog2(nrOfEntries);
    
    reg [nrOfBits - 1 : 0] pushCounter;
    reg [nrOfBits - 1 : 0] popCounter;
    
    always @(posedge clock)
    begin
        if(push == 1'b1)
        begin
            // write pushData into memoryContent(pushCounter)
            memoryContent[pushCounter] = pushData;
            // increment pushCounter
            pushCounter = pushCounter + 1;
        end

        if(pop == 1'b1 && pushCounter > popCounter)
        begin
            // increment popCounter
            popCounter = popCounter + 1;
        end

        if (reset == 1'b1)
        begin
            pushCounter = 0;
            popCounter  = 0;
        end
    
    end

    assign popData = memoryContent[popCounter-1];
    assign full    = pushCounter == (popCounter - 1);
    assign empty   = pushCounter == popCounter;


endmodule
