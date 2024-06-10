module player (
    input wire clk,  //div_res[1]
    input wire rstn,
    input wire [ 3:0] move,
    output reg [ 3:0] player_x,
    output reg [ 3:0] player_y,
    output reg [31:0] key_num,
    output reg [15:0] health,
    output reg [15:0] floor,
    output wire [18:0] bRAM_map_addr,
    input wire [15:0] bRAM_map_data,
    output wire bRAM_map_wr,
    output wire [15:0] bRAM_map_dwrite,

    input wire [3:0] BTN_Y
);

  wire        ask_move;
  wire [ 3:0] ask_x;
  wire [ 3:0] ask_y;

  wire        accept_move;
  wire [ 3:0] goto_x;
  wire [ 3:0] goto_y;

  wire [15:0] floor_out;
  wire [31:0] key_num_out;
  wire [15:0] health_out;

  player_move u_player_move (
      .clk        (clk),
      .rstn       (rstn),
      .move       (move),
      .pos_x      (player_x),
      .pos_y      (player_y),
      .ask_move   (ask_move),
      .ask_x      (ask_x),
      .ask_y      (ask_y),
      .accept_move(accept_move)
  );

  interact u_interact (
      .clk            (clk),
      .rstn           (rstn),
      .floor          (floor),
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
      .floor_out  (floor_out),
      .goto_x     (goto_x),
      .goto_y     (goto_y),
      .key_num_out(key_num_out),
      .health_out (health_out)
  );

  always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
      player_x <= 6;
      player_y <= 10;
      floor <= 0;
      key_num <= 0;
      health <= 20;
    end else if (accept_move) begin
      player_x <= goto_x;
      player_y <= goto_y;
      floor <= floor_out;
      key_num <= key_num_out;
      health <= health_out;
    end else if( !BTN_Y[1] ) health <= health + 1;
    else if( !BTN_Y[2] ) key_num <= key_num + 32'h01010101;
  end


endmodule
