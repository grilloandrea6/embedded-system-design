module rgb565Grayscalelse #(parameter [7:0] customInstructionId = 8'd0)
                (input wire start,
                input wire [31:0] valueA,
                input wire [7:0] isId,
                output wire done,
                output reg [31:0] result);

wire s_isMyCi = (isId == customInstructionId) ? start : 1'b0;

assign done = s_isMyCi;
wire [5:0] red   = {valueA[15:11],1'b0};
wire [5:0] green =  valueA[10: 5];
wire [5:0] blue  = {valueA[ 4: 0],1'b0};
wire [31:0] partial = (red * 54 + green * 183 + blue * 19);

always @*
    if (s_isMyCi == 1'b0) result <= 32'd0;
    else begin
      result[7:0] <= partial[13:6];
    end
endmodule