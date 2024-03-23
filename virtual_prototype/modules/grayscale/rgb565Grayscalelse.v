module rgb565Grayscalelse #(parameter [7:0] customInstructionId = 8'd0)
                (input wire start,
                input wire [31:0] valueA,
                input wire [7:0] isId,
                output wire done,
                output reg [31:0] result);

wire s_isMyCi = (isId == customInstructionId) ? start : 1'b0;
assign done = s_isMyCi;


/*
first version with multiplication handled by the synthesizer

wire [5:0] red_   = {valueA[15:11],1'b0};
wire [5:0] green_ =  valueA[10: 5];
wire [5:0] blue_  = {valueA[4:0],1'b0};
wire [31:0] partial = (red * 54 + green * 183 + blue * 19);
*/


wire [31:0] red_   = {26'b0, valueA[15:11], 1'b0};
wire [31:0] green_ = {26'b0, valueA[10: 5]};
wire [31:0] blue_  = {26'b0, valueA[ 4: 0],1'b0};

reg [31:0] red, green, blue, partial;

always @* begin
    red   = (red_   << 5) +
            (red_   << 4) +
            (red_   << 2) +
            (red_   << 1);
    green = (green_ << 7) +
            (green_ << 5) +
            (green_ << 4) +
            (green_ << 2) +
            (green_ << 1) +
            green_;
    blue  = (blue_  << 4) +
            (blue_  << 1) +
            blue_;
    partial = red + green + blue;

    if (s_isMyCi == 1'b0) begin
        result <= 32'd0;
    end
    else begin
      result[7:0] <= partial[13:6];
    end
end
endmodule