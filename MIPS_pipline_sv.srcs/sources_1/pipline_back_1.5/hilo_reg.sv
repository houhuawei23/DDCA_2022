
`include "defines.sv"

module hilo_reg(
    input logic           CLK,
    input logic           RST,
    input logic           WE,
    input logic[`RegBus]  hi_i,
    input logic[`RegBus]  lo_i,
    output logic[`RegBus] hi_o,
    output logic[`RegBus] lo_o
);
always_ff@(posedge CLK, negedge RST)begin //??
    if(RST == `RstEnable) begin
        hi_o <= `ZeroWord;
        lo_o <= `ZeroWord;
    end
    else if(WE == `WriteEnable)begin
        hi_o <= hi_i;
        lo_o <= lo_i;
    end
    else begin
        hi_o <= hi_o;
        lo_o <= lo_o;
    end

end

endmodule