`timescale 1ns / 1ps
`include "defines.sv"
module inst_rom(
    input logic               CE,
    input logic[`InstAddrBus] addr,
    output logic[`InstBus]    inst
);

reg[`InstBus]  inst_mem[0:`InstMemNum-1];
initial $readmemh ( "C:/Users/hhw/fpga/DDCA_2022/MIPS_pipline_sv/MIPS_pipline_sv.srcs/inst_rom_arithmetic.data", inst_mem);

always_comb begin
    if(CE == `ChipDisable) begin
        inst <= `ZeroWord;
    end 
    else begin // addr[]
        inst <= inst_mem[addr[`InstMemNumLog2 + 1: 2]];
    end
    
end

endmodule


