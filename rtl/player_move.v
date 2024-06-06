module player_move (
    input wire [3:0] move,  //R U D L
    input wire [3:0] pos_x,
    input wire [3:0] pos_y,
    output wire [3:0] pos_x_next,
    output wire [3:0] pos_y_next
);
  `include "./parameters/game_params.v"

  wire allow_left = (pos_x != 0);
  wire allow_down = (pos_y != MAP_HEIGHT - 1);
  wire allow_up = (pos_y != 0);
  wire allow_right = (pos_x != MAP_WIDTH - 1);
  wire [3:0] allow = {allow_right, allow_up, allow_down, allow_left};

  wire [3:0] mv = move & allow;
  wire right, up, down, left;
  assign {right, up, down, left} = mv;
  assign pos_x_next = pos_x - left + right;
  assign pos_y_next = pos_y - up + down;
endmodule
