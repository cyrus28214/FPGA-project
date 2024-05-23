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

  clk_div_vga clk_div_vga_inst (
      .clk_in (clk),
      .clk_out(vga_clk)
  );

  vga_mem dut (
      .clk(vga_clk),
      .rstn(rstn),
      .mem_data(mem_data),
      .mem_addr(mem_addr),
      .mem_en(mem_en),
      .hs(hs),
      .vs(vs),
      .rgb(rgb)
  );

  bRAM ram (
      .clkb (vga_clk),
      .enb  (mem_en),
      .addrb(mem_addr),
      .doutb(mem_data)
  );

  assign vga_red   = vga_rgb[11:8];
  assign vga_green = vga_rgb[7:4];
  assign vga_blue  = vga_rgb[3:0];

endmodule
