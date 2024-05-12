module thresholdChecker (
    input wire[15:0] rgb565,
    output wire[15:0] thresholdedPixel);

/*
 * The color to detect is 'magenta': (255, 0, 255) in RGB, 0xf81f [11111 000000 11111] in RGB565
 * The minimum threshold is 0xc1f8 [11000 001111 11000] and the maximum threshold is 0xf82f [11111 000000 10111]
 * DETECTION CONDITION: red[4:3]==1, green[5:4]==0, blue[4:0]==1
 * If the condition is met, the pixel is showed in green, otherwise in black
 *
 * ( The average threshold is 0xd91b [11011 001000 11011] )
 */

// red-green-blue conditions get checked
assign thresholdedPixel = (rgb565[15:11]==2'b11 && rgb565[10:5]==2'b00 && rgb565[4:0]==2'b11) ? 16'h07e0 : 16'h0000;

endmodule