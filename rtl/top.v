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
  wire [3:0] kbd = {key_right, key_up, key_down, key_left};
  wire [3:0] kbd_out;
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

  kbd_process4 u_kbd_process4 (
      .clk    (logic_clk),
      .rstn   (rstn),
      .kbd    (kbd),
      .kbd_out(kbd_out)
  );


  //vga
  wire [11:0] vga_rgb;

  wire [18:0] vga_mem_addr;
  wire [15:0] vga_mem_dwrite;
  wire        vga_mem_wr;
  vga u_vga (
      .clk    (clk),
      .rstn   (rstn),
      .vga_hs (vga_hs),
      .vga_vs (vga_vs),
      .vga_rgb(vga_rgb),

      .w_addr(vga_mem_addr),
      .w_data(vga_mem_dwrite),
      .we    (vga_mem_wr)
  );
  assign vga_red   = vga_rgb[11:8];
  assign vga_green = vga_rgb[7:4];
  assign vga_blue  = vga_rgb[3:0];

  //player
  //详见/docs/player_move_and_interact.drawio.png
  wire [3:0] move = kbd_out;

  wire [15:0] floor;
  wire [3:0] player_x;
  wire [3:0] player_y;
  wire [31:0] key_num;
  wire [15:0] health;
  wire [18:0] bRAM_map_addrb;
  wire [15:0] bRAM_map_doutb;
  wire bRAM_map_wrb;
  wire [15:0] bRAM_map_dwriteb;

  player u_player (
      .clk            (logic_clk),
      .rstn           (rstn),
      .move           (move),
      .floor          (floor),
      .player_x       (player_x),
      .player_y       (player_y),
      .key_num        (key_num),
      .health         (health),
      .bRAM_map_addr  (bRAM_map_addrb),
      .bRAM_map_data  (bRAM_map_doutb),
      .bRAM_map_dwrite(bRAM_map_dwriteb),
      .bRAM_map_wr    (bRAM_map_wrb)
  );


  // map 和 number 分频

  wire [18:0] vga_mem_addr_a;
  wire [15:0] vga_mem_dwrite_a;
  wire        vga_mem_wr_a;  
  wire [18:0] vga_mem_addr_b;
  wire [15:0] vga_mem_dwrite_b;
  wire        vga_mem_wr_b;
  vga_switch u_vga_switch (
    .clk(clk),
    .rstn(rstn),
    .addr_a(vga_mem_addr_a),
    .dwrite_a(vga_mem_dwrite_a),
    .wr_a(vga_mem_wr_a),
    .addr_b(vga_mem_addr_b),
    .dwrite_b(vga_mem_dwrite_b),
    .wr_b(vga_mem_wr_b),
    .addr(vga_mem_addr),
    .dwrite(vga_mem_dwrite),
    .wr(vga_mem_wr)
  );

  //map
  wire [18:0] map_id = floor;
  wire [15:0]                 bRAM_map_douta;
  wire [18:0]                 bRAM_map_addra;

  map u_map (
      .clk          (clk),
      .clk_swap     (div_res[24]),
      .rstn         (rstn),
      .map_id       (map_id),
      .player_x     (player_x),
      .player_y     (player_y),
      .bRAM_map_addr(bRAM_map_addra),
      .bRAM_map_data(bRAM_map_douta),
      .dst_addr     (vga_mem_addr_a),
      .dst_data     (vga_mem_dwrite_a),
      .dst_wr       (vga_mem_wr_a)
  );

  bRAM_map u_bRAM_map (
      .clka (~clk),
      .addra(bRAM_map_addra),
      .douta(bRAM_map_douta),
      .wea  (0),
      .dina (0),

      .clkb (~clk),
      .addrb(bRAM_map_addrb),
      .doutb(bRAM_map_doutb),
      .web  (bRAM_map_wrb),
      .dinb (bRAM_map_dwriteb)
  );

  number u_number (
    .clk(clk),
    .rstn(rstn),
    .floor(floor),
    .health(health),
    .key_num(key_num),
    .dst_addr(vga_mem_addr_b),
    .dst_data(vga_mem_dwrite_b),
    .dst_wr(vga_mem_wr_b)
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
      .hexs({
        floor[3:0], health[7:0], key_num[27:24], key_num[19:16], key_num[11:8], key_num[3:0], kbd
      }),
      .points(0),
      .LEs(0),
      .seg_clk(seg_clk),
      .seg_clrn(seg_clrn),
      .seg_sout(seg_sout),
      .seg_pen(seg_pen)
  );

endmodule
