module top(CLK_200M_P, vga_hs, vga_vs, vga_red, vga_green, vga_blue);
    input      CLK_200M_P;
    output vga_hs, vga_vs;
    output [3:0] vga_red, vga_green, vga_blue;

    wire vga_clk;

    clk_wiz_0 clk_wiz_0_inst(
       .clk_in(CLK_200M_P),
       .clk_out(vga_clk)
    );

    vga vga_inst(
        .clk(CLK_200M_P),
        .hs(vga_hs),
        .vs(vga_vs),
        .r(vga_red),
        .g(vga_green),
        .b(vga_blue)
    );

endmodule