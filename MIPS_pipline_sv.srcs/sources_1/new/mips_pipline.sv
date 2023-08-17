`timescale 1ns / 1ps
`include "defines.sv"
module mips_pipline(
    input logic                  CLK,
    input logic                  RST,
    // inst
    input logic[`InstBus]        rom_data_i,

    output logic[`InstAddrBus]   rom_addr_o,
    output logic                 rom_ce_o,
    // data
	input  logic[`DataBus]       ram_data_i,
	output logic[`DataAddrBus]   ram_addr_o,
	output logic[`DataBus]       ram_data_o,
	output logic                 ram_we_o,
	output logic[3:0]            ram_sel_o,
	output logic[3:0]            ram_ce_o
    );
// wire
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

    logic               id_is_in_delayslot_o;
    logic[`InstAddrBus] id_link_address_o;	
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

    logic               ex_is_in_delayslot_i;	
    logic[`InstAddrBus] ex_link_address_i;	
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
    //jump/branch
    logic is_in_delayslot_i;
    logic is_in_delayslot_o;
    logic next_inst_in_delayslot_o;
    logic id_branch_flag_o;
    logic[`RegBus] branch_target_address;
// pc_reg
pc_reg pc_reg0(
    .CLK(CLK),
    .RST(RST),
    .stall(stall),
    .branch_flag_i(id_branch_flag_o),
    .branch_target_address_i(branch_target_address),
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

logic[`InstBus] id_inst_o;
logic[`InstBus] ex_inst_i;
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
    //is_in_delayslot_i
    .is_in_delayslot_i(is_in_delayslot_i),

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
    //jump branch
    .is_in_delayslot_o(id_is_in_delayslot_o),

    .next_inst_in_delayslot_o(next_inst_in_delayslot_o),//
    .branch_flag_o(id_branch_flag_o),//
    .branch_target_address_o(branch_target_address),//
    .link_addr_o(id_link_address_o),//
    .inst_o(id_inst_o),
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
    .id_inst(id_inst_o),
    // id out
    .id_aluop(id_aluop_o),
    .id_alusel(id_alusel_o),
    .id_reg1(id_reg1_o),
    .id_reg2(id_reg2_o),
    .id_waddr(id_waddr_o),
    .id_WE(id_WE_o),

    .id_is_in_delayslot(id_is_in_delayslot_o),
    .id_link_addr(id_link_address_o),
    .next_inst_in_delayslot_i(next_inst_in_delayslot_o),


    // ex in
    .ex_aluop(ex_aluop_i),
    .ex_alusel(ex_alusel_i),
    .ex_reg1(ex_reg1_i),
    .ex_reg2(ex_reg2_i),

    .ex_waddr(ex_waddr_i),
    .ex_WE(ex_WE_i),

    .ex_is_in_delayslot(ex_is_in_delayslot_i),
    .ex_link_addr(ex_link_address_i),
    .is_in_delayslot_o(is_in_delayslot_i),

    .ex_inst(ex_inst_i)
);
//ex
logic[`AluOpBus]		ex_aluop_o;
logic[`DataAddrBus]	    ex_mem_addr_o;
logic[`RegBus]		    ex_reg2_o;
ex ex0(
    .RST(RST),
    // ex input
    .inst_i(ex_inst_i),
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
    // jump
    .is_in_delayslot_i(ex_is_in_delayslot_i),
    .link_addr_i(ex_link_address_i),

    //ex output
	// universial regs write
    .wdata_o(ex_wdata_o),
    .waddr_o(ex_waddr_o),
    .WE_o(ex_WE_o),
	// output exe hi_lo regs
	.WE_hilo_o(ex_WE_hilo_o),
	.hi_o     (ex_hi_o),
	.lo_o     (ex_lo_o),
    //
    .aluop_o    (ex_aluop_o),
    .mem_addr_o (ex_mem_addr_o),
    .reg2_o     (ex_reg2_o),
    .stallreq (stallreq_from_ex)
);
logic[`AluOpBus]		mem_aluop_i;
logic[`DataAddrBus]	    mem_mem_addr_i;
logic[`RegBus]		    mem_reg2_i;
// ex_mem_reg
ex_mem_reg ex_mem_reg0(
    .CLK(CLK),
    .RST(RST),
    .stall(stall),
    // ex output
    .ex_wdata(ex_wdata_o),
    .ex_waddr(ex_waddr_o),
    .ex_WE(ex_WE_o),
    //load store in
    .ex_aluop   (ex_aluop_o   ),
    .ex_mem_addr(ex_mem_addr_o),
    .ex_reg2    (ex_reg2_o    ),
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
    .mem_WE_hilo(mem_WE_hilo_i),
    .mem_aluop   (mem_aluop_i),
    .mem_mem_addr(mem_mem_addr_i),
    .mem_reg2    (mem_reg2_i)
);


// mem
mem mem0(
    .RST(RST),
    // mem input
    .wdata_i(mem_wdata_i),
    .waddr_i(mem_waddr_i),
    .WE_i(mem_WE_i),
    // load store
    .aluop_i    (mem_aluop_i),
    .mem_addr_i (mem_mem_addr_i),
    .reg2_i     (mem_reg2_i),
    .mem_data_i (ram_data_i),
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
    .WE_hilo_o(mem_WE_hilo_o),
    .mem_addr_o (ram_addr_o),
    .mem_we_o   (ram_we_o),
    .mem_sel_o  (ram_sel_o),
    .mem_data_o (ram_data_o),
    .mem_ce_o   (ram_ce_o)
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
