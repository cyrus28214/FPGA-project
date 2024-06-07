//将异步边沿信号转化成同步的一周期的脉冲信号
//本项目中用于将按钮按下/弹起的瞬间转化成脉冲
//参见/docs/edge_to_pulse_wave.png

module edge_to_pulse (
    input  wire clk,
    input  wire rstn,
    input  wire in,
    output reg  out
);
  localparam LOW = 0;
  localparam HIGH = 1;
  reg state;

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state <= LOW;
    end else
      case (state)
        LOW:  if (in) state <= HIGH;
        HIGH: if (!in) state <= LOW;
      endcase
  end

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      out <= 0;
    end else if (state == LOW && in) out <= 1;
    else out <= 0;
  end
endmodule
