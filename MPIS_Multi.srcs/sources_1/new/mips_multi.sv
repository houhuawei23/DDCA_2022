`timescale 1ns / 1ps

module mips_multi(
    input logic clk, reset,
    input logic [31:0] readdata,
	input logic [31:0] instr,
	
    output logic [31:0] aluout, writedata,
    output logic memwrite,
    output logic [31:0] pc
    );



controller controller0(
    .op(op),
    .funct(funct),
    .zero(zero),
    
    .pcen(pcen),
    .iord(iord),
    .memwrite(memwrite),//
    .irwrite(irwrite),
    .regdst(regdst),
    .memtoreg(memtoreg),
    .regwrite(regwrite),
    .alusrca(alusrca),
    .alusrcb(alusrcb),
    .alucontrol(alucontrol)
);

datapath datapath0(
    .pcen(pcen),
    .iord(iord),
//    .memwrite(memwrite),
    .irwrite(irwrite),
    .regdst(regdst),
    .memtoreg(memtoreg),
    .regwrite(regwrite),
    .alusrca(alusrca),
    .alusrcb(alusrcb),
    .alucontrol(alucontrol),
    
    .op(op),
    .funct(funct),
    .zero(zero)
    
    
);
endmodule
