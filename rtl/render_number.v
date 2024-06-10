module render_number ( // need at least 2^2 * 12 * 18 * 21 cycs
    input wire clk,
    input wire rstn,

    input wire [11:0] digit_id,
    output reg [3:0] grid_x,
    output reg [3:0] grid_y,

    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);
    `include "./parameters/number_params.v"


    wire [8:0] cnt;
    wire number_clk = cnt >= 216;
    clkdiv #(
        .DIV(9)
    ) u_clkdiv (
        .clk    (clk),
        .rstn   (rstn & cnt < 432),
        .div_res(cnt)
    );

    wire [18:0] number_addr = digit_id * 216;
    wire [ 9:0] top = grid_y == 0 ? 86 : (102 + grid_y * 32);
    wire [ 9:0] left = grid_y == 0 ? 58 : (34 + grid_x * 16);
    render_digit u_render_digit (
        .clk(clk),
        .rstn(rstn),
        .digit_addr(digit_addr),
        .top(top),
        .left(left),
        .dst_addr(dst_addr),
        .dst_data(dst_data),
        .dst_wr(dst_wr)
    );

    reg [3:0] grid_x_next, grid_y_next;
    always @(*) begin
        if ( grid_y == 0 ) begin
            grid_y_next <= 1;
            grid_x_next <= 0;
        end else if( grid_x == NUMBER_WIDTH - 1 ) begin// 4 - 1
            if( grid_y == NUMBER_HEIGHT - 1 ) 
                grid_y_next <= 0;
            else 
                grid_y_next <= grid_y + 1;
            grid_x_next <= 0;
        end else begin
            grid_x_next <= grid_x + 1;
            grid_y_next <= grid_y;
        end
    end

    always @(posedge number_clk or negedge rstn) begin
        if( !rstn ) begin
            grid_x <= 0;
            grid_y <= 0;
        end else begin
            grid_x <= grid_x_next;
            grid_y <= grid_y_next;
        end
    end

endmodule