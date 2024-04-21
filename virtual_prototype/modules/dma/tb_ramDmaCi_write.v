//`timescale 1ps/1ps

module tb_ramDmaCi;

    // Inputs
    reg clock = 1'b0;
    reg reset = 1'b0;
    reg [31:0] s_valueA = 32'b0;
    reg [31:0] s_valueB = 32'b0;
    reg [7:0] s_ciN = 8'b0;
    reg s_start = 1'b0;
    wire [31:0] data_out;
    reg [31:0] block_output = 32'b0;
    reg s_transactionGranted = 1'b0;
    reg [31:0] s_addressDataIn = 32'b0;
    reg s_endTransactionIn = 1'b0;
    reg s_busErrorIn = 1'b0;
    reg s_dataValidIn = 1'b0;
    wire EXITci_requestTransaction;
    wire[31:0] EXITci_addressDataOut;
    wire[7:0] EXITci_burstSizeOut;
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
ramDmaCi #(.customId(8'd15)) DUT
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
        s_valueA[31:0] = 0;
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
        
        
        s_valueB = 32'd10; // block size address
        s_valueA[12:10] = 3'b011; // write it
        
        @(posedge clock);
        
        s_valueB = 32'd2; // burst size
        s_valueA[12:10] = 3'b100; // write it
        
        
        repeat(2) @(posedge clock);
        // All registers for DMA are set up

        /* * * *
         * PHASE 2: transition from idle to read state
         * * * */
        s_busErrorIn = 1'b0;
        
        s_valueB[31:0] = 31'd2; // start DMA WRITE
        s_valueA[12:10] = 3'b101; // write it

        repeat(2) @(posedge clock); // this should bring DMA into REQUEST_BUS_W state
        // CHECK:
        // EXITci_requestTransaction: should be 1 , 0 all the other times
        repeat(3) @(posedge clock); // simulate some delay before transaction is granted

        s_transactionGranted = 1'b1; // transaction is granted
        @(posedge clock);
        s_transactionGranted = 1'b0; // transaction granted finished

        repeat(10) @(posedge clock); // simulate some delay before transaction is granted

        s_transactionGranted = 1'b1; // transaction is granted
        @(posedge clock);
        s_transactionGranted = 1'b0; // transaction granted finished

        repeat(10) @(posedge clock); // simulate some delay before transaction is granted

    end

endmodule
