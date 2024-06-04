
module vga (
    input wire clk,  // 100MHz
    input wire rstn,
    output wire vga_hs,
    output wire vga_vs,
    output reg [11:0] vga_rgb,

    // memory interface
    input wire [18:0] w_addr,
    input wire [15:0] w_data,
    input wire we
);
  `include "./parameter.v"

  // vga clock
  wire vga_clk;

  clk_div_vga clk_div_vga_inst (
      .clk_in (clk),
      .clk_out(vga_clk)
  );

  // sync signals
  reg [9:0] hcnt, vcnt;

  assign vga_hs = (hcnt < HS_sync);
  assign vga_vs = (vcnt < VS_sync);

  always @(posedge vga_clk or negedge rstn) begin
    if (!rstn) begin
      hcnt <= 0;
    end else begin
      hcnt <= (hcnt == HS_total - 1) ? 0 : hcnt + 1;
    end
  end

  always @(posedge vga_clk or negedge rstn) begin
    if (!rstn) begin
      vcnt <= 0;
    end else if (hcnt == HS_total - 1) begin
      vcnt <= (vcnt == VS_total - 1) ? 0 : vcnt + 1;
    end
  end

  wire video_on = (HS_left <= hcnt && hcnt < HS_video && VS_top <= vcnt && vcnt < VS_video);
  wire video_early = (HS_left - 2 <= hcnt && hcnt < HS_video - 2 && VS_top <= vcnt && vcnt < VS_video);

  // memory
  reg [18:0] mem_addr;
  wire [15:0] mem_out;

  // ram
  bRAM ram_inst (
      .clka (vga_clk),
      .addra(mem_addr),
      .wea  (0),
      .dina (0),
      .douta(mem_out),

      .clkb (~clk),
      .addrb(w_addr),
      .web  (we),
      .dinb (w_data),
      .doutb()
  );

  //always block
  always @(posedge vga_clk or negedge rstn) begin
    if (!rstn) begin
      mem_addr <= 0;
      vga_rgb  <= 0;
    end else begin
      if (video_early) begin
        mem_addr <= HS_left - 2 == hcnt && VS_top == vcnt ? 0 : mem_addr + 1;
      end
      vga_rgb <= video_on ? mem_out[11:0] : 0;
    end
  end



endmodule
