
`include "defines.sv"
module mem(
	input logic 				RST,
	input logic[`RegBus] 		wdata_i,
	input logic[`RegAddrBus]	waddr_i,
	input logic 				WE_i,
	
	output logic[`RegBus]		wdata_o,
	output logic[`RegAddrBus]	waddr_o,
	output logic 				WE_o
);

always_comb begin
	if(RST == `RstEnable) begin
		wdata_o	<= `ZeroWord;
		waddr_o	<= `NOPRegAddr;
		WE_o		<= `WriteDisable;
	end
	else begin
		wdata_o	<= wdata_i;
		waddr_o	<= waddr_i;
	     WE_o	<= WE_i;
	end
end

endmodule