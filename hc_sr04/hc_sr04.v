module hc_sr04(
	input clk,
	input echo,
	output reg trig,
	output reg [15:0] distance
);

reg [1:0] state;
reg [31:0] counter;
reg [31:0] echo_count;
parameter TRIG_TIME = 500;
parameter measure_time = 500_000;

always@(posedge clk) begin
	case(state)
		// idle mode: wait next time
		2'd0: begin	
			trig <= 0;
			counter <= counter + 1;
			if(counter >= 500_000) begin
				counter <= 0;
				state <= 2'd1;
			end 
		end 
		
		// generate 10us high level
		2'd1: begin
			trig <= 1;
			counter <= counter + 1;
			if(counter >= TRIG_TIME) begin
				trig <= 0;
				counter <= 0;
				state <= 2'd2;
			end 
		end
		
		// wait echo rise
		2'd2: begin
			if(echo==1) begin
				echo_count <= 0;
				state <= 2'd3;
			end 
			else begin
				counter <= counter + 1;
				if(counter > measure_time) begin
					counter <= 0;
					state <= 2'd0;
				end 
			end 
		end 
		
		// calculate distance 
		2'd3: begin
			if(echo==1) begin
				echo_count <= echo_count + 1;
			end 
			else begin
				distance <= echo_count / 291;
				state <= 0;
			end 
		end 
	endcase 
end 

endmodule 