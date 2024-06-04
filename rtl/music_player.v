`timescale 1ns/1ps

module music_player(
    input clk, // 100 MHz
    output beep
);

reg [31:0] i, p, cnt;
parameter MAXN = 66;
reg [31:0] pos[MAXN-1:0];
reg [7:0] note[MAXN-1:0];
initial begin
    note[0] = 64;
    note[1] = 62;
    note[2] = 60;
    note[3] = 62;
    note[4] = 64;
    note[5] = 65;
    note[6] = 64;
    note[7] = 62;
    note[8] = 0;
    note[9] = 48;
    note[10] = 48;
    note[11] = 52;
    note[12] = 52;
    note[13] = 50;
    note[14] = 53;
    note[15] = 52;
    note[16] = 50;
    note[17] = 50;
    note[18] = 50;
    note[19] = 48;
    note[20] = 48;
    note[21] = 53;
    note[22] = 52;
    note[23] = 50;
    note[24] = 50;
    note[25] = 48;
    note[26] = 50;
    note[27] = 52;
    note[28] = 0;
    note[29] = 52;
    note[30] = 55;
    note[31] = 60;
    note[32] = 59;
    note[33] = 60;
    note[34] = 59;
    note[35] = 60;
    note[36] = 59;
    note[37] = 57;
    note[38] = 55;
    note[39] = 55;
    note[40] = 50;
    note[41] = 53;
    note[42] = 53;
    note[43] = 52;
    note[44] = 52;
    note[45] = 43;
    note[46] = 53;
    note[47] = 52;
    note[48] = 50;
    note[49] = 52;
    note[50] = 55;
    note[51] = 48;
    note[52] = 0;
    note[53] = 48;
    note[54] = 50;
    note[55] = 48;
    note[56] = 47;
    note[57] = 48;
    note[58] = 55;
    note[59] = 48;
    note[60] = 53;
    note[61] = 52;
    note[62] = 50;
    note[63] = 48;
    note[64] = 48;
    note[65] = 48;
end
initial begin
    pos[0] = 500;
    pos[1] = 750;
    pos[2] = 1250;
    pos[3] = 1500;
    pos[4] = 1875;
    pos[5] = 2000;
    pos[6] = 2250;
    pos[7] = 3000;
    pos[8] = 3750;
    pos[9] = 3875;
    pos[10] = 4000;
    pos[11] = 4250;
    pos[12] = 4500;
    pos[13] = 4750;
    pos[14] = 5000;
    pos[15] = 5250;
    pos[16] = 5500;
    pos[17] = 5750;
    pos[18] = 6000;
    pos[19] = 6125;
    pos[20] = 6250;
    pos[21] = 6500;
    pos[22] = 6750;
    pos[23] = 7000;
    pos[24] = 7500;
    pos[25] = 7625;
    pos[26] = 7750;
    pos[27] = 8500;
    pos[28] = 9250;
    pos[29] = 9500;
    pos[30] = 9750;
    pos[31] = 10000;
    pos[32] = 10500;
    pos[33] = 10750;
    pos[34] = 11250;
    pos[35] = 11500;
    pos[36] = 11625;
    pos[37] = 11750;
    pos[38] = 12250;
    pos[39] = 12500;
    pos[40] = 12750;
    pos[41] = 13000;
    pos[42] = 13500;
    pos[43] = 13750;
    pos[44] = 14250;
    pos[45] = 14500;
    pos[46] = 14750;
    pos[47] = 15000;
    pos[48] = 15250;
    pos[49] = 15750;
    pos[50] = 16000;
    pos[51] = 16750;
    pos[52] = 17250;
    pos[53] = 17500;
    pos[54] = 17750;
    pos[55] = 18125;
    pos[56] = 18250;
    pos[57] = 18500;
    pos[58] = 18750;
    pos[59] = 19000;
    pos[60] = 19500;
    pos[61] = 19750;
    pos[62] = 20000;
    pos[63] = 20250;
    pos[64] = 20500;
    pos[65] = 21250;
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