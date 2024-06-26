`timescale 1ns / 1ps
module render_map_top_tb ();

  reg clk = 0;
  always #5 clk = ~clk;

  reg  [ 4:0] BTN_Y;
  reg  [15:0] switch;
  wire [ 4:0] BTN_X;
  wire        vga_hs;
  wire        vga_vs;
  wire [ 3:0] vga_red;
  wire [ 3:0] vga_green;
  wire [ 3:0] vga_blue;

  render_map_top u_render_map_top (
      .clk      (clk),
      .BTN_Y    (BTN_Y),
      .switch   (switch),
      .BTN_X    (BTN_X),
      .vga_hs   (vga_hs),
      .vga_vs   (vga_vs),
      .vga_red  (vga_red),
      .vga_green(vga_green),
      .vga_blue (vga_blue)
  );

  initial begin
    BTN_Y[1]  = 1;
    switch[0] = 0;
    #1000;
    BTN_Y[1]  = 0;
    switch[0] = 1;
    #1000;
    BTN_Y[1] = 1;
  end

endmodule  //TOP
