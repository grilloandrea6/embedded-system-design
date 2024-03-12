`timescale 1ps/1ps

module fifoTestBench;
  localparam bitWidth = 32;
  localparam nrOfEntries = 16;

  reg clock,reset, push, pop;
  wire full, empty;
  reg [bitWidth-1:0]    pushData;

  initial
    begin
      //pushData = bitWidth{1'b0};
      reset = 1'b1;
      clock = 1'b0;
      repeat (4) #5 clock = ~clock;
      reset = 1'b0;
      forever #5 clock = ~clock;
    end

  initial
    begin
      $dumpfile("fifoSignals.vcd");
      $dumpvars(1,DUT);
    end

  wire [bitWidth-1:0] popData_tb;

  fifo #(.nrOfEntries(nrOfEntries), .bitWidth(bitWidth)) DUT 
    ( .reset(reset),
      .clock(clock),
      .push(push),
      .pop(pop),
      .pushData(pushData),
      .popData(popData_tb),
      .full(full),
      .empty(empty));

initial
    begin
      push = 1'b0;
      pop = 1'b0;
      pushData = 8'd0;
      @(negedge reset);            /* wait for the reset period to end */
      repeat(2) @(negedge clock);  /* wait for 2 clock cycles */
      push = 1'b1;
      repeat(32) @(negedge clock) pushData = pushData + 8'd1;
      push = 1'b0;
      pop = 1'b1;
      repeat(32) @(negedge clock); /* wait for 32 clock cycles */
      pop = 1'b0;
      //$finish;                     /* finish the simulation */
    end
endmodule
/*
integer counter = 0;
always @(posedge clock) begin
    begin
      counter = counter + 1;

    // Stimuli generation
      if (counter == 2) begin
      // Every two inputs, pop one value
        pop = 1;
        counter = 0; // Reset counter after popping one value
      end else begin
      // Otherwise, push one value
        pushData = $random; // Random data for illustration
        push = 1;
        push = 0;
    end
end
*/
 
/*
always @(negedge clock)
    begin
      s_enable    <= (reset == 1'b1) ? 1'b0 : ~s_enable;
      s_direction <= (reset == 1'b1) ? 1'b1 :
                     (s_enable == 1'b0 && s_value == 8'd55) ? 1'b0 : s_direction;
    end
  
  initial
    begin
      s_direction = 1'b1;
      @(negedge reset);
      forever @(negedge clock) if (s_direction == 1'b0 && s_value == 8'd127) $finish;
      $finish;
    end
*/      
  

