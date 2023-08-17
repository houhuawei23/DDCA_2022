`include "defines.sv"
module ex_mem_reg       (
    input logic 				CLK,
    input logic 				RST,
    input logic[5:0]            stall,
    input logic[`RegBus]		ex_wdata,
    input logic[`RegAddrBus]	ex_waddr,
    input logic 				ex_WE,
    // ex hi lo
	input logic[`RegBus]		ex_hi,
	input logic[`RegBus] 		ex_lo,
	input logic 				ex_WE_hilo,
    
    output logic[`RegBus] 	    mem_wdata,
    output logic[`RegAddrBus]   mem_waddr,
    output logic 				mem_WE,

    // mem hi lo
	output logic[`RegBus]		mem_hi,
	output logic[`RegBus] 		mem_lo,
    output logic			 	mem_WE_hilo
);

always_ff@(posedge CLK, negedge RST)begin
    if(RST == `RstEnable) begin
        mem_wdata     <= `ZeroWord;
        mem_waddr     <= `NOPRegAddr;
        mem_WE        <= `WriteDisable;
        mem_hi        <= `ZeroWord;
        mem_lo        <= `ZeroWord;
        mem_WE_hilo   <= `WriteDisable;
    end
    else if(stall[3] == `Stop && stall[4] == `NoStop) begin
        mem_wdata     <= `ZeroWord;
        mem_waddr     <= `NOPRegAddr;
        mem_WE        <= `WriteDisable;
        mem_hi        <= `ZeroWord;
        mem_lo        <= `ZeroWord;
        mem_WE_hilo   <= `WriteDisable;
    end
    else if(stall[3] == `NoStop) begin
        mem_wdata     <= ex_wdata;
        mem_waddr     <= ex_waddr;
        mem_WE        <= ex_WE;
        mem_hi        <= ex_hi;
        mem_lo        <= ex_lo;
        mem_WE_hilo   <= ex_WE_hilo;
    end
    else begin
        mem_wdata     <= mem_wdata  ;
        mem_waddr     <= mem_waddr  ;
        mem_WE        <= mem_WE     ;
        mem_hi        <= mem_hi     ;
        mem_lo        <= mem_lo     ;
        mem_WE_hilo   <= mem_WE_hilo;
    end
end

endmodule