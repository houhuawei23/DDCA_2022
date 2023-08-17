module mips(
	input logic clk, reset,
	output logic [31:0] pc,
	input logic [31:0] instr,
	output logic memwrite,
	output logic [31:0] aluout, writedata,
	input logic [31:0] readdata
);
logic memtoreg, alusrc, regdst, regwrite, jump, pcsrc, zero;
logic [2:0] alucontrol;
controller c(
            .op(instr[31:26]), 
            .funct(instr[5:0]), 
            .zero(zero), 
            .memtoreg(memtoreg), 
            .memwrite(memwrite), 
            .pcsrc(pcsrc), 
            .alusrc(alusrc), 
            .regdst(regdst), 
            .regwrite(regwrite), 
            .jump(jump), 
            .alucontrol(alucontrol)
);
datapath dp(
            .clk(clk), 
            .reset(reset), 
            
            .memtoreg(memtoreg), 
            .pcsrc(pcsrc), 
            .alusrc(alusrc), 
            .regdst(regdst), 
            .regwrite(regwrite),
            
            .jump(jump), 
            .alucontrol(alucontrol), 
            
            .zero(zero),//output
            .pc(pc), 
            .instr(instr), 
            .aluout(aluout), 
            .writedata(writedata), 
            .readdata(readdata)
);
endmodule