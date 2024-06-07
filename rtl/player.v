module player (
    input wire clk,  // slow clock: div_res[1]
    input wire rstn,
    input wire [3:0] btn,  // R U D L, low active
    input wire [15:0] goto_tile_id,
    output reg [3:0] pos_x,
    output reg [3:0] pos_y,
    output wire [3:0] goto_pos_x,
    output wire [3:0] goto_pos_y,
    output wire [15:0] appearance
);
  `include "./parameters/resources_params.v"

  localparam [1:0] STATE_IDLE = 2'b00;
  localparam [1:0] STATE_WAIT = 2'b01; //wait for loading RAM
  localparam [1:0] STATE_MOVE = 2'b10;

  reg [1:0] state;
  reg [1:0] next_state;
  reg [3:0] move;

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state <= STATE_IDLE;
      pos_x
    end else if (|(~btn)) begin
      state <= STATE_WAIT;
      move <= ~btn;
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    case (state)
      STATE_IDLE: begin
        next_state = STATE_IDLE;






  player_move u_player_move (
      .move      (move),
      .pos_x     (pos_x),
      .pos_y     (pos_y),
      .pos_x_next(goto_pos_x),
      .pos_y_next(goto_pos_y)
  );

  wire [3:0] new_pos_x;
  wire [3:0] new_pos_y;

  player_react u_player_react (
      .org_pos_x(pos_x),
      .org_pos_y(pos_y),
      .goto_pos_x(goto_pos_x),
      .goto_pos_y(goto_pos_y),
      .goto_tile_id(goto_tile_id),
      .new_pos_x(new_pos_x),
      .new_pos_y(new_pos_y)
  );

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      pos_x <= 4'd6;
      pos_y <= 4'd11;
      clear_move <= 1'b0;
    end else if (clear_move) clear_move <= 1'b0;
    else if (|btn_reg) begin
      pos_x <= new_pos_x;
      pos_y <= new_pos_y;
      clear_move <= 1'b1;
    end
  end

  assign appearance = RS_hero_0;

endmodule
