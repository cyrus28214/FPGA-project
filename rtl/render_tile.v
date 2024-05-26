module render_tile (  // need at least 18 cycles to render a tile
    input wire clk,
    input wire rstn,
    input wire [18:0] tile_addr,
    input wire [9:0] top,
    input wire [9:0] left,

    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);

  wire [15:0] color;
  reg [9:0] cnt;
  wire [9:0] cnt_write = cnt - 2;

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      cnt <= 0;
    end else begin
      cnt <= cnt + 1;
    end
  end

  render_pixel render_pixel_inst (
      .x(left + cnt_write[4:0]),
      .y(top + (cnt_write >> 5)),
      .color(color),
      .dst_addr(dst_addr),
      .dst_data(dst_data),
      .dst_wr(dst_wr)
  );

  bROM_tile bROM_tile_inst (
      .clka (clk),
      .addra(tile_addr + cnt),
      .douta(color)
  );

endmodule
