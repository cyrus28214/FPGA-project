// 各个按键输出为高电平即代表玩家按下按键。目前仅支持上下左右+回车
// 待下板

`timescale 1ns / 1ps

module PS2(
    input clk, rstn,
    input PS2_clk, PS2_data,
    output reg right, left, up, down, enter
    );

reg [3:0] num; // 位计数

reg [9:0] data; 
reg [7:0] tmp_data;
reg data_expand, data_break, data_done; // 输入 data 处理

reg [2:0] PS2_clk_flg; // 打拍

// 对频率较低的 PS2_clk 进行打拍，对准时钟避免异步问题
// 这里的周期偏移无需考虑
always @(posedge clk or negedge rstn) begin
    if( !rstn ) begin
        PS2_clk_flg <= 3'b0;
    end else begin
        PS2_clk_flg[0] <= PS2_clk;
        PS2_clk_flg[1] <= PS2_clk_flg[0];
        PS2_clk_flg[2] <= PS2_clk_flg[1];
    end
end
wire negedge_PS2_clk = !PS2_clk_flg[1] & PS2_clk_flg[2]; // 下降沿，只会存在 1clk

// 对每次传输进行数数，注意这里 num = 11 只会持续 1clk
always @(posedge clk or negedge rstn) begin
    if( !rstn )
        num <= 0;
    else if( num == 11 )
        num <= 0;
    else if( negedge_PS2_clk )
        num <= num + 1;
end

// 读入 PS2_data, 注意这里读入的上一 clk 的 num 有精确的一延迟
always @(posedge clk or negedge rstn) begin
    if( !rstn ) begin
        tmp_data <= 0;
    end else if( negedge_PS2_clk ) begin
        if( 2 <= num && num <= 9 ) tmp_data[num-2] <= PS2_data;
        else tmp_data <= tmp_data;
    end
end

// 整合输入按键数据
always @(posedge clk or negedge rstn) begin
    if( !rstn ) begin
        data <= 0;
        data_expand <= 0;
        data_break <= 0; 
    end else if( num == 11 ) begin
        if( tmp_data == 8'hE0 )
            data_expand <= 1; 
        else if( tmp_data == 8'hF0 )
            data_break <= 1;
        else begin
            data <= {data_expand, data_break, tmp_data};
            data_done <= 1;
            data_expand <= 0;
            data_break <= 0;
        end
    end else begin
        data <= data;
        data_done <= 0;
        data_expand <= data_expand;
        data_break <= data_break;
    end
end

always @(posedge clk or negedge rstn) begin
    if( !rstn ) begin
        right <= 0; 
        left <= 0;
        up <= 0;
        down <= 0;
        enter <= 0;
    end else begin
        case (data) 
            10'h274: right <= 1;
            10'h374: right <= 0;
            10'h26B: left <= 1;
            10'h36B: left <= 0;
            10'h275: up <= 1;
            10'h375: up <= 0;
            10'h272: down <= 1;
            10'h372: down <= 0;
            10'h05A: enter <= 1;
            10'h15A: enter <= 0;
        endcase
    end
end

endmodule