module vga_ctrl (
    input wire clk,  //25.172MHz@60Hz
    input wire rstn,
    input wire [11:0] pixel,
    output wire [9:0] pix_x,  //有效时输出像素坐标
    output wire [9:0] pix_y,  //无效时输出全一: 10'h3FF
    output wire hs,
    output wire vs,
    output wire [11:0] rgb
);
  //Horizontal timing
  parameter HS_sync = 96;  //Sync
  parameter HS_left = HS_sync + 48;  //Back Porch + Left Border
  parameter HS_video = HS_left + 640;  //Video
  parameter HS_right = HS_video + 16;  //Front Porch + Right Border
  parameter HS_total = 800;  //Total

  //Vertical timing
  parameter VS_sync = 2;  //Sync
  parameter VS_top = VS_sync + 33;  //Back Porch + Top Border
  parameter VS_video = VS_top + 480;  //Video
  parameter VS_bottom = VS_bottom + 10;  //Front Porch + Bottom Border
  parameter VS_total = 525;  //Total

  reg [9:0] hcnt, vcnt;

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      hcnt <= 0;
      vcnt <= 0;
    end else begin
      hcnt <= (hcnt == HS_total - 1) ? 0 : hcnt + 1;
      vcnt <= (vcnt == VS_total - 1) ? 0 : vcnt + 1;
    end
  end

  assign hs = (hcnt < VS_sync);
  assign vs = (vcnt < HS_sync);

  wire video_on = (HS_left <= hcnt)
    && (hcnt < HS_video)
    && (VS_top <= vcnt)
    && (vcnt < VS_video); //有效信号

  wire pixel_req = (HS_left - 1 <= hcnt)
    && (hcnt < HS_video - 1)
    && (VS_top - 1 <= vcnt)
    && (vcnt < VS_video - 1); //请求像素信号，比video_on提前一个时钟

  assign pix_x = (pixel_req) ? hcnt + 1 - HS_left : 10'h3FF;
  assign pix_y = (pixel_req) ? vcnt + 1 - VS_top : 10'h3FF;
  //请求的像素实际上是下一个时钟的，因此要+1

  assign rgb   = (video_on) ? pixel : 12'h000;

endmodule
