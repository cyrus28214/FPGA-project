
module render_pixel (
    input wire clk,
    input wire rstn,
    input wire [9:0] x,
    input wire [9:0] y,
    input wire [15:0] color,

    output wire [18:0] src_addr,
    input wire [15:0] src_data,
    output wire src_rd,

    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);
  `include "./parameter.v"
  reg [35:0] queue[2:0];

  wire [9:0] w_x, w_y;
  wire [15:0] w_color;

  assign {w_x, w_y, w_color} = queue[0];

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      {queue[2], queue[1], queue[0]} <= 0;
    end else begin
      {queue[2], queue[1], queue[0]} <= {{x, y, color}, queue[2], queue[1]};
    end
  end

  assign src_addr = y * SCREEN_WIDTH + x;
  assign src_rd   = rstn;

  assign dst_addr = w_y * SCREEN_WIDTH + w_x;
  assign dst_data = w_color;
  assign dst_wr   = w_color[12];

endmodule
