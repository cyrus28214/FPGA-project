`timescale 1ns/1ps

module clk_wiz_0_tb;
    reg clk_in = 0;
    wire clk_out;

    clk_wiz_0 dut (
       .clk_in(clk_in),
       .clk_out(clk_out)
    );

    always #2.5 clk_in = ~clk_in;
endmodule