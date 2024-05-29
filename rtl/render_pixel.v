module render_pixel (
    input wire [ 9:0] pos_x,
    input wire [ 9:0] pos_y,
    input wire [15:0] color,

    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);
  `include "./parameter.v"

  assign dst_addr = (pos_y * SCREEN_WIDTH + pos_x);
  assign dst_data = color;
  assign dst_wr   = color[12];

endmodule
