`timescale 1ns / 1ps

module clock_wrapper(
        input CLK,
        input SW0,//reset
        input SW1,//set
        
        input BTNU, BTND, BTNL, BTNR, BTNC,
        output [11:0]display_out
);
wire reset;
wire clock_clk; //1Hz  
wire scan_clk; //1kHZ
wire set_clk;
wire set;
wire [3:0] sethour1;
wire [3:0] sethour2;
wire [3:0] setminute1;
wire [3:0] setminute2;
wire [3:0] setsecond1;
wire [3:0] setsecond2;
assign reset = sw0;
assign set = sw1;
//用sw0,sw1不行，为什么？？
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

in_out myio(
       .CLK(CLK), 

       .BTNU(BTNU), 
       .BTND(BTND), 
       .BTNL(BTNL), 
       .BTNR(BTNR), 
       .BTNC(BTNC),
       .SW0(SW0), 
       .SW1(SW1), 
       .SW2(SW2), 
       
       .btnu_down(btnu_down), 
       .btnd_down(btnd_down), 
       .btnl_down(btnl_down), 
       .btnr_down(btnr_down), 
       .btnc_down(btnc_down),
       .sw0(sw0), 
       .sw1(sw1), 
       .sw2(sw2)

);

clock test_clock(
        .CLK(CLK),
        .clock_clk(clock_clk), 
        .scan_clk(scan_clk), 
        .reset(reset), 
        .set(set),

        .sethour1(sethour1),
        .sethour2(sethour2),
        .setminute1(setminute1),
        .setminute2(setminute2),
        .setsecond1(setsecond1),
        .setsecond2(setsecond2),
		
   
        .clock_seg(display_out[7:0]),
        .seln(display_out[11:8]));
button_set_time my_set( 
        .CLK(CLK), 
        .reset(reset),
        .set(set),
        .btnu_down(btnu_down), 
        .btnd_down(btnd_down), 
        .btnl_down(btnl_down), 
        .btnr_down(btnr_down), 
        .btnc_down(btnc_down),

        //out
        .sethour1(sethour1), 
        .sethour2(sethour2), 
        .setminute1(setminute1),
        .setminute2(setminute2),
        .setsecond1(setsecond1),
        .setsecond2(setsecond2));



endmodule


