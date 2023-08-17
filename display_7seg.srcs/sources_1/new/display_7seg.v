`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2022 02:59:47 PM
// Design Name: 
// Module Name: display_7seg
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


module display_7seg( 
 input CLK, 
 input SW_in, 
 output reg[10:0] display_out 
 );
 reg [19:0]count=0; 
 reg [2:0] sel=0; 
 parameter T1MS=50000; 
 always@(posedge CLK)begin 
        if(SW_in==0)begin 
            case(sel) 
            0:display_out<=11'b0111_1001111;//1
            1:display_out<=11'b1011_0010010;//2
            2:display_out<=11'b1101_0000110;//3
            3:display_out<=11'b1110_1001100;//4
            default:display_out<=11'b1111_1111111; 
            endcase 
        end 
        else begin 
            case(sel) 
            0:display_out<=11'b1110_1001111;// 4' 1 
            1:display_out<=11'b1101_0010010; // 3' 2
            2:display_out<=11'b1011_0000110; // 2' 3
            3:display_out<=11'b0111_1001100; // 1' 4
            default:display_out<=11'b1111_1111111; 
            endcase 
        end 
    end 
    always@(posedge CLK)begin 
        count<=count+1; 
        if(count==T1MS)begin 
             count<=0; 
             sel<=sel+1; 
             if(sel==4) 
                 sel<=0; 
        end 
     end 
endmodule

module xiaodou_action(key_in,clk,key_out);

input key_in,clk;
output reg key_out;
reg [1:0] state;

parameter S0='d0,S1='d1,S2='d2,S3='d3;

always @(posedge clk)
begin
 case(state)
  S0: begin 
    if(key_in) begin key_out<=0; state<=S1; end
    else begin key_out<=0; state<=S0; end
    end 
  S1: begin 
    if(key_in) begin key_out<=0; state<=S2; end
    else begin key_out<=0; state<=S0; end
    end 
  S2: begin 
    if(key_in) begin key_out<=0; state<=S3; end
    else begin key_out<=0; state<=S0; end
    end 
  S3: begin 
    if(key_in) begin key_out<=1; state<=S0; end  //S3¸ÄÎªS0
    else begin key_out<=0; state<=S0; end
    end 
  default state<=S0;
 endcase
end
endmodule

//ÒëÂëÆ÷
module encoder(
    input [3:0] bin,
    output reg[6:0] seg
);
    always@(bin)begin
        case(bin)
           3'd0: seg = 7'b1000_000;
           3'd1: seg = 7'b1001_111;
           3'd2: seg = 7'b0010_010;
           3'd3: seg = 7'b0000_110;
           3'd4: seg = 7'b1001_100;
           3'd5: seg = 7'b0100_100;
           3'd6: seg = 7'b0100_000;
           3'd7: seg = 7'b1001_110;
           3'd8: seg = 7'b0000_000;
		   3'd9: seg = 7'b0000_100;
		   default: seg = 7'b1000_000;
		  endcase
    end
endmodule

