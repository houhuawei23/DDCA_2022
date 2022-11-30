`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2022 10:22:08 AM
// Design Name: 
// Module Name: test_clock_wrapper
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


module test_clock_wrapper(

    );
        reg CLKA;
        reg CLKB;
        reg CLKC;
        reg reset;
        reg set;
        reg BTNU, BTND, BTNL, BTNR, BTNC;
        wire [11:0]display_out;
clock_wrapper dut(
        .CLK(CLKA),
        .SW0(reset),//reset
        .SW1(set),//set
        .BTNU(BTNU), 
        .BTND(BTND), 
        .BTNL(BTNL), 
        .BTNR(BTNR), 
        .BTNC(BTNC),
        .display_out(display_out)
);
always begin
	CLKA = 1'b0;
	#5;
	CLKA=1'b1;
	#5;
end

initial begin
    reset <= 0;
    set <=0;
    #5;
    reset <= 1;
    set <=1;
    BTNU <= 0;
    #2000000;
    BTNU <= 1;
    #2000000;
    BTNU <= 0;
    #2000000;
    BTNU <= 1;
    #2000000;
    BTNU <= 0;
    #2000000;
    BTNU <= 1;
    #2000000;
    //
    BTNL <= 0;
    #2000000;
    BTNL <= 1;
    #2000000;
    BTNL <= 0;
    #2000000;
    BTNL <= 1;
    #2000000;
    //
    BTNU <= 0;
    #2000000;
    BTNU <= 1;
    #2000000;
    BTNU <= 0;
    #2000000;
    BTNU <= 1;
    #2000000;
    BTNU <= 0;
    #2000000;
    BTNU <= 1;
    #2000000;
    BTNU <= 0;
    #2000000;
    BTNU <= 1;
end
endmodule
