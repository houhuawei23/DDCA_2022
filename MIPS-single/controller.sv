module controller(
	input logic [5:0] op, funct,
	input logic zero,
	output logic memtoreg, memwrite,
	output logic pcsrc, alusrc,
	output logic regdst, regwrite,
	output logic jump,
	output logic [2:0] alucontrol
);
logic [1:0] aluop;
logic branch; 
// pc 是否分支；若为分支指令且Zero标志有效，则选择PCBranch
maindec md(
            .op(op), 
            .memtoreg(memtoreg), 
            .memwrite(memwrite), 
            .branch(branch), 
            .alusrc(alusrc), 
            .regdst(regdst), 
            .regwrite(regwrite), 
            .jump(jump), 
            .aluop(aluop));
aludec ad(
            .funct(funct), 
            .aluop(aluop), 
            .alucontrol(alucontrol));
assign pcsrc = branch & zero;
endmodule