`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2022 04:36:29 PM
// Design Name: 
// Module Name: test_button_set
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_button_set();
        reg CLKA;
        reg CLKB;
        reg CLKC;
        wire clkb;
        wire clkc;
        reg reset;

        wire scan_clk; //1kHZ
		reg set;
		wire [3:0] sethour1;
		wire [3:0] sethour2;
		wire [3:0] setminute1;
		wire [3:0] setminute2;
		wire [3:0] setsecond1;
		wire [3:0] setsecond2;
		
		wire [11:0]display_out;
		wire [5:0] setbbt;
		reg btnu,btnd,btnl,btnr,btnc;
divclk_scan test_myscan_clk( // ‰≥ˆ1000Hz…®√Ë ±÷”
        .CLK(CLKA), 
        .reset(reset),
        .scan_clk(scan_clk) 
 );
button_set_time dut(
            .CLK(CLKA),
            .reset(reset),
            .set(set),
            .btnu(btnu), 
            .btnd(btnd), 
            .btnl(btnl), 
            .btnr(btnr), 
            .btnc(btnc),
            
            .sethour1(sethour1), 
            .sethour2(sethour2), 
            .setminute1(setminute1),
            .setminute2(setminute2),
            .setsecond1(setsecond1),
            .setsecond2(setsecond2),
            .setbbt(setbbt)
);

initial begin 
        btnu <= 1'b0;
        btnd <= 1'b0;
        btnl <= 1'b0;
        btnr <= 1'b0;
        btnc <= 1'b0;
		reset <= 1'b0;
        set <= 1'b0;    
		#5;
		reset <= 1'b1;
		set <=1'b1;
end
always begin
	CLKA = 1'b0;
	#5;
	CLKA=1'b1;
	#5;
end
always begin
	CLKB = 1'b0;
	#29;
	CLKB=1'b1;
	#29;
end
always begin
	CLKC = 1'b0;
	#119;
	CLKC=1'b1;
	#119;
end
debounce dbb(
.CLK(CLKA),    
.reset(reset),  
.key_in(CLKB), 
.key_out(clkb));

debounce dbc(
.CLK(CLKA),    
.reset(reset),  
.key_in(CLKC), 
.key_out(clkc));
always@(posedge clkb)begin
    btnu = ~btnu;
end
//btnl = ~btnl;
always@(posedge clkc)begin
     btnl = ~btnl;
end
//assign display_out = {}
endmodule


module debounce(
            input CLK,
            input reset,
            input key_in,
            output key_out
);
reg delay1;
reg delay2;
reg delay3;
always@(posedge CLK, negedge reset)begin
    if(~reset)begin
        delay1 <=1'b0;
        delay2 <=1'b0;
        delay3 <=1'b0;
    end
    else begin
        delay1 <= key_in;
        delay2 <= delay1;
        delay3 <= delay2;
    end
end

assign key_out = delay3;

endmodule