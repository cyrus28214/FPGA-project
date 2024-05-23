`timescale 1ns / 1ps

module bRAM_tb;
   reg         clk = 0;

   reg  [ 3:0] addra;
   reg  [15:0] dina;
   reg         wea = 1;

   reg  [ 3:0] addrb = 0;
   wire [15:0] doutb;

   always #5 clk = ~clk;

   bRAM dut (
      .clka (clk),
      .addra({{15{1'b0}}, addra}),
      .dina (dina),
      .wea  (wea),
      .clkb (clk),
      .addrb({{15{1'b0}}, addrb}),
      .doutb(doutb)
   );

   always @(negedge clk) begin
      addra <= $random;
      dina  <= $random;
      addrb <= addrb + 1;
   end

endmodule
