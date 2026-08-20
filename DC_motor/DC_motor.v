module DC_motor(
	input clk_50M, key0, key1,
	output [6:0] seg0, seg1, seg2,
	output PWM
);
// 先產生10Hz去選long press or short press
reg [25:0] counter10;
reg clk_10Hz;
parameter DIVISOR10 = 2_499_999;

initial begin
	clk_10Hz = 0;
	counter10 = 26'h0;
end 

always@(posedge clk_50M) begin
	if(counter10 == DIVISOR10) begin
		counter10 <= 26'b0;
		clk_10Hz <= ~clk_10Hz;
	end 
	else begin
		counter10 <= counter10 + 1;
	end 
end 

// 10Hz 計算長短按
reg [9:0] press_cnt;
reg [7:0] level;
reg flag;
initial begin press_cnt = 0; flag = 0; end 
always@(posedge clk_10Hz) begin
	if(~key0) begin
		flag <= 1;
		press_cnt <= press_cnt + 1;
	end 
	else if(~key1) begin
		flag <= 0;
		press_cnt <= press_cnt + 1;
	end 
	else begin
		if(press_cnt >= 10) begin
			if(flag) 
				if(level <= 8'd245) level <= level + 10;
				else level <= 8'd255;
			else 
				if(level > 8'd10) level <= level - 10;
				else level <= 8'd0;
		end 
		else if(press_cnt > 0) begin
			if(flag) 
				if(level < 8'd255) level <= level + 1;
				else level <= 8'd255;
			else 
				if(level > 8'd0) level <= level - 1;
				else level <= 8'd0;
		end 
		press_cnt <= 0;
	end 
end 


// binary to bcd
reg [11:0] bcd;
integer i;
initial begin bcd = 0; end 
always@(level) begin
	bcd = 0;
	for(i=0;i<8;i=i+1) begin
		if(bcd[3-:4]>4) bcd[3:0] = bcd[3:0] + 3;
		if(bcd[7-:4]>4) bcd[7:4] = bcd[7:4] + 3;
		if(bcd[11-:4]>4) bcd[11:8] = bcd[11:8] + 3;
		bcd = {bcd[10:0], level[7-i]};
	end 
end 

reg [3:0] SB2, SB1, SB0;
initial begin SB2=0; SB1=0; SB0=0; end 
always@(*) begin
	if(level<8'ha) begin
		SB2 = 4'ha;
		SB1 = 4'ha;
		SB0 = bcd[3-:4];
	end 
	else if(level>=8'ha && level<8'h64) begin
		SB2 = 4'ha;
		SB1 = bcd[7-:4];
		SB0 = bcd[3-:4];
	end 
	else begin
		SB2 = bcd[11-:4];	// MSB
		SB1 = bcd[7-:4];
		SB0 = bcd[3-:4];	//LSB
	end 
end 

seg7 u1(SB2, seg2);
seg7 u2(SB1, seg1);
seg7 u3(SB0, seg0);

PWM_Generator u4(.clk_50M(clk_50M), .level(level), .PWM(PWM));

endmodule 