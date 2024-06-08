module map (
    input wire clk,
    input wire rstn,
    input wire [18:0] map_id,

    input wire [3:0] player_x,
    input wire [3:0] player_y,

    output wire [18:0] bRAM_map_addr,
    input  wire [15:0] bRAM_map_data,

    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);

  `include "./parameters/game_params.v"
  `include "./parameters/resources_params.v"

  wire [ 3:0] grid_x;
  wire [ 3:0] grid_y;
  wire [18:0] dst_addr;
  wire [15:0] dst_data;
  wire        dst_wr;
  assign bRAM_map_addr = map_id * MAP_WIDTH * MAP_HEIGHT + grid_y * MAP_WIDTH + grid_x;
  wire [18:0] tild_id = (grid_x == player_x && grid_y == player_y) ? RS_hero_0 : bRAM_map_data;

  render_map u_render_map (
      .clk     (clk),
      .rstn    (rstn),
      .tile_id (tile_id),
      .grid_x  (grid_x),
      .grid_y  (grid_y),
      .dst_addr(dst_addr),
      .dst_data(dst_data),
      .dst_wr  (dst_wr)
  );


endmodule
