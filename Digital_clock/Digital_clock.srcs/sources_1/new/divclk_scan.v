`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2022 06:08:01 PM
// Design Name: 
// Module Name: divclk_scan
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
// input: 100MHz CLK
// output: 

module divclk_scan(
    input CLK, reset,
    output scan_clk 
    );
reg [19: 0] counter;
always@(posedge CLK, negedge reset)
begin
    if(!reset) counter <= 20'b0;
    else begin
        counter = counter + 10;
    end
end
//assign scan_clk = counter[8];
assign scan_clk = counter[19];
endmodule
