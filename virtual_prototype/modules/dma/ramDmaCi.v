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
//begintransaction in?? readnotwritein??
                    // Input
                    input wire [31:0]   addressDataIn,
                    input wire          endTransactionIn,
                                        dataValidIn,
                                        busyIn,                 //TODO ADD IN MAIN FILE
                                        busErrorIn,
                    
                    // Output
                    output wire [31:0]  addressDataOut,
                    output reg [3:0]   byteEnablesOut,            //TODO ADD IN MAIN FILE
                    output reg [7:0]   burstSizeOut, //todo
                    output reg         readNotWriteOut, 
                    output wire        beginTransactionOut, // DONE
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
            .writeEnableB(1'b0),
            .addressA(valueA[8:0]),
            .addressB(9'b0),
            .dataInA(valueB),
            .dataInB(32'b0),
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
reg        s_startTransactionReg;
reg        s_dataValidOutReg;
reg        s_busDataInValidReg;
 
assign beginTransactionOut = s_startTransactionReg;
// *** Update outout signals based on current state
assign requestTransaction = (s_dmaState == REQUEST_BUS_R || s_dmaState == REQUEST_BUS_W) ? 1'd1 : 1'd0; // Output request sent to the arbiter



// States
localparam [3:0] IDLE            = 3'd0,
                 REQUEST_BUS_R   = 3'd1,
                 INIT_BURST_R    = 3'd2,
                 READ            = 3'd3,
                 FINISH_BURST    = 3'd4,
                 READ_DONE       = 3'd5,
                 ERROR           = 3'd6;


// *** Decide next state based on current
always @*
    case (s_dmaState)
        IDLE            : s_dmaStateNext <= (control_reg[0] == 1'b1) ? REQUEST_BUS_R : IDLE;
        
        // Read operation
        REQUEST_BUS_R    : s_dmaStateNext <= (transactionGranted == 1'b1) ? INIT_BURST_R : REQUEST_BUS_R;
        INIT_BURST_R     : s_dmaStateNext <= READ;

        READ             : s_dmaStateNext <= (busErrorIn == 1'b1 && endTransactionIn == 1'b0) ? ERROR :
                                            (busErrorIn == 1'b1) ? IDLE :
                                            (s_endTransactionInReg == 1'b1) ? FINISH_BURST : READ;                        // ToDo define reg and assign to endTransactionIn & ~reset;

        FINISH_BURST     : s_dmaStateNext <= (s_blockCountReg == block_size) ? FINISH : REQUEST_BUS_R;
        
        READ_DONE        : s_dmaStateNext <= IDLE;

        ERROR            : s_dmaStateNext <= (s_endTransactionInReg == 1'b1) ? IDLE : ERROR;

        default          : s_dmaStateNext <= IDLE;
    endcase

always @(posedge clock) begin
    s_dmaState               <= (reset == 1'd1) ? IDLE : s_dmaStateNext;
    s_startTransactionReg   <= (s_dmaState == INIT_BURST_R) ? 1'b1 : 1'b0;
    s_busDataInValidReg     <= dataValidIn;
    byteEnablesOut          <= (s_dmaState == INIT) ? 4'hF : 4'd0;

    s_dataValidOutReg        <= 1'b1; // always 1, we're not able to detect errors
    s_blockCountReg      <= (reset == 1'b1) ? 10'd0 : (s_dmaState == FINISH || s_dmaState == FINISH) ? 10'd0 : s_blockCountReg; // Reset block counter every time we request bus

    memory_start_address <= (reset == 1'b1) ? 9'b0 : (s_busDataInValidReg == 1'b1 && (s_dmaState == READ || s_dmaState == WRITE)) ? memory_start_address + 1'b1 : memory_start_address; // Increment memory address
    s_blockCountReg      <= (reset == 1'b1) ? 10'd0 : (s_dmaState == READ || s_dmaState == WRITE) ? s_blockCountReg + 1'b1 : s_blockCountReg; // Increment block counter
    //s_addressDataOut     <= (reset == 1'b1) ? 32'd0 : (s_dmaState == REQUEST_BUS_R || s_dmaState == REQUEST_BUS_W) ? bus_start_address : s_addressDataOut; // Set address
    status_reg[0]        <= (s_dmaState == IDLE) ? 1'b0 : 1'b1   // shows if DMA-transfer is still in progress
    status_reg[1]        <= (s_dmaState == ERROR) ? 1'b1 : 1'b0  // error flag
    control_reg[0]       <= (s_dmaState != IDLE) ? 1'b0 : 1'b1   // reset control register

end


// Update signals (address, burst size, block size)
always @* begin
    case (s_dmaState)
        IDLE            : begin
                            s_blockCountReg <= 10'd0;
                            s_addressDataOut <= 32'd0;
                            //s_dataValidOut <= 1'b0; ??
                            s_startTransactionReg <= 1'b0;
                        end
        REQUEST_BUS_R   : begin
                            s_addressDataOut <= bus_start_address;
                        end
        INIT_BURST_R    : begin
                            s_addressDataOut <= memory_start_address;
                        end
        READ            : begin
                            s_addressDataOut <= s_addressDataOut + 32'd4;
                        end

        ERROR           : begin
                            s_addressDataOut <= 32'd0;
                        end
        default         : begin
                            s_addressDataOut <= 32'd0;
                        end
    endcase
end

endmodule