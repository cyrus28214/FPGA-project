module PS2(
	input clk, // 100 MHz
	input rstn,
	input PS2_clk, PS2_data, 
	output reg up, left, right, enter, down // key down -> HIGH
	);

reg PS2_clk_falg0, PS2_clk_falg1, PS2_clk_falg2;
wire negedge_PS2_clk = !PS2_clk_falg1 & PS2_clk_falg2;
reg negedge_PS2_clk_shift;
reg [9:0] data;
reg data_break, data_done, data_expand;
reg[7:0]temp_data;
reg[3:0]num;

always@(posedge clk or negedge rstn)begin
	if(!rstn)begin
		PS2_clk_falg0<=1'b0;
		PS2_clk_falg1<=1'b0;
		PS2_clk_falg2<=1'b0;
	end
	else begin
		PS2_clk_falg0<=PS2_clk;
		PS2_clk_falg1<=PS2_clk_falg0;
		PS2_clk_falg2<=PS2_clk_falg1;
	end
end

always@(posedge clk or negedge rstn)begin
	if(!rstn)
		num<=4'd0;
	else if (num==4'd11)
		num<=4'd0;
	else if (negedge_PS2_clk)
		num<=num+1'b1;
end

always@(posedge clk)begin
	negedge_PS2_clk_shift<=negedge_PS2_clk;
end


always@(posedge clk or negedge rstn)begin
	if(!rstn)
		temp_data<=8'd0;
	else if (negedge_PS2_clk_shift)begin
		case(num)
			4'd2 : temp_data[0]<=PS2_data;
			4'd3 : temp_data[1]<=PS2_data;
			4'd4 : temp_data[2]<=PS2_data;
			4'd5 : temp_data[3]<=PS2_data;
			4'd6 : temp_data[4]<=PS2_data;
			4'd7 : temp_data[5]<=PS2_data;
			4'd8 : temp_data[6]<=PS2_data;
			4'd9 : temp_data[7]<=PS2_data;
			default: temp_data<=temp_data;
		endcase
	end
	else temp_data<=temp_data;
end

always@(posedge clk or negedge rstn)begin
	if(!rstn)begin
		data_break<=1'b0;
		data<=10'd0;
		data_done<=1'b0;
		data_expand<=1'b0;
	end
	else if(num==4'd11)begin
		if(temp_data==8'hE0)begin
			data_expand<=1'b1;
		end
		else if(temp_data==8'hF0)begin
			data_break<=1'b1;
		end
		else begin
			data<={data_expand,data_break,temp_data};
			data_done<=1'b1;
			data_expand<=1'b0;
			data_break<=1'b0;
		end
	end
	else begin
		data<=data;
		data_done<=1'b0;
		data_expand<=data_expand;
		data_break<=data_break;
	end
end

always @(posedge clk) begin
	case (data)
        10'h05A:enter <= 1;
        10'h15A:enter <= 0;
        10'h275:up <= 1;
        10'h375:up <= 0;
        10'h26B:left <= 1;
        10'h36B:left <= 0;
        10'h274:right <= 1;
        10'h374:right <= 0;
        10'h272:down <= 1;
        10'h372:down <= 0;
    endcase
end

endmodule