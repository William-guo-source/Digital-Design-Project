module seg7_point(
	input [3:0]inx,
	output reg [7:0]seg
);

always@(*)begin
	case(inx)
		4'h0: seg = 8'b00000010;	// 0
		4'h1: seg = 8'b10011110;	// 1
		4'h2: seg = 8'b00100100;	// 2
		4'h3: seg = 8'b00001100;	// 3
		4'h4: seg = 8'b10011000;	// 4
		4'h5: seg = 8'b01001000;	// 5
		4'h6: seg = 8'b01000000;	// 6
		4'h7: seg = 8'b00011110;	// 7
		4'h8: seg = 8'b00000000;	// 8
		4'h9: seg = 8'b00001000;	// 9
		default: seg = 8'b01100000; // E
	endcase 
end 

endmodule 