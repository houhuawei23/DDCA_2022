`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2022 05:47:56 PM
// Design Name: 
// Module Name: encoder
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
//输入 4位无符号十进制数
//输出对应的数码管编码

function [6:0]encoder;
    input [3:0] dec;

    begin
        case(dec)
           4'd0: encoder = 7'b1000_000;
           4'd1: encoder = 7'b1001_111;
           4'd2: encoder = 7'b0010_010;
           4'd3: encoder = 7'b0000_110;
           4'd4: encoder = 7'b1001_100;
           4'd5: encoder = 7'b0100_100;
           4'd6: encoder = 7'b0100_000;
           4'd7: encoder = 7'b1001_110;
           4'd8: encoder = 7'b0000_000;
		   4'd9: encoder = 7'b0000_100;
		   default: encoder = 7'b1000_000;
		  endcase
    end
endfunction

