
/*
combination logic
*/

`include "defines.sv"

module ex(
	input logic 				RST,
	input logic[`AluOpBus] 		aluop_i,
	input logic[`AluSelBus] 	alusel_i,
	input logic[`RegBus] 		reg1_i,
	input logic[`RegBus] 		reg2_i,
	input logic[`RegAddrBus]	waddr_i,
	input logic 				WE_i,
	
	output logic[`RegBus] 		wdata_o,
	output logic[`RegAddrBus] 	waddr_o,
	output logic 				WE_o
);
// logic result
logic[`RegBus] logicout;

// aluop_i 
always_comb begin
if(RST == `RstEnable) begin
    logicout =`ZeroWord;
end
else begin
    case(aluop_i)
        `EXE_OR_OP: begin 
            logicout = reg1_i | reg2_i;
        end
        // 
        default: begin
            //???
        end
    endcase
end
end

//
always_comb begin
	waddr_o = waddr_i;
	WE_o    = WE_i;
	case(alusel_i)
		`EXE_RES_LOGIC: begin
			wdata_o = logicout;
		end
		default: begin
			wdata_o = `ZeroWord;
		end
	endcase

end
endmodule