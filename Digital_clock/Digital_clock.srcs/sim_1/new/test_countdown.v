`timescale 1ns / 1ns

module test_countdown();
        reg CLK;
        reg reset;
        reg [5:0]set;
        wire clock_clk; //1Hz  
        wire scan_clk; //1kHZ
		reg [5:0] set;
		reg [3:0] sethour1;
		reg [3:0] sethour2;
		reg [3:0] setminute1;
		reg [3:0] setminute2;
		reg [3:0] setsecond1;
		reg [3:0] setsecond2;
		reg start_pause;
		wire [11:0]display_out;
divclk_scan test_myscan_clk( //输出1000Hz扫描时钟
        .CLK(CLK), 
        .reset(reset),
        .scan_clk(scan_clk) 
 );

divclk_1Hz test_myclock_clk( //输出1Hz计时时钟
        .CLK(CLK), 
        .reset(reset),
        .clock_clk(clock_clk)
);
countdown mycd(
        .CLK(CLK),
        .clock_clk(clock_clk), 
        .scan_clk(scan_clk), 
        .reset(reset), 
        .set(set),
        
        .start_pause(start_pause),
        .sethour1(sethour1),
        .sethour2(sethour2),
        .setminute1(setminute1),
        .setminute2(setminute2),
        .setsecond1(setsecond1),
        .setsecond2(setsecond2),
    
        .clock_seg(display_out[7:0]),
        .seln(display_out[11:8])
    );
initial begin 
		sethour1  <= 4'b0;
		sethour2  <= 4'b0;
		setminute1<= 4'b0;
		setminute2<= 4'b0;
		setsecond1<= 4'b0;
		setsecond2<= 4'b0;
		reset <= 1'b0;
        set <= 6'b0;   
        start_pause <=0; 
		#5;
		reset <= 1'b1;
end
always begin
	CLK = 1'b0;
	#5;
	CLK=1'b1;
	#5;
end
always begin
    start_pause <= 1'b1;
    #100000;
    start_pause <= 1'b0;
end

endmodule


