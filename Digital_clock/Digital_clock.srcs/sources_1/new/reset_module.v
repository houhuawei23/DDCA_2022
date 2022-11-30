`timescale 1ns / 1ps

module reset_module(
    input CLK,
    input Reset,
    input scan_clk,
    input clock_clk,
    output reg [7:0] clock_seg,
    output reg [3:0] seln
    );

reg [2:0] sel; 
reg [2:0] sel_1Hz;
reg [3:0] num;

always@(posedge scan_clk, negedge Reset)begin
    if(!Reset) sel<=3'b0;
    else if(sel==3) sel<=0;
    else sel <= sel+1;
end	


always@(posedge clock_clk, negedge Reset)begin
    if(!Reset) num<=4'b0;
    else if(num==4'd9) num<=4'd0;
    else num<=num+4'd1;
end


//É¨Ãè
always@(posedge scan_clk, negedge Reset)begin
    if(~Reset)begin
       {seln, clock_seg} <= 12'b1110_0000000_0;
    end
    else begin
        case(sel)      
            3'd0:{seln, clock_seg} <= {4'b0111, encoder(num), 1'b0};
            3'd1:{seln, clock_seg} <= {4'b1011, encoder(num), 1'b0};
            3'd2:{seln, clock_seg} <= {4'b1101, encoder(num), 1'b0};
            3'd3:{seln, clock_seg} <= {4'b1110, encoder(num), 1'b0};
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
