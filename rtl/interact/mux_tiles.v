module mux_tiles (
    input wire [3:0] pos_x,
    input wire [3:0] pos_y,

    input wire [15:0] floor,
    input wire [ 3:0] player_x,
    input wire [ 3:0] player_y,
    input wire [31:0] key_num,
    input wire [15:0] health,
    input wire [15:0] tile_id,

    output reg [15:0] floor_out,
    output reg [ 3:0] player_goto_x,
    output reg [ 3:0] player_goto_y,
    output reg [31:0] key_num_out,
    output reg [15:0] health_out,
    output reg [15:0] new_tile_id
);
  `include "../parameters/resources_params.v"
  `include "../parameters/number_params.v"
  wire is_wall = (RS_wall_0 <= tile_id && tile_id <= RS_wall_2);
  wire is_key = (RS_key_0 <= tile_id && tile_id <= RS_key_3);
  wire is_potion = (RS_potion_0 <= tile_id && tile_id <= RS_potion_3);
  wire is_gem = (RS_gem_0 <= tile_id && tile_id <= RS_gem_3);
  wire is_door = (RS_door_0 <= tile_id && tile_id <= RS_door_3);
  wire is_enemy = (RS_slime_0 <= tile_id && tile_id <= RS_knight_7);
  wire is_downstair = tile_id == RS_stair_0;
  wire is_upstair = tile_id == RS_stair_1;

  wire [3:0] down_x;
  wire [3:0] down_y;
  wire [3:0] up_x;
  wire [3:0] up_y;

  wire [7:0] key_num_0, key_num_1, key_num_2, key_num_3;
  assign {key_num_3, key_num_2, key_num_1, key_num_0} = key_num;
  `define key_num_out_0 key_num_out[ 7: 0]
  `define key_num_out_1 key_num_out[15: 8]
  `define key_num_out_2 key_num_out[23:16]
  `define key_num_out_3 key_num_out[31:24]

  floor_pos u_floor_pos (
      .floor (floor),
      .down_x(down_x),
      .down_y(down_y),
      .up_x  (up_x),
      .up_y  (up_y)
  );

  wire [15:0] attack;
  enemy_attack u_enemy_attack (
      .tile_id(tile_id),
      .attack (attack)
  );

  always @(*) begin
    floor_out     <= floor;
    player_goto_x <= pos_x;
    player_goto_y <= pos_y;
    key_num_out   <= key_num;
    new_tile_id   <= tile_id;
    health_out    <= health;

    if (is_wall) begin
      player_goto_x <= player_x;
      player_goto_y <= player_y;

    end else if (is_key) begin
      case (tile_id)
        RS_key_0: `key_num_out_0 <= key_num_0 + 1;
        RS_key_1: `key_num_out_1 <= key_num_1 + 1;
        RS_key_2: `key_num_out_2 <= key_num_2 + 1;
        RS_key_3: `key_num_out_3 <= key_num_3 + 1;
      endcase
      new_tile_id <= RS_ground_0;

    end else if (is_potion || is_gem) begin
      health_out  <= health + 5;
      new_tile_id <= RS_ground_0;

    end else if (is_door) begin
      case (tile_id)

        RS_door_0:
        if (key_num_0 > 0) begin
          `key_num_out_0 <= key_num_0 - 1;
          new_tile_id <= RS_ground_0;
        end else begin
          player_goto_x <= player_x;
          player_goto_y <= player_y;
        end

        RS_door_1:
        if (key_num_1 > 0) begin
          `key_num_out_1 <= key_num_1 - 1;
          new_tile_id <= RS_ground_0;
        end else begin
          player_goto_x <= player_x;
          player_goto_y <= player_y;
        end

        RS_door_2:
        if (key_num_2 > 0) begin
          `key_num_out_2 <= key_num_2 - 1;
          new_tile_id <= RS_ground_0;
        end else begin
          player_goto_x <= player_x;
          player_goto_y <= player_y;
        end

        RS_door_3:
        if (key_num_3 > 0) begin
          `key_num_out_3 <= key_num_3 - 1;
          new_tile_id <= RS_ground_0;
        end else begin
          player_goto_x <= player_x;
          player_goto_y <= player_y;
        end
      endcase

    end else if (is_enemy) begin
      if (health > attack) begin
        health_out  <= health - attack;
        new_tile_id <= RS_ground_0;
      end else begin
        player_goto_x <= player_x;
        player_goto_y <= player_y;
      end

    end else if (is_upstair) begin
      player_goto_x <= up_x;
      player_goto_y <= up_y;
      floor_out <= floor + 1;

    end else if (is_downstair) begin
      player_goto_x <= down_x;
      player_goto_y <= down_y;
      floor_out <= floor - 1;
    end

  end

endmodule
