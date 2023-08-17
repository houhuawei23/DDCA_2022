`timescale 1ns / 1ps

module top(
    input logic clk, reset,
    output logic [31:0] writedata, adr,
    output logic memwrite
    );
logic [31:0]pc, instr, readdata;
mips_multi mips_multi0(

);

id_mem id_mem0(
    .clk(),
    .we(),
    .a(),
    .wd(),
    .rd()
);

endmodule
