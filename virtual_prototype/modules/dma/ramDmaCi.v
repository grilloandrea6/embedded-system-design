module ramDmaCi #( parameter [7:0] customId = 8'h00 )
                  ( input  wire         start,
                                        clock,
                                        reset,
                    input  wire [31:0]  valueA,
                                        valueB,
                    input  wire  [7:0]  ciN,

                    // Define bus interface
                    // Input
                    input wire [31:0]   addressDataIn,
                    input wire [7:0]    burstSizeIn,
                    input wire          beginTransactionIn,
                                        endTransactionIn,
                                        dataValidIn,
                                        busErrorIn,
                    
                    // Output
                    output wire [31:0]  addressDataOut,
                    output wire [7:0]   burstSizeOut,
                    output wire         beginTransActionOut,
                                        endTransactionOut,
                                        dataValidOut,


                    output wire         done,
                    output reg  [31:0]  result);

wire s_isMyCi = (ciN == customId) ? start : 1'b0;
wire [31:0] partial;
reg done_int, cycle_count;

// Registers with info needed by DMA
reg [31:0] bus_start_address;
reg [8:0] memory_start_address;
reg [9:0] block_size;
reg [7:0] burst_size;
reg [1:0] status_reg;
reg control_reg;

// FSM registers
reg [2:0] s_stateMachineReg, s_stateMachineNext;

wire [31:0] dataoutB;

dmaMemory myDmaMemory
            (.clockA(clock),
            .clockB(clock),
            .writeEnableA(valueA[9] && (valueA[31:10] == 0) && s_isMyCi),
            .writeEnableB(1'b0),
            .addressA(valueA[8:0]),
            .addressB(9'b0),
            .dataInA(valueB),
            .dataInB(32'b0),
            .dataOutA(partial),
            .dataOutB(dataoutB)
            );


// Read/write in SSRAM or DMA control registers
always @* begin
    if (s_isMyCi == 1'b0) begin.addressDataIn(s_addressData),
            .byteEnablesIn(s_byteEnables),
            .burstSizeIn(s_burstSize),
            
        // 1. Read/Write from memory location
        3'b000  :   begin
                        if (valueA[9] == 1'b1) begin // Write in 1 cycle
                            result <= partial;
                            done_int <= 1'b1;
                        end
                        else begin
                            if (cycle_count < 1'b1) begin   // Read in 2 cycles
                                cycle_count <= 1'b1;
                                done_int <= 1'b0;
                            end
                            else begin 
                                cycle_count <= 1'b0;
                                result <= partial;
                                done_int <= 1'b1;
                            end
                        end
                    end
        
        // 2. Read/Write the bus start address of the DMA-transfer
        3'b001  :   begin
                        if (valueA[9] == 1'b1) begin // Write in 1 cycle
                            bus_start_address <= valueB[31:0];
                            done_int <= 1'b1;
                        end
                        else begin
                            if (cycle_count < 1'b1) begin   // Read in 2 cycles
                                cycle_count <= 1'b1;
                                done_int <= 1'b0;
                            end
                            else begin 
                                cycle_count <= 1'b0;
                                result <= bus_start_address;
                                done_int <= 1'b1;
                            end
                        end
                    end

        // 3. Read/Write the memory start address of the DMA-transfer
        3'b010  :   begin
                        if (valueA[9] == 1'b1) begin // Write in 1 cycle
                            memory_start_address <= valueB[8:0];
                            done_int <= 1'b1;
                        end
                        else begin
                            if (cycle_count < 1'b1) begin   // Read in 2 cycles
                                cycle_count <= 1'b1;
                                done_int <= 1'b0;
                            end
                            else begin 
                                cycle_count <= 1'b0;
                                result <= memory_start_address;
                                done_int <= 1'b1;
                            end
                        end
                    end

        // 4. Read/Write the block size of the DMA-transfer
        3'b011  :   begin
                        if (valueA[9] == 1'b1) begin // Write in 1 cycle
                            block_size <= valueB[9:0];
                            done_int <= 1'b1;
                        end
                        else begin
                            if (cycle_count < 1'b1) begin   // Read in 2 cycles
                                cycle_count <= 1'b1;
                                done_int <= 1'b0;
                            end
                            else begin 
                                cycle_count <= 1'b0;
                                result <= block_size;
                                done_int <= 1'b1;
                            end.addressDataIn(s_addressData),
            .byteEnablesIn(s_byteEnables),
            .burstSizeIn(s_burstSize),
                        end
                    end

        // 5. Read/Write the burst size used for the DMA-transfer
        3'b100  :   begin
                        if (valueA[9] == 1'b1) begin // Write in 1 cycle
                            burst_size <= valueB[7:0];
                            done_int <= 1'b1;
                        end
                        else begin
                            if (cycle_count < 1'b1) begin   // Read in 2 cycles
                                cycle_count <= 1'b1;
                                done_int <= 1'b0;
                            end
                            else begin 
                                cycle_count <= 1'b0;
                                result <= burst_size;
                                done_int <= 1'b1;
                            end
                        end
                    end

        // 6. Read the status register / Write the control register
        3'b100  :   begin
                        if (valueA[9] == 1'b1) begin // Write in 1 cycle
                            burst_size <= valueB[7:0];
                            done_int <= 1'b1;
                        end
                        else begin
                            if (cycle_count < 1'b1) begin   // Read in 2 cycles
                                cycle_count <= 1'b1;
                                done_int <= 1'b0;
                            end
                            else begin 
                                cycle_count <= 1'b0;
                                result <= burst_size;
                                done_int <= 1'b1;
                            end
                        end
                    end

        endcase  
    end
end


// Finite State Machine - DMA controller
localparam [2:0] IDLE         = 3'd0;
localparam [2:0] REQUEST_BUS1 = 3'd1;
localparam [2:0] INIT_BURST1  = 3'd2;
localparam [2:0] DO_BURST1    = 3'd3;
localparam [2:0] END_TRANS1   = 3'd4;
localparam [2:0] END_TRANS2   = 3'd5;


// Decide next state based on current
  always @*
    case (s_stateMachineReg)
      IDLE            : s_dmaStateNext <= xxx ? REQUEST_BUS1 : IDLE;
      REQUEST_BUS1    : s_dmaStateNext <= xxx ? INIT_BURST1 : REQUEST_BUS1;
      INIT_BURST1     : s_dmaStateNext <= DO_BURST1;
      DO_BURST1       : s_dmaStateNext <= (busErrorIn == 1'b1) ? END_TRANS2 :
                                              (s_burstCountReg[8] == 1'b1 && busyIn == 1'b0) ? END_TRANS1 : DO_BURST1;
      END_TRANS1      : s_dmaStateNext <= (s_nrOfPixelsPerLineReg != 9'd0) ? REQUEST_BUS1 : IDLE;
      default         : s_dmaStateNext <= IDLE;
    endcase




always @* begin
    if 

end


assign done = done_int;

endmodule