`timescale 1ns / 1ps

module edge_to_pulse_tb ();

  reg sys_clk = 0;
  reg sys_rstn = 1;

  always #5 sys_clk = ~sys_clk;

  wire out;
  reg  in;

  edge_to_pulse u_edge_to_pulse (
      .clk (sys_clk),
      .rstn(sys_rstn),
      .in  (in),
      .out (out)
  );



  initial begin
    sys_clk = 0;
    sys_rstn = 0;
    in = 0;
    #13;
    sys_rstn = 1;
    #38;
    in = 1;
    #21;
    in = 0;
    #56;
    in = 1;

  end

endmodule  //TOP
