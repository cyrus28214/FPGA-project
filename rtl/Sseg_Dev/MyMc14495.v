module MyMC14495(
  input D0, D1, D2, D3,
  input LE,
  input point,
  output reg p,
  output reg a, b, c, d, e, f, g
);
  wire [3:0] D   = {D3, D2, D1, D0};
  always @(*) begin
    if (LE) {a, b, c, d, e, f, g} = 7'b1111111;
    else
        case (D)
        0:    {a, b, c, d, e, f, g} = 7'b0000001;
        1:    {a, b, c, d, e, f, g} = 7'b1001111;
        2:    {a, b, c, d, e, f, g} = 7'b0010010;
        3:    {a, b, c, d, e, f, g} = 7'b0000110;
        4:    {a, b, c, d, e, f, g} = 7'b1001100;
        5:    {a, b, c, d, e, f, g} = 7'b0100100;
        6:    {a, b, c, d, e, f, g} = 7'b0100000;
        7:    {a, b, c, d, e, f, g} = 7'b0001111;
        8:    {a, b, c, d, e, f, g} = 7'b0000000;
        9:    {a, b, c, d, e, f, g} = 7'b0000100;
        4'ha: {a, b, c, d, e, f, g} = 7'b0001000;
        4'hb: {a, b, c, d, e, f, g} = 7'b1100000;
        4'hc: {a, b, c, d, e, f, g} = 7'b0110001;
        4'hd: {a, b, c, d, e, f, g} = 7'b1000010;
        4'he: {a, b, c, d, e, f, g} = 7'b0110000;
        4'hf: {a, b, c, d, e, f, g} = 7'b0111000;
        endcase
    p = ~point;
  end
endmodule