module player(
    input move,
    input [1:0] direction,
    // 0: left, 1: right, 2: up, 3: down
    output reg [3:0] x_pos,
    output reg [3:0] y_pos
);

    always @ (posedge move) begin

        case (direction)
            0: x_pos <= x_pos - 1;
            1: x_pos <= x_pos + 1;
            2: y_pos <= y_pos - 1;
            3: y_pos <= y_pos + 1;
        endcase

    end

endmodule