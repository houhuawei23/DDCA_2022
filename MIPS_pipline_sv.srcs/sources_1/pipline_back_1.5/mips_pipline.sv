`timescale 1ns / 1ps
`include "defines.sv"
module mips_pipline(
    input logic                  CLK,
    input logic                  RST,
    input logic[`InstBus]        rom_data_i,

    output logic[`InstAddrBus]   rom_addr_o,
    output logic                 rom_ce_o
    );
// fectch
logic[`InstAddrBus] pc;

// decode
logic[`InstAddrBus] id_pc_i;
logic[`InstBus]     id_inst_i;

logic reg1_read, reg2_read;
logic[`RegAddrBus]  reg1_addr;
logic[`RegAddrBus]  reg2_addr;

logic[`AluOpBus]    id_aluop_o;
logic[`AluSelBus]   id_alusel_o;

logic[`RegBus]      id_reg1_o;
logic[`RegBus]      id_reg2_o;

logic[`RegBus]      reg1_data;
logic[`RegBus]      reg2_data;

logic               id_WE_o;
logic[`RegAddrBus]  id_waddr_o;

// Execute
logic[`AluOpBus]    ex_aluop_i;
logic[`AluSelBus]   ex_alusel_i;

logic[`RegBus]      ex_reg1_i;
logic[`RegBus]      ex_reg2_i;
logic               ex_WE_i;
logic[`RegAddrBus]  ex_waddr_i;

logic               ex_WE_o;
logic[`RegAddrBus]  ex_waddr_o;
logic[`RegBus] 		ex_wdata_o;

// memory
logic               mem_WE_i;
logic[`RegAddrBus]  mem_waddr_i;
logic[`RegBus] 		mem_wdata_i;

logic               mem_WE_o;
logic[`RegAddrBus]  mem_waddr_o;
logic[`RegBus] 		mem_wdata_o;
// writeback
logic               wb_WE_i;
logic[`RegAddrBus]  wb_waddr_i;
logic[`RegBus] 		wb_wdata_i;

// hi lo regs -> ex
logic[`RegBus]		hi;
logic[`RegBus] 		lo;

// ex hi lo out
logic 				ex_WE_hilo_o;
logic[`RegBus]		ex_hi_o;
logic[`RegBus] 		ex_lo_o;
// mem hi lo in
logic 				mem_WE_hilo_i;
logic[`RegBus]		mem_hi_i;
logic[`RegBus] 		mem_lo_i;
// mem hi lo out
logic 				mem_WE_hilo_o;
logic[`RegBus]		mem_hi_o;
logic[`RegBus] 		mem_lo_o;
// mem hi lo in
logic 				wb_WE_hilo_i;
logic[`RegBus]		wb_hi_i;
logic[`RegBus] 		wb_lo_i;

// stall
logic[5:0]          stall;
logic               stallreq_from_id;
logic               stallreq_from_ex;
// pc_reg
pc_reg pc0(
    .CLK(CLK),
    .RST(RST),
    .stall(stall),
    .pc(pc),
    .CE(rom_ce_o)
);

assign rom_addr_o = pc;

//if_id_reg
if_id_reg if_id_reg0(
    .CLK(CLK),
    .RST(RST),
    .stall(stall),
    .if_pc(pc),
    .if_inst(rom_data_i),

    .id_pc(id_pc_i),
    .id_inst(id_inst_i)
);


// id
id id0(
    .RST(RST),
    .pc_i(id_pc_i),
    .inst_i(id_inst_i),

    .reg1_data_i(reg1_data),
    .reg2_data_i(reg2_data),

    .ex_WE_i(ex_WE_o),
    .ex_wdata_i(ex_wdata_o),
    .ex_waddr_i(ex_waddr_o),

    .mem_WE_i(mem_WE_o),
    .mem_wdata_i(mem_wdata_o),
    .mem_waddr_i(mem_waddr_o),
    
    .reg1_read_o(reg1_read),
    .reg2_read_o(reg2_read),
    .raddr1_o(reg1_addr),
    .raddr2_o(reg2_addr),

    .aluop_o(id_aluop_o),
    .alusel_o(id_alusel_o),
    .rdata1_o(id_reg1_o),
    .rdata2_o(id_reg2_o),
    .waddr_o(id_waddr_o),
    .WE_o(id_WE_o),
    .stallreq(stallreq_from_id)
);
// regfile
regfile regfile0(
    .CLK(CLK),
    .RST(RST),

    .WE(wb_WE_i),
    .waddr(wb_waddr_i),
    .wdata(wb_wdata_i),

    .RE1(reg1_read), // Read Enable
    .raddr1(reg1_addr),
    .rdata1(reg1_data),

    .RE2(reg2_read), // Read Enable
    .raddr2(reg2_addr),
    .rdata2(reg2_data)
);
// id_ex_reg
id_ex_reg id_ex_reg0(
    .CLK(CLK),
    .RST(RST),
    .stall(stall),
    // id out
    .id_aluop(id_aluop_o),
    .id_alusel(id_alusel_o),
    .id_reg1(id_reg1_o),
    .id_reg2(id_reg2_o),
    .id_waddr(id_waddr_o),
    .id_WE(id_WE_o),
    // ex in
    .ex_aluop(ex_aluop_i),
    .ex_alusel(ex_alusel_i),
    .ex_reg1(ex_reg1_i),
    .ex_reg2(ex_reg2_i),

    .ex_waddr(ex_waddr_i),
    .ex_WE(ex_WE_i)
);
//ex

ex ex0(
    .RST(RST),
// ex input
    .aluop_i(ex_aluop_i),
    .alusel_i(ex_alusel_i),
    .reg1_i(ex_reg1_i),
    .reg2_i(ex_reg2_i),
    .waddr_i(ex_waddr_i),
    .WE_i(ex_WE_i),
	// hi_lo regs -> ex
	.hi_i(hi),
	.lo_i(lo),
	// mem forwarding -> ex
	.mem_WE_hilo_i(mem_WE_hilo_o),
	.mem_hi_i(mem_hi_o),
	.mem_lo_i(mem_lo_o),

	// wb forwarding -> ex
	.wb_WE_hilo_i(wb_WE_hilo_i),
	.wb_hi_i(wb_hi_i),
	.wb_lo_i(wb_lo_i),
//ex output
	// universial regs write
    .wdata_o(ex_wdata_o),
    .waddr_o(ex_waddr_o),
    .WE_o(ex_WE_o),
	// output exe hi_lo regs
	.WE_hilo_o(ex_WE_hilo_o),
	.hi_o     (ex_hi_o),
	.lo_o     (ex_lo_o),
    .stallreq (stallreq_from_ex)
);

// ex_mem_reg
ex_mem_reg ex_mem_reg0(
    .CLK(CLK),
    .RST(RST),
    .stall(stall),
// ex output
    .ex_wdata(ex_wdata_o),
    .ex_waddr(ex_waddr_o),
    .ex_WE(ex_WE_o),
    // ex hi lo in
    .ex_hi(ex_hi_o),
    .ex_lo(ex_lo_o),
    .ex_WE_hilo(ex_WE_hilo_o),
// mem input
    .mem_wdata(mem_wdata_i),
    .mem_waddr(mem_waddr_i),
    .mem_WE(mem_WE_i),
    // mem hi lo out
    .mem_hi(mem_hi_i),
    .mem_lo(mem_lo_i),
    .mem_WE_hilo(mem_WE_hilo_i)
);


// mem
mem mem0(
    .RST(RST),
// mem input
    .wdata_i(mem_wdata_i),
    .waddr_i(mem_waddr_i),
    .WE_i(mem_WE_i),
    // mem hi lo in
    .hi_i(mem_hi_i),
    .lo_i(mem_lo_i),
    .WE_hilo_i(mem_WE_hilo_i),
// mem output
    .wdata_o(mem_wdata_o),
    .waddr_o(mem_waddr_o),
    .WE_o(mem_WE_o),
    // output ex hi_lo regs
    .hi_o(mem_hi_o),
    .lo_o(mem_lo_o),
    .WE_hilo_o(mem_WE_hilo_o)
); 

// mem_wb_reg
mem_wb_reg mem_wb_reg0(
    .CLK(CLK),
    .RST(RST),
    .stall(stall),
// mem output
    .mem_wdata(mem_wdata_o),
    .mem_waddr(mem_waddr_o),
    .mem_WE(mem_WE_o),
    // mem hi lo 
    .mem_hi(mem_hi_o),
    .mem_lo(mem_lo_o),
    .mem_WE_hilo(mem_WE_hilo_o),
// wb input
    .wb_wdata(wb_wdata_i),
    .wb_waddr(wb_waddr_i),
    .wb_WE(wb_WE_i),
    // wb hi lo
    .wb_hi(wb_hi_i),
    .wb_lo(wb_lo_i),
    .wb_WE_hilo(wb_WE_hilo_i)
);
// hilo_reg
hilo_reg hilo_reg0(
    .CLK(CLK),
    .RST(RST),
    .WE(wb_WE_hilo_i),
    .hi_i(wb_hi_i),
    .lo_i(wb_lo_i),
    .hi_o(hi),
    .lo_o(lo)
);
// ctrl
ctrl ctrl0(
    .rst(rst),
    .stallreq_from_id(stallreq_from_id),
    .stallreq_from_ex(stallreq_from_ex),
    .stall(stall) 
);
endmodule
