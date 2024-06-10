module get_digit #(
    parameter LEN = 8 ) (
    input wire [LEN-1:0] number,
    input wire [1:0] index,
    output reg [3:0] digit
);

    always @(*) begin
        case (index)
            3: digit <= number % 10;
            2: digit <= (number / 10) % 10;
            1: digit <= (number / 100) % 10;
            0: digit <= (number / 1000) % 10;
        endcase
    end

endmodule