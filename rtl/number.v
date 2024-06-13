module number (
    input wire clk,
    input wire rstn,
    input wire [15:0] floor,
    input wire [15:0] health,
    input wire [31:0] key_num,
    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);
  //一个digit给2^11个时钟
  reg [10:0] cnt;
  reg [ 4:0] state;
  reg [ 9:0] top;
  reg [ 9:0] left;
  reg [ 3:0] digit;

  render_digit u_render_digit (
      .clk     (clk),
      .rstn    (rstn),
      .digit   (digit),
      .top     (top),
      .left    (left),
      .dst_addr(dst_addr),
      .dst_data(dst_data),
      .dst_wr  (dst_wr)
  );

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      cnt   <= 0;
      state <= 0;
    end else begin
      cnt <= cnt + 1;
      if (&cnt) begin
        if (state < 20) state <= state + 1;
        else state <= 0;
      end
    end
  end

  reg [15:0] tmp;
  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      top  <= 0;
      left <= 0;
    end else begin
      if (&cnt) begin
        if (state == 20) begin
          top   <= 86;
          left  <= 58;
          digit <= floor[3:0];
        end else begin
          if (state % 4 == 0) begin
            if (state == 0) top <= 134;
            else top <= top + 32;
            left <= 98;
            if (state == 0) begin
              tmp   <= health / 10;
              digit <= health % 10;
            end else if (state == 4) begin
              tmp   <= key_num[7:0] / 10;
              digit <= key_num[7:0] % 10;
            end else if (state == 8) begin
              tmp   <= key_num[15:8] / 10;
              digit <= key_num[15:8] % 10;
            end else if (state == 12) begin
              tmp   <= key_num[23:16] / 10;
              digit <= key_num[23:16] % 10;
            end else if (state == 16) begin
              tmp   <= key_num[31:24] / 10;
              digit <= key_num[31:24] % 10;
            end
          end else begin
            left  <= left - 16;
            tmp   <= tmp / 10;
            digit <= tmp % 10;
          end
        end
      end
    end
  end

  /*
    position:
    20
     3  2  1  0
     7  6  5  4
    11 10  9  8
    15 14 13 12
    19 18 17 16
    */

endmodule
