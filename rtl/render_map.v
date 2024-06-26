module render_map (
    input wire clk,  //need 2^13 * MAP_WIDTH * MAP_HEIGHT cycs
    input wire rstn,

    input  wire [18:0] tile_id,
    output reg  [ 3:0] grid_x,
    output reg  [ 3:0] grid_y,

    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);

  `include "./parameters/game_params.v"
  reg [12:0] cnt;
  wire [9:0] top = (grid_y << 5) + 32;
  wire [9:0] left = (grid_x << 5) + 32 * 4;
  render_tile u_render_tile (
      .clk      (clk),
      .rstn     (rstn),
      .tile_id(tile_id),
      .top      (top),
      .left     (left),
      .dst_addr (dst_addr),
      .dst_data (dst_data),
      .dst_wr   (dst_wr)
  );

  reg [3:0] grid_x_next, grid_y_next;
  always @(*) begin
    if (grid_x != MAP_WIDTH - 1) begin
      grid_x_next <= grid_x + 1;
      grid_y_next <= grid_y;
    end else begin
      grid_x_next <= 0;
      if (grid_y != MAP_HEIGHT - 1) begin
        grid_y_next <= grid_y + 1;
      end else begin
        grid_y_next <= 0;
      end
    end
  end

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      cnt <= 0;
      grid_x <= 0;
      grid_y <= 0;
    end else begin
      cnt <= cnt + 1;
      if (&cnt) begin
        grid_x <= grid_x_next;
        grid_y <= grid_y_next;
      end
    end
  end

endmodule
