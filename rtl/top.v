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
  reg [11:0] pixel;
  wire [9:0] pix_x;
  wire [9:0] pix_y;
  
  always @ (*) begin
    if (pix_x < 60) pixel <= 12'hF00;
    else if (pix_x < 120) pixel <= 12'hFF0;
    else if (pix_x < 180) pixel <= 12'h0F0;
    else if (pix_x < 240) pixel <= 12'h0FF;
    else if (pix_x < 300) pixel <= 12'h00F;
    else if (pix_x < 360) pixel <= 12'hF0F;
    else if (pix_x > 580) pixel <= 12'hFFF;
    else pixel <= 12'h000;
   end
    
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

  assign vga_red   = vga_rgb[11:8];
  assign vga_green = vga_rgb[7:4];
  assign vga_blue  = vga_rgb[3:0];

endmodule
