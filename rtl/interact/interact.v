module interact (
    input wire clk,
    input wire rstn,
    input wire [3:0] player_x,
    input wire [3:0] player_y,
    input wire player_ask_move,
    input wire [3:0] player_ask_x,
    input wire [3:0] player_ask_y,

    output reg  [18:0] bRAM_map_addr,
    input  wire [15:0] bRAM_map_data,

    output reg accept_move,
    output reg [3:0] goto_x,
    output reg [3:0] goto_y
);

  `include "../parameters/resources_params.v"
  `include "../parameters/game_params.v"

  localparam IDLE = 0;
  localparam LOADING_RAM = 1;
  localparam INTERACTING = 2;
  reg [1:0] state;

  //state machine
  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state <= IDLE;
    end else
      case (state)

        IDLE: begin
          if (player_ask_move) begin
            state <= LOADING_RAM;
          end
        end

        LOADING_RAM: begin
          state <= INTERACTING;
        end

        INTERACTING: begin
          state <= IDLE;
        end

      endcase
  end

  //bRAM_map_addr
  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      bRAM_map_addr <= 0;
    end else if (state == IDLE && player_ask_move) begin
      bRAM_map_addr <= player_ask_y * MAP_WIDTH + player_ask_x;
    end
  end

  //ask_tile_id
  reg [15:0] tile_id;
  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      tile_id <= 0;
    end else if (state == LOADING_RAM) begin
      tile_id <= bRAM_map_data;
    end
  end

  //accept_move, goto_x, goto_y
  wire [3:0] player_goto_x;
  wire [3:0] player_goto_y;

  mux_tiles u_mux_tiles (
      .tile_id      (tile_id),
      .pos_x        (player_ask_x),
      .pos_y        (player_ask_y),
      .player_x     (player_x),
      .player_y     (player_y),
      .player_goto_x(player_goto_x),
      .player_goto_y(player_goto_y)
  );

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      accept_move <= 0;
      goto_x <= 0;
      goto_y <= 0;
    end else if (state == INTERACTING) begin
      accept_move <= 1;
      goto_x <= player_goto_x;
      goto_y <= player_goto_y;
    end else begin
      accept_move <= 0;
    end
  end


endmodule
