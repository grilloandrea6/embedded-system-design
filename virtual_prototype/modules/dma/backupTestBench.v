// `timescale 1ps/1ps

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
    wire [3:0] EXITci_byteEnablesOut;
        reg s_busyIn = 1'b0;


  initial
    begin
      reset = 1'b1;
      clock = 1'b0;
      repeat (4) #5 clock = ~clock;
      reset = 1'b0;
      repeat(1000) #5 clock = ~clock;
    end

    initial begin
       $dumpfile("OUTPUT.vcd");
       $dumpvars(1,DUT);
    end


    // Instantiate the module under test
ramDmaCi #(.customId(8'd15)) DUT
                  ( .start(s_start),
                    .clock(clock),
                    .reset(reset),
                    .valueA(s_valueA),
                    .valueB(s_valueB),
                    .ciN(s_ciN),
                    .busyIn(s_busyIn),

                    // Define bus interface
                    // Arbiter
                    .requestTransaction(EXITci_requestTransaction),
                    .transactionGranted(s_transactionGranted),
                    // Input
                    .addressDataIn(s_addressDataIn),
                    .endTransactionIn(s_endTransactionIn),
                    .dataValidIn(s_dataValidIn),
                    .busErrorIn(s_busErrorIn),
                    .byteEnablesOut(EXITci_byteEnablesOut),
                    
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
        //s_start = 1'b1;
        
        @(negedge reset);            // wait for the reset period to end
        repeat(2) @(negedge clock);  // wait
        s_start = 1'b1;

        s_valueB = 32'd55; // bus start address
        s_valueA[12:10] = 3'b001; // write it
        @(negedge clock);
        s_valueB = 32'd0; // memory start address
        s_valueA[12:10] = 3'b010; // write it
        @(negedge clock);
        s_valueB = 32'd6; // block size 
        s_valueA[12:10] = 3'b011; // write it
        @(negedge clock);
        s_valueB = 32'd2; // burst size
        s_valueA[12:10] = 3'b100; // write it
        @(negedge clock);
        // All registers for DMA are set up

        s_start = 1'b0;

        @(negedge clock);

        /* * * *
         * PHASE 2: READ
         * * * */
        s_busErrorIn = 1'b0;
        s_start = 1'b1;

        s_valueB[31:0] = 31'd1; // start DMA
        s_valueA[12:10] = 3'b101; // write it
        @(negedge clock);
        s_start = 0;
        repeat(2) @(negedge clock); // this should bring DMA into REQUEST_BUS_R state
        // CHECK:
        // EXITci_requestTransaction: should be 1 , 0 all the other times
        repeat(2) @(negedge clock); // simulate some delay before transaction is granted

        s_transactionGranted = 1'b1; // transaction is granted
        @(negedge clock);
        s_transactionGranted = 1'b0; // transaction granted finished
        
        
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
        s_addressDataIn = 32'd10; // incoming data
        repeat(2) @(posedge clock) begin
            s_addressDataIn = s_addressDataIn + 32'd10;
        end
        // check that these values were assigned to s_busDataInReg_input -> read properly
        @(posedge clock);
        s_dataValidIn = 1'b0;
        s_addressDataIn = 0;

        //@(posedge clock); // DMA should now be in FINISH state
        s_endTransactionIn = 1'b1;
        @(posedge clock); // DMA should now be in FINISH state
        s_endTransactionIn = 1'b0;

        repeat(2) @(posedge clock); // this should bring DMA into REQUEST_BUS_R state
        // CHECK:
        // EXITci_requestTransaction: should be 1 , 0 all the other times
        repeat(2) @(posedge clock); // simulate some delay before transaction is granted

        s_transactionGranted = 1'b1; // transaction is granted
        @(posedge clock);
        s_transactionGranted = 1'b0; // transaction granted finished
        
        
        // * * * * * DMA should now be in INIT_BURST_R state
        // CHECK:
        // EXITci_addressDataOut: should match 's_busAddressReg' , is 0 all the other times
        // EXITci_burstSizeOut: should match 'burst_size' , is 0 all the other times
        // EXITci_readNotWriteOut: should be 1 , 0 all the other times
        // EXITci_beginTransactionOut: should be 1 , 0 all the other times

        @(posedge clock); // DMA should now be in READ state
        @(posedge clock); // DMA should now be in READ state


        /* * * *
         * PHASE 3: read data
         * * * */
        s_dataValidIn = 1'b1;
        s_addressDataIn = 32'd40; // incoming data
        repeat(2) @(posedge clock) begin
            s_addressDataIn = s_addressDataIn + 32'd10;
        end
        // check that these values were assigned to s_busDataInReg_input -> read properly
        @(posedge clock);
        s_dataValidIn = 1'b0;
        s_addressDataIn = 0;


        
        
        /* * * *
         * PHASE 4: end transaction
         * * * */
        s_endTransactionIn = 1'b1;
        @(posedge clock); // DMA should now be in FINISH state
        s_endTransactionIn = 1'b0;

        repeat(5) @(posedge clock);  // wait

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // FINE READ /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // FINE READ /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // FINE READ /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // FINE READ /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        s_start = 1'b0;
        @(posedge clock);
        
        s_ciN = 8'd15;
        s_valueA = 32'd5;
        s_start = 1'b1;
        @(posedge clock);
        s_start = 1'b0;
        


      repeat(5) @(negedge clock);  // wait


      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // FINE READ /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // FINE READ /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // FINE READ /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // FINE READ /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    


        s_ciN = 8'd15;
        s_valueA[31:0] = 0;
        s_valueA[9] = 1'b1;     
        s_start = 1'b1;
        

        s_valueB = 32'd13; // bus start address
        s_valueA[12:10] = 3'b001; // write it
        @(negedge clock);

        s_valueB = 32'd0; // memory start address
        s_valueA[12:10] = 3'b010; // write it
        @(negedge clock);
        
        
        s_valueB = 32'd5; // block size 
        s_valueA[12:10] = 3'b011; // write it
        
        @(negedge clock);
        
        s_valueB = 32'd2; // burst size
        s_valueA[12:10] = 3'b100; // write it
                s_start = 1'b0;

        
        repeat(4) @(negedge clock);
        // All registers for DMA are set up

        /* * * *
         * PHASE 2: transition from idle to read state
         * * * */
        s_busErrorIn = 1'b0;
                s_start = 1'b1;

        s_valueB[31:0] = 31'd2; // start DMA WRITE
        s_valueA[12:10] = 3'b101; // write it
        @(negedge clock);
                s_start = 1'b0;
        s_valueA[12:10] = 0;
@(negedge clock);
                s_start = 1'b0;

        repeat(2) @(negedge clock); // this should bring DMA into REQUEST_BUS_W state
        // CHECK:
        // EXITci_requestTransaction: should be 1 , 0 all the other tnegedgeimes
        repeat(3) @(negedge clock); // simulate some delay before transaction is granted

        s_transactionGranted = 1'b1; // transaction is granted
        @(posedge clock);
        s_transactionGranted = 1'b0; // transaction granted finished

        repeat(3) @(posedge clock);
        
        //s_busyIn = 1'b1;
        repeat(1) @(posedge clock);
        s_busyIn = 0;
        repeat(10) @(negedge clock);
        
        s_transactionGranted = 1'b1; // transaction is granted
        @(negedge clock);
        s_transactionGranted = 1'b0; // transaction granted finished


repeat(10) @(negedge clock);
        
        s_transactionGranted = 1'b1; // transaction is granted
        @(negedge clock);
        s_transactionGranted = 1'b0; // transaction granted finished

        // repeat(10) @(negedge clock); // simulate some delay before transaction is granted
        // s_transactionGranted = 1'b1; // transaction is granted
        // @(negedge clock);
        // s_transactionGranted = 1'b0; // transaction granted finished

        // repeat(10) @(negedge clock); // simulate some delay before transaction is granted
        // s_transactionGranted = 1'b1; // transaction is granted
        // @(negedge clock);
        // s_transactionGranted = 1'b0; // transaction granted finished

        // repeat(10) @(negedge clock); // simulate some delay before transaction is granted

    end

endmodule
