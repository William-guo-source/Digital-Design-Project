module bcd_subtractor_module(
	input [3:0]x, y,
	output bout,
	output [3:0]diff
);

wire [4:0]d_tmp;

assign d_tmp = x - y;
assign bout = d_tmp[4];
assign diff = (d_tmp[4]==1)? (4'ha - (d_tmp[3:0] - 4'h6)) : d_tmp[3:0];

endmodule 