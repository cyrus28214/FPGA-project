module clkdiv #(
    parameter DIV = 32
) (
    input                clk,
    input                rstn,
    output reg [DIV-1:0] div_res = 0
);

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      div_res <= 0;
    end else begin
      div_res <= div_res + 1;
    end
  end

endmodule
