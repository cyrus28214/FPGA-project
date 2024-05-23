module render_tile_tb;

  reg clk = 0, rstn = 0;
  reg [18:0] tile_addr = 0;
  reg [ 9:0] x = 13;
  reg [ 9:0] y = 3;

  wire src_rd, dst_wr;
  wire [18:0] src_addr, dst_addr;
  wire [15:0] src_data, dst_data;

  always #5 clk = ~clk;

  render_tile dut (
      .clk(clk),
      .rstn(rstn),
      .tile_addr(tile_addr),
      .x(x),
      .y(y),
      .src_rd(src_rd),
      .src_addr(src_addr),
      .src_data(src_data),
      .dst_wr(dst_wr),
      .dst_addr(dst_addr),
      .dst_data(dst_data)
  );

  bRAM bRAM_inst (
      .clka (clk),
      .addra(dst_addr),
      .dina (dst_data),
      .wea  (dst_wr)
  );

  bROM bROM_inst (
      .clka (clk),
      .addra(src_addr),
      .douta(src_data)
  );

  initial begin
    rstn = 0;
    #40;
    rstn = 1;
  end
endmodule

