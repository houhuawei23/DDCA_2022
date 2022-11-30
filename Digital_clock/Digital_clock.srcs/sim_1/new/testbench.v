`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2022 06:57:14 PM
// Design Name: 
// Module Name: testbench
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
/*
CLK
reset
set
BTNU
BTND
BTNL
BTNR
BTNC
SW0
SW1
SW2
SW3
*/

module testbench();
            reg CLK;
            reg reset;
            reg [5:0]set;
            reg BTNU; 
            reg BTND; 
            reg BTNL; 
            reg BTNR; 
            reg BTNC;
            reg SW0; 
            reg SW1; 
            reg SW2; 
            reg SW3;
            wire [11:0]display_out;
digital_clk testdc(
            .CLK(CLK), 
            .reset(reset), 
            .set(set),
            .BTNU(BTNU), 
            .BTND(BTND), 
            .BTNL(BTNL), 
            .BTNR(BTNR), 
            .BTNC(BTNC),
            .SW0(SW0), 
            .SW1(SW1), 
            .SW2(SW2), 
            .SW3(SW3),
            .display_out(display_out));


initial begin
	CLK  <= 0;
	reset<= 0;
	set  <= 0;
	BTNU <= 0;
	BTND <= 0;
	BTNL <= 0;
	BTNR <= 0;
	BTNC <= 0;
	SW0  <= 0;
	SW1  <= 0;
	SW2  <= 0;
	SW3  <= 0;
	#5;
	reset<= 1;
end
	
always begin
	CLK = 1'b0;
	#5;
	CLK=1'b1;
	#5;
end

always@(posedge CLK, negedge reset)begin
    
end

endmodule
