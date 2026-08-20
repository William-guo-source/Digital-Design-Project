module debouncer(
	input clk_10ms, sw_in,
	output sw_out
);
wire d;
reg [1:0] q_sample;
reg q_jk;

initial begin
	q_sample = 2'b00;
end 

always@(posedge clk_10ms) begin
	q_sample[1] <= q_sample[0];
	q_sample[0] <= sw_in;
end 

assign d = (((q_sample[0] & q_sample[1]) & ~q_jk) |
			  (~(~q_sample[0] & ~q_sample[1]) & q_jk));
			  
always@(posedge clk_10ms) begin
	q_jk <= d;
end 

assign sw_out = q_jk;

endmodule 