module countdown(
    input CLK,
    input clock_clk, 
    input scan_clk, 
    input Reset, 
    input reset, 
    input set,
    input display_h,
    input start_pause,//0 1
    
    input [3:0] sethour1,
    input [3:0] sethour2,
    input [3:0] setminute1,
    input [3:0] setminute2,
    input [3:0] setsecond1,
    input [3:0] setsecond2,
    
    output reg[7:0] clock_seg,
    output reg[3:0] seln
);

wire [5:0] cout;
wire [3:0] hour1;  
wire [3:0]hour2;  
wire [3:0]minute1;
wire [3:0]minute2;
wire [3:0]second1;
wire [3:0]second2;
reg [2:0] sel; 
reg dot;
//判断是否满23:59:59
wire full;
assign full =(hour1==4'd2) && (hour2==4'd3) && (minute1 ==4'd5) && (minute2 ==4'd9) && (second1 ==4'd5) && (second2 ==4'd9);
//当set=0, mode=1开始走 .set()=0, set | ~mode

decounter #(2) h1_decounter(
                .CLK(CLK),
                .reset(Reset && ~reset),
                .set(set),
                .start_pause(start_pause),
                .cin(cout[4]),
                .scount(sethour1),
                .count(hour1),
                .cout(cout[5])
);
decounter #(10) h2_decounter(
                .CLK(CLK),
                .reset(Reset && ~reset),
                .set(set),
                .start_pause(start_pause),
                .cin(cout[3]),
                .scount(sethour2),
                .count(hour2),
                .cout(cout[4])
);
decounter #(6) m1_decounter(
                .CLK(CLK),
                .reset(Reset && ~reset),
                .set(set),
                .start_pause(start_pause),
                .cin(cout[2]),
                .scount(setminute1),
                .count(minute1),
                .cout(cout[3])
);
decounter #(10) m2_decounter(
                .CLK(CLK),
                .reset(Reset && ~reset),
                .set(set),
                .start_pause(start_pause),
                .cin(cout[1]),
                .scount(setminute2),
                .count(minute2),
                .cout(cout[2])
); 
decounter #(6) s1_decounter(
                .CLK(CLK),
                .reset(Reset && ~reset),
                .set(set),
                .start_pause(start_pause),
                .cin(cout[0]),
                .scount(setsecond1),
                .count(second1),
                .cout(cout[1])
);
decounter #(10) s2_decounter(
                .CLK(CLK),
                .reset(Reset && ~reset),
                .set(set),
                .start_pause(start_pause),
                .cin(clock_clk),
                .scount(setsecond2),
                .count(second2),
                .cout(cout[0])
);   
initial begin
    sel<=3'b0;
end
always@(posedge scan_clk)begin
   if(sel==3) sel<=0;
   else sel <= sel+1;
end	
always@(posedge clock_clk, negedge Reset)begin
    if(~Reset)dot<=0;
    else dot<=~dot;
end
//扫描
always@(posedge scan_clk, negedge Reset)begin
    if(~Reset || full)begin
       {seln, clock_seg} <= 12'b1111_1111111_0;
    end
    else if(~display_h)begin
        case(sel)      
            3'd0:{seln, clock_seg} <= {4'b0111, encoder(minute1), 1'b1};
            3'd1:{seln, clock_seg} <= {4'b1011, encoder(minute2), dot };
            3'd2:{seln, clock_seg} <= {4'b1101, encoder(second1), 1'b1};
            3'd3:{seln, clock_seg} <= {4'b1110, encoder(second2), dot };
            default:{seln, clock_seg} <= 12'b1111_1111111_0;
        endcase
    end
    else begin
        case(sel)      
            3'd0:{seln, clock_seg} <= {4'b0111, encoder(hour1),    1'b0};
            3'd1:{seln, clock_seg} <= {4'b1011, encoder(hour2), 1'b0};
            3'd2:{seln, clock_seg} <= {4'b1101, encoder(minute1), 1'b0};
            3'd3:{seln, clock_seg} <= {4'b1110, encoder(minute2), 1'b0};
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