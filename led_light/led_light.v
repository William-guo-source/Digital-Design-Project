module led_light (
		input clk_50M,			       	// 50MHz input clock
		input speed, rst,
		input dir,
		output reg [9:0] led,
		output reg [6:0] seg7
);
reg [28:0]dly;
always@(posedge clk_50M) dly<=dly+1'b1;
assign clk = dly[25];

reg clk_500m, clk_400m, clk_300m, clk_200m, clk_100m, clk_80m, clk_60m, clk_40m;
reg [2:0] select;
reg clk_hz;
	 
reg [25:0] counter_500m;		
reg [25:0] counter_400m;
reg [25:0] counter_300m;
reg [25:0] counter_200m;
reg [25:0] counter_100m;
reg [25:0] counter_80m;
reg [25:0] counter_60m;
reg [25:0] counter_40m;				

parameter DIVISOR_500m = 12_500_000;
parameter DIVISOR_400m = 10_000_000;
parameter DIVISOR_300m = 7_500_000;
parameter DIVISOR_200m = 5_000_000;
parameter DIVISOR_100m = 2_500_000;
parameter DIVISOR_80m = 2_000_000;
parameter DIVISOR_60m = 1_500_000;
parameter DIVISOR_40m = 1_000_000;

initial begin
	select = 3'h0;
	clk_hz = 1'b0;
	
	counter_500m = 26'b0;
	counter_400m = 26'b0;
	counter_300m = 26'b0;
	counter_200m = 26'b0;
	counter_100m = 26'b0;
	counter_80m = 26'b0;
	counter_60m = 26'b0;
	counter_40m = 26'b0;
	
	clk_500m = 1'b0;
	clk_400m = 1'b0;
	clk_300m = 1'b0;
	clk_200m = 1'b0;
	clk_100m = 1'b0; 
	clk_80m = 1'b0;
	clk_60m = 1'b0;
	clk_40m = 1'b0;
	
end

// Clock divider 2Hz process
always @(posedge clk_50M) begin
	if (counter_500m == DIVISOR_500m) begin
    	counter_500m <= 16'b0;      			// Reset counter
		clk_500m <= ~clk_500m;    		// Toggle output clock
	end else begin
    	counter_500m <= counter_500m + 1; 		// Increment counter
	end
end

// Clock divider 2.5Hz process
always @(posedge clk_50M) begin
	if (counter_400m == DIVISOR_400m) begin
    	counter_400m <= 16'b0;      			// Reset counter
		clk_400m <= ~clk_400m;    		// Toggle output clock
	end else begin
    	counter_400m <= counter_400m + 1; 		// Increment counter
	end
end

// Clock divider 3.3Hz process
always @(posedge clk_50M) begin
	if (counter_300m == DIVISOR_300m) begin
    	counter_300m <= 16'b0;      			// Reset counter
		clk_300m <= ~clk_300m;    		// Toggle output clock
	end else begin
    	counter_300m <= counter_300m + 1; 		// Increment counter
	end
end

// Clock divider 5Hz process
always @(posedge clk_50M) begin
	if (counter_200m == DIVISOR_200m) begin
    	counter_200m <= 16'b0;      			// Reset counter
		clk_200m <= ~clk_200m;    		// Toggle output clock
	end else begin
    	counter_200m <= counter_200m + 1; 		// Increment counter
	end
end

// Clock divider 10Hz process
always @(posedge clk_50M) begin
	if (counter_100m == DIVISOR_100m) begin
    	counter_100m <= 16'b0;      			// Reset counter
		clk_100m <= ~clk_100m;    		// Toggle output clock
	end else begin
    	counter_100m <= counter_100m + 1; 		// Increment counter
	end
end

// Clock divider 12.5Hz process
always @(posedge clk_50M) begin
	if (counter_80m == DIVISOR_80m) begin
    	counter_80m <= 16'b0;      			// Reset counter
		clk_80m <= ~clk_80m;    		// Toggle output clock
	end else begin
    	counter_80m <= counter_80m + 1; 		// Increment counter
	end
end

// Clock divider 16Hz process
always @(posedge clk_50M) begin
	if (counter_60m == DIVISOR_60m) begin
    	counter_60m <= 16'b0;      			// Reset counter
		clk_60m <= ~clk_60m;    		// Toggle output clock
	end else begin
    	counter_60m <= counter_60m + 1; 		// Increment counter
	end
end

// Clock divider 25Hz process
always @(posedge clk_50M) begin
	if (counter_40m == DIVISOR_40m) begin
    	counter_40m <= 16'b0;      			// Reset counter
		clk_40m <= ~clk_40m;    		// Toggle output clock
	end else begin
    	counter_40m <= counter_40m + 1; 		// Increment counter
	end
end

always@(negedge rst, negedge speed) begin
	if(~rst) begin
		select <= 3'h0;
	end 
	else if(~speed) begin
		select <= select + 3'h1;
		if(select > 3'h7) select <= 3'h0;
	end 
	else begin
		select <= select;
	end 
end 

always@(select) begin
	case(select)
		3'h0: clk_hz = clk_500m;
		3'h1: clk_hz = clk_400m;
		3'h2: clk_hz = clk_300m;
		3'h3: clk_hz = clk_200m;
		3'h4: clk_hz = clk_100m;
		3'h5: clk_hz = clk_80m;
		3'h6: clk_hz = clk_60m;
		3'h7: clk_hz = clk_40m;
		default: clk_hz = clk_500m;
	endcase 
end 


integer i;
initial begin led={{5{1'b0}}, {5{1'b1}}}; end
always@(posedge clk_hz, negedge rst) begin
	 if(~rst) led<={{5{1'b0}}, {5{1'b1}}};
    else begin
      for(i=0;i<=9;i=i+1)begin
        if(dir)begin
          if(led[0])begin
            led<=led>>1;
            led[9]<=1'b1;
          end else led<=led>>1;
        end else begin
          if(led[9])begin
            led<=led<<1;
            led[0]<=1'b1;
          end else led<=led<<1;
        end
      end
    end
end 

always@(*)begin
   case(select)
     0: seg7= 7'h40;
     1: seg7= 7'h79;
     2: seg7= 7'h24;
     3: seg7= 7'h30;
     4: seg7= 7'h19;
     5: seg7= 7'h12;
     6: seg7= 7'h2;
     7: seg7= 7'h78;
     8: seg7= 7'h0;
     9: seg7= 7'h10;
     default: seg7= 7'hff;
   endcase
end


endmodule

