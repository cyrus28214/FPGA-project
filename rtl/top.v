module render_map_top (
    input wire clk,  // 100 MHz
    input wire [3:0] BTN_Y,  // button down is LOW
    input wire [15:0] switch,
    output wire [3:0] BTN_X,
    output wire vga_hs,
    output wire vga_vs,
    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue,
    output wire beep
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

  // button
  assign BTN_X = 4'b0111;
  wire [3:0] btn_db;
  pbdebounce_n #(
      .N(4)
  ) u_pbdebounce_n (
      .clk   (div_res[17]),
      .button(BTN_Y),
      .pbreg (btn_db)
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
  reg [3:0] player_x;
  reg [3:0] player_y;
  wire [3:0] player_goto_x;
  wire [3:0] player_goto_y;

  wire [3:0] move; //当按钮弹起，相应的move被设置，等待处理，处理完之后清零。
  reg clear_move;

  btn_reg u_btn_reg (
      .btn(btn_db),
      .rstn(rstn && !clear_move),
      .btn_reg(move)
  );

  player_move u_player_move (
      .move(move),
      .pos_x(player_x),
      .pos_y(player_y),
      .pos_x_next(player_goto_x),
      .pos_y_next(player_goto_y)
  );

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      player_x   <= 4'd6;
      player_y   <= 4'd11;
      clear_move <= 1'b0;
    end else if (clear_move) clear_move <= 1'b0;
    else if (|move) begin
      player_x   <= player_goto_x;
      player_y   <= player_goto_y;
      clear_move <= 1'b1;
    end
  end

  wire [18:0] bRAM_map_addrb = player_goto_y * MAP_WIDTH + player_goto_x;
  wire [15:0] bRAM_map_doutb;
  wire [15:0] goto_tile_id = bRAM_map_doutb;

  // wire [3:0]  	new_pos_x;
  // wire [3:0]  	new_pos_y;

  // player_react u_player_react(
  //                .org_pos_x(player_x),
  //                .org_pos_y(player_y),
  //                .goto_pos_x(player_goto_x),
  //                .goto_pos_y(player_goto_y),
  //                .goto_tile_id(goto_tile_id),
  //                .new_pos_x(new_pos_x),
  //                .new_pos_y(new_pos_y)
  //              );

  wire [3:0] new_pos_x = player_goto_x;
  wire [3:0] new_pos_y = player_goto_y;

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

endmodule
