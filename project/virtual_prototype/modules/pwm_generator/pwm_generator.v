module pwm_generator #(  parameter [7:0] customId = 8'h00 )
             (  input  wire         start,
                                    clock,
                                    reset,  // ToDo use it -> 
                input  wire [31:0]  valueA,
                                    valueB,
                input  wire  [7:0]  ciN,
                output wire  [1:0]  pwmPins,
                output wire         done
              );

    // Valua A: bit 0 and 1 activate pwm 1 and 2
    //          bit 2 and 3 are used to select which duty cycle to write (valueB)
    
    // VALUE A
    // first 2 bits are directly written to the pwmactivated pins
    // 3rd bit
    // write duty1 from valueB to duty_1
    // 4th bit
    // write duty2 from valueB to duty_2

    // duty can be from 0 to 2^20

    wire s_isMyCust = (ciN == customId) ? start : 1'b0;
    assign done = s_isMyCust;

    reg [1:0] pwmActivated = 0;

    // We want to generate PWM at 50Hz (from motor datasheet)
    // The system clock should be 72MHz
    // Which means that we need to count 1.440.000 cycles to get 50Hz
    // With a 20bits counter we can count up to 1.048.576, which seems like a good compromise
    // This way we never reset the counter
    reg [19:0] counterFreq = 0;
    
    reg [19:0] duty_1 = 0 , duty_2 = 0;
    
    assign pwmPins[0] = (pwmActivated[0] && counterFreq < duty_1) ? 1'b1 : 1'b0;
    assign pwmPins[1] = (pwmActivated[1] && counterFreq < duty_2) ? 1'b1 : 1'b0;

    always @(posedge clock) begin
        if (reset) begin
            counterFreq <= 0;
            pwmActivated <= 0;
            duty_1 <= 0;
            duty_2 <= 0;
        end else begin
            if (s_isMyCust) begin
                pwmActivated <= valueA[1:0];
                duty_1 <= valueA[3:2] == 2'b01 ? valueB[19:0] : duty_1;
                duty_2 <= valueA[3:2] == 2'b10 ? valueB[19:0] : duty_2;
            end
        end
        counterFreq <= counterFreq + 1'b1; 
    end

endmodule