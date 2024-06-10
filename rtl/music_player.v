`timescale 1ns/1ps

module music_player(
    input clk, // 100 MHz
    output beep
);

reg [31:0] i, p, cnt;
parameter MAXN = 48;
reg [31:0] pos[MAXN-1:0];
reg [7:0] note[MAXN-1:0];
initial begin
    note[0] = 57;
    note[1] = 60;
    note[2] = 64;
    note[3] = 57;
    note[4] = 60;
    note[5] = 64;
    note[6] = 57;
    note[7] = 60;
    note[8] = 64;
    note[9] = 57;
    note[10] = 60;
    note[11] = 64;
    note[12] = 55;
    note[13] = 59;
    note[14] = 62;
    note[15] = 55;
    note[16] = 59;
    note[17] = 62;
    note[18] = 55;
    note[19] = 59;
    note[20] = 62;
    note[21] = 55;
    note[22] = 59;
    note[23] = 62;
    note[24] = 53;
    note[25] = 57;
    note[26] = 60;
    note[27] = 53;
    note[28] = 57;
    note[29] = 60;
    note[30] = 53;
    note[31] = 57;
    note[32] = 60;
    note[33] = 53;
    note[34] = 57;
    note[35] = 60;
    note[36] = 55;
    note[37] = 59;
    note[38] = 62;
    note[39] = 55;
    note[40] = 59;
    note[41] = 62;
    note[42] = 55;
    note[43] = 59;
    note[44] = 62;
    note[45] = 55;
    note[46] = 59;
    note[47] = 62;
end
initial begin
    pos[0] = 250;
    pos[1] = 500;
    pos[2] = 750;
    pos[3] = 1000;
    pos[4] = 1250;
    pos[5] = 1500;
    pos[6] = 1750;
    pos[7] = 2000;
    pos[8] = 2250;
    pos[9] = 2500;
    pos[10] = 2750;
    pos[11] = 3000;
    pos[12] = 3250;
    pos[13] = 3500;
    pos[14] = 3750;
    pos[15] = 4000;
    pos[16] = 4250;
    pos[17] = 4500;
    pos[18] = 4750;
    pos[19] = 5000;
    pos[20] = 5250;
    pos[21] = 5500;
    pos[22] = 5750;
    pos[23] = 6000;
    pos[24] = 6250;
    pos[25] = 6500;
    pos[26] = 6750;
    pos[27] = 7000;
    pos[28] = 7250;
    pos[29] = 7500;
    pos[30] = 7750;
    pos[31] = 8000;
    pos[32] = 8250;
    pos[33] = 8500;
    pos[34] = 8750;
    pos[35] = 9000;
    pos[36] = 9250;
    pos[37] = 9500;
    pos[38] = 9750;
    pos[39] = 10000;
    pos[40] = 10250;
    pos[41] = 10500;
    pos[42] = 10750;
    pos[43] = 11000;
    pos[44] = 11250;
    pos[45] = 11500;
    pos[46] = 11750;
    pos[47] = 12000;
end

wire clk_out;
clk_1ms getClk(
    .clk(clk),
    .clk_1ms(clk_out)
);

initial begin
    cnt = 0;
    p = 0;
end

always @(posedge clk_out) begin
    if( cnt >= pos[MAXN-1] ) begin
        cnt <= 0;
        p <= 0;
    end else begin
        cnt <= cnt + 1;
        p <= pos[p] <= cnt ? p + 1 : p;
    end
end

wire [7:0] note_in = note[p];
buzzer inst(
    .clk(clk),
    .note(note_in),
    .beep(beep)
);

endmodule