`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2022 03:02:21 PM
// Design Name: 
// Module Name: display_7seg_tb
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


module display_7seg_tb();
    reg CLK;
    reg SW_in;
    wire SW_in_after;
    wire [10:0] display_out;
    
    xiaodou_action xiao(.key_in(SW_in),
                        .clk(CLK),
                        .key_out(SW_in_after)
                        );
    display_7seg dut(.CLK(CLK),
                     .SW_in(SW_in_after),
                     .display_out(display_out)
                     );
    initial begin
        CLK = 0;
        SW_in = 0;
        #100;
    end
//    parameter T = 200;
    always begin
        CLK = 1'b0;
        #20;
        CLK=1'b1;
        #20;
    end
    always@(posedge CLK)begin
        SW_in = ~SW_in;
    end
endmodule
