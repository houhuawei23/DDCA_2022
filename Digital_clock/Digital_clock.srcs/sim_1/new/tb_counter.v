`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2022 12:03:41 AM
// Design Name: 
// Module Name: tb_counter
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
module counter #(parameter base = 10)(
            input CLK,
            input cin,
            input reset,
            input set,
            input [3:0] scount,
            
            output reg[3:0] count,
            output reg cout
    );

module tb_counter();
reg CLKA, CLKB;

endmodule
