module Sseg_Dev(
    input clk,
    input start,
    input [31:0] hexs,
    input [7:0] points,
    input [7:0] LEs,
    output seg_clk,
    output seg_clrn,
    output seg_sout,
    output seg_pen
);

    wire [63:0] seg_data;

    HexTo8Seg u_HexTo8Seg(
        .hexs(hexs),
        .points(points),
        .LEs(LEs),
        .seg_data(seg_data)
    );

    P2S #(.BIT_WIDTH(64)) u_P2S(
        .clk(clk),
        .start(start),
        .par_in(seg_data),
        .sclk(seg_clk),
        .sclrn(seg_clrn),
        .sout(seg_sout),
        .EN(seg_pen)
    );


endmodule

