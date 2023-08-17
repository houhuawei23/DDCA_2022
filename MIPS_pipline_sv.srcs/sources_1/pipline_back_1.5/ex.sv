
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
	// hi_lo regs
	input logic[`RegBus]		hi_i,
	input logic[`RegBus] 		lo_i,
	// mem forwarding 
	input logic			 		mem_WE_hilo_i,
	input logic[`RegBus]		mem_hi_i,
	input logic[`RegBus] 		mem_lo_i,

	// wb forwarding 
	input logic 				wb_WE_hilo_i,
	input logic[`RegBus]		wb_hi_i,
	input logic[`RegBus] 		wb_lo_i,

	// universial regs write
	output logic[`RegBus] 		wdata_o,
	output logic[`RegAddrBus] 	waddr_o,
	output logic 				WE_o,

	// output exe hi_lo regs
	output logic 				WE_hilo_o,
	output logic[`RegBus]		hi_o,
	output logic[`RegBus] 		lo_o,

	output logic 				stallreq
);
assign stallreq = `NoStop;
// results
logic[`RegBus] logic_res;
logic[`RegBus] shift_res;
logic[`RegBus] move_res;
logic[`RegBus] arithmetic_res;
logic[`DoubleRegBus] mul_res;	

logic[`RegBus] hi;
logic[`RegBus] lo;

logic overflow;
logic reg1_eq_reg2;
logic reg1_lt_reg2;

logic[`RegBus] reg2_i_mux; //re2_i mux
logic[`RegBus] reg1_i_not; //reg1_i not
logic[`RegBus] result_sum; // add result

logic[`RegBus] opdata1_mult; // mult
logic[`RegBus] opdata2_mult;
logic[`DoubleRegBus] hilo_temp; //64bit

logic[4:0] shamt;
assign shamt = reg1_i[4:0];


// forwarding hi lo
always_comb begin
	if(RST == `RstEnable) begin
    	hi = `ZeroWord;
		lo = `ZeroWord;
	end
	else if(mem_WE_hilo_i == `WriteEnable)begin
    	hi = mem_hi_i;
		lo = mem_lo_i;
	end
	else if(wb_WE_hilo_i == `WriteEnable)begin
    	hi = wb_hi_i;
		lo = wb_lo_i;
	end
	else begin
    	hi = hi_i;
		lo = lo_i;
	end
end

assign reg2_i_mux = ((aluop_i == `EXE_SUB_OP)||
					 (aluop_i == `EXE_SUBU_OP)||
					 (aluop_i ==`EXE_SLT_OP)) ?
					 (~reg2_i) + 1 : reg2_i;

assign result_sum = reg1_i + reg2_i_mux;

assign overflow = ((!reg1_i[31] && !reg2_i_mux[31]) && result_sum[31]) ||
				((reg1_i[31] && reg2_i_mux[31]) && (!result_sum[31]));  

assign reg1_lt_reg2 = ((aluop_i == `EXE_SLT_OP)) ?
						((reg1_i[31] && !reg2_i[31]) || 
						(!reg1_i[31] && !reg2_i[31] && result_sum[31])||
			            (reg1_i[31] && reg2_i[31] && result_sum[31]))
			            :(reg1_i < reg2_i);

assign reg1_i_not = ~reg1_i;
// aluop_i 
// arithmetic
always_comb begin
if(RST == `RstEnable) begin
    arithmetic_res =`ZeroWord;
end
else begin
case(aluop_i)
	`EXE_SLT_OP, `EXE_SLTU_OP: begin // less than
		arithmetic_res = reg1_lt_reg2;
	end
	`EXE_ADD_OP, `EXE_ADDI_OP, `EXE_ADDU_OP, // add and sub
	`EXE_ADDIU_OP,`EXE_SUB_OP, `EXE_SUBU_OP:begin 
		arithmetic_res = result_sum;
	end
	default begin
		arithmetic_res = `ZeroWord;
	end
endcase
end
end

// logic
always_comb begin
if(RST == `RstEnable) begin
    logic_res =`ZeroWord;
end
else begin
    case(aluop_i)
	    // logic
        `EXE_OR_OP: begin 
            logic_res = reg1_i | reg2_i;
        end
		`EXE_AND_OP:begin
			logic_res = reg1_i & reg2_i;
		end
		`EXE_NOR_OP:begin
			logic_res = ~(reg1_i |reg2_i);
		end
		`EXE_XOR_OP:begin
			logic_res = reg1_i ^ reg2_i;
		end
		`EXE_LUI_OP:begin
			logic_res = reg2_i;
		end

		default:begin
			logic_res = `ZeroWord;
		end
    endcase
end
end
// shift
always_comb begin
if(RST == `RstEnable)begin
	shift_res = `ZeroWord;
end
else begin
	case(aluop_i)
		`EXE_SLL_OP:begin
			shift_res = reg2_i << shamt;
		end
		`EXE_SRL_OP:begin
			shift_res = reg2_i >> shamt;
		end
		`EXE_SRA_OP:begin
			shift_res =  ($signed(reg2_i)) >>> shamt;
		end
		default:begin
			shift_res = `ZeroWord;
		end
	endcase
end // else end
end // always_comb end

// move
always_comb begin
if(RST == `RstEnable)begin
	move_res = `ZeroWord;
end
else begin
	case(aluop_i)
		`EXE_MOVN_OP: move_res = reg1_i;
		`EXE_MOVZ_OP: move_res = reg1_i;
		`EXE_MFHI_OP: move_res = hi;
		`EXE_MFLO_OP: move_res = lo;
		default:      move_res = `ZeroWord;
	endcase
	
end // else end
end // always_comb end

// wdata_o
always_comb begin
	waddr_o = waddr_i;

	if(((aluop_i == `EXE_ADD_OP) || (aluop_i == `EXE_ADDI_OP) || 
	    (aluop_i == `EXE_SUB_OP)) && (overflow == 1'b1)) begin
	 	WE_o = `WriteDisable;
	end else begin
	  WE_o = WE_i;
	end
	case(alusel_i)
		`EXE_RES_LOGIC: begin
			wdata_o = logic_res;
		end
		`EXE_RES_SHIFT:begin
			wdata_o = shift_res;
		end
		`EXE_RES_MOVE: wdata_o = move_res;
		`EXE_RES_ARITHMETIC: wdata_o = arithmetic_res;
		default: begin
			wdata_o = `ZeroWord;
		end
	endcase
end
// hi_o lo_o
always_comb begin
if(RST == `RstEnable)begin
	WE_hilo_o = `WriteDisable;
	hi_o 	  = `ZeroWord;
	lo_o 	  = `ZeroWord;
end
else if(aluop_i == `EXE_MTHI_OP)begin 
	WE_hilo_o = `WriteEnable;
	hi_o 	  = reg1_i;
	lo_o 	  = lo;
end
else if(aluop_i == `EXE_MTLO_OP)begin 
	WE_hilo_o = `WriteEnable;
	hi_o 	  = hi;
	lo_o 	  = reg1_i;
end
else begin 
	WE_hilo_o = `WriteDisable;
	hi_o 	  = `ZeroWord;
	lo_o 	  = `ZeroWord;
end
end // comb

endmodule