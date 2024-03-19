module rgb565Grayscalelse_faster #(parameter [7:0] customInstructionId = 8'd0)
                (input wire start,
                input wire [31:0] valueA,
                input wire [31:0] valueB,
                input wire [7:0] isId,
                output wire done,
                output reg [31:0] result);

wire s_isMyCi = (isId == customInstructionId) ? start : 1'b0;

assign done = s_isMyCi;

// Bit 1
wire [5:0] red1   = {valueA[15:11],1'b0};
wire [5:0] green1 =  valueA[10: 5];
wire [5:0] blue1  = {valueA[ 4: 0],1'b0};
// Bit 2
wire [5:0] red2   = {valueA[31:27],1'b0};
wire [5:0] green2 =  valueA[26: 21];
wire [5:0] blue2  = {valueA[ 20: 16],1'b0};
// Bit 3
wire [5:0] red3   = {valueB[15:11],1'b0};
wire [5:0] green3 =  valueB[10: 5];
wire [5:0] blue3  = {valueB[ 4: 0],1'b0};
// Bit 4
wire [5:0] red4   = {valueB[31:27],1'b0};
wire [5:0] green4 =  valueB[26: 21];
wire [5:0] blue4  = {valueB[ 20: 16],1'b0};

wire [31:0] partial1 = (red1 * 54 + green1 * 183 + blue1 * 19);
wire [31:0] partial2 = (red2 * 54 + green2 * 183 + blue2 * 19);
wire [31:0] partial3 = (red3 * 54 + green3 * 183 + blue3 * 19);
wire [31:0] partial4 = (red4 * 54 + green4 * 183 + blue4 * 19);

always @*
    if (s_isMyCi == 1'b0) result <= 32'd0;
    else begin
      result[7:0] <= partial1[13:6];
      result[15:8] <= partial2[13:6];
      result[23:16] <= partial3[13:6];
      result[31:24] <= partial4[13:6];
    end
endmodule