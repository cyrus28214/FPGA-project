module mux_tiles (
    input  wire [15:0] tile_id,
    input  wire [ 3:0] pos_x,
    input  wire [ 3:0] pos_y,
    input  wire [ 3:0] player_x,
    input  wire [ 3:0] player_y,
    input  wire [ 3:0] key_num,
    output reg  [ 3:0] player_goto_x,
    output reg  [ 3:0] player_goto_y,
    output reg  [ 3:0] key_num_out,
    output reg  [15:0] new_tile_id
);
  `include "../parameters/resources_params.v"
  wire is_wall = (RS_wall_0 <= tile_id && tile_id <= RS_wall_2);
  wire is_key = (RS_key_0 <= tile_id && tile_id <= RS_key_3);
  wire is_door = (RS_door_0 <= tile_id && tile_id <= RS_door_3);

  always @(*) begin
    player_goto_x <= pos_x;
    player_goto_y <= pos_y;
    key_num_out   <= key_num;
    new_tile_id   <= tile_id;

    if (is_wall) begin
      player_goto_x <= player_x;
      player_goto_y <= player_y;
    end else if (is_key) begin
      key_num_out <= key_num + 1;
      new_tile_id <= RS_ground_0;
    end else if (is_door) begin
      if (key_num == 0) begin
        player_goto_x <= player_x;
        player_goto_y <= player_y;
      end else begin
        key_num_out <= key_num - 1;
        new_tile_id <= RS_ground_0;
      end
    end
  end

endmodule
