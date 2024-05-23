module top (
    input wire clk,  //100MHz
    input wire RSTN,
    output wire vga_hs,
    output wire vga_vs,
    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue
);
  wire vga_clk;
  wire [11:0] vga_rgb;
  wire [11:0] pixel = 12'hF00;
  wire pix_x;
  wire pix_y;

  clk_div_vga clk_div_vga_inst (
      .clk_in (clk),
      .clk_out(vga_clk)
  );

  vga_ctrl vga_ctrl_inst (
      .clk(vga_clk),
      .rstn(RSTN),
      .pixel(pixel),
      .pix_x(pix_x),
      .pix_y(pix_y),
      .hs(vga_hs),
      .vs(vga_vs),
      .rgb(vga_rgb)
  );

  assign vga_red   = vga_rgb[3:0];
  assign vga_green = vga_rgb[7:4];
  assign vga_blue  = vga_rgb[11:8];

endmodule
