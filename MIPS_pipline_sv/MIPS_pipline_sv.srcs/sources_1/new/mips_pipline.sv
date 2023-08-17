`timescale 1ns / 1ps
`include "defines.sv"
module mips_pipline(
    input logic                 CLK,
    input logic                 RST,
    input logic[`InstBus]        rom_data_i,

    output logic[`InstAddrBus]   rom_addr_o,
    output logic                rom_ce_o
    );
// fectch
logic[`InstAddrBus] pc_f;

// decode
logic[`InstAddrBus] pc_d;
logic[`InstBus]     inst_d;

logic RE1, RE2;
logic[`RegAddrBus]  raddr1;
logic[`RegAddrBus]  raddr2;

logic[`AluOpBus]    aluop_d;
logic[`AluSelBus]   alusel_d;

logic[`RegBus]      reg1_d;
logic[`RegBus]      reg2_d;
logic[`RegBus]      rdata1;
logic[`RegBus]      rdata2;
logic               WE_d;
logic[`RegAddrBus]  waddr_d;

// Execute
logic[`AluOpBus]    aluop_e;
logic[`AluSelBus]   alusel_e;

logic[`RegBus]      reg1_e;
logic[`RegBus]      reg2_e;
logic               WE_e;
logic[`RegAddrBus]  waddr_e;

logic               WE_eo;
logic[`RegAddrBus]  waddr_eo;
logic[`RegBus] 		wdata_eo;

// memory
logic               WE_m;
logic[`RegAddrBus]  waddr_m;
logic[`RegBus] 		wdata_m;

logic               WE_mo;
logic[`RegAddrBus]  waddr_mo;
logic[`RegBus] 		wdata_mo;
// writeback
logic               WE_w;
logic[`RegAddrBus]  waddr_w;
logic[`RegBus] 		wdata_w;
// pc_reg
pc_reg pc0(
    .CLK(CLK),
    .RST(RST),
    .pc(pc_f),
    .CE(rom_ce_o)
);

assign rom_addr_o = pc_f;

//if_id_reg
if_id_reg if_id_reg0(
    .CLK(CLK),
    .RST(RST),
    .if_pc(pc_f),
    .if_inst(rom_data_i),

    .id_pc(pc_d),
    .id_inst(inst_d)
);


// id
id id0(
    .RST(RST),
    .pc(pc_d),
    .inst(inst_d),

    .rdata1(rdata1),
    .rdata2(rdata2),
    .RE1(RE1),
    .RE2(RE2),
    .raddr1_o(raddr1),
    .raddr2_o(raddr2),
    .aluop(aluop_d),
    .alusel(alusel_d),
    .rdata1_o(reg1_d),
    .rdata2_o(reg2_d),
    .waddr_o(waddr_d),
    .WE(WE_d)
);
// regfile
regfile regfile0(
    .CLK(CLK),
    .RST(RST),
    .WE(WE_w),
    .waddr(waddr_w),
    .wdata(wdata_w),
    .RE1(RE1),
    .raddr1(raddr1),
    .rdata1(rdata1),
    .RE2(RE2),
    .raddr2(raddr2),
    .rdata2(rdata2)
);
// id_ex_reg
id_ex_reg id_ex_reg0(
    .CLK(CLK),
    .RST(RST),
    .id_aluop(aluop_d),
    .id_alusel(alusel_d),
    .id_reg1(reg1_d),
    .id_reg2(reg2_d),
    .id_waddr(waddr_d),
    .id_WE(WE_d),
    .ex_aluop(aluop_e),
    .ex_alusel(alusel_e),
    .ex_reg1(reg1_e),
    .ex_reg2(reg2_e),
    .ex_waddr(waddr_e),
    .ex_WE(WE_e)
);
//ex
ex ex0(
    .RST(RST),
    .aluop_i(aluop_e),
    .alusel_i(alusel_e),
    .reg1_i(reg1_e),
    .reg2_i(reg2_e),
    .waddr_i(waddr_e),
    .WE_i(WE_e),

    .wdata_o(wdata_eo),
    .waddr_o(waddr_eo),
    .WE_o(WE_eo)   
);
// ex_mem_reg
ex_mem_reg ex_mem_reg0(
    .CLK(CLK),
    .RST(RST),
    .ex_wdata(wdata_eo),
    .ex_waddr(waddr_eo),
    .ex_WE(WE_eo),
    .mem_wdata(wdata_m),
    .mem_waddr(waddr_m),
    .mem_WE(WE_m)
);
// mem
mem mem0(
    .RST(RST),
    .wdata_i(wdata_m),
    .waddr_i(waddr_m),
    .WE_i(WE_m),
    .wdata_o(wdata_mo),
    .waddr_o(waddr_mo),
    .WE_o(WE_mo) 
); 
// mem_wb_reg
mem_wb_reg mem_wb_reg0(
    .CLK(CLK),
    .RST(RST),
    .mem_wdata(wdata_mo),
    .mem_waddr(waddr_mo),
    .mem_WE(WE_mo),
    .wb_wdata(wdata_w),
    .wb_waddr(waddr_w),
    .wb_WE(WE_w)   
);

endmodule
