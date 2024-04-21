//`timescale 1ps/1ps

module tb_ramDmaCi;

    // Inputs
    reg clock;
    reg reset;
    reg [31:0] s_valueA;
    reg [31:0] s_valueB;
    reg [7:0] s_ciN;
    reg s_start;
    wire [31:0] data_out;
    reg [31:0] block_output;
    reg s_transactionGranted = 1'b0;
    reg [31:0] s_addressDataIn;
    reg s_endTransactionIn;
    reg s_busErrorIn;
    reg s_dataValidIn;
    wire EXITci_requestTransaction;
    wire EXITci_addressDataOut;
    wire EXITci_burstSizeOut;
    wire EXITci_readNotWriteOut;
    wire EXITci_beginTransactionOut;
    wire EXITci_exitTransactionOut;
    wire EXITci_dataValidOut;

  initial
    begin
      reset = 1'b1;
      clock = 1'b0;
      repeat (4) #5 clock = ~clock;
      reset = 1'b0;
      forever #5 clock = ~clock;
    end

    //initial begin
    //    $dumpfile("OUTPUT.vcd");
    //    $dumpvars(1,DUT);
    //end


    // Instantiate the module under test
ramDmaCi #(.customId(8'h15)) DUT
                  ( .start(s_start),
                    .clock(clock),
                    .reset(reset),
                    .valueA(s_valueA),
                    .valueB(s_valueB),
                    .ciN(s_ciN),

                    // Define bus interface
                    // Arbiter
                    .requestTransaction(EXITci_requestTransaction),
                    .transactionGranted(s_transactionGranted),
                    // Input
                    .addressDataIn(s_addressDataIn),
                    .endTransactionIn(s_endTransactionIn),
                    .dataValidIn(s_dataValidIn),
                    .busErrorIn(s_busErrorIn),
                    
                    // Output
                    .addressDataOut(EXITci_addressDataOut),
                    //output reg [3:0]   byteEnablesOut,            //TODO ADD IN MAIN FILE
                    .burstSizeOut(EXITci_burstSizeOut),
                    .readNotWriteOut(EXITci_readNotWriteOut), 
                    .beginTransactionOut(EXITci_beginTransactionOut),
                    .endTransactionOut(EXITci_exitTransactionOut),
                    .dataValidOut(EXITci_dataValidOut),
                                        
                    .done(done),
                    .result(data_out));




    initial begin

        /* * * *
         * PHASE 1: set up register for DMA functioning
         * * * */

        s_ciN = 8'd15;
        s_valueA[31:10] = 0;
        s_valueA[9] = 1'b1;     
        s_start = 1'b1;
        
        @(negedge reset);            // wait for the reset period to end
        repeat(2) @(negedge clock);  // wait

        s_valueB = 32'd55; // bus start address
        s_valueA[12:10] = 3'b001; // write it
        @(posedge clock);
        s_valueB = 32'd66; // memory start address
        s_valueA[12:10] = 3'b010; // write it
        @(posedge clock);
        s_valueB = 32'd88; // block size address
        s_valueA[12:10] = 3'b011; // write it
        @(posedge clock);
        s_valueB = 32'd77; // burst size
        s_valueA[12:10] = 3'b100; // write it
        repeat(2) @(posedge clock);
        // All registers for DMA are set up



        /* * * *
         * PHASE 2: transition from idle to read state
         * * * */
        s_busErrorIn = 1'b0;
        
        s_valueB[1:0] = 2'b01; // start DMA
        s_valueA[12:10] = 3'b101; // write it
        repeat(2) @(posedge clock); // this should bring DMA into REQUEST_BUS_R state
        // CHECK:
        // EXITci_requestTransaction: should be 1 , 0 all the other times
        repeat(2) @(posedge clock); // simulate some delay before transaction is granted

        s_transactionGranted = 1'b1; // transaction is granted
        @(posedge clock);
        
        // * * * * * DMA should now be in INIT_BURST_R state
        // CHECK:
        // EXITci_addressDataOut: should match 's_busAddressReg' , is 0 all the other times
        // EXITci_burstSizeOut: should match 'burst_size' , is 0 all the other times
        // EXITci_readNotWriteOut: should be 1 , 0 all the other times
        // EXITci_beginTransactionOut: should be 1 , 0 all the other times

        @(posedge clock); // DMA should now be in READ state


        /* * * *
         * PHASE 3: read data
         * * * */
        s_dataValidIn = 1'b1;
        s_addressDataIn = 32'd33; // incoming data
        repeat(5) @(posedge clock) begin
            s_addressDataIn = s_addressDataIn + 32'd10;
        end
        // check that these values were assigned to s_busDataInReg_input -> read properly

        // simulate non valid data
        s_dataValidIn = 1'b0;
        repeat(5) @(posedge clock) begin
            s_addressDataIn = 32'd999;
        end

        /* * * *
         * PHASE 4: end transaction
         * * * */
        s_endTransactionIn = 1'b1;
        @(posedge clock); // DMA should now be in FINISH state


        // CHECK:
        // was EXITci_exitTransactionOut always 0? (should be)
        // was EXITci_dataValidOut always 0? (should be)

    end

endmodule
