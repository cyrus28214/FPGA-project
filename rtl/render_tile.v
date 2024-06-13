module render_tile (  // need at least 2^12 cycles to render a tile
    input wire clk,
    input wire rstn,
    input wire [18:0] tile_id,
    input wire [9:0] top,
    input wire [9:0] left,

    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);

  wire [18:0] src_addr;
  wire [15:0] src_data;
  bROM_tile bROM_tile_inst (
      .clka (~clk),
      .addra((tile_id << 10) + src_addr),
      .douta(src_data)
  );

  render_image #(
      .W(32),
      .H(32)
  ) u_render_image (
      .clk     (clk),
      .rstn    (rstn),
      .top     (top),
      .left    (left),
      .src_addr(src_addr),
      .src_data(src_data),
      .dst_addr(dst_addr),
      .dst_data(dst_data),
      .dst_wr  (dst_wr)
  );

endmodule
