module ramDmaCi #( parameter [7:0] customId = 8'h00 )
                  ( input  wire         start,
                                        clock,
                                        reset,
                    input  wire [31:0]  valueA,
                                        valueB,
                    input  wire  [7:0]  ciN,

                    // Define bus interface
                    // Arbiter
                    output wire         requestTransaction,
                    input wire          transactionGranted,
                    // Input
                    input wire [31:0]   addressDataIn,
                    input wire          endTransactionIn,
                                        dataValidIn,
                                        busErrorIn,
                    
                    // Output
                    output wire [31:0]  addressDataOut,
                    //output reg [3:0]   byteEnablesOut,            //TODO ADD IN MAIN FILE
                    output reg [7:0]   burstSizeOut,
                    output reg         readNotWriteOut, 
                    output wire        beginTransactionOut,
                                       endTransactionOut,
                                       dataValidOut,
                                        
                    output wire         done,
                    output reg  [31:0]  result);

wire s_startCi = (ciN == customId) && start;
wire [31:0] partial;
reg done_int, s_reading = 1'b0;
assign done = done_int;


// Registers with info needed by DMA
reg [31:0] bus_start_address;
reg [8:0]  memory_start_address;
reg [9:0]  block_size;
reg [7:0]  burst_size;
reg [1:0]  status_reg;
reg [1:0]  control_reg;

wire [31:0] dataoutB;

dmaMemory myDmaMemory
            (.clockA(clock),
            .clockB(~clock),
            .writeEnableA(valueA[9] && (valueA[31:10] == 0) && s_startCi),
            .writeEnableB(s_busDataInValidReg_input),
            .addressA(valueA[8:0]),
            .addressB(s_memoryAddressReg_input),
            .dataInA(valueB),
            .dataInB(s_busDataInReg_input), //todo handle endianness shit
            .dataOutA(partial),
            .dataOutB(dataoutB)
            );


// Read/write in SSRAM or DMA control registers
always @(posedge clock) begin
    if (s_startCi) begin
        // either read1 or write
        if(valueA[9] == 1'b1) begin
            // Write
            case (valueA[12:10])
                //3'b000  : // Write memory location
                    // just nothing
                3'b001  : // Write bus start address
                    bus_start_address <= valueB[31:0];
                3'b010  : // Write memory start address
                    memory_start_address <= valueB[8:0];
                3'b011  : // Write block size
                    block_size <= valueB[9:0];
                3'b100  : // Write burst size
                    burst_size <= valueB[7:0];
                3'b101  : // Write control register
                    control_reg <= valueB[1:0];
            endcase
            done_int <= 1'b1;
        end
        else begin
            // read1
            s_reading <= 1'b1;
        end    
    end 
    else begin
        // either read2 or nothing
        if(s_reading == 1'b1) begin
            // read2
            case (valueA[12:10])
                3'b000  : // Read memory location
                    result <= partial;
                3'b001  : // Read bus start address
                    result <= bus_start_address;
                3'b010  : // Read memory start address
                    result <= memory_start_address;
                3'b011  : // Read block size
                    result <= block_size;
                3'b100  : // Write burst size
                    result <= burst_size;
                3'b101  : // Read status register
                    result <= status_reg;
            endcase

            done_int <= 1'b1;
            s_reading <= 1'b0;
        end else begin
            // nothing
            result <= 32'b0;
            done_int <= 1'b0;
        end

    end
end




/* * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * BUS signals
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 


/* * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * DMA controller - FSM
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * */

reg [3:0]  s_dmaState, s_dmaStateNext;
reg [7:0]  s_burstCountReg;
reg [9:0]  s_blockCountReg;
reg        s_startTransactionReg,
           s_busDataInValidReg,
           s_beginTransactionOutReg,
           s_endTransactionInReg;
reg [31:0] s_busDataOutReg,
           s_busDataInReg;

reg [31:0] s_busAddressReg;
reg [8:0]  s_memoryAddressReg;


// States
localparam [3:0] IDLE            = 3'd0,
                 INIT            = 3'd1,
                 REQUEST_BUS_R   = 3'd2,
                 INIT_BURST_R    = 3'd3,
                 READ            = 3'd4,
                 FINISH          = 3'd5,
                 ERROR           = 3'd6;

// will be needed for last part - now we just wait for slave to finish transaction - assign endTransactionOut   = s_endTransactionReg;
assign endTransactionOut   = 1'b0;
assign addressDataOut      = s_busDataOutReg;
assign beginTransactionOut = s_beginTransactionOutReg;
assign dataValidOut = 1'b0; //(todo) when will implement other direction
assign requestTransaction = (s_dmaState == REQUEST_BUS_R) ? 1'd1 : 1'd0; // Output request sent to the arbiter


// *** Decide next state based on current
always @*
    case (s_dmaState)
        IDLE            : s_dmaStateNext <= (control_reg[0] == 1'b1) ? INIT : IDLE;
        
        INIT            : s_dmaStateNext <= REQUEST_BUS_R; // todo : check if this is needed (coudl be INIT_WRITE)

        // Read operation
        REQUEST_BUS_R    : s_dmaStateNext <= (transactionGranted == 1'b1) ? INIT_BURST_R : REQUEST_BUS_R;
        INIT_BURST_R     : s_dmaStateNext <= READ;

        READ             : s_dmaStateNext <= (busErrorIn == 1'b1 && endTransactionIn == 1'b0) ? ERROR :
                                            (busErrorIn == 1'b1) ? IDLE :
                                            (s_endTransactionInReg == 1'b1) ? FINISH : READ;                   

        FINISH     : s_dmaStateNext <= (s_blockCountReg == block_size) ? IDLE : REQUEST_BUS_R;

        ERROR            : s_dmaStateNext <= (s_endTransactionInReg == 1'b1) ? IDLE : ERROR;

        default          : s_dmaStateNext <= IDLE;
    endcase

always @(posedge clock) begin
    // update state
    s_dmaState               <= (reset == 1'd1) ? IDLE : s_dmaStateNext;

    // reset or increment memory address
    s_memoryAddressReg           <= (s_dmaState == INIT) ? memory_start_address : 
                                (s_dmaState == READ && s_busDataInValidReg == 1'd1) ? s_busAddressReg + 32'd4 : s_busAddressReg;
    
    // reset or increment bus address
    s_busAddressReg               <= (s_dmaState == INIT) ? bus_start_address : 
                                  (s_dmaState == READ && s_busDataInValidReg == 1'd1) ? s_memoryAddressReg + 9'd1 : s_memoryAddressReg;
    

    // reset or increment burst count
    s_blockCountReg             <= (reset == 1'd1 || s_dmaState == IDLE) ? 10'd0 : 
                                (s_dmaState == READ && s_busDataInValidReg == 1'd1) ? s_blockCountReg + 10'd1 : s_blockCountReg;

    // end transaction read from slave or reset
    s_endTransactionInReg   <= endTransactionIn & ~reset;

    s_busDataInValidReg     <= dataValidIn;
    s_busDataInReg          <= addressDataIn;

    // - todo for writing we will need it ? always 4?
    //byteEnablesOut          <= (s_dmaState == INIT_BURST_R) ? 4'hF : 4'd0;

    // send address when we start transaction, otherwise ero, todo for writing we will need it
    s_busDataOutReg         <= (s_dmaState == INIT_BURST_R) ? s_busAddressReg : 32'd0;

    // MASTER's outputs: start transaction
    s_beginTransactionOutReg <= (s_dmaState == INIT_BURST_R) ? 1'd1 : 1'd0;
    readNotWriteOut          <= (s_dmaState == INIT_BURST_R) ? 1'd1 : 1'd0; //   (todo for writing we will need it
    burstSizeOut             <= (s_dmaState == INIT_BURST_R) ? burst_size : 8'd0;

    // status reg
    status_reg[0]        <= (s_dmaState == IDLE) ? 1'b0 : 1'b1;   // shows if DMA-transfer is still in progress
    
    // error flag - //todo maybe it should be kept high even when we are back in idle
    status_reg[1]        <= (s_dmaState == ERROR) ? 1'b1 : 1'b0;
    
    // reset control register after DMA transfer is started
    // todo control_reg[0]       <= (s_dmaState != IDLE) ? 1'b0 : control_reg;   

end

assign s_busDataInValidReg_input = s_busDataInValidReg;
assign s_memoryAddressReg_input = s_memoryAddressReg;
assign s_busDataInReg_input = s_busDataInReg;

endmodule