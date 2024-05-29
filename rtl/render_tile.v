module render_tile (  // need at least 18 cycles to render a tile
    input wire clk,
    input wire rstn,
    input wire [18:0] tile_addr,
    input wire [9:0] top,
    input wire [9:0] left,

    output reg finish,
    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);

  wire [15:0] color;
  reg pixel_en;
  reg [9:0] cnt_rd;
  reg [9:0] cnt_wr;

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      cnt_rd   <= 0;
      cnt_wr   <= 0;
      pixel_en <= 0;
      finish   <= 0;
    end else if (!finish) begin
      if (cnt_rd < 2) begin
        cnt_rd <= cnt_rd + 1;
      end else if (cnt_rd < 10'h3FF) begin
        cnt_rd   <= cnt_rd + 1;
        cnt_wr   <= cnt_wr + 1;
        pixel_en <= 1;
      end else begin
        cnt_rd   <= 0;
        cnt_wr   <= 0;
        pixel_en <= 0;
        finish   <= 1;
      end
    end
  end

  render_pixel render_pixel_inst (
      .pos_x(left + cnt_wr[4:0]),
      .pos_y(top + (cnt_wr >> 5)),
      .color(pixel_en ? color : 0),
      .dst_addr(dst_addr),
      .dst_data(dst_data),
      .dst_wr(dst_wr)
  );

  bROM_tile bROM_tile_inst (
      .clka (clk),
      .addra(tile_addr + cnt_rd),
      .douta(color)
  );

endmodule
