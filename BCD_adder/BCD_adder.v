module BCD_adder(
	input [3:0]x, y,
	input mode,
	output [6:0] segment1, segment2, segment3
);

wire ip_err;
assign ip_err = (x>9 || y>9)? 1'h1:1'h0;
assign err = ip_err? 1'h1: 1'h0;

wire add_sub;
assign add_sub = (mode==0)? 1'h0: 1'h1;

// adder
wire [4:0] s_tmp;
wire [3:0] ac, sum;

bcd_adder_module uu1(.x(x), .y(y), .cout(s_tmp[4]), .sum(s_tmp[3:0]));
assign ac = (err==1)? 4'hb: (s_tmp[4]==1'h1)? 4'h1: 4'hb;
assign sum = (err==1)? 4'ha: s_tmp[3:0];


// subtractor
wire [4:0] d_tmp;
wire bout_tmp;
wire [3:0] bout, diff, minus;

bcd_subtractor_module uu2(.x(x), .y(y), .bout(d_tmp[4]), .diff(d_tmp[3:0]));
assign bout = 4'hb;
assign diff = (err==1)? 4'ha: d_tmp[3:0];


// consider output add/sub result
wire [3:0] digit, ten, sign;
assign digit = (add_sub==1'h0)? sum: diff;
assign ten = (add_sub==1'h0)? ac: bout;
assign sign = ((add_sub==1'h1) && (d_tmp[4]==1) && (err==0))? 4'hc: 4'hb;

seg7 u1(.inx(digit), .seg(segment1));
seg7 u2(.inx(ten), .seg(segment2));
seg7 u3(.inx(sign), .seg(segment3));

endmodule 
