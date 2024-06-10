module vga_switch(
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
    output reg wr
);

    wire [19:0] cnt;
    clkdiv #(
        .DIV(20)
    ) u_clkdiv (
        .clk(clk),
        .rstn(rstn & cnt < 710368), // 4 * 12 * 18 * 21 + 2^13 * 13 * 13
        .div_res(cnt)
    );

    always @(posedge clk) begin
        if( cnt >= 18144 ) begin
            addr <= addr_a;
            dwrite <= dwrite_a;
            wr <= wr_a;
        end else begin
            addr <= addr_b;
            dwrite <= dwrite_b;
            wr <= wr_b;
        end
    end    

endmodule