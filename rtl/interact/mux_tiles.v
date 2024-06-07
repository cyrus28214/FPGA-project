module mux_tiles (
    input  wire [15:0] tile_id,
    input  wire [ 3:0] pos_x,
    input  wire [ 3:0] pos_y,
    input  wire [ 3:0] player_x,
    input  wire [ 3:0] player_y,
    output wire [ 3:0] player_goto_x,
    output wire [ 3:0] player_goto_y
);
  `include "../parameters/resources_params.v"
  wire is_wall = (RS_wall_0 <= tile_id && tile_id <= RS_wall_2);

  assign player_goto_x = is_wall ? player_x : pos_x;
  assign player_goto_y = is_wall ? player_y : pos_y;

endmodule
