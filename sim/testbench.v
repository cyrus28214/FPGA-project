`timescale 1ns / 1ps

module kbd_process_tb ();

  reg clk = 0;
  reg rstn = 0;

  always #5 clk = ~clk;

  always begin
    #5 rstn = 1;
  end

  wire kbd_out;
  reg  kbd;

  kbd_process u_kbd_process (
      .clk    (clk),
      .rstn   (rstn),
      .kbd    (kbd),
      .kbd_out(kbd_out)
  );

  initial begin
    kbd = 0;
    #100;
    kbd = 1;
  end

endmodule  //TOP
