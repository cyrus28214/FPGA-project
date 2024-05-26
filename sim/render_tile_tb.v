module render_tile_tb;
  reg         clk = 0;
  reg         rstn = 0;
  reg  [18:0] tile_addr = 5;
  reg  [ 9:0] top = 2;
  reg  [ 9:0] left = 3;

  // outports wire
  wire [18:0] dst_addr;
  wire [15:0] dst_data;
  wire        dst_wr;

  render_tile dut (
      .clk      (clk),
      .rstn     (rstn),
      .tile_addr(tile_addr),
      .top      (top),
      .left     (left),
      .dst_addr (dst_addr),
      .dst_data (dst_data),
      .dst_wr   (dst_wr)
  );

  always #5 clk = ~clk;

  initial begin
    #20;
    rstn = 1;
  end

endmodule

