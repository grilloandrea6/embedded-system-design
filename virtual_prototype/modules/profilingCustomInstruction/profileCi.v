module profileCi #(parameter[7:0] customId = 8'd8)
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

wire correctId = (ciN == customId) && start;
wire [31:0] value_counter0, value_counter1, value_counter2, value_counter3;
wire count0Enabled, count1Enabled, count2Enabled, count3Enabled;
reg  [31:0] selected_result;
reg [11:0] save_regB;


assign count0Enabled = valueB[0] && !save_regB[4];
assign count1Enabled = valueB[1] && !save_regB[5];
assign count2Enabled = valueB[2] && !save_regB[6];
assign count3Enabled = valueB[3] && !save_regB[7];

counter #(.WIDTH(32)) counter0 ( // count CPU cycles
        .reset(reset || save_regB[8]),
        .clock(clock),
        .enable(count0Enabled),
        .direction(1'b1), // Count up
        .counterValue(value_counter0) // Save counter's value in result
    );

counter #(.WIDTH(32)) counter1 ( // stall counter
        .reset(reset || save_regB[9]),
        .clock(clock),
        .enable(stall && count1Enabled), // Count only when stall is high
        .direction(1'b1), // Count up
        .counterValue(value_counter1) // Save counter's value in result
    );

counter #(.WIDTH(32)) counter2 ( // busIdle counter
        .reset(reset || save_regB[10]),
        .clock(clock),
        .enable(busIdle && count2Enabled), // Count only when busIdle is high
        .direction(1'b1), // Count up
        .counterValue(value_counter2) // Save counter's value in result
    );

counter #(.WIDTH(32)) counter3 ( // count CPU cycles
        .reset(reset || save_regB[11]),
        .clock(clock),
        .enable(count3Enabled),
        .direction(1'b1), // Count up
        .counterValue(value_counter3) // Save counter's value in result
    );


always @* begin
  if (reset) begin
    save_regB <= 12'b0;
  end
  if (correctId) begin
    save_regB <= valueB;
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
assign done = correctId;

endmodule