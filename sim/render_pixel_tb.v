module render_pixel_tb;
  reg clk = 0;
  always #5 clk = ~clk;

  reg rstn = 0;
  initial begin
    #10 rstn = 1;
  end

  reg  [ 9:0] x = 0;
  reg  [ 9:0] y = 0;
  reg  [15:0] color = 0;
  wire [15:0] src_data;

  // outports wire
  wire [18:0] src_addr;
  wire        src_rd;
  wire [18:0] dst_addr;
  wire [15:0] dst_data;
  wire        dst_wr;

  render_pixel u_render_pixel (
      .clk     (clk),
      .rstn    (rstn),
      .x       (x),
      .y       (y),
      .color   (color),
      .src_addr(src_addr),
      .src_data(src_data),
      .src_rd  (src_rd),
      .dst_addr(dst_addr),
      .dst_data(dst_data),
      .dst_wr  (dst_wr)
  );

  bROM u_bROM (
      .clka  (clk),
      .addra(src_addr),
      .douta(src_data)
  );

  always @(posedge clk) begin
    if (rstn) begin
      x[3:0] <= $random;
      y[3:0] <= $random;
      color[12:0] <= $random;
    end
  end

endmodule
