module render_tile (
    input wire clk,
    input wire rstn,
    input wire [18:0] tile_addr,
    input wire [9:0] x,
    input wire [9:0] y,
    output reg finish_rd,
    output reg finish_wr,

    output wire src_rd,
    output wire [18:0] src_addr,
    input wire [15:0] src_data,

    output wire dst_wr,
    output wire [18:0] dst_addr,
    output wire [15:0] dst_data
);
  `include "./parameter.v"


  reg [9:0] cnt;  //32 x 32
  wire [9:0] rd_cnt = cnt;
  wire [9:0] wr_cnt = cnt - 2;

  assign src_rd   = rstn;
  assign src_addr = tile_addr + cnt;

  render_pixel render_pixel_inst (
      .x(x + cnt[4:0]),
      .y(y + (cnt >> 5)),
      .color(src_data),
      .dst_addr(dst_addr),
      .dst_data(dst_data),
      .dst_wr(dst_wr)
  );

  always @(posedge clk or negedge rstn) begin


    //first posedge of clk after rstn = 1: shift = 100
    //second: shift = 110
    //third: shift = 111, then wr = 1
    //rendering
    //first posedge of clk after rstn = 0: shift = 011
    //second: shift = 001
    //third: shift = 000, then wr = 0

  end


endmodule

