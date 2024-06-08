module player (
    input wire clk,  //div_res[1]
    input wire rstn,
    input wire [3:0] move,
    output wire [3:0] player_x,
    output wire [3:0] player_y,
    output reg [3:0] key_num,
    output reg [7:0] health,
    output wire [18:0] bRAM_map_addr,
    input wire [15:0] bRAM_map_data,
    output wire bRAM_map_wr,
    output wire [15:0] bRAM_map_dwrite
);

  wire [3:0] key_num_out;
  wire [3:0] health_out;
  wire       accept_move;
  wire [3:0] ask_x;
  wire [3:0] ask_y;
  wire [3:0] goto_x;
  wire [3:0] goto_y;

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

  interact u_interact (
      .clk            (clk),
      .rstn           (rstn),
      .player_x       (player_x),
      .player_y       (player_y),
      .key_num        (key_num),
      .health         (health),
      .player_ask_move(ask_move),
      .player_ask_x   (ask_x),
      .player_ask_y   (ask_y),

      .bRAM_map_addr  (bRAM_map_addr),
      .bRAM_map_data  (bRAM_map_data),
      .bRAM_map_dwrite(bRAM_map_dwrite),
      .bRAM_map_wr    (bRAM_map_wr),

      .accept_move(accept_move),
      .goto_x     (goto_x),
      .goto_y     (goto_y),
      .key_num_out(key_num_out),
      .health_out (health_out)
  );

  always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
      key_num <= 0;
      health  <= 10;
    end else if (accept_move) begin
      key_num <= key_num_out;
      health  <= health_out;
    end
  end

endmodule
