`include "defines.sv"
module mem_wb_reg(
	input logic 				CLK,
	input logic 				RST,
	input logic[5:0]			stall,
	input logic[`RegBus]		mem_wdata,
	input logic[`RegAddrBus]	mem_waddr,
	input logic 				mem_WE,
	// mem hi lo 
	input logic[`RegBus]		mem_hi,
	input logic[`RegBus] 		mem_lo,
	input logic 				mem_WE_hilo,

	output logic[`RegBus]		wb_wdata,
	output logic[`RegAddrBus]	wb_waddr,
	output logic 				wb_WE,
    // wb hi lo
	output logic[`RegBus]		wb_hi,
	output logic[`RegBus] 		wb_lo,
    output logic			 	wb_WE_hilo
);
always_ff@(posedge CLK, negedge RST)begin
	if(RST == `RstEnable)begin
		wb_wdata 	 <= `ZeroWord;
		wb_waddr 	 <= `NOPRegAddr;
		wb_WE    	 <= `WriteDisable;
		wb_hi	  	 <= `ZeroWord;
		wb_lo        <= `ZeroWord;
		wb_WE_hilo   <= `WriteDisable;
	end
	else if(stall[4] == `Stop && stall[5] == `NoStop)begin
		wb_wdata 	 <= `ZeroWord;
		wb_waddr 	 <= `NOPRegAddr;
		wb_WE    	 <= `WriteDisable;
		wb_hi	  	 <= `ZeroWord;
		wb_lo        <= `ZeroWord;
		wb_WE_hilo   <= `WriteDisable;
	end
	else if(stall[4] == `NoStop)begin
		wb_wdata     <= mem_wdata;
		wb_waddr     <= mem_waddr;
	    wb_WE        <= mem_WE;
		wb_hi	  	 <= mem_hi;
		wb_lo      	 <= mem_lo;
		wb_WE_hilo   <= mem_WE_hilo;
	end
	else begin 
		wb_wdata     <= wb_wdata  ;
		wb_waddr     <= wb_waddr  ;
	    wb_WE        <= wb_WE     ;
		wb_hi	  	 <= wb_hi	  ;
		wb_lo      	 <= wb_lo     ;
		wb_WE_hilo   <= wb_WE_hilo;
	end
end

endmodule