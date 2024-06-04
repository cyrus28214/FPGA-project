module render_map_top (
    input wire clk,  // 100 MHz
    input wire [3:0] BTN_Y,  // button down is LOW
    input wire [15:0] switch,
    output wire [3:0] BTN_X,
    output wire vga_hs,
    output wire vga_vs,
    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue
  );

  // button
  assign BTN_X = 4'b1110;
  wire [3:0] btn_db;
  pbdebounce_n #(
                 .N(4)
               ) u_pbdebounce_n (
                 .clk   (clk),
                 .button(BTN_Y),
                 .pbreg (btn_db)
               );

  //reset
  wire rstn = switch[0];

  // clkdiv
  wire [31:0] div_res;
  clkdiv u_clkdiv (
           .clk(clk),
           .rstn(rstn),
           .div_res(div_res)
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
  wire [3:0] player_x_next;
  wire [3:0] player_y_next;
  wire any_move = |(~btn_db);

  player_move u_player_move (
                .move(~btn_db),
                .pos_x(player_x),
                .pos_y(player_y),
                .pos_x_next(player_x_next),
                .pos_y_next(player_y_next)
              );

  always @(posedge any_move)
    begin
      player_x <= player_x_next;
      player_y <= player_y_next;
    end

  //map
  wire [3:0] grid_x;
  wire [3:0] grid_y;

  wire [15:0] bRAM_map_douta;
  wire [18:0] bRAM_map_addra = grid_y * 11 + grid_x;

  wire [15:0] tile_id = (grid_x == player_x && grid_y == player_y) ? 16'h0001 : bRAM_map_douta;

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
             .clkb(~clk),
             .addrb(0),
             .web(0),
             .dinb(0),
             .doutb(0)
           );

endmodule
