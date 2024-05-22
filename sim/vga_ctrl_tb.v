module vga_ctrl_tb;
  reg clk = 0;
  reg rstn;
  wire [11:0] pixel = 12'hF00;
  wire [9:0] pix_x, pix_y;
  wire hs, vs;
  wire [11:0] rgb;

  wire vga_clk;
  vga_ctrl dut (
   .clk(vga_clk),
   .rstn(rstn),
   .pixel(pixel),
   .pix_x(pix_x),
   .pix_y(pix_y),
   .hs(hs),
   .vs(vs),
   .rgb(rgb)
  );

  always #5 clk = ~clk;

  clk_div_vga clk_div_vga_inst (
    .clk_in(clk),
    .clk_out(vga_clk)
  );

  initial begin
    rstn = 0;
    #10 rstn = 1;
    #1000 $finish;
  end

endmodule