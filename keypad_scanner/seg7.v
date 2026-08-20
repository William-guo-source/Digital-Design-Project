module seg7(
	input [4:0]inx,
	output reg [6:0]seg
);

always@(*)begin
	case(inx)
		5'h0: seg <= 7'b0000001;	// 0
		5'h1: seg <= 7'b1001111;	// 1
		5'h2: seg <= 7'b0010010;	// 2
		5'h3: seg <= 7'b0000110;	// 3
		5'h4: seg <= 7'b1001100;	// 4
		5'h5: seg <= 7'b0100100;	// 5
		5'h6: seg <= 7'b0100000;	// 6
		5'h7: seg <= 7'b0001111;	// 7
		5'h8: seg <= 7'b0000000;	// 8
		5'h9: seg <= 7'b0000100;	// 9
		5'ha: seg <= 7'b0001000;   // A
		5'hb: seg <= 7'b1100000;	// b
		5'hc: seg <= 7'b0110001;	// C
		5'hd: seg <= 7'b1000010;	// d
		5'he: seg <= 7'b0110000;	// E
		5'hf: seg <= 7'b0111000;	// F
		default: seg <= 7'b1111111; // 
	endcase 
end 

endmodule 