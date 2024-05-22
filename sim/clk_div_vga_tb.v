`timescale 1ns / 1ps

// 进行模拟的时候请运行足够多的时间才能看到效果，可以点击上方的Run for 10 us按钮
module clk_wiz_vga_tb;
  reg  clk_in = 0;
  wire clk_out;

  clk_wiz_0 dut (
      .clk_in (clk_in),
      .clk_out(clk_out)
  );

  always #2.5 clk_in = ~clk_in;
endmodule
