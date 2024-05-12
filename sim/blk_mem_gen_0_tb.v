`timescale 1ns/1ps

//当前上升沿传入的地址，要在下一个上升沿才能拿到数据，请注意
module blk_mem_gen_0_tb;
  reg         clka = 0;
  reg  [ 3:0] addra = 4'd0;
  wire [15:0] douta;
  
  always #10 clka = ~clka;

  reg [7:0] cnt = 0;

  always @(posedge clka) begin
    cnt <= cnt + 1;
    addra <= cnt[7:4];
  end

  blk_mem_gen_0 dut(
    .clka(clka),
    .addra(addra),
    .douta(douta)
  );
endmodule