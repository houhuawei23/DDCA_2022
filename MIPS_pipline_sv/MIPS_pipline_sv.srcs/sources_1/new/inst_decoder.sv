/*
input: 
	RST,
	pc,
	inst,
	rdata1,
	rdata2,
output:
	RE1,
	RE2,
	raddr1,
	raddr2,
	
	aluop,
	alusel,
	
	
*/
`include "defines.sv"
module id(
	input logic 				    RST,
	input logic[`InstAddrBus] 		pc,
	input logic[`InstBus] 			inst,
	input logic[`RegBus] 		    rdata1,
	input logic[`RegBus] 		    rdata2,
	
	output logic 	                RE1,
	output logic 				    RE2,
	output logic[`RegAddrBus]  		raddr1_o,
	output logic[`RegAddrBus] 		raddr2_o,
	
	output logic[`AluOpBus]       	aluop,
	output logic[`AluSelBus] 	    alusel,
	
	output logic[`RegBus] 			rdata1_o,
	output logic[`RegBus] 			rdata2_o,
	
	output logic[`RegAddrBus] 		waddr_o,
	output logic 				    WE
);
logic[5:0] op;
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
logic[31:0] imm_unsigned_ext;
logic[31:0] imm_signed_ext;
always_comb begin
// divide
op = inst[31:26];

rs = inst[25:21];
rt = inst[20:16];
imm = inst[15:0];

rd = inst[15:11];
shamt = inst[10:6];
funct = inst[5:0];

addr = inst[25:0];
imm_unsigned_ext = {16'b0, imm};
imm_signed_ext = {{16{imm[15]}}, imm};
end
assign raddr1_o = rs;
assign raddr2_o = rt;

// inst decode??
always_comb begin
	if(RST == `RstEnable)begin
		aluop		= 0;
		alusel		= 0;
		waddr_o		= 0;
		WE 		 	= 0;
	end
	else begin
		case(op)
			`Op_ori: begin
				WE   = `WriteEnable;
				aluop= `EXE_OR_OP;
				alusel = `EXE_RES_LOGIC; /*??*/
				RE1 = 1;
				RE2 = 0;
				waddr_o = rt;
				// instvalid
			end
			default: begin
				WE   = `WriteDisable;
				aluop= `EXE_NOP_OP;
				alusel = `EXE_RES_NOP; /*??*/
				RE1 = 0;
				RE2 = 0;
				waddr_o = 0;
			end
		endcase
	end
end
// rdata1
always_comb begin
	if(RST == `RstEnable) begin
		rdata1_o = `ZeroWord;
	end
	else if(RE1 == 1)begin
		rdata1_o = rdata1;
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
	else if(RE2 == 1)begin
		rdata2_o = rdata1;
	end
	else if(RE2 == 0)begin //��������
		rdata2_o = imm_unsigned_ext;
	end
	else begin
		rdata2_o = `ZeroWord;
	end
end





end //
end //RST else
endmodule