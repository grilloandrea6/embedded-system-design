`timescale 1ps/1ps

module fifoTestBench;
  localparam bitWidth = 32;
  localparam nrOfEntries = 16;

  reg clock,reset, push, pop, full, empty;
  reg [bitWidth-1:0]    pushData;

  initial
    begin
      pushData = bitWidth{1'b0};
      reset = 1'b1;
      clock = 1'b0;
      repeat (4) #5 clock = ~clock;
      reset = 1'b0;
      forever #5 clock = ~clock;
    end

  wire [bitWidth:0] popData;

  fifo #(.nrOfEntries(nrOfEntries), .bitWidth(bitWidth)) dut 
    ( .reset(reset),
      .clock(clock),
      .push(push),
      .pop(pop),
      .pushData(pushData),
      .popData(popData),
      .full(full),
      .empty(empty));

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
      
  
  initial
    begin
      $dumpfile("fifoSignals.vcd");
      $dumpvars(1,dut);
    end
endmodule
