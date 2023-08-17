

module fifomem(rdata, wdata, waddr, raddr, wclken, wclk, rclk);
    parameter DATASIZE = 32; // Memory data word width 字长
	parameter ADDRSIZE = 5; // Number of memory address bits 位宽
	parameter DEPTH = 1<<ADDRSIZE; // DEPTH = 2**ADDRSIZE
	
	output [DATASIZE-1:0] rdata;
	input [DATASIZE-1:0] wdata;
	input [ADDRSIZE-1:0] waddr, raddr;
	input wclken, wclk, rclk;



//	SRAM_DP_32X32_wrapper MEM(
//                              .QB(rdata), 
							  
//                              .CLKA(wclk), 
//                              .CENA(~winc), //0有效
//                              .WENA(~winc), 
//                              .AA(waddr), 
//                              .DA(wdata), 
							  
//                              .CLKB(rclk), //clkb怎么设置？
//                              .CENB(~rinc), //0有效
//                              .WENB(1'b1), 
//                              .AB(raddr), 
//                              .DB(32'b0));
 	reg [DATASIZE-1:0] MEM [0:DEPTH-1];
	assign rdata = MEM[raddr];
	
	always @(posedge wclk)
		if (wclken) MEM[waddr] <= wdata;
		
endmodule
