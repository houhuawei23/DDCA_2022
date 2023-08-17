`timescale 1ns / 1ps
`include "defines.sv"
module mips_pipline_sopc(
    input logic CLK,
    input logic RST
);
logic[`InstAddrBus] inst_addr;
logic[`InstBus]     inst;
logic               rom_ce;
logic               mem_we_i;
logic[`DataAddrBus] mem_addr_i;
logic[`DataBus]     mem_data_i;
logic[`DataBus]     mem_data_o;
logic[3:0]          mem_sel_i;  
logic               mem_ce_i;  
 
mips_pipline mips_pipline0(
    .CLK(CLK),
    .RST(RST),
    // inst
    .rom_data_i(inst),
    .rom_addr_o(inst_addr),
    .rom_ce_o(rom_ce),
    // data
    .ram_we_o   (mem_we_i),
    .ram_addr_o (mem_addr_i),
    .ram_data_i (mem_data_o),
    .ram_data_o (mem_data_i),
    .ram_sel_o  (mem_sel_i),
    .ram_ce_o   (mem_ce_i)
);
inst_rom inst_rom0(
	.addr(inst_addr),
	.inst(inst),
	.CE(rom_ce)	
);

data_ram data_ram0(
    .CLK    (CLK),

    .we     (mem_we_i),
    .addr   (mem_addr_i),
    .sel    (mem_sel_i),
    .data_i (mem_data_i),
    .data_o (mem_data_o),
    .ce     (mem_ce_i)
);
endmodule
