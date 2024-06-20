module floor_pos(
    input [15:0] floor,
    output reg [3:0] down_x,
    output reg [3:0] down_y,
    output reg [3:0] up_x,
    output reg [3:0] up_y
);

always @(*) begin
    case(floor)
        0: begin
            down_x = 0;
            down_y = 0;
            up_x = 1;
            up_y = 2;
        end
        1: begin
            down_x = 2;
            down_y = 1;
            up_x = 2;
            up_y = 11;
        end
        2: begin
            down_x = 1;
            down_y = 10;
            up_x = 11;
            up_y = 10;
        end
        3: begin
            down_x = 11;
            down_y = 10;
            up_x = 6;
            up_y = 6;
        end
        4: begin
            down_x = 6;
            down_y = 2;
            up_x = 0;
            up_y = 0;
        end
        default: begin
            down_x = 0;
            down_y = 0;
            up_x = 0;
            up_y = 0;
        end
    endcase
end
endmodule
