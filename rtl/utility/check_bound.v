module check_bound (
    input  wire [3:0] pos_x,
    input  wire [3:0] pos_y,
    output wire [3:0] allow
);
  `include "../parameters/game_params.v"

  wire allow_left = (pos_x != 0);
  wire allow_down = (pos_y != MAP_HEIGHT - 1);
  wire allow_up = (pos_y != 0);
  wire allow_right = (pos_x != MAP_WIDTH - 1);

  assign allow = {allow_right, allow_up, allow_down, allow_left};

endmodule
