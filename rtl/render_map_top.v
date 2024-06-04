module render_map_top (
    input wire clk,  // 100 MHz
    input wire [3:0] BTN_Y,  // button push is LOW
    input wire [15:0] switch,
    output wire BTN_X4,
    output wire vga_hs,
    output wire vga_vs,
    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue
);

  // debounce
  wire [3:0] btn_db;
  pbdebounce_n #(
      .N(4)
  ) u_pbdebounce_n (
      .clk   (clk),
      .button(BTN_Y),
      .pbreg (btn_db)
  );

  //reset
  wire rstn = BTN_Y[3];

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

  render_map u_render_map (
      .clk(clk),
      .rstn(rstn),
      .map_addr(0),
      .dst_addr(w_addr),
      .dst_data(w_data),
      .dst_wr(we)
  );

  assign BTN_X4 = 1'b0;

endmodule
