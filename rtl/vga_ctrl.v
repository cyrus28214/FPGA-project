module vga_ctrl (
   input wire clk,  //25.175MHz@60Hz
   input wire rstn,
   input wire [11:0] pixel,
   output wire [9:0] pix_x,
   output wire [9:0] pix_y,
   output wire hs,
   output wire vs,
   output wire [11:0] rgb
);

   `include "./vga_parameter.v"

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

   wire video_on = (HS_left <= hcnt) && (hcnt < HS_video) && (VS_top <= vcnt) && (vcnt < VS_video);  //video signal valid

   wire pixel_req = (HS_left <= hcnt) && (hcnt < HS_video) && (VS_top <= vcnt) && (vcnt < VS_video);  //require pixel signal

   assign pix_x = (pixel_req) ? hcnt - HS_left : 10'h3FF;
   assign pix_y = (pixel_req) ? vcnt - VS_top : 10'h3FF;
   //required pixel position

   assign rgb   = (video_on) ? pixel : 12'h000;

endmodule
