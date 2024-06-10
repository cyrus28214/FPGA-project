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

  wire [15:0] color;
  reg  [18:0] src_addr;
  bROM_tile bROM_tile_inst (
      .clka (~clk),
      .addra(src_addr),
      .douta(color)
  );

  reg [4:0] pos_x;
  reg [4:0] pos_y;
  wire pix_wr;
  render_pixel render_pixel_inst (
      .pos_x(left + pos_x),
      .pos_y(top + pos_y),
      .color(color),
      .dst_addr(dst_addr),
      .dst_data(dst_data),
      .dst_wr(pix_wr)
  );

  reg  [1:0] cnt;
  wire [4:0] pos_x_next;
  wire [4:0] pos_y_next;
  assign {pos_y_next, pos_x_next} = {pos_y, pos_x} + 1;

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      src_addr <= 0;
      pos_x <= 0;
      pos_y <= 0;
      cnt <= 0;
    end else begin
      cnt <= cnt + 1;
      if (cnt == 3) begin
        {pos_y, pos_x} <= {pos_y_next, pos_x_next};
        src_addr <= tile_addr + {pos_y_next, pos_x_next};
      end
    end
  end

  assign dst_wr = pix_wr & (cnt == 3);

endmodule
