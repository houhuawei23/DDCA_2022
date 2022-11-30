`timescale 1ns / 1ps

module clock(
    input CLK,
    input clock_clk, 
    input scan_clk, 
    input Reset, 
    input reset,//0
	input set,//“要设置时间“的信号
	input start_pause,
	input display_h,
    input [3:0] sethour1,
    input [3:0] sethour2,
    input [3:0] setminute1,
    input [3:0] setminute2,
    input [3:0] setsecond1,
    input [3:0] setsecond2,

    output wire [3:0] hour1,  
    output wire [3:0] hour2,  
    output wire [3:0] minute1,
    output wire [3:0] minute2,
    output wire [3:0] second1,
    output wire [3:0] second2,

    output reg [7:0] clock_seg,
    output reg [3:0] seln
    );

wire [5:0] cout;
reg [2:0] sel; 
reg dot;
//判断是否满23:59:59
wire full;
assign full =(hour1==4'd2) && (hour2==4'd3) && 
              (minute1 ==4'd5) && (minute2 ==4'd9) && 
              (second1 ==4'd5) && (second2 ==4'd9);
counter #(2) h1_counter(
            .CLK(CLK),
            .reset(Reset&&~reset),
//            .reset(Reset),
            .set(set),
            .start_pause(start_pause),
            .cin(cout[4]),
            .scount(sethour1),
            .count(hour1),
            .cout(cout[5])
);
counter #(10) h2_counter(
            .CLK(CLK),
            .reset(Reset&&~reset),
//            .reset(Reset),
            .set(set),
            .start_pause(start_pause),
            .cin(cout[3]),
            .scount(sethour2),
            .count(hour2),
            .cout(cout[4])
);
counter #(6) m1_counter(
            .CLK(CLK),
            .reset(Reset&&~reset),
//            .reset(Reset),
            .set(set),
            .start_pause(start_pause),
            .cin(cout[2]),
            .scount(setminute1),
            .count(minute1),
            .cout(cout[3])
);
counter #(10) m2_counter(
            .CLK(CLK),
            .reset(Reset&&~reset),
//            .reset(Reset),
            .set(set),
            .start_pause(start_pause),
            .cin(cout[1]),
            .scount(setminute2),
            .count(minute2),
            .cout(cout[2])
); 
counter #(6) s1_counter(
            .CLK(CLK),
            .reset(Reset&&~reset),
//            .reset(Reset),
            .set(set),
            .start_pause(start_pause),
            .cin(cout[0]),
            .scount(setsecond1),
            .count(second1),
            .cout(cout[1])
);
counter #(10) s2_counter(
            .CLK(CLK),
            .reset(Reset&&~reset),
//            .reset(Reset),
            .set(set),
            .start_pause(start_pause),
            .cin(clock_clk),
            .scount(setsecond2),
            .count(second2),
            .cout(cout[0])
);   

always@(posedge scan_clk, negedge Reset)begin
    if(!Reset) sel<=0;
    else if(sel==3) sel<=0;
    else sel <= sel+1;
end	
always@(posedge clock_clk, negedge Reset)begin
    if(~Reset)dot<=0;
    else dot<=~dot;
end
//扫描
always@(posedge scan_clk, negedge Reset)begin
    if(~Reset || full)begin
       {seln, clock_seg} <= 12'b1101_0000001_1;
    end
    else if(~display_h)begin
        case(sel)      
            3'd0:{seln, clock_seg} <= {4'b0111, encoder(minute1), 1'b1};
            3'd1:{seln, clock_seg} <= {4'b1011, encoder(minute2), dot };
            3'd2:{seln, clock_seg} <= {4'b1101, encoder(second1), 1'b1};
            3'd3:{seln, clock_seg} <= {4'b1110, encoder(second2), dot };
            default:{seln, clock_seg} <= 12'b1011_0000000_0;
        endcase
    end
    else begin
        case(sel)      
            3'd0:{seln, clock_seg} <= {4'b0111, encoder(hour1),   1'b1};
            3'd1:{seln, clock_seg} <= {4'b1011, encoder(hour2),   dot };
            3'd2:{seln, clock_seg} <= {4'b1101, encoder(minute1), 1'b1};
            3'd3:{seln, clock_seg} <= {4'b1110, encoder(minute2), dot };
            default:{seln, clock_seg} <= 12'b0111_0000000_0;
        endcase
    end
end

function [6:0]encoder;
    input [3:0] dec;
    begin
        case(dec)
           4'd0: encoder = 7'b0000_001;
           4'd1: encoder = 7'b1001_111;
           4'd2: encoder = 7'b0010_010;
           4'd3: encoder = 7'b0000_110;
           4'd4: encoder = 7'b1001_100;
           4'd5: encoder = 7'b0100_100;
           4'd6: encoder = 7'b0100_000;
           4'd7: encoder = 7'b0001_111;
           4'd8: encoder = 7'b0000_000;
		   4'd9: encoder = 7'b0000_100;
		   default: encoder = 7'b1000_000;
		  endcase
    end
endfunction
endmodule

