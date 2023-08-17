
`include "defines.sv"

module id_ex_reg(
	input logic 				CLK,
	input logic 				RST,
	input logic[`InstAddrBus]	id_inst,
	input logic[5:0]			stall,
	input logic[`AluOpBus]		id_aluop,
	input logic[`AluSelBus]		id_alusel,
	input logic[`RegBus]		id_reg1,
	input logic[`RegBus]		id_reg2,
	input logic[`RegAddrBus]	id_waddr,
	input logic 				id_WE,
	
	// jump branch
	input logic					id_is_in_delayslot,
	input logic[`InstAddrBus]	id_link_addr,
	input logic					next_inst_in_delayslot_i,

	output logic[`AluOpBus] 	ex_aluop,
	output logic[`AluSelBus] 	ex_alusel,
	output logic[`RegBus]	 	ex_reg1,
	output logic[`RegBus]	 	ex_reg2,
	output logic[`RegAddrBus] 	ex_waddr,
	output logic				ex_WE,
	// jump branch
	output logic 				ex_is_in_delayslot,
	output logic[`InstAddrBus] 	ex_link_addr,
	output logic 				is_in_delayslot_o,

	output logic[`InstBus]		ex_inst
);

always_ff@(posedge CLK, negedge RST)begin
	if(RST == `RstEnable) begin
		ex_aluop  <= `EXE_NOP_OP;
		ex_alusel <= `EXE_RES_NOP;
		ex_reg1   <= `ZeroWord;
		ex_reg2   <= `ZeroWord;
		ex_waddr  <= `NOPRegAddr;
		ex_WE	  <= `WriteDisable;
		ex_link_addr 		<= `ZeroWord;
		ex_is_in_delayslot 	<= `NotInDelaySlot;
		is_in_delayslot_o 	<= `NotInDelaySlot;	
		ex_inst	  <= `ZeroWord;
	end
	else if(stall[2] == `Stop && stall[3] == `NoStop) begin 
		ex_aluop  <= `EXE_NOP_OP;
		ex_alusel <= `EXE_RES_NOP;
		ex_reg1   <= `ZeroWord;
		ex_reg2   <= `ZeroWord;
		ex_waddr  <= `NOPRegAddr;
		ex_WE	  <= `WriteDisable;
		ex_link_addr 		<= `ZeroWord;
		ex_is_in_delayslot 	<= `NotInDelaySlot;
		is_in_delayslot_o 	<= `NotInDelaySlot;	
		ex_inst	  <= `ZeroWord;
	end
	else if(stall[2] == `NoStop)begin
		ex_aluop  <= id_aluop;
		ex_alusel <= id_alusel;
		ex_reg1   <= id_reg1;
		ex_reg2   <= id_reg2;
		ex_waddr  <= id_waddr;
		ex_WE	  <= id_WE;
		ex_link_addr 		<= id_link_addr;
		ex_is_in_delayslot 	<= id_is_in_delayslot;
		is_in_delayslot_o 	<=	next_inst_in_delayslot_i;	
		ex_inst	  <= id_inst;
	end
	else begin
		ex_aluop  	<= ex_aluop ;
		ex_alusel 	<= ex_alusel;
		ex_reg1   	<= ex_reg1  ;
		ex_reg2   	<= ex_reg2  ;
		ex_waddr  	<= ex_waddr ;
		ex_WE	  	<= ex_WE	 ;
		ex_link_addr 		<= ex_link_addr;
		ex_is_in_delayslot 	<= ex_is_in_delayslot;
		is_in_delayslot_o 	<=	is_in_delayslot_o;
		ex_inst		<= ex_inst;	
	end
end
endmodule