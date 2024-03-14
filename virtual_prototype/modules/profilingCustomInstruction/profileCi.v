module profileCi #(parameter[7:0] customId = 8'h00)
		  (input wire	start,
				clock,
				reset,
				stall,
				busIdle,
		   input wire[31:0] valueA,
				    valueB,
		   input wire [7:0] ciN,
		   output wire 	    done,
		   output wire [31:0] result);

wire correctId = (ciN == customId)&& start;
wire enable0, enable1, enable2, enable3;
wire [31:0] value_counter0, value_counter1, value_counter2, value_counter3;
reg [31:0] selected_result;

counter #(.WIDTH(32)) counter0 ( // count n� of CPU cycles
        .reset(reset || valueB[8]),
        .clock(clock),
        .enable(valueB[0]&& valueB[4]),
        .direction(1'b1), // Count up
        .counterValue(value_counter0) // Save counter's value in result
    );

counter #(.WIDTH(32)) counter1 ( // stall counter
        .reset(reset || valueB[9]),
        .clock(clock),
        .enable(stall && valueB[1]&& !valueB[5]), // Count only when stall is high
        .direction(1'b1), // Count up
        .counterValue(value_counter1) // Save counter's value in result
    );

counter #(.WIDTH(32)) counter2 ( // busIdle counter
        .reset(reset || valueB[10]),
        .clock(clock),
        .enable(busIdle && valueB[2]&& !valueB[6]), // Count only when busIdle is high
        .direction(1'b1), // Count up
        .counterValue(value_counter2) // Save counter's value in result
    );

counter #(.WIDTH(32)) counter3 ( // count n� of POU cycles
        .reset(reset || valueB[11]),
        .clock(clock),
        .enable(valueB[3]&& !valueB[7]),
        .direction(1'b1), // Count up
        .counterValue(value_counter3) // Save counter's value in result
    );


always @* begin
  
  if (correctId) begin
    case (valueA[1:0])
      2'b00: selected_result = value_counter0; // Counter 0
      2'b01: selected_result = value_counter1; // Counter 1
      2'b10: selected_result = value_counter2; // Counter 2
      2'b11: selected_result = value_counter3; // Counter 3
    endcase
  end else begin
    selected_result = 32'b0;
  end	
end

assign result = selected_result;
assign done = correctId && start;

endmodule