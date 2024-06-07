module player_move (
    input wire clk,  //div_res[1]
    input wire rstn,
    input wire [3:0] move,

    output reg ask_move,
    output reg [3:0] ask_x,
    output reg [3:0] ask_y,
    input wire accept_move,
    input wire [3:0] goto_x,
    input wire [3:0] goto_y,

    output reg [3:0] pos_x,
    output reg [3:0] pos_y
);

  localparam IDLE = 0;
  localparam ASK_MOVE = 1;
  reg state;


  wire [3:0] allow;
  wire [3:0] bound_move = move & allow;
  check_bound u_check_bound (
      .pos_x(pos_x),
      .pos_y(pos_y),
      .move (move),
      .allow(allow)
  );
  wire any_move = |bound_move;

  wire [3:0] new_pos_x;
  wire [3:0] new_pos_y;
  pos_move u_pos_move (
      .move(bound_move),
      .pos_x(pos_x),
      .pos_y(pos_y),
      .new_pos_x(new_pos_x),
      .new_pos_y(new_pos_y)
  );

  //state machine
  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state <= IDLE;
    end else begin
      case (state)

        IDLE: begin
          if (any_move) begin
            state <= ASK_MOVE;
          end
        end

        ASK_MOVE: begin
          if (accept_move) begin
            state <= IDLE;
          end
        end

      endcase
    end
  end

  //ask_move
  always @(posedge clk or negedge rstn) begin
    if (!rstn) ask_move <= 0;
    else if (state == IDLE && any_move) ask_move <= 1;
    else if (state == ASK_MOVE) ask_move <= 0;
  end

  //ask_x, ask_y
  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      ask_x <= 0;
      ask_y <= 0;
    end else if (state == IDLE && any_move) begin
      ask_x <= new_pos_x;
      ask_y <= new_pos_y;
    end
    // ASK_MOVE: keep ask_x and ask_y
  end

  //pos_x, pos_y
  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      pos_x <= 6;
      pos_y <= 11;
    end else if (state == ASK_MOVE && accept_move) begin
      pos_x <= goto_x;
      pos_y <= goto_y;
    end
  end

endmodule
