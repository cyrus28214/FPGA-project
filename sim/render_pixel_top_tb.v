`timescale 1ns / 1ps

module render_pixel_top_tb ();
  reg clk = 0;
  always #5 clk = ~clk;

  reg RSTN;
  initial begin
    RSTN = 0;
    #10;
    RSTN = 1;
  end

  wire       BTN_X4;
  wire       vga_hs;
  wire       vga_vs;
  wire [3:0] vga_red;
  wire [3:0] vga_green;
  wire [3:0] vga_blue;

  render_pixel_top u_render_pixel_top (
      .clk      (clk),
      .RSTN     (RSTN),
      .BTN_Y    (4'h0),
      .BTN_X4   (BTN_X4),
      .vga_hs   (vga_hs),
      .vga_vs   (vga_vs),
      .vga_red  (vga_red),
      .vga_green(vga_green),
      .vga_blue (vga_blue)
  );

  initial begin
  end

endmodule
