module keypad_scanner(
	input clk_50M,
	input [3:0] R,
	inout [3:0] C,
	output [6:0] seg1, seg2, seg3, seg4, seg5, seg6,
	output [9:0]led
);

reg [3:0] C_tmp;
wire K, Kd;
reg [2:0] state, nextstate;
reg [3:0] N;
reg V;

// divide frequence
reg [18:0] counter100;
reg [15:0] counter1K;
reg clk_100Hz, clk_1KHz;
parameter DIVISOR100 = 250_000;
parameter DIVISOR1K = 25_000; 
initial begin
	clk_100Hz = 0;
	counter100 = 16'b0;
	clk_1KHz = 0;
	counter1K = 19'b0;
end 

// divide frequence 100Hz
always@(posedge clk_50M) begin
	if(counter100 == DIVISOR100) begin
		counter100 = 19'b0;
		clk_100Hz <= ~clk_100Hz;
	end 
	else begin
		counter100 <= counter100 + 1;
	end 
end 
//divide frequence 1KHz
always@(posedge clk_50M) begin
	if(counter1K == DIVISOR1K) begin
		counter1K = 16'b0;
		clk_1KHz <= ~clk_1KHz;
	end 
	else begin
		counter1K <= counter1K + 1;
	end 
end 


// debounce
assign C = C_tmp;
assign K = |R;
debouncer db0(.clk_10ms(clk_100Hz), .sw_in(K), .sw_out(Kd));

// Row and Column decoder
always@(R, C) begin
	case({R,C})
		8'h11: N = 4'b0000;
		8'h12: N = 4'b0001;
		8'h14: N = 4'b0010;
		8'h18: N = 4'b0011;
		8'h21: N = 4'b0100;
		8'h22: N = 4'b0101;
		8'h24: N = 4'b0110;
		8'h28: N = 4'b0111;
		8'h41: N = 4'b1000;
		8'h42: N = 4'b1001;
		8'h44: N = 4'b1010;
		8'h48: N = 4'b1011;
		8'h81: N = 4'b1100;
		8'h82: N = 4'b1101;
		8'h84: N = 4'b1110;
		8'h88: N = 4'b1111;
		default: N = 4'bZZZZ;
	endcase 
end 

// Controller
initial begin
	state = 0;
	nextstate = 0;
	V = 1'b0;
end 

always@(state or K or Kd) begin
	V = 1'b0;
	
	case(state)
		3'h0:
			begin
				nextstate = 3'h1;
			end 
		
		3'h1:
			begin
				C_tmp = 4'b1111;
				if((K & Kd) == 1'b1) begin
					nextstate = 3'h2;
				end 
				else begin
					nextstate = 3'h1;
				end 
			end 
			
		3'h2:
			begin
				C_tmp = 4'h0001;
				if((K & Kd) == 1'b1) begin
					V = 1'b1;
					nextstate = 3'h6;
				end 
				else if(K == 1'b0) begin
					nextstate = 3'h3;
				end 
				else begin
					nextstate = 3'h2;
				end 
			end 
		
		3'h3:
			begin
				C_tmp = 4'b0010;
				if((K & Kd) == 1'b1) begin
					V = 1'b1;
					nextstate = 3'h6;
				end 
				else if(K == 1'b0) begin
					nextstate = 3'h4;
				end 
				else begin
					nextstate = 3'h3;
				end 
			end 
			
		3'h4:
			begin
				C_tmp = 4'b0100;
				if((K & Kd) == 1'b1) begin
					V = 1'b1;
					nextstate = 3'h6;
				end 
				else if(K == 1'b0) begin
					nextstate = 3'h5;
				end 
				else begin
					nextstate = 3'h4;
				end 
			end 
			
		3'h5:
			begin
				C_tmp = 4'b1000;
				if((K & Kd) == 1'b1) begin
					V = 1'b1;
					nextstate = 3'h6;
				end 
				else begin
					nextstate = 3'h1;
				end 
			end 
		
		3'h6:
			begin
				C_tmp = 4'b1111;
				if(Kd == 1'b0) begin
					nextstate = 3'h1;
				end 
				else begin
					nextstate = 3'h6;
				end 
			end 
	endcase 
end 

always@(posedge clk_1KHz) begin
	state <= nextstate;
end 

reg [29:0] total;
reg [29:0] save;
reg [2:0]cmp;
reg flag;
reg [2:0] cmp_state;
reg [9:0] true_led;
reg [15:0] delay_counter;
initial begin 
	total = 30'b10000_10000_10000_10000_10000_10000;
	save = 30'b00001_00011_00101_00111_01001_01011;
	cmp = 3'b0;
	flag = 1'b0;
	cmp_state = 3'b0;
	true_led = 10'b00000_00001;
	delay_counter = 16'h0;
end 

always@(posedge clk_1KHz) begin
	case(cmp_state)
		// input / compare
		3'h0:
			begin
				true_led <= 10'b00000_00001;
				
				// left shift
				if(V) begin
					total[4:0] <= {1'b0, N};
					total[9:5] <= total[4:0];
					total[14:10] <= total[9:5];
					total[19:15] <= total[14:10];
					total[24:20] <= total[19:15];
					total[29:25] <= total[24:20];
					cmp <= cmp + 1'b1;
					if(cmp +1'b1 >= 3'd6) begin
						flag <= 1'b1;
					end 
				end
				
				// compare
				if(flag && cmp == 3'h6) begin
					if(total[3:0] == 4'hb && 
						total[8:5] == 4'h9 && 
						total[13:10] == 4'h7 && 
						total[18:15] == 4'h5 && 
						total[23:20] == 4'h3 && 
						total[28:25] == 4'h1 ) begin
							cmp_state <= 3'h1;
							delay_counter <= 16'b0;
						end 
					else begin
						cmp_state <= 3'h2;
						delay_counter <= 16'h0;
					end 
				end 
			end 
			
		// correct state
		3'h1:
			begin
				total <= total;
				true_led <= 10'b00000_00010;
				
				if(delay_counter < 16'd5000) begin
					delay_counter <= delay_counter + 1'b1;
					if(delay_counter >= 16'd500 && delay_counter <=16'd1000 ||
						delay_counter >= 16'd1500 && delay_counter <=16'd2000 ||
						delay_counter >= 16'd2500 && delay_counter <=16'd3000 ||
						delay_counter >= 16'd3500 && delay_counter <=16'd4000 ||
						delay_counter >= 16'd4500 && delay_counter <=16'd5000) begin
						total <= 30'b10000_10000_10000_10000_10000_10000;
					end 
					else total <= save;
				end 
				else begin
					cmp_state <= 3'h0;
					total <= 30'b10000_10000_10000_10000_10000_10000;
					cmp <= 3'b0;
					flag <= 1'b0;
					true_led <= 10'b00000_00001;
					delay_counter <= 16'b0;
				end 
			end 
			
		// failure state
		3'h2:
			begin
				total <= 30'b10000_10000_10000_10000_10000_01110;
				true_led <= 10'b00000_00001;
				
				if(delay_counter < 16'd2000) begin	// 1KHz = 1ms, 1ms*2000 = 2sec
					delay_counter <= delay_counter + 1'b1;
					total <= 30'b10000_10000_10000_10000_10000_01110;
				end 
				else begin
					cmp_state <= 3'h0;
					total <= 30'b10000_10000_10000_10000_10000_10000;
					cmp <= 3'b0;
					flag <= 1'b0;
					true_led <= 10'b00000_00001;
					delay_counter <= 16'b0;
				end 
			end 
			
		default: cmp_state <= 3'h0;
	endcase 
	
end 

assign led = true_led;

seg7 u1(.inx(total[4:0]), .seg(seg1));
seg7 u2(.inx(total[9:5]), .seg(seg2));
seg7 u3(.inx(total[14:10]), .seg(seg3));
seg7 u4(.inx(total[19:15]), .seg(seg4));
seg7 u5(.inx(total[24:20]), .seg(seg5));
seg7 u6(.inx(total[29:25]), .seg(seg6));

endmodule 