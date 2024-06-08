module player (
    input wire clk,  //div_res[1]
    input wire rstn,
    input wire move,
    output wire player_x,
    output wire player_y,
    output wire [18:0] bRAM_map_addr,
    input wire [15:0] bRAM_map_data
);

  reg [3:0] key_num;

  player_move u_player_move (
      .clk        (clk),
      .rstn       (rstn),
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

  wire       accept_move;
  wire [3:0] goto_x;
  wire [3:0] goto_y;

  interact u_interact (
      .clk            (clk),
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

  always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
      key_num <= 0;
    end
  end

endmodule
