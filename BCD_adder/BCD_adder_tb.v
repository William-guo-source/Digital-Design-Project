`timescale 1ns/10ps
module BCD_adder_tb;

reg [3:0] x, y;
reg mode;
wire [6:0] segment1, segment2, segment3;

BCD_adder u1(.x(x), .y(y), .mode(mode), .segment1(segment1), .segment2(segment2), .segment3(segment3));

integer i, j, k;
initial begin 
	for(k=0;k<2;k=k+1)begin
		for(i=0;i<10;i=i+1)begin
			for(j=0;j<10;j=j+1)begin
				mode=k; x=i; y=j;
				#10;
			end 
		end 
	end 
end 

initial #2000 $stop;

endmodule 