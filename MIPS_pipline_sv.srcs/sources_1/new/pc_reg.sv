`include "defines.sv"
/*
pc_reg
input:
    clk, rst
output:
    pc, ce
*/
module pc_reg(
	input logic 				CLK,
	input logic 				RST,
	input logic[5:0]			stall,
	// branch
	input logic					branch_flag_i,
	input logic[`RegBus]		branch_target_address_i,
	output logic[`InstAddrBus]	pc,
	output logic 				CE // chip enable
);
always_ff@(posedge CLK, negedge RST)begin
	if(RST == `RstEnable)begin
		CE <= `ChipDisable;
	end
	else begin
		CE <= `ChipEnable;
	end
end

always_ff@(posedge CLK) begin
	if(CE == `ChipDisable)begin 
		pc <= 32'b0;
	end
	else if(stall[0] == `Stop)begin
		pc <= pc;
	end
	else if(branch_flag_i == `Branch)begin
		pc <= branch_target_address_i;
	end
	else begin
		pc <= pc + 4;
	end
end
endmodule