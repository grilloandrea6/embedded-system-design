module ramDmaCi #( parameter [7:0] customId = 8'h00 )
                  ( input  wire         start,
                                        clock,
                                        reset,
                    input  wire [31:0]  valueA,
                                        valueB,
                    input  wire  [7:0]  ciN,
                    output wire         done,
                    output reg  [31:0]  result);

wire s_isMyCi = (ciN == customId) ? start : 1'b0;
wire [31:0] partial;
reg done_int, cycle_count;
wire [31:0] dataoutB;

dmaMemory myDmaMemory
            (.clockA(clock),
            .clockB(clock),
            .writeEnableA(valueA[9] && (valueA[31:10] == 0)),
            .writeEnableB(1'b0),
            .addressA(valueA[8:0]),
            .addressB(9'b0),
            .dataInA(valueB),
            .dataInB(32'b0),
            .dataOutA(partial),
            .dataOutB(dataoutB)
            );


always @* begin
    if (s_isMyCi == 1'b0) begin
        cycle_count <= 1'b0;
        result <= 32'd0;
    end
    else begin
        if (valueA[9] == 1'b1) begin
            result <= partial;
            done_int <= 1'b1;
        end
        else begin
            if (cycle_count < 1'b1) begin
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
end

assign done = done_int;

endmodule