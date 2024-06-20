module vga_switch (
    input wire clk,
    input wire rstn,
    input wire [18:0] addr_a,
    input wire [15:0] dwrite_a,
    input wire wr_a,
    input wire [18:0] addr_b,
    input wire [15:0] dwrite_b,
    input wire wr_b,
    output reg [18:0] addr,
    output reg [15:0] dwrite,
    output reg wr,

    input wire [3:0] BTN_Y
);

  reg [19:0] cnt;
  reg sel;

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      cnt <= 0;
      sel <= 0;
    end else begin
      cnt <= cnt + 1;
      if (&cnt) begin
        sel <= ~sel;
      end
    end
  end

  always @* begin
    if (sel) begin
      addr = addr_b;
      dwrite = dwrite_b;
      wr = wr_b;
    end else begin
      addr = addr_a;
      dwrite = dwrite_a;
      wr = wr_a;
    end
  end


endmodule
