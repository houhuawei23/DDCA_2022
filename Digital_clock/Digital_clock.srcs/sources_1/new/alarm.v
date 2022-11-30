module alarm(
    input CLK,
    input clock_clk, 
    input scan_clk, 
    input Reset, 
    input reset,
    input set,
    input start,
    input display_h,
    
    input wire [3:0] hour1,  
    input wire [3:0] hour2,  
    input wire [3:0] minute1,
    input wire [3:0] minute2,
    input wire [3:0] second1,
    input wire [3:0] second2,
    
    input [3:0] sethour1,
    input [3:0] sethour2,
    input [3:0] setminute1,
    input [3:0] setminute2,
    input [3:0] setsecond1,
    input [3:0] setsecond2,
    
    output reg [7:0] clock_seg,
    output reg [3:0] seln,

    output reg beep//持续一段时间
);
reg [3:0] alarm_hour1; 
reg [3:0] alarm_hour2; 
reg [3:0] alarm_minute1;
reg [3:0] alarm_minute2;
reg [3:0] alarm_second1;
reg [3:0] alarm_second2;

reg [2:0] sel; 
reg [2:0] sel_1Hz;
reg [7:0] clock_seg_buff;  
reg [3:0] seln_buff;
reg [7:0] clock_seg_beep;  
reg [3:0] seln_beep;

wire onclk;
reg pre;
reg [3:0] count;
reg dot;
assign onclk = 
alarm_hour1  ==  hour1 &&
alarm_hour2  ==  hour2 &&
alarm_minute1== minute1&&
alarm_minute2== minute2&&
alarm_second1== second1&&
alarm_second2== second2;

always@(posedge CLK, negedge Reset)begin
    if(~Reset && reset) begin
        alarm_hour1   <= 4'b0;
        alarm_hour2   <= 4'b0;
        alarm_minute1 <= 4'b0;
        alarm_minute2 <= 4'b0;
        alarm_second1 <= 4'b0;
        alarm_second2 <= 4'b0;
    end
    else if(set)begin
        alarm_hour1   <= sethour1;
        alarm_hour2   <= sethour2;
        alarm_minute1 <= setminute1;
        alarm_minute2 <= setminute2;
        alarm_second1 <= setsecond1;
        alarm_second2 <= setsecond2;
    end
    else begin
        alarm_hour1   <= alarm_hour1; 
        alarm_hour2   <= alarm_hour2; 
        alarm_minute1 <= alarm_minute1;
        alarm_minute2 <= alarm_minute2;
        alarm_second1 <= alarm_second1;
        alarm_second2 <= alarm_second2;   
    end
end

always@(posedge scan_clk, negedge Reset)begin
   if(!Reset)sel<=3'b0;
   else if(sel==3) sel<=0;
   else sel <= sel+1;
end	

always@(posedge clock_clk, negedge Reset)begin
   if(!Reset)sel_1Hz<=3'b0;
   else if(sel_1Hz ==3) sel_1Hz<=0;
   else sel_1Hz <= sel_1Hz+1;
end	
always@(posedge clock_clk, negedge Reset)begin
    if(~Reset)dot<=0;
    else dot<=~dot;
end
//beep持续5s
always@(posedge clock_clk, negedge Reset)begin
    if(~Reset)begin                    
       count <= 4'b0;
       pre <= 1'b0;
       count <=4'b0;
    end  
    else if(onclk && start)begin //到时间
            pre <=1;
            count<=0;
            beep <=1;
    end
    else if(pre==1 && count <4'd5)begin
        count<= count+1;
    end
    else if(pre==1 && count>=4'd5)begin
        pre<=0;
        count<=0;
        beep<=0;
    end
    else begin
        pre<=pre;
        count<=count;
        beep<=beep;
    end
end
//扫描

always@(posedge clock_clk, negedge Reset)begin
    if(~Reset)begin
        {seln_beep,clock_seg_beep }<= 12'b1111_1111111_0;
    end
    else if(~display_h)begin
        case(sel_1Hz)      
            3'd0:{seln_beep,clock_seg_beep} <= {4'b0111, encoder(alarm_minute1), 1'b1};
            3'd1:{seln_beep,clock_seg_beep} <= {4'b1011, encoder(alarm_minute2), dot };
            3'd2:{seln_beep,clock_seg_beep} <= {4'b1101, encoder(alarm_second1), 1'b1};
            3'd3:{seln_beep,clock_seg_beep} <= {4'b1110, encoder(alarm_second2), dot };
            default:{seln_beep,clock_seg_beep} <= 12'b1111_1111111_0;
        endcase
    end
    else begin
        case(sel_1Hz)      
            3'd0:{seln_beep,clock_seg_beep} <= {4'b0111, encoder(alarm_hour1),   1'b1}; 
            3'd1:{seln_beep,clock_seg_beep} <= {4'b1011, encoder(alarm_hour2),   dot }; 
            3'd2:{seln_beep,clock_seg_beep} <= {4'b1101, encoder(alarm_minute1), 1'b1}; 
            3'd3:{seln_beep,clock_seg_beep} <= {4'b1110, encoder(alarm_minute2), dot }; 
            default:{seln_beep, clock_seg_beep} <= 12'b1111_1111111_0;
        endcase
    end
end



always@(posedge scan_clk, negedge Reset)begin
    if(~Reset)begin
       {seln, clock_seg} <= 12'b1111_1111111_0;
    end
    else if(beep)begin
        {seln, clock_seg} <= {seln_beep,clock_seg_beep};
    end 
    else if(~display_h)begin
        case(sel)      
            3'd0:{seln, clock_seg} <= {4'b0111, encoder(alarm_minute1), 1'b0};
            3'd1:{seln, clock_seg} <= {4'b1011, encoder(alarm_minute2), 1'b0};
            3'd2:{seln, clock_seg} <= {4'b1101, encoder(alarm_second1), 1'b0};
            3'd3:{seln, clock_seg} <= {4'b1110, encoder(alarm_second2), 1'b0};
            default:{seln, clock_seg} <= 12'b1111_1111111_0;
        endcase
    end
    else begin
        case(sel)      
            3'd0:{seln, clock_seg} <= {4'b0111, encoder(alarm_hour1), 1'b0};
            3'd1:{seln, clock_seg} <= {4'b1011, encoder(alarm_hour2), 1'b0};
            3'd2:{seln, clock_seg} <= {4'b1101, encoder(alarm_minute1), 1'b0};
            3'd3:{seln, clock_seg} <= {4'b1110, encoder(alarm_minute2), 1'b0};
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