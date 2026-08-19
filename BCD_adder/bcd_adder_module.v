module bcd_adder_module(
	input [3:0] x, y,
	output cout,
	output [3:0] sum
);

wire [4:0] s_tmp;

assign s_tmp = x + y;
assign sum = s_tmp[3:0] + ((s_tmp>5'h9) ? 4'h6: 4'h0);
assign cout = (s_tmp>9)? 1'h1: 1'h0;

endmodule 