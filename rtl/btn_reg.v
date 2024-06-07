//input button signal (low when button is pressed), output registered move signal (set when button up)

module btn_reg (
    input wire [3:0] btn,
    input wire rstn,
    output reg [3:0] btn_reg
);

  genvar i;
  generate
    for (i = 0; i < 4; i = i + 1) begin
      always @(posedge btn[i] or negedge rstn) begin
        if (!rstn) begin
          btn_reg[i] <= 0;
        end else begin
          btn_reg[i] <= 1;
        end
      end
    end
  endgenerate

endmodule
