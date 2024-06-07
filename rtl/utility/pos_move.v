module pos_move (
    input  wire [3:0] move,
    input  wire [3:0] pos_x,
    input  wire [3:0] pos_y,
    output wire [3:0] new_pos_x,
    output wire [3:0] new_pos_y
);
  wire right, up, down, left;
  assign {right, up, down, left} = move;

  assign new_pos_x = pos_x + right - left;
  assign new_pos_y = pos_y + down - up;

endmodule
