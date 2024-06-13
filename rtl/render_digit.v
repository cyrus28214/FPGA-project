module render_digit (  // need at least 2^2 * 12 * 18 cycles to render a number
    input wire clk,  // 100MHz
    input rstn,
    input wire [3:0] digit,
    input wire [9:0] top,
    input wire [9:0] left,

    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);

  wire [18:0] src_addr;
  wire [15:0] src_data;
  bROM_num bROM_tile_num (
      .clka (~clk),
      .addra((digit * 12 * 18) + src_addr),
      .douta(src_data)
  );

  render_image #(
      .W(12),
      .H(18)
  ) u_render_image (
      .clk     (clk),
      .rstn    (rstn),
      .top     (top),
      .left    (left),
      .src_addr(src_addr),
      .src_data(src_data),
      .dst_addr(dst_addr),
      .dst_data(dst_data),
      .dst_wr  (dst_wr)
  );

endmodule
