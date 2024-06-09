module kbd_process (
    input wire clk,  //div_res[1] (25MHz 40ns)
    input wire rstn,
    input wire kbd,
    output reg kbd_out
);
  localparam INTERVAL = 5000000;
  localparam IDLE = 0;
  localparam PRESS = 1;

  reg state;
  reg [31:0] cnt;
  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state <= IDLE;
      kbd_out <= 0;
      cnt <= 0;
    end else
      case (state)

        IDLE: begin
          if (kbd) begin
            state <= PRESS;
            kbd_out <= 1;
            cnt <= 0;
          end
        end

        PRESS: begin
          kbd_out <= 0;
          if (cnt >= INTERVAL || !kbd) begin
            state <= IDLE;
          end else begin
            cnt <= cnt + 1;
          end
        end
      endcase
  end
endmodule


module kbd_process4 (
    input wire clk,  //div_res[1] (25MHz 40ns)
    input wire rstn,
    input wire [3:0] kbd,
    output wire [3:0] kbd_out
);
  genvar i;
  generate
    for (i = 0; i < 4; i = i + 1) begin
      kbd_process u_kbd_process (
          .clk(clk),
          .rstn(rstn),
          .kbd(kbd[i]),
          .kbd_out(kbd_out[i])
      );
    end
  endgenerate
endmodule
