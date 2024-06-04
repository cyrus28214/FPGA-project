module render_tile (  // need at least 2^12 cycles to render a tile
    input wire clk,
    input wire rstn,
    input wire [18:0] tile_addr,
    input wire [9:0] top,
    input wire [9:0] left,

    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);

  wire [11:0] cnt;
  clkdiv #(
      .DIV(12)
  ) u_clkdiv (
      .clk    (clk),
      .rstn   (rstn),
      .div_res(cnt)
  );

  wire [18:0] src_addr = tile_addr + cnt[11:2];
  wire [15:0] color;
  bROM_tile bROM_tile_inst (
      .clka (~clk),
      .addra(src_addr),
      .douta(color)
  );

  wire [9:0] pos_x = left + cnt[6:2];
  wire [9:0] pos_y = top + cnt[11:7];
  wire [18:0] addr;
  wire [15:0] data;
  wire wr;
  render_pixel render_pixel_inst (
      .pos_x(pos_x),
      .pos_y(pos_y),
      .color(color),
      .dst_addr(addr),
      .dst_data(data),
      .dst_wr(wr)
  );

  assign dst_addr = addr;
  assign dst_data = data;
  assign dst_wr   = cnt[1:0] == 2'b11 && wr;

endmodule
