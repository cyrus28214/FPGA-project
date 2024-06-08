module top (
    input wire clk,  // 100 MHz
    input wire [3:0] BTN_Y,  // button down is LOW
    input wire [15:0] switch,
    input wire PS2_clk,
    input wire PS2_data,
    output wire [4:0] BTN_X,
    output wire vga_hs,
    output wire vga_vs,
    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue,
    output wire beep,
    output wire seg_clk,
    output wire seg_clrn,
    output wire seg_sout,
    output wire seg_pen

);

  `include "./parameters/game_params.v"
  `include "./parameters/resources_params.v"

  //reset
  wire rstn = switch[0];

  // clkdiv
  wire [31:0] div_res;
  clkdiv u_clkdiv (
      .clk(clk),
      .rstn(rstn),
      .div_res(div_res)
  );
  wire logic_clk = div_res[1];

  // button
  assign BTN_X = 5'b01111;
  wire [3:0] btn_db;
  pbdebounce_n #(
      .N(4)
  ) u_pbdebounce_n (
      .clk   (div_res[17]),
      .button(BTN_Y),
      .pbreg (btn_db)
  );

  //PS2
  wire key_up, key_down, key_left, key_right, key_enter;
  wire [3:0] keys = {key_right, key_up, key_down, key_left};
  PS2 u_PS2 (
      .clk(clk),
      .rstn(rstn),
      .PS2_clk(PS2_clk),
      .PS2_data(PS2_data),
      .up(key_up),
      .down(key_down),
      .left(key_left),
      .right(key_right),
      .enter(key_enter)
  );

  //vga
  wire [11:0] vga_rgb;

  wire [18:0] w_addr;
  wire [15:0] w_data;
  wire        we;
  vga u_vga (
      .clk    (clk),
      .rstn   (rstn),
      .vga_hs (vga_hs),
      .vga_vs (vga_vs),
      .vga_rgb(vga_rgb),

      .w_addr(w_addr),
      .w_data(w_data),
      .we    (we)
  );
  assign vga_red   = vga_rgb[11:8];
  assign vga_green = vga_rgb[7:4];
  assign vga_blue  = vga_rgb[3:0];

  //player
  //详见/docs/player_move_and_interact.drawio.png
  wire [3:0] move;

  genvar i;
  generate
    for (i = 0; i < 4; i = i + 1) begin
      edge_to_pulse u_edge_to_pulse_i (
          .clk (logic_clk),
          .rstn(rstn),
          .in  (~keys[i]),
          .out (move[i])
      );
    end
  endgenerate

  // outports wire
  wire        player_x;
  wire        player_y;
  wire [18:0] bRAM_map_addrb;
  wire [15:0] bRAM_map_doutb;

  player u_player (
      .clk          (clk),
      .rstn         (rstn),
      .move         (move),
      .player_x     (player_x),
      .player_y     (player_y),
      .bRAM_map_addr(bRAM_map_addrb),
      .bRAM_map_data(bRAM_map_doutb)
  );


  //map
  wire [3:0] grid_x;
  wire [3:0] grid_y;

  wire [15:0] bRAM_map_douta;
  wire [18:0] bRAM_map_addra = grid_y * MAP_WIDTH + grid_x;
  wire [15:0] tile_id = (grid_x == player_x && grid_y == player_y) ? RS_hero_0 : bRAM_map_douta;

  render_map u_render_map (
      .clk(clk),
      .rstn(rstn),
      .tile_id(tile_id),
      .grid_x(grid_x),
      .grid_y(grid_y),
      .dst_addr(w_addr),
      .dst_data(w_data),
      .dst_wr(we)
  );

  bRAM_map u_bRAM_map (
      .clka (~clk),
      .addra(bRAM_map_addra),
      .douta(bRAM_map_douta),

      .clkb (~clk),
      .addrb(bRAM_map_addrb),
      .web  (0),
      .dinb (0),
      .doutb(bRAM_map_doutb)
  );

  //music
  wire _beep;
  music_player u_music_player (
      .clk (clk),
      .beep(_beep)
  );
  assign beep = switch[1] & _beep;

  //7seg
  Sseg_Dev u_Sseg_Dev (
      .clk(clk),
      .start(div_res[20]),
      .hexs(32'hDEADBEEF),
      .points(0),
      .LEs(0),
      .seg_clk(seg_clk),
      .seg_clrn(seg_clrn),
      .seg_sout(seg_sout),
      .seg_pen(seg_pen)
  );

endmodule
