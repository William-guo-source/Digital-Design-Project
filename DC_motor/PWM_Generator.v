module PWM_Generator(
	input clk_50M,
	input [7:0] level,
	output reg PWM
);
reg [7:0] prescale_cnt;
reg pwm_clk;
reg [7:0] counter;

initial begin 
	prescale_cnt = 0;
	pwm_clk = 0;
	counter = 0;
end 

always@(posedge clk_50M) begin
	if(prescale_cnt==8'd98) begin
		prescale_cnt <= 8'h0;
		pwm_clk <= ~pwm_clk;
	end 
	else prescale_cnt <= prescale_cnt + 1;
end 

always@(posedge pwm_clk) begin
	counter <= counter + 1;
	PWM <= (counter < level);
end 

endmodule 