`timescale 1ns/1ps

module blk_mem_gen_0_tb;
  reg         clka = 0;
  reg  [3:0]  addra = 4'd0;
  wire [31:0] douta;
  
  always #10 clka = ~clka;

  always @(posedge clka) begin
    addra <= addra + 4'd1;
  end

  blk_mem_gen_0_tb dut(
    .clka(clka),
    .addra(addra),
    .douta(douta)
  )
endmodule