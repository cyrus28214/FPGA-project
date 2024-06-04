module player_move(
    input wire [3:0] move, //L D U R
    input wire [3:0] pos_x,
    input wire [3:0] pos_y,
    output wire [3:0] pos_x_next,
    output wire [3:0] pos_y_next
  );
`include "./parameter.v"

  wire allow_left = (pos_x != 0);
  wire allow_down = (pos_y != MAP_HEIGHT-1);
  wire allow_up = (pos_y != 0);
  wire allow_right = (pos_x != MAP_WIDTH-1);
  wire [3:0] allow = {allow_left, allow_down, allow_up, allow_right};

  wire mv = move & allow;
  wire left, down, up, right;
  assign {left, down, up, right} = mv;
  assign pos_x_next = pos_x - left + right;
  assign pos_y_next = pos_y - down + up;
endmodule
