module ShiftReg #(
    parameter WIDTH = 8
) (
    input              clk,
    input              shiftn_loadp,
    input              shift_in,
    input  [WIDTH-1:0] par_in,
    output [WIDTH-1:0] Q
);
  //行为描述
  reg [WIDTH-1:0] shift_reg;
  always @(posedge clk) begin
    if (shiftn_loadp) begin
      shift_reg <= par_in;
    end else begin
      shift_reg <= {shift_in, shift_reg[WIDTH-1:1]};
    end
  end
  assign Q = shift_reg;

  //结构描述
  // genvar i;
  // generate
  //     for(i = 0; i < WIDTH; i = i + 1) begin
  //         wire shift = (i == WIDTH - 1) ? shift_in : Q[i+1];
  //         FD fd_inst(
  //             .D(shiftn_loadp ? par_in[i] : shift),
  //             .clk(clk),
  //             .Q(Q[i])
  //         );
  //     end
  // endgenerate

endmodule
