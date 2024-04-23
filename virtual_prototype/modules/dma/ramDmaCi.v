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
                                        busyIn,
                    
                    // Output
                    output wire [31:0]  addressDataOut,
                    output reg [3:0]   byteEnablesOut,            
                    output reg [7:0]   burstSizeOut,
                    output reg         readNotWriteOut, 
                    output wire        beginTransactionOut,
                                       endTransactionOut,
                                       dataValidOut,
                                        
                    output wire         done,
                    output reg  [31:0]  result);

// States
localparam [3:0] IDLE            = 4'd0,
                 INIT_R            = 4'd1,
                 INIT_W            = 4'd2,
                 REQUEST_BUS_R   = 4'd3,
                 INIT_BURST_R    = 4'd4,
                 READ            = 4'd5,
                 REQUEST_BUS_W   = 4'd6,
                 INIT_BURST_W    = 4'd7,
                 WRITE           = 4'd8,
                 FINISH_WRITE    = 4'd9,
                 FINISH_WRITE_2  = 4'd10,
                 ERROR           = 4'd11;


wire s_startCi = (ciN == customId) && start;
wire [31:0] partial;
reg done_int, s_reading = 1'b0;
assign done = done_int;


// Registers with info needed by DMA
reg [31:0] bus_start_address        = 32'b0;
reg [8:0]  memory_start_address     = 9'b0;
reg [9:0]  block_size               = 10'b0;
reg [7:0]  burst_size               = 8'b0;
reg [1:0]  status_reg               = 2'b0;
reg [1:0]  control_reg              = 2'b0;
reg [3:0]  s_dmaState = IDLE, s_dmaStateNext = IDLE;

wire [31:0] dataoutB;
wire [8:0] s_memoryAddressReg_input;
wire        s_busDataInValidReg_input;
wire [31:0] s_busDataInReg_input;




dmaMemory myDmaMemory
            (.clockA(clock),
            .clockB(~clock),
            .writeEnableA(valueA[9] && (valueA[31:10] == 0) && s_startCi),
            .writeEnableB(s_dmaState == READ && s_busDataInValidReg_input),
            .addressA(valueA[8:0]),
            .addressB(s_memoryAddressReg_input),
            .dataInA(valueB),
            .dataInB(s_busDataInReg_input),
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
                default : 
                    control_reg <= 0;
            endcase
            done_int <= 1'b1;
        end
        else begin
            // read1
            s_reading      <= 1'b1; 
            control_reg <= 2'b0;

        end    
        result <= 32'b0;
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
        control_reg <= 2'b0;
    end
end



/* * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * DMA controller - FSM
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * */

reg [9:0]  s_blockCountReg          = 10'd0;
reg [7:0]  s_burstCountReg          = 8'd0;
reg        s_startTransactionReg    = 1'b0,
           s_busDataInValidReg      = 1'b0,
           s_beginTransactionOutReg = 1'b0,
           s_endTransactionInReg    = 1'b0,
           s_busyReg                = 1'b0,
           s_dataValidOutReg        = 1'b0,
           s_endTransactionOutReg      = 1'b0;
reg [31:0] s_busDataOutReg          = 32'd0,
           s_busDataInReg           = 32'd0;

reg [31:0] s_busAddressReg          = 32'd0;
reg [8:0]  s_memoryAddressReg       = 9'd0;


assign endTransactionOut   = s_endTransactionOutReg;
assign addressDataOut      = s_busDataOutReg;
assign beginTransactionOut = s_beginTransactionOutReg;
assign dataValidOut = s_dataValidOutReg;
assign requestTransaction = (s_dmaState == REQUEST_BUS_R || s_dmaState == REQUEST_BUS_W) ? 1'd1 : 1'd0; // Output request sent to the arbiter


// *** Decide next state based on current
always @*
    case (s_dmaState)
        IDLE            : s_dmaStateNext <= (control_reg == 2'b01) ? INIT_R : 
                          (control_reg == 2'b10) ? INIT_W : IDLE;
        
        INIT_R            : s_dmaStateNext <= REQUEST_BUS_R; 
        INIT_W            : s_dmaStateNext <= REQUEST_BUS_W; 
        
        // Read operation
        REQUEST_BUS_R    : s_dmaStateNext <= (transactionGranted == 1'b1) ? INIT_BURST_R : REQUEST_BUS_R;
        INIT_BURST_R     : s_dmaStateNext <= READ;

        READ             : s_dmaStateNext <= (busErrorIn == 1'b1 && endTransactionIn == 1'b0) ? ERROR :
                                            (busErrorIn == 1'b1) ? IDLE :
                                            (s_endTransactionInReg == 1'b1) ? (s_blockCountReg == 10'd0) ? IDLE : REQUEST_BUS_R : READ;                   

        // Write operation
        REQUEST_BUS_W    : s_dmaStateNext <= (transactionGranted == 1'b1) ? INIT_BURST_W : REQUEST_BUS_W;
        INIT_BURST_W     : s_dmaStateNext <= WRITE;
        WRITE            : s_dmaStateNext <= (busErrorIn == 1'b1 && endTransactionIn == 1'b0) ? ERROR :
                                            (busErrorIn == 1'b1) ? IDLE :
                                            (s_burstCountReg == 8'd1) ? FINISH_WRITE : WRITE;

        FINISH_WRITE     : s_dmaStateNext <= (s_blockCountReg == 0) ? IDLE : FINISH_WRITE_2;

        FINISH_WRITE_2   : s_dmaStateNext <= REQUEST_BUS_W;

        ERROR            : s_dmaStateNext <= (s_endTransactionInReg == 1'b1) ? IDLE : ERROR;

        default          : s_dmaStateNext <= IDLE;
    endcase

always @(posedge clock) begin
    // update state
    s_dmaState               <= (reset == 1'd1) ? IDLE : s_dmaStateNext;

    // reset or increment memory address
    s_memoryAddressReg           <= ((s_dmaState == INIT_R) || (s_dmaState == INIT_W)) ? memory_start_address : 
                                ((s_dmaState == READ && s_busDataInValidReg == 1'd1) || (s_dmaState == WRITE && busyIn == 0)) ? s_memoryAddressReg + 9'd1 : s_memoryAddressReg;
    
    // reset or increment bus address
    s_busAddressReg               <= ((s_dmaState == INIT_R) || (s_dmaState == INIT_W)) ? bus_start_address : 
                                  ((s_dmaState == READ && s_busDataInValidReg == 1'd1) || (s_dmaState == WRITE && busyIn == 0)) ? s_busAddressReg + 32'd4 : s_busAddressReg;
    

    // reset or increment burst count
    s_blockCountReg             <= ((s_dmaState == INIT_R) || (s_dmaState == INIT_W)) ? block_size : 
                                ((s_dmaState == READ && s_busDataInValidReg == 1'd1) || (s_dmaState == WRITE && busyIn == 0)) ? s_blockCountReg - 10'd1 : s_blockCountReg;

    // end transaction read from slave or reset
    s_endTransactionInReg   <= endTransactionIn & ~reset;

    s_busDataInValidReg     <= dataValidIn;
    s_busDataInReg          <= {addressDataIn[7:0], addressDataIn[15:8], addressDataIn[23:16], addressDataIn[31:24]};
    s_busyReg               <= busyIn;

    // send address when we start read or write transaction, if WRITE send data
    s_busDataOutReg         <= (s_dmaState == INIT_BURST_R || s_dmaState == INIT_BURST_W) ? s_busAddressReg : 
                               (s_dmaState == WRITE) ? {dataoutB[7:0], dataoutB[15:8], dataoutB[23:16], dataoutB[31:24]} : 32'd0;

    // MASTER's outputs: start transaction
    s_beginTransactionOutReg <= (s_dmaState == INIT_BURST_R || s_dmaState == INIT_BURST_W) ? 1'd1 : 1'd0;
    readNotWriteOut          <= (s_dmaState == INIT_BURST_R) ? 1'd1 : 1'd0; 

    burstSizeOut             <= (s_dmaState == INIT_BURST_R || s_dmaState == INIT_BURST_W) ? (burst_size < (s_blockCountReg - 1)) ? burst_size : (s_blockCountReg - 1) : 8'd0;

    // status reg
    status_reg[0]        <= (s_dmaState == IDLE) ? 1'b0 : 1'b1;   // shows if DMA-transfer is still in progress
    
    // error flag - //todo maybe it should be kept high even when we are back in idle
    status_reg[1]        <= (s_dmaState == ERROR) ? 1'b1 : 1'b0;

    s_dataValidOutReg    <= (s_dmaState == WRITE) ? 1'd1 : 1'd0; // when writing data is always valid
    s_burstCountReg      <= (s_dmaState == REQUEST_BUS_W) ? (burst_size < (s_blockCountReg - 1)) ? burst_size : (s_blockCountReg - 1) : (s_dmaState == WRITE && busyIn == 0) ? s_burstCountReg - 8'd1 : s_burstCountReg;

    //s_burstCountReg <= (s_dmaState == WRITE) ? 
    //                   (s_busyReg): s_burstCountReg + 8'd1 : s_burstCountReg : 8'b0;
    
    


    s_endTransactionOutReg <= (s_dmaState == FINISH_WRITE) ? 1'd1 : 1'd0;
    byteEnablesOut       <= (s_dmaState == INIT_BURST_R || s_dmaState == INIT_BURST_W) ? 4'hF : 4'd0;
end

assign s_busDataInValidReg_input = s_busDataInValidReg;
assign s_memoryAddressReg_input = s_memoryAddressReg;
assign s_busDataInReg_input = s_busDataInReg;

endmodule