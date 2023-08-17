`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2022 01:29:21 AM
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
	parameter ASIZE = 5;
	
    logic wclk;
    logic rclk;

//    wire wfull;
//    wire rempty;

    logic winc;
    logic rinc;
    
//    logic wrst_n;
//    logic rrst_n;
    
    logic [DSIZE-1:0] wdata;
    logic [DSIZE-1:0] rdata;  
    
    logic [4:0] waddr;
    logic [4:0] raddr; 
	SRAM_DP_32X32_wrapper MEM(
                              //不用，设为0
                              .QB(rdata), 
							  
                              .CLKA(wclk), 
                              .CENA(~winc), //0有效
                              .WENA(~winc), 
                              .AA(waddr), 
                              .DA(wdata), 
							  
                              .CLKB(rclk), //clkb怎么设置？
                              .CENB(~rinc), //0有效
                              .WENB(1'b1), 
                              .AB(raddr), 
                              .DB(32'b0));
    always begin
        #5;wclk=~wclk;
    end
    always begin
        #7;rclk=~rclk;
    end
	
    initial begin
        winc = 1'b0;
        rinc = 1'b0;
        
        wclk = 1'b0;
        rclk = 1'b0;
        
		waddr = 5'b0;
        wdata = 32'b0;
        
        raddr = 5'b0;
        #50;
//		rrst_n=1'b0;
//        wrst_n=1'b0;
//        #20;
//        rrst_n=1'b1;
//        wrst_n=1'b1;
		repeat(33) begin
			@(posedge wclk)begin
				#2;
				waddr = waddr + 5'd1;
				winc = 1'b1;
				wdata = wdata+32'd2;
			end
		end
		@(posedge wclk)begin
			#2;
			winc=1'b0;
		end
		
		#30;
		repeat(31) begin
			@(posedge rclk)begin
			    #2;
			    raddr = raddr+5'd1;
				rinc=1'b1;
			end 
		end

		@(posedge rclk);	// 等待CLKB的时钟上升沿
		#5;		

    end
endmodule
