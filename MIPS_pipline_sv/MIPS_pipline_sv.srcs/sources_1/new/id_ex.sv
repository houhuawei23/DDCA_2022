
`include "defines.sv"

module id_ex_reg(
	input logic 				CLK,
	input logic 				RST,
	input logic[`AluOpBus]		id_aluop,
	input logic[`AluSelBus]		id_alusel,
	input logic[`RegBus]		id_reg1,
	input logic[`RegBus]		id_reg2,
	input logic[`RegAddrBus]	id_waddr,
	input logic 				id_WE,
	
	output logic[`AluOpBus] 	ex_aluop,
	output logic[`AluSelBus] 	ex_alusel,
	output logic[`RegBus]	 	ex_reg1,
	output logic[`RegBus]	 	ex_reg2,
	output logic[`RegAddrBus] 	ex_waddr,
	output logic				ex_WE
);

always_ff@(posedge CLK, negedge RST)begin
	if(RST == `RstEnable) begin
		ex_aluop  <= `EXE_NOP_OP;
		ex_alusel <= `EXE_RES_NOP;
		ex_reg1   <= `ZeroWord;
		ex_reg2   <= `ZeroWord;
		ex_waddr  <= 0;
		ex_WE	  <= `WriteDisable;
	end
	else begin
		ex_aluop  <= id_aluop;
		ex_alusel <= id_alusel;
		ex_reg1   <= id_reg1;
		ex_reg2   <= id_reg2;
		ex_waddr  <= id_waddr;
		ex_WE	  <= id_WE;
	end
end
endmodule