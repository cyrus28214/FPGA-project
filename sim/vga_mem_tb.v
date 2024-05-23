module vga_mem_tb;
  reg clk = 0;
  reg rstn;
  wire [15:0] mem_data;
  wire [18:0] mem_addr;
  wire mem_en;
  wire hs, vs;
  wire [11:0] rgb;

  always #20 clk = ~clk;

  vga_mem dut (
      .clk(clk),
      .rstn(rstn),
      .mem_data(mem_data),
      .mem_addr(mem_addr),
      .mem_en(mem_en),
      .hs(hs),
      .vs(vs),
      .rgb(rgb)
  );

  reg [18:0] addra;
  reg [15:0] dina;
  reg wea;

  bRAM ram (
      .clka (clk),
      .wea  (wea),
      .addra(addra),
      .dina (dina),
      .clkb (clk),
      .enb  (mem_en),
      .addrb(mem_addr),
      .doutb(mem_data)
  );

  initial begin
    rstn = 0;
    #100;
    rstn = 1;
  end

endmodule
