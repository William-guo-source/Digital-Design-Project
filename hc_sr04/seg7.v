module seg7(
	input [3:0]inx,
	output reg [6:0]seg
);

always@(*)begin
	case(inx)
		4'h0: seg = 7'b0000001;	// 0
		4'h1: seg = 7'b1001111;	// 1
		4'h2: seg = 7'b0010010;	// 2
		4'h3: seg = 7'b0000110;	// 3
		4'h4: seg = 7'b1001100;	// 4
		4'h5: seg = 7'b0100100;	// 5
		4'h6: seg = 7'b0100000;	// 6
		4'h7: seg = 7'b0001111;	// 7
		4'h8: seg = 7'b0000000;	// 8
		4'h9: seg = 7'b0000100;	// 9
		default: seg = 7'b0110000; // E
	endcase 
end 

endmodule 