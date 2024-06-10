module render_digit( // need at least 2^2 * 12 * 18 cycles to render a number
    input wire clk, // 100MHz
    input rstn,
    input wire [11:0] digit_addr, 
    input wire [9:0] top,
    input wire [9:0] left,

    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);

    wire [9:0] cnt;
    clkdiv #(
        .DIV(10)
    ) u_clkdiv (
        .clk (clk),
        .rstn (rstn && cnt < 864), // 4 * 12 * 18
        .div_res(cnt)
    );

    wire [11:0] src_addr = digit_addr + cnt[9:2];
    wire [15:0] color;
    bROM_num bROM_num_inst (
        .clka (~clk),
        .addra(src_addr),
        .douta(color)
    );

    wire [9:0] pos_x = left + cnt[9:2] % 12;
    wire [9:0] pos_y = top + cnt[9:2] / 12;
    wire [18:0] addr;
    wire [15:0] data;
    wire wr;
    render_pixel render_pixel_inst (
        .pos_x(pos_x),
        .pos_y(pos_y),
        .color(color),
        .dst_addr(addr),
        .dst_data(data),
        .dst_wr(wr)
    );

    assign dst_addr = addr;
    assign dst_data = data;
    assign dst_wr = cnt[1:0] == 2'b11 && wr;

endmodule