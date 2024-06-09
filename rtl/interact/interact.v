module interact (
    input wire clk,
    input wire rstn,
    input wire [3:0] player_x,
    input wire [3:0] player_y,
    input wire [15:0] floor,
    input wire [3:0] key_num,
    input wire [15:0] health,

    input wire player_ask_move,
    input wire [3:0] player_ask_x,
    input wire [3:0] player_ask_y,

    output reg [18:0] bRAM_map_addr,
    input wire [15:0] bRAM_map_data,
    output reg bRAM_map_wr,
    output reg [15:0] bRAM_map_dwrite,

    output reg accept_move,
    output wire [15:0] floor_out,
    output wire [3:0] goto_x,
    output wire [3:0] goto_y,
    output wire [3:0] key_num_out,
    output wire [15:0] health_out
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
      bRAM_map_addr <= floor * MAP_WIDTH * MAP_HEIGHT + player_ask_y * MAP_WIDTH + player_ask_x;
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
  wire [15:0] new_tile_id;

  mux_tiles u_mux_tiles (
      .pos_x(player_ask_x),
      .pos_y(player_ask_y),

      .floor   (floor),
      .player_x(player_x),
      .player_y(player_y),
      .key_num (key_num),
      .health  (health),
      .tile_id (tile_id),

      .floor_out    (floor_out),
      .player_goto_x(goto_x),
      .player_goto_y(goto_y),
      .key_num_out  (key_num_out),
      .health_out   (health_out),
      .new_tile_id  (new_tile_id)
  );

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      accept_move <= 0;
      bRAM_map_wr <= 0;
      bRAM_map_dwrite <= 0;
    end else if (state == INTERACTING) begin
      accept_move <= 1;
      bRAM_map_wr <= 1;
      bRAM_map_dwrite <= new_tile_id;
    end else begin
      accept_move <= 0;
      bRAM_map_wr <= 0;
    end
  end


endmodule
