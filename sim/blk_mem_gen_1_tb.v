`timescale 1ns/1ps

module blk_mem_gen_1_tb;
  reg         clk = 0;

  reg  [ 3:0] addra;
  reg  [15:0] dina;
  reg         wea = 1;

  reg  [ 3:0] addrb = 0;
  wire [15:0] doutb;

  always #2.5 clk = ~clk;
  
  blk_mem_gen_1 dut(
    .clka  	(clk),
    .addra 	(addra),
    .dina 	(dina),
    .wea   	(wea),
    .clkb  	(clk),
    .addrb 	(addrb),
    .doutb 	(doutb)
  );

  always @(posedge clk) begin
    addra <= $random;
    dina  <= $random;
    addrb <= addrb + 1;
  end

endmodule