module player_react(
    input [3:0] org_pos_x,
    input [3:0] org_pos_y,
    input [3:0] goto_pos_x,
    input [3:0] goto_pos_y,
    input [15:0] goto_tile_id,

    output reg [3:0] new_pos_x,
    output reg [3:0] new_pos_y
  );

`include "./parameters/resources_params.v"

  wire is_wall = (RS_wall_0 <= goto_tile_id <= RS_wall_2);

  always @ (*)
    begin
      if (is_wall)
        begin
          new_pos_x = org_pos_x;
          new_pos_y = org_pos_y;
        end
      else
        begin
          new_pos_x = goto_pos_x;
          new_pos_y = goto_pos_y;
        end
    end

endmodule
