module thresholdChecker (
    input wire[15:0] rgb565,
    output wire out);

    wire [4:0] s_red = rgb565[15:11];
    wire [5:0] s_green = rgb565[10:5];
    wire [4:0] s_blue = rgb565[4:0];

    wire s_rok, s_gok, s_bok;

    // Use of fine-tuned values with comparison operators
    // assign s_rok = s_red > 5'd15 & s_red < 5'd25;
    // assign s_gok = s_green < 6'd10;
    // assign s_bok = s_blue > 5'd5 & s_blue < 5'd15;

    // Check with no use of comparison operators
    assign s_rok = ~s_red[4] & s_red[3];
    assign s_gok = ~s_green[5] & ~s_green[4] & ~s_green[3];
    assign s_bok = (s_blue[2] | (s_blue[1] & s_blue[0])) & ~s_blue[4] & ~s_blue[3];

    assign out = s_rok & s_gok & s_bok;

endmodule