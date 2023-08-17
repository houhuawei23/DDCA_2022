`timescale 1ns / 1ps
`include "defines.sv"

module mips_pipline_sopc_tb();

logic CLK_50;
logic RST;
initial begin
    CLK_50 <= 1'b0;
    forever #10 CLK_50 <= ~CLK_50;
end

initial begin
    RST <= `RstEnable;
    #200 RST <= `RstDisable;
//    #1000 $stop;
end
mips_pipline_sopc mips_pipline_sopc0(
    .CLK(CLK_50),
    .RST(RST)
);
endmodule
