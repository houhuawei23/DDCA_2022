/*
2r1w
*/
`include "defines.sv"

module regfile(
	input logic 				CLK,
	input logic 				RST,
	
	input logic 				WE,
	input logic[`RegAddrBus] 	waddr,
	input logic[`RegBus] 		wdata,
	
	input logic 				RE1,
	input logic[`RegAddrBus]	raddr1,
	output logic[`RegBus] 		rdata1,
	input logic 				RE2,
	input logic[`RegAddrBus] 	raddr2,
	output logic[`RegBus] 		rdata2);

reg[`RegBus] regs[0:`RegNum -1];

// Write

always_ff@(posedge CLK, negedge RST)begin
	if(RST == `RstDisable) begin
		if((WE == `WriteEnable) && (waddr != `RegNumLog2'b0))begin
			regs[waddr] <= wdata;
		end
	end
	else begin
	
	end
end
// Read1
always_ff@(posedge CLK, negedge RST)begin
	if((RST == `RstEnable) || 
	   (raddr1 == `RegNumLog2 'b0) ||
	   (RE1 == `ReadDisable))begin
		rdata1 <= `ZeroWord;
	end
	else begin
		rdata1 <= regs[raddr1];
	end
end
// Read2
always_ff@(posedge CLK, negedge RST)begin
	if((RST == `RstEnable) || 
	   (raddr2 == `RegNumLog2 'b0)|| 
	   (RE2 == `ReadDisable))begin
		rdata2 <= `ZeroWord;
	end
	else begin
		rdata2 <= regs[raddr2];
	end
end
endmodule