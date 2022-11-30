`timescale 1ns / 1ps

module stopwatch(
    input CLK,
    input ms_clk,
    input scan_clk,
    input Reset,//全局复位
    input reset,//功能复位
    input start_pause,
    input display_h,
    output reg [7:0] clock_seg,
    output reg [3:0] seln
    );
wire [5:0] cout;
reg [2:0] sel; 
//判断是否满59:59:59ms
wire full;
wire [3:0]minute1;
wire [3:0]minute2;
wire [3:0]second1;
wire [3:0]second2;
wire [3:0]ms1;
wire [3:0]ms2;
assign full = (minute1 ==4'd5) && (minute2 ==4'd9) && 
              (second1 ==4'd5) && (second2 ==4'd9) &&
              (ms1 == 4'd5) && (ms2 == 4'd9);
counter #(6) m1_counter(
            .CLK(CLK),
            .reset(Reset && ~reset),
            .set(1'b0),
            .start_pause(start_pause),
            .cin(cout[4]),
            .scount(4'b0),
            .count(minute1),
            .cout(cout[5])
);
counter #(10) m2_counter(
            .CLK(CLK),
            .reset(Reset && ~reset),
            .set(1'b0),
            .start_pause(start_pause),
            .cin(cout[3]),
            .scount(4'b0),
            .count(minute2),
            .cout(cout[4])
); 
counter #(6) s1_counter(
            .CLK(CLK),
            .reset(Reset && ~reset),
            .set(1'b0),
            .start_pause(start_pause),
            .cin(cout[2]),
            .scount(4'b0),
            .count(second1),
            .cout(cout[3])
);
counter #(10) s2_counter(
            .CLK(CLK),
            .reset(Reset && ~reset),
            .set(1'b0),
            .start_pause(start_pause),
            .cin(cout[1]),
            .scount(4'b0),
            .count(second2),
            .cout(cout[2])
); 
counter #(6) ms1_counter(
            .CLK(CLK),
            .reset(Reset && ~reset),
            .set(1'b0),
            .start_pause(start_pause),
            .cin(cout[0]),
            .scount(4'b0),
            .count(ms1),
            .cout(cout[1])
);
counter #(10) ms2_counter(
            .CLK(CLK),
            .reset(Reset && ~reset),
            .set(1'b0),
            .start_pause(start_pause),
            .cin(ms_clk),
            .scount(4'b0),
            .count(ms2),
            .cout(cout[0])
);   
always@(posedge scan_clk, negedge Reset)begin
    if(!Reset) sel<=0;
    else if(sel==3) sel<=0;
    else sel <= sel+1;
end	
always@(posedge scan_clk, negedge Reset)begin
    if(~Reset || full)begin
       {seln, clock_seg} <= 12'b1111_1111111_0;
    end
    else if(display_h) begin
        case(sel)
            3'd0:{seln, clock_seg} <= {4'b0111, encoder(minute1), 1'b1};
            3'd1:{seln, clock_seg} <= {4'b1011, encoder(minute2), 1'b0};
            3'd2:{seln, clock_seg} <= {4'b1101, encoder(second1), 1'b1};
            3'd3:{seln, clock_seg} <= {4'b1110, encoder(second2), 1'b0};
            default:{seln, clock_seg} <= 12'b1111_1111111_0;
        endcase
    end
    else begin
        case(sel)      
            3'd0:{seln, clock_seg} <= {4'b0111, encoder(second1),   1'b1};
            3'd1:{seln, clock_seg} <= {4'b1011, encoder(second2),   1'b0 };
            3'd2:{seln, clock_seg} <= {4'b1101, encoder(ms1), 1'b1};
            3'd3:{seln, clock_seg} <= {4'b1110, encoder(ms2), 1'b0 };
            default:{seln, clock_seg} <= 12'b1111_1111111_0;
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


