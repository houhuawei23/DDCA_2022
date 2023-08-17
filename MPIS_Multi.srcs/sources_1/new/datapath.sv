`timescale 1ns / 1ps

module datapath(
    input logic clk, reset,
    
    input logic readdata,
    
    input logic pcen,
    input logic iord,
    input logic irwrite,
    input logic regdst,
    input logic memtoreg,
    input logic regwrite,
    input logic alusrca,
    input logic [1:0] alusrcb,
    input logic [2:0] alucontrol,
    input logic pcsrc,
    
    output logic [5:0] op,
    output logic [5:0] funct,
    output logic zero,
    output logic adr,//adr
    output logic [31:0] aluout,
    output logic [31:0] writedata
    );
logic [31:0] pc, instr, data, wd3, rd1, rd2;
logic [31:0] a,b, srca, srcb;
logic [4:0]ra1, ra2, wa3;
logic [31:0] signimm, signimmsh, aluresult;
//logic [31:0] ;
   
assign op = instr[31:26];
assign funct = instr[5:0];
assign ra1 = instr[25:21];
assign ra2 = instr[20:16];
//pc�Ĵ���
flopre #(32) pcreg(
    .clk(clk),
    .reset(reset),
    .enable(pcen),
    .d(pcnext),
    .q(pc)
);
//IorDѡ��
mux2 #(32) adrmux(
    .d0(pc),
    .d1(aluout),
    .sel(iord),
    .y(adr)
);
//IRWrite ָ��Ĵ���
flopre #(32) irreg(
    .clk(clk),
    .reset(reset),
    .enable(irwrite),
    .d(readdata),
    .q(instr)
);
//���ݼĴ���
flopre #(32) datareg(
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .d(readdata),
    .q(data)
);
//�Ĵ����ļ�
regfile rf(
    .clk(clk),
    .we3(regwrite),
    .ra1(ra1),
    .ra2(ra2),
    .wa3(wa3),
    .wd3(wd3),
    
    .rd1(rd1),
    .rd2(rd2)
);
//�Ĵ���д��ַѡ��
mux2 #(5) wa3mux(
    .d0(instr[20:16]),
    .d1(instr[15:11]),
    .sel(regdst),
    .y(wa3)
);
//�Ĵ���д����ѡ��
mux2 #(32) wd3mux(
    .d0(aluout),
    .d1(data),
    .sel(memtoreg),
    .y(wd3)
);
//�Ĵ����ļ�������rd1�Ĵ���
flopre #(32) rd1reg(
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .d(rd1),
    .q(a)
);
//�Ĵ����ļ�������rd2�Ĵ���
flopre #(32) rd2reg(
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .d(rd1),
    .q(b)
);
//������������չ
signext se(
    .a(instr[15:0]),
    .y(signimm)
);
//������չ��������λ
sl2 sl(
    .a(signimm),
    .y(signimmsh)
);
//�ӷ�������srcaѡ��
mux2 #(32) srcamux(
    .d0(pc),
    .d1(a),
    .sel(alusrca),
    .y(srca)
);
//�ӷ�������srcbѡ��
mux4 #(32) srcbmux(
    .d0(b),
    .d1(4),
    .d2(signimm),
    .d3(signimmsh),
    .sel(alusrcb),
    .y(srcb)
);
//�ӷ���
alu aluab(
    .A(srca),
    .B(srcb),
    .F(alucontrol),
    .Y(aluresult),
    .zero(zero)
);
//aluout�Ĵ���
flopre #(32) aluoutreg(
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .d(aluresult),
    .q(aluout)
);
//pcnextѡ��
mux2 #(32) pcnextmux(
    .d0(aluresult),
    .d1(aluout),
    .sel(pcsrc),
    .y(pcnext)
);
endmodule






















