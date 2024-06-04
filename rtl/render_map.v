module render_map (
    input wire clk,
    input wire rstn,
    input wire [18:0] map_addr,
    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);


  wire [12:0] cnt;
  wire map_clk = cnt[12];
  clkdiv #(
      .DIV(13)
  ) u_clkdiv (
      .clk    (clk),
      .rstn   (rstn),
      .div_res(cnt)
  );

  reg  [18:0] src_addr;
  wire [15:0] src_data;
  bROM_map u_bROM_map (
      .clka (~clk),
      .addra(src_addr),
      .douta(src_data)
  );

  wire [18:0] tile_addr = src_data << 10;
  reg [3:0] grid_x, grid_y;
  wire [9:0] top = grid_x << 5;
  wire [9:0] left = grid_y << 5;
  render_tile u_render_tile (
      .clk      (clk),
      .rstn     (rstn),
      .tile_addr(tile_addr),
      .top      (top),
      .left     (left),
      .dst_addr (dst_addr),
      .dst_data (dst_data),
      .dst_wr   (dst_wr)
  );

  reg [3:0] grid_x_next, grid_y_next;
  always @(*) begin
    if (grid_x < 10) begin
      grid_x_next <= grid_x + 1;
      grid_y_next <= grid_y;
    end else begin
      grid_x_next <= 0;
      if (grid_y < 10) begin
        grid_y_next <= grid_y + 1;
      end else begin
        grid_y_next <= 0;
      end
    end
  end

  always @(posedge map_clk or negedge rstn) begin
    if (!rstn) begin
      grid_x   <= 0;
      grid_y   <= 0;
      src_addr <= 0;
    end else begin
      grid_x   <= grid_x_next;
      grid_y   <= grid_y_next;
      src_addr <= map_addr + (grid_y * 11 + grid_x);
    end
  end

endmodule
