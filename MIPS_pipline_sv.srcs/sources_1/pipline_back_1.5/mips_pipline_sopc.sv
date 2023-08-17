`timescale 1ns / 1ps
`include "defines.sv"
module mips_pipline_sopc(
    input logic CLK,
    input logic RST
);
logic[`InstAddrBus] inst_addr;
logic[`InstBus]     inst;
logic               rom_ce;
mips_pipline mips_pipline0(
    .CLK(CLK),
    .RST(RST),
    .rom_data_i(inst),
    .rom_addr_o(inst_addr),
    .rom_ce_o(rom_ce)
);
inst_rom inst_rom0(
	.addr(inst_addr),
	.inst(inst),
	.CE(rom_ce)	
);
endmodule
