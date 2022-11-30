`timescale 1ns / 1ps
module digital_clk(
        input CLK,
        input BTNU, BTND, BTNL, BTNR, BTNC,
        input SW0, SW1, SW2, SW3, SW4, SW5, SW6,
        input SW13, SW14, SW15,
        output reg[11:0] display_out,
        output LD0, LD1, LD2, LD3, LD4, LD5, LD6,
        output LD13, LD14, LD15
    );  
//时钟分频
wire ms_clk;
wire clock_clk; //1Hz  
wire scan_clk; //1kHZ  
wire Reset, reset, set;
//按键接线
wire btnu_down, btnd_down, btnl_down, btnr_down, btnc_down;
wire sw0, sw1, sw2, sw3, sw4, sw5, sw6;
wire sw13, sw14, sw15;
//各模块数码管输出区
wire [11:0]clock_seg ; 
wire [11:0]countup_seg;
wire [11:0]countdown_seg;
wire [11:0]alarm_seg;
wire [11:0]reset_seg;
wire [11:0]sw_seg;
//时间设置接线
wire [3:0] sethour1;
wire [3:0] sethour2;
wire [3:0] setminute1;
wire [3:0] setminute2;
wire [3:0] setsecond1;
wire [3:0] setsecond2;

wire [3:0] hour1;  
wire [3:0] hour2;  
wire [3:0] minute1;
wire [3:0] minute2;
wire [3:0] second1;
wire [3:0] second2;
//wire [5:0] setbit;
wire beep;
assign Reset = sw0;
assign reset = sw13;
assign set = sw1;
//LD
assign LD0 = sw0;
assign LD1 = sw1;
assign LD2 = sw2;
assign LD3 = sw3;
assign LD4 = sw4;
assign LD5 = sw5;
assign LD6 = sw6;
assign LD13 =sw13;
assign LD14 = sw14;
assign LD15 = sw15;

div_n32p #(42950) myscan_clk( //输出1000Hz扫描时钟
        .CLK(CLK), 
        .reset(Reset),
        .clk(scan_clk)
);
div_n32p #(43) myclock_clk( //输出1Hz计时时钟
        .CLK(CLK), 
        .reset(Reset),
        .clk(clock_clk)
);
div_n32p #(2577) myms_clk(
        .CLK(CLK), 
        .reset(Reset),
        .clk(ms_clk)
);

// io模块  
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
    .SW3(SW3),
    .SW4(SW4), 
    .SW5(SW5),
    .SW6(SW6),
    .SW13(SW13),
    .SW14(SW14),
    .SW15(SW15),
    .btnu_down(btnu_down), 
    .btnd_down(btnd_down), 
    .btnl_down(btnl_down), 
    .btnr_down(btnr_down), 
    .btnc_down(btnc_down),
    .sw0(sw0), 
    .sw1(sw1), 
    .sw2(sw2), 
    .sw3(sw3),
    .sw4(sw4), 
    .sw5(sw5),
    .sw6(sw6),
    .sw13(sw13),
    .sw14(sw14),
    .sw15(sw15)
);
// 时钟模块
clock myclock(
    .CLK(CLK),
    .clock_clk(clock_clk), //1Hz  
    .scan_clk(scan_clk), //1kHZ   
    .Reset(Reset), 
    .reset(reset && sw2),
    .set(set && sw2),
    .start_pause(btnc_down && sw2),
    .display_h(sw15),

    .sethour1(sethour1),  
    .sethour2(sethour2),  
    .setminute1(setminute1),
    .setminute2(setminute2),
    .setsecond1(setsecond1),
    .setsecond2(setsecond2),
    
    .hour1  (hour1),
    .hour2  (hour2),
    .minute1(minute1),
    .minute2(minute2),
    .second1(second1),
    .second2(second2),

    .clock_seg(clock_seg[7:0]),//8
    .seln(clock_seg[11:8])//4
);
//正计时模块
countup mycountup(
    .CLK(CLK),
    .clock_clk(clock_clk), //1Hz
    .scan_clk(scan_clk), //1kHZ
    .Reset(Reset), 
    .reset(reset && sw3),
    .set(set && sw3),
    .display_h(sw15),
    .start_pause(btnc_down && sw3),
    .sethour1(sethour1),  
    .sethour2(sethour2),  
    .setminute1(setminute1),
    .setminute2(setminute2),
    .setsecond1(setsecond1),
    .setsecond2(setsecond2),
    
    .clock_seg(countup_seg[7:0]),//8
    .seln(countup_seg[11:8])//4
);
//倒计时模块
countdown mycountdown(
    .CLK(CLK),  
    .clock_clk(clock_clk), //1Hz
    .scan_clk(scan_clk), //1kHZ
    .Reset(Reset), 
    .reset(reset && sw4),
    .set(set && sw4),
    .display_h(sw15),
    .start_pause(btnc_down && sw4),
    
    .sethour1(sethour1),  
    .sethour2(sethour2),  
    .setminute1(setminute1),
    .setminute2(setminute2),
    .setsecond1(setsecond1),
    .setsecond2(setsecond2),
    
    .clock_seg(countdown_seg[7:0]),//8
    .seln(countdown_seg[11:8])//4

);
//闹钟模块
alarm myalarm(
    .CLK(CLK),
    .clock_clk(clock_clk), //1Hz
    .scan_clk(scan_clk), //1kHZ
    .Reset(Reset), 
    .reset(reset && sw5),
    .set(set && sw5),
    .start(sw14),
    .display_h(sw15),
    .hour1(hour1),
    .hour2(hour2),
    .minute1(minute1),
    .minute2(minute2),
    .second1(second1),
    .second2(second2),
    .sethour1(sethour1),  
    .sethour2(sethour2),  
    .setminute1(setminute1),
    .setminute2(setminute2),
    .setsecond1(setsecond1),
    .setsecond2(setsecond2),
    
    .clock_seg(alarm_seg[7:0]),//8
    .seln(alarm_seg[11:8]),//4
    .beep(beep)
);
//秒表
stopwatch mystopwatch(
    .CLK(CLK),       
    .ms_clk(ms_clk),    
    .scan_clk(scan_clk),  
    .Reset(Reset),//全局复
    .reset(reset && sw6),//功能复
    .start_pause(btnc_down && sw6),
    .display_h(display_h), 
    .clock_seg(sw_seg[7:0]),//8
    .seln(sw_seg[11:8])//4
);

button_set_time myset( 
    .CLK(CLK), 
    .Reset(Reset),
//    .reset(1'b0),
    .reset(reset && set),
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
reset_module myreset(
    .CLK(CLK),
    .Reset(Reset),
    .scan_clk(scan_clk),
    .clock_clk(clock_clk),
    .clock_seg(reset_seg[7:0]), 
    .seln(reset_seg[11:8]));


//选择输出
always@(posedge CLK, negedge Reset)begin
    if(~Reset) display_out <= reset_seg;
    else if(sw2) begin//时钟
        if(beep && sw14)display_out <=alarm_seg;//闹钟响了
        else display_out <= clock_seg;
    end
    else if(sw3)display_out <=countup_seg;  //正计时
    else if(sw4)display_out <=countdown_seg;//倒计时
    else if(sw5)display_out <=alarm_seg;    //闹钟
    else if(sw6)display_out <=sw_seg;       //秒表
    else display_out <= reset_seg;          
end
//always@(posedge CLK, negedge Reset)begin
//    if(~Reset) display_out <= reset_seg;
//    else if(sw2)display_out <= clock_seg;
//    else display_out <= reset_seg;
//end
//always@(posedge CLK)begin
//    if(sw2)display_out <= clock_seg;
//    else display_out <= reset_seg;
//end
endmodule