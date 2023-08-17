module datapath(
	input logic clk, reset,
	input logic memtoreg, pcsrc,
	input logic alusrc, regdst,
	input logic regwrite, jump,
	input logic [2:0] alucontrol,
	output logic zero,
	output logic [31:0] pc,
	input logic [31:0] instr,
	output logic [31:0] aluout, writedata,
	input logic [31:0] readdata
);
logic [4:0] writereg;
logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
logic [31:0] signimm, signimmsh;
logic [31:0] srca, srcb;
logic [31:0] result;
// next PC logic
// PC 寄存器
flopr #(32) pcreg(
            .clk(clk), 
            .reset(reset), 
            .d(pcnext), 
            .q(pc)
);
// pc + 4
adder pcadd1(
            .a(pc), 
            .b(32'b100), 
            .y(pcplus4)
);

// 左移两位
sl2 immsh(
            .a(signimm), 
            .y(signimmsh));
// PC + signimmsh
adder pcadd2(
            .a(pcplus4), 
            .b(signimmsh), 
            .y(pcbranch));
// PC 分支选择器
mux2 #(32) pcbrmux(
            .d0(pcplus4), 
            .d1(pcbranch), 
            .s(pcsrc), 
            .y(pcnextbr));
// PC 选择器
mux2 #(32) pcmux(
            .d0(pcnextbr), 
            .d1({pcplus4[31:28], instr[25:0], 2'b00}), //JTA
            .s(jump), // 如果jump则跳到JTA
            .y(pcnext));

// register file logic
regfile rf(
            .clk(clk), 
            .we3(regwrite), 
            .ra1(instr[25:21]), 
            .ra2(instr[20:16]), 
            .wa3(writereg), 
            .wd3(result), // result 写到wd3
            .rd1(srca), 
            .rd2(writedata));
mux2 #(5) wrmux(
            .d0(instr[20:16]), 
            .d1(instr[15:11]), 
            .s (regdst), 
            .y (writereg));

mux2 #(32) resmux(
            .d0(aluout), 
            .d1(readdata), 
            .s(memtoreg), 
            .y(result));
//符号扩展
signext se(
            .a(instr[15:0]), 
            .y(signimm));
// ALU logic
mux2 #(32) srcbmux(
            .d0(writedata), 
            .d1(signimm), 
            .s (alusrc), 
            .y (srcb));
alu alu(
            .A(srca), 
            .B(srcb), 
            .F(alucontrol), 
            .Y(aluout), 
            .zero(zero));
endmodule