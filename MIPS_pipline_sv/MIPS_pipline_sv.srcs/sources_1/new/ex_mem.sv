`include "defines.sv"
module ex_mem_reg       (
    input  logic 				CLK,
    input  logic 				RST,
    input  logic[`RegBus]		ex_wdata,
    input  logic[`RegAddrBus]	ex_waddr,
    input  logic 				ex_WE,
    output logic[`RegBus] 	    mem_wdata,
    output logic[`RegAddrBus]   mem_waddr,
    output logic 				mem_WE
);

always_ff@(posedge CLK, negedge RST)begin
    if(RST == `RstEnable) begin
        mem_wdata <= `ZeroWord;
        mem_waddr <= `NOPRegAddr;
        mem_WE    <= `WriteDisable;
    end
    else begin
        mem_wdata <= ex_wdata;
        mem_waddr <= ex_waddr;
        mem_WE    <= ex_WE;
    end
end

endmodule