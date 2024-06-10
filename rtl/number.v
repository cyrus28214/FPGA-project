module number(
    input wire clk,
    input wire rstn,
    input wire [15:0] floor,
    input wire [15:0] health,
    input wire [31:0] key_num,
    output wire [18:0] dst_addr,
    output wire [15:0] dst_data,
    output wire dst_wr
);

    wire [3:0] grid_x, grid_y;
    reg [3:0] digit_id;
    wire [3:0] digit_floor, digit_health, digit_key_0,
               digit_key_1, digit_key_2, digit_key_3;

    get_digit #(.LEN(16))
    u_get_digit_floor (
        .number(floor),
        .index(3),
        .digit(digit_floor)
    );
    get_digit #(.LEN(16))
    u_get_digit_health (
        .number(health),
        .index(grid_x),
        .digit(digit_health)
    );
    get_digit #(.LEN(8))
    u_get_digit_key_0 (
        .number(key_num[7:0]),
        .index(grid_x),
        .digit(digit_key_0)
    );
    get_digit #(.LEN(8))
    u_get_digit_key_1 (
        .number(key_num[15:8]),
        .index(grid_x),
        .digit(digit_key_1)
    );
    get_digit #(.LEN(8))
    u_get_digit_key_2 (
        .number(key_num[23:16]),
        .index(grid_x),
        .digit(digit_key_2)
    );
    get_digit #(.LEN(8))
    u_get_digit_key_3 (
        .number(key_num[31:24]),
        .index(grid_x),
        .digit(digit_key_3)
    );

    always @(*) begin
        case(grid_y)
            0: digit_id <= digit_floor;
            1: digit_id <= digit_health;
            2: digit_id <= digit_key_0;
            3: digit_id <= digit_key_1;
            4: digit_id <= digit_key_2;
            5: digit_id <= digit_key_3;
        endcase
    end

    render_number u_render_number (
        .clk(clk),
        .rstn(rstn),
        .digit_id(digit_id),
        .grid_x(grid_x),
        .grid_y(grid_y),
        .dst_addr(dst_addr),
        .dst_data(dst_data),
        .dst_wr(dst_wr)
    );

endmodule