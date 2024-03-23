module rgb565Grayscalelse_faster #(parameter [7:0] customInstructionId = 8'd0)
                (input wire start,
                input wire [31:0] valueA,
                input wire [31:0] valueB,
                input wire [7:0] isId,
                output wire done,
                output reg [31:0] result);

wire s_isMyCi = (isId == customInstructionId) ? start : 1'b0;

reg [31:0] partial1, partial2, partial3, partial4;
assign done = s_isMyCi;

// Pixel 1
wire [31:0] red1   = {valueA[7:3],1'b0};
wire [31:0] green1 =  {valueA[2:0], valueA[15:13]};
wire [31:0] blue1  = {valueA[12:8],1'b0};
// Pixel 2
wire [31:0] red2   = {valueA[23:19],1'b0};
wire [31:0] green2 =  {valueA[18:16], valueA[31:29]};
wire [31:0] blue2  = {valueA[28:24],1'b0};
// Pixel 3
wire [31:0] red3   = {valueB[7:3],1'b0};
wire [31:0] green3 =  {valueB[2:0], valueB[15:13]};
wire [31:0] blue3  = {valueB[12:8],1'b0};
// Pixel 4
wire [5:0] red4   = {valueB[23:19],1'b0};
wire [5:0] green4 =  {valueB[18:16], valueB[31:29]};
wire [5:0] blue4  = {valueB[28:24],1'b0};

/* first version with multiplication handled by the synthesizer
reg [31:0] partial1 = (red1 * 54 + green1 * 183 + blue1 * 19);
wire [31:0] partial2 = (red2 * 54 + green2 * 183 + blue2 * 19);
wire [31:0] partial3 = (red3 * 54 + green3 * 183 + blue3 * 19);
wire [31:0] partial4 = (red4 * 54 + green4 * 183 + blue4 * 19);
*/ 

always @*
    if (s_isMyCi == 1'b0) begin
      result <= 32'd0;
    end
    else begin
    
    partial1   = (red1   << 5) +
                 (red1   << 4) +
                 (red1   << 2) +
                 (red1   << 1) +
                 (green1 << 7) +
                 (green1 << 5) +
                 (green1 << 4) +
                 (green1 << 2) +
                 (green1 << 1) +
                  green1 +
                 (blue1  << 4) +
                 (blue1  << 1) +
                  blue1;
    
    partial2   = (red2   << 5) +
                 (red2   << 4) +
                 (red2   << 2) +
                 (red2   << 1) +
                 (green2 << 7) +
                 (green2 << 5) +
                 (green2 << 4) +
                 (green2 << 2) +
                 (green2 << 1) +
                  green2 +
                 (blue2  << 4) +
                 (blue2  << 1) +
                  blue2;

    partial3   = (red3   << 5) +
                 (red3   << 4) +
                 (red3   << 2) +
                 (red3   << 1) +
                 (green3 << 7) +
                 (green3 << 5) +
                 (green3 << 4) +
                 (green3 << 2) +
                 (green3 << 1) +
                  green3 +
                 (blue3  << 4) +
                 (blue3  << 1) +
                  blue3;

    partial4   = (red4   << 5) +
                 (red4   << 4) +
                 (red4   << 2) +
                 (red4   << 1) +
                 (green4 << 7) +
                 (green4 << 5) +
                 (green4 << 4) +
                 (green4 << 2) +
                 (green4 << 1) +
                  green4 +
                 (blue4  << 4) +
                 (blue4  << 1) +
                  blue4;

      result[7:0] <= partial1[13:6];
      result[15:8] <= partial2[13:6];
      result[23:16] <= partial3[13:6];
      result[31:24] <= partial4[13:6];
    end
endmodule