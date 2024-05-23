module vga_mem (
    input wire clk,  //25.172MHz@60Hz
    input wire rstn,
    input wire [15:0] mem_data,
    output wire mem_rd,
    output wire [18:0] mem_addr,
    output wire hs,
    output wire vs,
    output wire [11:0] rgb
);

  `include "./parameter.v"


  reg [9:0] hcnt, vcnt;

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      hcnt <= 0;
    end else begin
      hcnt <= (hcnt == HS_total - 1) ? 0 : hcnt + 1;
    end
  end

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      vcnt <= 0;
    end else if (hcnt == HS_total - 1) begin
      vcnt <= (vcnt == VS_total - 1) ? 0 : vcnt + 1;
    end
  end

  assign hs = (hcnt < HS_sync);
  assign vs = (vcnt < VS_sync);

  wire video_on = (HS_left <= hcnt)
    && (hcnt < HS_video)
    && (VS_top <= vcnt)
    && (vcnt < VS_video); //有效信号

  wire pixel_req = (HS_left - 2 <= hcnt)
    && (hcnt < HS_video - 2)
    && (VS_top - 2 <= vcnt)
    && (vcnt < VS_video - 2); //

  reg [9:0] pix_x;
  reg [9:0] pix_y;

  always @(negedge clk) begin
    if (!rstn) begin
      pix_x <= 0;
      pix_y <= 0;
    end else begin
      pix_x <= pixel_req ? hcnt + 2 - HS_left : 0;
      pix_y <= pixel_req ? vcnt + 2 - VS_top : 0;
    end
  end

  assign mem_addr = (pix_y * SCREEN_WIDTH + pix_x);
  assign mem_rd = pixel_req;

  assign rgb = (video_on) ? mem_data[11:0] : 12'h000;

endmodule
