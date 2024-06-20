module render_image #(
    parameter W = 32,
    parameter H = 32
) (
    input wire clk,
    input wire rstn,
    input wire [9:0] top,
    input wire [9:0] left,

    output reg  [18:0] src_addr,
    input  wire [15:0] src_data,

    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output dst_wr
);

  localparam W_BITS = $clog2(W);
  localparam H_BITS = $clog2(H);

  reg [W_BITS-1:0] pos_x;
  reg [H_BITS-1:0] pos_y;
  wire [18:0] pix_addr;
  wire [15:0] pix_data;
  wire pix_wr;
  render_pixel render_pixel_inst (
      .pos_x(left + pos_x),
      .pos_y(top + pos_y),
      .color(src_data),
      .dst_addr(pix_addr),
      .dst_data(pix_data),
      .dst_wr(pix_wr)
  );

  reg [W_BITS-1:0] pos_x_next;
  reg [H_BITS-1:0] pos_y_next;
  always @* begin
    if (pos_x < W - 1) begin
      pos_x_next = pos_x + 1;
      pos_y_next = pos_y;
    end else begin
      pos_x_next = 0;
      if (pos_y < H - 1) begin
        pos_y_next = pos_y + 1;
      end else begin
        pos_y_next = 0;
      end
    end
  end

  reg [1:0] cnt;
  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      cnt <= 0;
      pos_x <= 0;
      pos_y <= 0;
      src_addr <= 0;
    end else begin
      cnt <= cnt + 1;
      if (cnt == 3) begin
        pos_x <= pos_x_next;
        pos_y <= pos_y_next;
        if (src_addr == W * H - 1) src_addr <= 0;
        else src_addr <= src_addr + 1;
      end
    end
  end

  //   always @(posedge clk or negedge rstn) begin
  //     if (!rstn) begin
  //       dst_addr <= 0;
  //       dst_data <= 0;
  //       dst_wr   <= 0;
  //     end else begin
  //       if (cnt == 3) begin
  //         dst_addr <= pix_addr;
  //         dst_data <= pix_data;
  //         dst_wr   <= pix_wr;
  //       end else dst_wr <= 0;
  //     end
  //   end

  assign dst_addr = pix_addr;
  assign dst_data = pix_data;
  assign dst_wr   = pix_wr && cnt == 3;

endmodule
