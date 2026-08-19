module seg7(
	input [3:0]inx,
	output [6:0]seg
);

assign seg = (inx==4'h0) ? 7'b0000001 :
				 (inx==4'h1) ? 7'b1001111 :
				 (inx==4'h2) ? 7'b0010010 :
				 (inx==4'h3) ? 7'b0000110 :
				 (inx==4'h4) ? 7'b1001100 :
				 (inx==4'h5) ? 7'b0100100 :
				 (inx==4'h6) ? 7'b0100000 :
				 (inx==4'h7) ? 7'b0001111 :
				 (inx==4'h8) ? 7'b0000000 :
				 (inx==4'h9) ? 7'b0000100 :
				 (inx==4'ha) ? 7'b0110000 :
				 (inx==4'hb) ? 7'b1111111 :
				 (inx==4'hc) ? 7'b1111110 : 7'b1111111;
				 

endmodule 