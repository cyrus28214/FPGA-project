`timescale 1ns / 1ps

// 输入 100MHz 时钟和音符音高标号，输出蜂鸣器频率
// 标号 48 为 C4, 标号每增加 1 升高一个半音
module buzzer(
    input clk, // 100MHz
    input [7:0] note,
    output reg beep
    );

reg [31:0] num [11:0];
reg [31:0] tot, cnt;

initial begin
    tot = 0;  cnt = 0;
    num[0] = 32'd191109;
    num[1] = 32'd180383;
    num[2] = 32'd170259;
    num[3] = 32'd160703;
    num[4] = 32'd151683;
    num[5] = 32'd143170;
    num[6] = 32'd135134;
    num[7] = 32'd127550;
    num[8] = 32'd120391;
    num[9] = 32'd113634;
    num[10] = 32'd107256;
    num[11] = 32'd101236;
end

always @(note) begin
    tot = num[note % 12];
    if( note >= 48 ) tot = tot >> ((note-48)/12);
    else tot = tot << ((59-note)/12);
end

initial beep = 1'b0;
always @(posedge clk) begin
    cnt <= (cnt >= tot-1) ? 0 : cnt+1;
end

always @(posedge clk) begin
    if( note != 0 && cnt == tot-1 )
        beep = ~beep;
end
endmodule
