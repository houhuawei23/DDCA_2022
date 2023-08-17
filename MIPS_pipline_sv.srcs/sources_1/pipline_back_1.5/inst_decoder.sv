/*

*/
`include "defines.sv"
module id(
	input logic 				    RST,
	input logic[`InstAddrBus] 		pc_i,
	input logic[`InstBus] 			inst_i,
	input logic[`RegBus] 		    reg1_data_i,
	input logic[`RegBus] 		    reg2_data_i,
	
	input logic 					ex_WE_i,
	input logic[`RegBus] 			ex_wdata_i,
	input logic[`RegAddrBus] 		ex_waddr_i,

	input logic 					mem_WE_i,
	input logic[`RegBus] 			mem_wdata_i,
	input logic[`RegAddrBus] 		mem_waddr_i,
// output
	output logic 	                reg1_read_o,
	output logic 				    reg2_read_o,
	output logic[`RegAddrBus]  		raddr1_o,
	output logic[`RegAddrBus] 		raddr2_o,
	
	output logic[`AluOpBus]       	aluop_o,
	output logic[`AluSelBus] 	    alusel_o,
	
	output logic[`RegBus] 			rdata1_o,
	output logic[`RegBus] 			rdata2_o,
	
	output logic[`RegAddrBus] 		waddr_o,
	output logic 				    WE_o,

	output logic 	 				stallreq
);

assign stallreq = `NoStop;

logic[`RegBus]     imm_res;
logic[4:0] shamt;
assign shamt = inst_i[10:6];
// inst decode??
select select0(
    .RST(RST),
	.inst_i(inst_i),
	.reg1_data_i(reg1_data_i),
	.reg2_data_i(reg2_data_i),
	
    .WE_o(WE_o),
    .aluop_o(aluop_o),
    .alusel_o(alusel_o),
    .reg1_read_o(reg1_read_o),
    .reg2_read_o(reg2_read_o),
    .waddr_o(waddr_o),
	.raddr1_o(raddr1_o),
	.raddr2_o(raddr2_o),
	.imm_res_o(imm_res)
	);

logic[1:0] Forward_r1; // 00 none; 01 ex; 10 mem
logic[1:0] Forward_r2;
always_comb begin
	if((reg1_read_o == `ReadEnable) && 
	   (ex_WE_i == `WriteEnable) &&
	   (ex_waddr_i == raddr1_o)) begin
		Forward_r1 = 2'b01;	
	end
	else if((reg1_read_o == `ReadEnable)&&
			(mem_WE_i == `WriteEnable)&&
			(mem_waddr_i == raddr1_o))begin
		Forward_r1 = 2'b10;	
	end
	else Forward_r1 = 2'b00;

	if((reg2_read_o == `ReadEnable) && 
	   (ex_WE_i == `WriteEnable) &&
	   (ex_waddr_i == raddr2_o)) begin
		Forward_r2 = 2'b01;	
	end
	else if((reg2_read_o == `ReadEnable)&&
			(mem_WE_i == `WriteEnable)&&
			(mem_waddr_i == raddr2_o))begin
		Forward_r2 = 2'b10;	
	end
	else Forward_r2 = 2'b00;
end
// rdata1
always_comb begin
	if(RST == `RstEnable) begin
		rdata1_o = `ZeroWord;
	end
	else if(Forward_r1 == 2'b01) begin
		rdata1_o = ex_wdata_i;
	end
	else if(Forward_r1 == 2'b10) begin
		rdata1_o = mem_wdata_i;
	end
	else if(reg1_read_o == `ReadEnable)begin
		rdata1_o = reg1_data_i;
	end
	else if(reg1_read_o == `ReadDisable)begin
		if(alusel_o == `EXE_RES_SHIFT) begin
			rdata1_o = shamt;//sll v sra
		end
		else rdata1_o = imm_res;
	end
	else begin
		rdata1_o = `ZeroWord;
	end
end

// rdata2
always_comb begin
	if(RST == `RstEnable) begin
		rdata2_o = `ZeroWord;
	end
	else if(Forward_r2 == 2'b01) begin
		rdata2_o = ex_wdata_i;
	end
	else if(Forward_r2 == 2'b10) begin
		rdata2_o = mem_wdata_i;
	end
	else if(reg2_read_o == `ReadEnable)begin
		rdata2_o = reg2_data_i;
	end
	// else if(reg2_read_o == `ReadDisable)begin 
	// 	if(op == `Op_lui) rdata2_o = {imm, 16'b0};// upper
	// 	else rdata2_o = ZeroImm;
	// end
	else if(reg2_read_o == `ReadDisable)begin 
		rdata2_o = imm_res;
	end
	else begin
		rdata2_o = `ZeroWord;
	end
end


endmodule

module select(
    input logic RST,
	input logic[`InstBus]     inst_i,
	input logic[`RegBus]	  reg1_data_i,
	input logic[`RegBus]	  reg2_data_i,

	output logic 			  WE_o,
	output logic[`AluOpBus]   aluop_o,
	output logic[`AluSelBus]  alusel_o,
	output logic 	          reg1_read_o,
	output logic 			  reg2_read_o,
	output logic[`RegAddrBus] waddr_o,
	output logic[`RegAddrBus] raddr1_o,
	output logic[`RegAddrBus] raddr2_o,
	output logic[`RegBus]     imm_res_o
);
/////////////////////////////////////////
logic[5:0]  op;
// I type
logic[4:0]  rs;
logic[4:0]  rt;
logic[15:0] imm;
// R type
logic[4:0] rd;
logic[4:0] shamt;
logic[5:0] funct;
// J type
logic[25:0] addr;
logic[31:0] ZeroImm;
logic[31:0] ImmZero;
logic[31:0] SingnImm;
always_comb begin
// divide
op = inst_i[31:26]; //op

rs = inst_i[25:21];
rt = inst_i[20:16]; //op4
imm = inst_i[15:0];

rd = inst_i[15:11];
shamt = inst_i[10:6]; //op2
funct = inst_i[5:0]; //op3
addr = inst_i[25:0];

ZeroImm = {16'b0, imm};
ImmZero = {imm, 16'b0};
SingnImm = {{16{imm[15]}}, imm};

raddr1_o = rs;
raddr2_o = rt;

end

/////////////////////////////////////////////////
always_comb begin
if(RST == `RstEnable)begin
    aluop_o		= 0;
    alusel_o		= 0;
    waddr_o		= 0;
    WE_o 		 	= 0;
	reg1_read_o			= 0;
 	reg2_read_o			= 0;
end
else if(inst_i == 32'b0)begin
	WE_o 	   = `WriteDisable;
	aluop_o  = `EXE_NOP_OP;
	alusel_o = `EXE_RES_NOP;
	reg1_read_o    = `ReadDisable;
	reg2_read_o    = `ReadDisable;
	waddr_o = `NOPRegAddr;
end
else begin // RstDisable
case(op)
	`Op_Rtype: begin // R类型指令
		case(funct)
			// logic
			`Funct_and:begin
				WE_o      		= `WriteEnable;
				aluop_o   		= `EXE_AND_OP;
				alusel_o  		= `EXE_RES_LOGIC;
				reg1_read_o     = `ReadEnable;
				reg2_read_o     = `ReadEnable;
				waddr_o = rd;
			end
			`Funct_or:begin
				WE_o      		= `WriteEnable;
				aluop_o   		= `EXE_OR_OP;
				alusel_o  		= `EXE_RES_LOGIC;
				reg1_read_o	    = `ReadEnable;
				reg2_read_o     = `ReadEnable;
				waddr_o = rd;
			end
			`Funct_xor:begin
				WE_o      		= `WriteEnable;
				aluop_o   		= `EXE_XOR_OP;
				alusel_o  		= `EXE_RES_LOGIC;
				reg1_read_o     = `ReadEnable;
				reg2_read_o     = `ReadEnable;
				waddr_o = rd;
			end
			`Funct_nor:begin
				WE_o 	    	= `WriteEnable;
				aluop_o   		= `EXE_NOR_OP;
				alusel_o  		= `EXE_RES_LOGIC;
				reg1_read_o     = `ReadEnable;
				reg2_read_o     = `ReadEnable;
				waddr_o = rd;
			end
			// shift
			`Funct_sll:begin 
				WE_o 	       = `WriteEnable;
				aluop_o  	   = `EXE_SLL_OP;
				alusel_o 	   = `EXE_RES_SHIFT;
				reg1_read_o    = `ReadDisable;
				reg2_read_o    = `ReadEnable;
				waddr_o = rd;
			end
			`Funct_srl:begin 
				WE_o 	   	   = `WriteEnable;
				aluop_o  	   = `EXE_SRL_OP;
				alusel_o 	   = `EXE_RES_SHIFT;
				reg1_read_o    = `ReadDisable;
				reg2_read_o    = `ReadEnable;
				waddr_o = rd;
			end
			`Funct_sra:begin
				WE_o 	   = `WriteEnable;
				aluop_o  = `EXE_SRA_OP;
				alusel_o = `EXE_RES_SHIFT;
				reg1_read_o    = `ReadDisable;
				reg2_read_o    = `ReadEnable;
				waddr_o = rd;
			end
			`Funct_sllv:begin //
				WE_o 	    = `WriteEnable;
				aluop_o   = `EXE_SLL_OP;//?
				alusel_o  = `EXE_RES_SHIFT;
				reg1_read_o     = `ReadEnable;
				reg2_read_o     = `ReadEnable;
				waddr_o = rd;
			end
			`Funct_srlv:begin
				WE_o 	    = `WriteEnable;
				aluop_o   = `EXE_SRL_OP;
				alusel_o  = `EXE_RES_SHIFT;
				reg1_read_o     = `ReadEnable;
				reg2_read_o     = `ReadEnable;
				waddr_o = rd;
			end
			`Funct_srav:begin
				WE_o 	    = `WriteEnable;
				aluop_o   = `EXE_SRA_OP;
				alusel_o  = `EXE_RES_SHIFT;
				reg1_read_o     = `ReadEnable;
				reg2_read_o     = `ReadEnable;
				waddr_o = rd;
			end
			// move
			`Funct_movn:begin
				if(reg2_data_i != `ZeroWord) WE_o = `WriteEnable;
				else					WE_o = `WriteDisable;
				aluop_o   = `EXE_MOVN_OP;
				alusel_o  = `EXE_RES_MOVE;
				reg1_read_o     = `ReadEnable;
				reg2_read_o     = `ReadEnable;
				waddr_o = rd;
			end
			`Funct_movz:begin
				if(reg2_data_i == `ZeroWord) WE_o = `WriteEnable;
				else 					WE_o = `WriteDisable;
				aluop_o   = `EXE_MOVZ_OP;
				alusel_o  = `EXE_RES_MOVE;
				reg1_read_o     = `ReadEnable;
				reg2_read_o     = `ReadEnable;
				waddr_o = rd;
			end
			`Funct_mfhi:begin
				WE_o 	    = `WriteEnable;
				aluop_o   = `EXE_MFHI_OP;
				// alusel_o  = `EXE_RES_MOVE; ??
				reg1_read_o     = `ReadDisable;
				reg2_read_o     = `ReadDisable;
				waddr_o = rd;
			end
			`Funct_mflo:begin
				WE_o 	    = `WriteEnable;
				aluop_o   = `EXE_MFLO_OP;
				// alusel_o  = `EXE_RES_MOVE;
				reg1_read_o     = `ReadDisable;
				reg2_read_o     = `ReadDisable;
				waddr_o = rd;
			end
			`Funct_mthi:begin
				WE_o 	    = `WriteDisable;
				aluop_o   = `EXE_MTHI_OP;
				alusel_o  = `EXE_RES_MOVE;
				reg1_read_o     = `ReadEnable;
				reg2_read_o     = `ReadDisable;
				waddr_o = `NOPRegAddr;
			end
			`Funct_mtlo:begin
				WE_o 	    = `WriteDisable;
				aluop_o   	= `EXE_MTLO_OP;
				alusel_o  	= `EXE_RES_MOVE;
				reg1_read_o = `ReadEnable;
				reg2_read_o = `ReadDisable;
				waddr_o 	= `NOPRegAddr;
			end
////////////////////////////////////////////////////	
			// arithmetic
			`Funct_add:begin
				WE_o 	    = `WriteEnable;
				aluop_o   	= `EXE_ADD_OP;
				alusel_o  	= `EXE_RES_ARITHMETIC;
				reg1_read_o = `ReadEnable;
				reg2_read_o = `ReadEnable;
				waddr_o 	= rd;
			end
			`Funct_addu:begin
				WE_o 	    = `WriteEnable;
				aluop_o   	= `EXE_ADDU_OP;
				alusel_o  	= `EXE_RES_ARITHMETIC;
				reg1_read_o = `ReadEnable;
				reg2_read_o = `ReadEnable;
				waddr_o 	= rd;
			end
			`Funct_sub:begin
				WE_o 	    = `WriteEnable;
				aluop_o   	= `EXE_SUB_OP;
				alusel_o  	= `EXE_RES_ARITHMETIC;
				reg1_read_o = `ReadEnable;
				reg2_read_o = `ReadEnable;
				waddr_o 	= rd;
			end
			`Funct_subu:begin
				WE_o 	    = `WriteEnable;
				aluop_o   	= `EXE_SUBU_OP;
				alusel_o  	= `EXE_RES_MOVE;
				alusel_o  	= `EXE_RES_ARITHMETIC;
				reg1_read_o = `ReadEnable;
				reg2_read_o = `ReadEnable;
				waddr_o 	= rd;
			end
			`Funct_slt:begin
				WE_o 	    = `WriteEnable;
				aluop_o   	= `EXE_SLT_OP;
				alusel_o  	= `EXE_RES_ARITHMETIC;
				reg1_read_o = `ReadEnable;
				reg2_read_o = `ReadEnable;
				waddr_o 	= rd;
			end
			`Funct_sltu:begin
				WE_o 	    = `WriteEnable;
				aluop_o   	= `EXE_SLTU_OP;
				alusel_o  	= `EXE_RES_ARITHMETIC;
				reg1_read_o = `ReadEnable;
				reg2_read_o = `ReadEnable;
				waddr_o 	= rd;
			end
/////////////////////////////////////////////////
			`Funct_sync:begin
				WE_o 	    = `WriteDisable;
				aluop_o   = `EXE_NOP_OP;
				alusel_o  = `EXE_RES_NOP;
				reg1_read_o     = `ReadDisable;
				reg2_read_o     = `ReadEnable;
				waddr_o = `NOPRegAddr;
			end
			default:begin
				WE_o 	   = `WriteDisable;
				aluop_o  = `EXE_NOP_OP;
				alusel_o = `EXE_RES_NOP;
				reg1_read_o    = `ReadDisable;
				reg2_read_o    = `ReadDisable;
				waddr_o = `NOPRegAddr;
			end
		endcase
	end // op == `Rtype
	// not Rtype
	`Op_ori: begin
		WE_o      = `WriteEnable;
		aluop_o   = `EXE_OR_OP;
		alusel_o  = `EXE_RES_LOGIC; /*??*/
		reg1_read_o     = `ReadEnable;
		reg2_read_o     = `ReadDisable;
		waddr_o = rt;
		imm_res_o = ZeroImm;
		// instvalid
	end
	`Op_andi:begin
		WE_o      = `WriteEnable;
		aluop_o   = `EXE_AND_OP;
		alusel_o  = `EXE_RES_LOGIC; /*??*/
		reg1_read_o     = `ReadEnable;
		reg2_read_o     = `ReadDisable;
		waddr_o = rt;
		imm_res_o = ZeroImm;
	end
	`Op_xori:begin
		WE_o      = `WriteEnable;
		aluop_o   = `EXE_XOR_OP;
		alusel_o  = `EXE_RES_LOGIC; /*??*/
		reg1_read_o     = `ReadEnable;
		reg2_read_o     = `ReadDisable;
		waddr_o = rt;
		imm_res_o = ZeroImm;
	end
	`Op_lui:begin
		WE_o      = `WriteEnable;
		aluop_o   = `EXE_LUI_OP;
		alusel_o  = `EXE_RES_LOGIC; /*??*/
		reg1_read_o     = `ReadEnable;
		reg2_read_o     = `ReadDisable;
		waddr_o = rt;
		imm_res_o = ImmZero;
	end
// arithmetic
	`Op_addi:begin
		WE_o      = `WriteEnable;
		aluop_o   = `EXE_ADDI_OP;
		alusel_o  = `EXE_RES_ARITHMETIC; 
		reg1_read_o     = `ReadEnable;
		reg2_read_o     = `ReadDisable; //imm
		waddr_o = rt;
		imm_res_o = SingnImm;
	end
	`Op_addiu:begin
		WE_o      = `WriteEnable;
		aluop_o   = `EXE_ADDIU_OP;
		alusel_o  = `EXE_RES_ARITHMETIC; 
		reg1_read_o     = `ReadEnable;
		reg2_read_o     = `ReadDisable; //imm
		waddr_o = rt;
		imm_res_o = SingnImm;
	end
	`Op_slti:begin
		WE_o      = `WriteEnable;
		aluop_o   = `EXE_SLT_OP;
		alusel_o  = `EXE_RES_ARITHMETIC; 
		reg1_read_o     = `ReadEnable;
		reg2_read_o     = `ReadDisable; //imm
		waddr_o = rt;
		imm_res_o = SingnImm;
	end
	`Op_sltiu:begin
		WE_o      = `WriteEnable;
		aluop_o   = `EXE_SLTU_OP;
		alusel_o  = `EXE_RES_ARITHMETIC; 
		reg1_read_o     = `ReadEnable;
		reg2_read_o     = `ReadDisable; //imm
		waddr_o = rt;
		imm_res_o = SingnImm;
	end
	`Op_pref:begin //??
		WE_o      = `WriteEnable;
		aluop_o   = `EXE_NOP_OP;
		alusel_o  = `EXE_RES_NOP; /*??*/
		reg1_read_o     = `ReadDisable;
		reg2_read_o     = `ReadDisable;
		waddr_o = rt;
	end
	default: begin
		WE_o   = `WriteDisable;
		aluop_o= `EXE_NOP_OP;
		alusel_o = `EXE_RES_NOP; /*??*/
		reg1_read_o = 0;
		reg2_read_o = 0;
		waddr_o = 0;
	end
endcase // case op

end // RST else
end // always_comb
endmodule