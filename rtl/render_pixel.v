module render_pixel (
    input wire [ 9:0] x,
    input wire [ 9:0] y,
    input wire [15:0] color,

    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);
  `include "./parameter.v"

  assign dst_addr = y * SCREEN_WIDTH + x;
  assign dst_data = color;
  assign dst_wr   = color[12];

endmodule
