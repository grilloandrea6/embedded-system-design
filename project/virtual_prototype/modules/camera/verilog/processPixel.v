module processPixel (
    input wire[15:0] rgb565,
    output wire[15:0] processedPixel,
    output wire outputMask);

    wire  [7:0] grayscale;
    wire [15:0] grayscale565;

    thresholdChecker thr ( .rgb565(rgb565),
                          .out(outputMask) );

    rgb565Grayscale rgb ( .rgb565(rgb565),
                          .grayscale(grayscale) );

    assign grayscale565 = {grayscale[7:3],grayscale[7:2],grayscale[7:3]};
   
    assign processedPixel = outputMask ? rgb565 : grayscale565;

endmodule