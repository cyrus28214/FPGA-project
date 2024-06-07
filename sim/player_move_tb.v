`timescale 1ns / 1ps

module player_move_tb ();

  reg sys_clk = 0;
  reg sys_rst = 1;

  //100MHz clock
  always #5 sys_clk = ~sys_clk;

  always begin
    #5 sys_rst = 0;
  end

  wire       ask_move;
  wire [3:0] ask_x;
  wire [3:0] ask_y;
  wire [3:0] pos_x;
  wire [3:0] pos_y;
  reg  [3:0] move;
  reg        accept_move;
  reg  [3:0] goto_x;
  reg  [3:0] goto_y;

  player_move u_player_move (
      .clk        (sys_clk),
      .rstn       (~sys_rst),
      .move       (move),
      .ask_move   (ask_move),
      .ask_x      (ask_x),
      .ask_y      (ask_y),
      .accept_move(accept_move),
      .goto_x     (goto_x),
      .goto_y     (goto_y),
      .pos_x      (pos_x),
      .pos_y      (pos_y)
  );

  initial begin
    move <= 0;
    accept_move <= 0;
    goto_x <= 0;
    goto_y <= 0;
    #15;
    move <= 4'b0010;
    #10;
    move <= 0;
    goto_x <= ask_x + 1;
    goto_y <= ask_y + 1;
    accept_move <= 1;
    #100;
    move   <= 4'b0001;
    goto_x <= 10;
    goto_y <= 4;
    #10;
    move <= 0;

  end

endmodule  //TOP
