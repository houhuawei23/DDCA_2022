`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2022 02:24:12 PM
// Design Name: 
// Module Name: tb
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


module test();
	parameter DSIZE = 32;
	parameter ASIZE = 4;
    reg CLKA;
    reg CLKB;
    reg [DSIZE-1:0] rdata;
    reg wfull;
    reg rempty;
    reg [DSIZE-1:0]wdata;
    wire winc;
    reg wrst_n;
    wire rinc;
    reg rrst_n;
    
    fifo2 dutfifo(
                .rdata(rdata),
                .wfull(wfull),
                .rempty(rempty),
                .wdata(wdata),
                .winc(winc),
                .wclk(wclk),
                .wrst_n(wrst_n),
                .rinc(rinc),
                .rclk(rclk),
                .rrst_n(rrst_n)
    );
    assign winc = 1;
    assign rinc = 1;
    initial begin
        CLKA = 1'b0;
        CLKB = 1'b0;
        #50;
        
        @(posedge CLKA);
        
    end
	

    
    
    
    
endmodule
