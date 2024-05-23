`timescale 1ns / 1ps

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

  clk_div_vga clk_div_vga_inst (
      .clk_in (clk),
      .clk_out(vga_clk)
  );

  wire [18:0] mem_addr;
  wire [15:0] mem_data;
  wire mem_rd;

  vga_mem vga_mem_inst (
      .clk(vga_clk),
      .rstn(RSTN),
      .mem_data(mem_data),
      .mem_addr(mem_addr),
      .mem_rd(mem_rd),
      .hs(vga_hs),
      .vs(vga_vs),
      .rgb(vga_rgb)
  );

  bRAM ram_inst (
      .clka (clk),
      .addra(0),
      .wea  (0),
      .dina (0),
      .douta(),

      .clkb (vga_clk),
      .addrb(mem_addr),
      .web  (0),
      .dinb (0),
      .doutb(mem_data)
  );

  assign vga_red   = vga_rgb[11:8];
  assign vga_green = vga_rgb[7:4];
  assign vga_blue  = vga_rgb[3:0];

endmodule

module top_tb;
  reg clk = 0;
  reg RSTN;
  wire vga_hs;
  wire vga_vs;
  wire [3:0] vga_red;
  wire [3:0] vga_green;
  wire [3:0] vga_blue;

  top top_inst (
      .clk(clk),
      .RSTN(RSTN),
      .vga_hs(vga_hs),
      .vga_vs(vga_vs),
      .vga_red(vga_red),
      .vga_green(vga_green),
      .vga_blue(vga_blue)
  );

  always #2.5 clk = ~clk;
  initial begin
    clk  = 0;
    RSTN = 0;
    #10;
    RSTN = 1;
  end
endmodule
