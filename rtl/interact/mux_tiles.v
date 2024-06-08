module mux_tiles (
    input  wire [15:0] tile_id,
    input  wire [ 3:0] pos_x,
    input  wire [ 3:0] pos_y,
    input  wire [ 3:0] player_x,
    input  wire [ 3:0] player_y,
    input  wire [ 3:0] key_num,
    output wire [ 3:0] player_goto_x,
    output wire [ 3:0] player_goto_y,
    output wire [ 3:0] key_num_out,
    output wire [15:0] new_tile_id
);
  `include "../parameters/resources_params.v"
  wire is_wall = (RS_wall_0 <= tile_id && tile_id <= RS_wall_2);
  wire is_key = (RS_key_0 <= tile_id && tile_id <= RS_key_3);

  assign player_goto_x = is_wall ? player_x : pos_x;
  assign player_goto_y = is_wall ? player_y : pos_y;
  assign key_num_out   = is_key ? key_num + 1 : key_num;
  assign new_tile_id   = is_key ? RS_ground_0 : tile_id;

endmodule
