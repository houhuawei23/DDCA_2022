/*
if_id:
input:
    
output:
*/
`include "defines.sv"
module if_id_reg(
    input logic                 CLK,
    input logic                 RST,
    input logic[5:0]            stall,
    input logic [`InstAddrBus]  if_pc,
    input logic [`InstBus]      if_inst,

    output logic [`InstAddrBus] id_pc,
    output logic [`InstBus]     id_inst
);
  always_ff @(posedge CLK, negedge RST) begin
    if (RST == `RstEnable) begin
      id_pc   <= 0;
      id_inst <= 0;
    end 
    else if(stall[1] ==`Stop && stall[2] == `NoStop) begin 
      id_pc   <= `ZeroWord;
      id_inst <= `ZeroWord;
    end
    else if(stall[1] == `NoStop) begin
      id_pc   <= if_pc;
      id_inst <= if_inst;
    end
    else begin
      id_pc   <= id_pc;
      id_inst <= id_inst;
    end
  end
endmodule
