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
assign done = s_isMyCi;
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
        result <= 32'd0;
    end
    else begin
        result <= partial;
    end
end

endmodule