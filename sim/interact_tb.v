`include "../rtl/player/player_move.v"
`timescale 1ns / 1ps

module intetact_tb ();

  reg sys_clk = 0;
  reg sys_rst = 1;

  always #5 sys_clk = ~sys_clk;

  initial begin
    sys_clk = 0;
    sys_rst = 1;
    #10 sys_rst = 0;
  end

  wire [31:0] div_res;

  clkdiv u_clkdiv (
      .clk(sys_clk),
      .rstn(~sys_rst),
      .div_res(div_res)
  );


  wire       ask_move;
  wire [3:0] ask_x;
  wire [3:0] ask_y;
  wire [3:0] player_x;
  wire [3:0] player_y;

  reg  [3:0] move;

  player_move u_player_move (
      .clk        (div_res[1]),
      .rstn       (~sys_rst),
      .move       (move),
      .ask_move   (ask_move),
      .ask_x      (ask_x),
      .ask_y      (ask_y),
      .accept_move(accept_move),
      .goto_x     (goto_x),
      .goto_y     (goto_y),
      .pos_x      (player_x),
      .pos_y      (player_y)
  );


  wire [18:0] bRAM_map_addr;
  wire [15:0] bRAM_map_data;
  wire        accept_move;
  wire [ 3:0] goto_x;
  wire [ 3:0] goto_y;

  interact u_interact (
      .clk            (div_res[1]),
      .rstn           (~sys_rst),
      .player_x       (player_x),
      .player_y       (player_y),
      .player_ask_move(ask_move),
      .player_ask_x   (ask_x),
      .player_ask_y   (ask_y),
      .bRAM_map_addr  (bRAM_map_addr),
      .bRAM_map_data  (bRAM_map_data),
      .accept_move    (accept_move),
      .goto_x         (goto_x),
      .goto_y         (goto_y)
  );

  bRAM_map u_bRAM_map (
      .clka (~sys_clk),
      .addra(bRAM_map_addr),
      .douta(bRAM_map_data)
  );

  initial begin
    #15;
    move <= 4'b0001;
    #40;
    move <= 0;
    #400;
    move <= 4'b0010;
    #40;
    move <= 0;
    #400;
    move <= 4'b0001;
    #40;
    move <= 0;
  end

endmodule  //TOP
