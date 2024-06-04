module pbdebounce (
    input  wire clk,
    input  wire button,
    output reg  pbreg
);

  reg [7:0] pbshift;

  always @(posedge clk) begin
    pbshift = pbshift << 1;
    pbshift[0] = button;
    if (pbshift == 8'b0) pbreg = 0;
    if (pbshift == 8'hFF) pbreg = 1;
  end

endmodule

module pbdebounce_n #(
    parameter N = 4
) (
    input wire clk,
    input wire [N-1:0] button,
    output wire [N-1:0] pbreg
);

  genvar i;
  generate
    for (i = 0; i < N; i = i + 1) begin
      pbdebounce u_pbdebounce (
          .clk(clk),
          .button(button[i]),
          .pbreg(pbreg[i])
      );
    end
  endgenerate
endmodule
