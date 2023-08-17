
`include "defines.sv"
module mem(
	input logic 				RST,
	input logic[`RegBus] 		wdata_i,
	input logic[`RegAddrBus]	waddr_i,
	input logic 				WE_i,
    // mem hi lo in
	input logic[`RegBus]		hi_i,
	input logic[`RegBus] 		lo_i,
    input logic			 	    WE_hilo_i,

	output logic[`RegBus]		wdata_o,
	output logic[`RegAddrBus]	waddr_o,
	output logic 				WE_o,

	// output ex hi_lo regs
	output logic[`RegBus]		hi_o,
	output logic[`RegBus] 		lo_o,
	output logic 				WE_hilo_o
);

always_comb begin
	if(RST == `RstEnable) begin
		wdata_o	  <= `ZeroWord;
		waddr_o	  <= `NOPRegAddr;
		WE_o	  <= `WriteDisable;
		hi_o	  <= `ZeroWord;
		lo_o	  <= `ZeroWord;
		WE_hilo_o <= `WriteDisable;
	end
	else begin
		wdata_o	  <= wdata_i;
		waddr_o	  <= waddr_i;
	    WE_o	  <= WE_i;
		hi_o	  <= hi_i;
		lo_o	  <= lo_i;
		WE_hilo_o <= WE_hilo_i;
	end
end

endmodule