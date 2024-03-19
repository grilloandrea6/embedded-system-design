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
wire count0Enabled, count1Enabled, count2Enabled, count3Enabled, count0Reset, count1Reset, count2Reset, count3Reset;
reg  [31:0] selected_result;
reg [11:0] save_regB;
reg internal_done;

integer i;

assign count0Enabled = save_regB[0] && !save_regB[4];
assign count1Enabled = save_regB[1] && !save_regB[5];
assign count2Enabled = save_regB[2] && !save_regB[6];
assign count3Enabled = save_regB[3] && !save_regB[7];
assign count0Reset = reset || save_regB[8];
assign count1Reset = reset || save_regB[9];
assign count2Reset = reset || save_regB[10];
assign count3Reset = reset || save_regB[11];

assign result = selected_result;
assign done = internal_done;

counter #(.WIDTH(32)) counter0 ( // count CPU cycles
        .reset(count0Reset),
        .clock(clock),
        .enable(count0Enabled),
        .direction(1'b1), // Count up
        .counterValue(value_counter0) // Save counter's value in result
    );

counter #(.WIDTH(32)) counter1 ( // stall counter
        .reset(count1Reset),
        .clock(clock),
        .enable(count1Enabled), // Count only when stall is high
        .direction(1'b1), // Count up
        .counterValue(value_counter1) // Save counter's value in result
    );

counter #(.WIDTH(32)) counter2 ( // busIdle counter
        .reset(count2Reset),
        .clock(clock),
        .enable(count2Enabled), // Count only when busIdle is high
        .direction(1'b1), // Count up
        .counterValue(value_counter2) // Save counter's value in result
    );

counter #(.WIDTH(32)) counter3 ( // count CPU cycles
        .reset(count3Reset),
        .clock(clock),
        .enable(count3Enabled),
        .direction(1'b1), // Count up
        .counterValue(value_counter3) // Save counter's value in result
    );


always @* begin
  if (reset) begin
    save_regB = 12'hf00;
  end
  if (correctId) begin
    for(i=0; i < 12; i = i + 1) begin
      if(valueB[i] == 1'b1)
        save_regB[i] = valueB[i];
    end

    for(i = 4; i < 8; i = i + 1) begin
      if((valueB[i-4] == 1'b1) && (valueB[i] == 1'b0))
        save_regB[i] = 0;
    end

    case (valueA[1:0])
      2'b00: selected_result = value_counter0; // Counter 0
      2'b01: selected_result = value_counter1; // Counter 1
      2'b10: selected_result = value_counter2; // Counter 2
      2'b11: selected_result = value_counter3; // Counter 3
    endcase
    internal_done = 1'b1;
  end else begin
    selected_result = 32'b0;
    save_regB[11:8] = 4'd0;
    internal_done = 1'b0;
  end	
end

endmodule