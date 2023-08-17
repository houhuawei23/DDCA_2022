`include "defines.sv"
module mem_wb_reg(
	input logic 				CLK,
	input logic 				RST,
	input logic[`RegBus]		mem_wdata,
	input logic[`RegAddrBus]	mem_waddr,
	input logic 				mem_WE,
	
	output logic[`RegBus]		wb_wdata,
	output logic[`RegAddrBus]	wb_waddr,
	output logic 				wb_WE
);
always_ff@(posedge CLK, negedge RST)begin
	if(RST == `RstEnable)begin
		wb_wdata <= `ZeroWord;
		wb_waddr <= `NOPRegAddr;
		wb_WE    <= `WriteDisable;
	end
	else begin
		wb_wdata <= mem_wdata;
		wb_waddr <= mem_waddr;
	    wb_WE   <= mem_WE;
	end
end

endmodule