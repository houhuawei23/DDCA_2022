
`include "defines.sv"
module mem(
	input logic 				RST,
	input logic[`RegBus] 		wdata_i,
	input logic[`RegAddrBus]	waddr_i,
	input logic 				WE_i,
	//
	input logic[`AluOpBus]		aluop_i,
	input logic[`DataAddrBus]	mem_addr_i,
	input logic[`RegBus]		reg2_i,

	input logic[`RegBus]		mem_data_i,//
    // mem hi lo in
	input logic[`RegBus]		hi_i,
	input logic[`RegBus] 		lo_i,
    input logic			 	    WE_hilo_i,

	output logic[`RegBus]		wdata_o,
	output logic[`RegAddrBus]	waddr_o,
	output logic 				WE_o,

	// output ex hi_lo regs
	output logic[`RegBus]		hi_o,
	output logic[`RegBus] 		lo_o,
	output logic 				WE_hilo_o,

	output logic[`DataAddrBus]	mem_addr_o,
	output logic				mem_we_o,
	output logic[3:0]			mem_sel_o,
	output logic[`RegBus]		mem_data_o,
	output logic				mem_ce_o
);

always_comb begin
	if(RST == `RstEnable) begin
		wdata_o	  	= `ZeroWord;
		waddr_o	  	= `NOPRegAddr;
		WE_o	  	= `WriteDisable;
		hi_o	  	= `ZeroWord;
		lo_o	  	= `ZeroWord;
		WE_hilo_o 	= `WriteDisable;
		mem_addr_o	= `ZeroWord;
		mem_we_o	= `WriteDisable;
		mem_sel_o	= 4'b0;
		mem_data_o	= `ZeroWord;
		mem_ce_o	= `ChipDisable;
	end
	else begin
		wdata_o	  	= wdata_i;
		waddr_o	  	= waddr_i;
	    WE_o	  	= WE_i;
		hi_o	  	= hi_i;
		lo_o	  	= lo_i;
		WE_hilo_o 	= WE_hilo_i;

		case(aluop_i)
			`EXE_LB_OP:begin
				mem_ce_o = `ChipEnable;
				mem_we_o = `WriteDisable;
				mem_addr_o = mem_addr_i;
					case (mem_addr_i[1:0])
						2'b00:	begin
							wdata_o = {{24{mem_data_i[31]}},mem_data_i[31:24]};
							mem_sel_o = 4'b1000;
						end
						2'b01:	begin
							wdata_o = {{24{mem_data_i[23]}},mem_data_i[23:16]};
							mem_sel_o = 4'b0100;
						end
						2'b10:	begin
							wdata_o = {{24{mem_data_i[15]}},mem_data_i[15:8]};
							mem_sel_o = 4'b0010;
						end
						2'b11:	begin
							wdata_o = {{24{mem_data_i[7]}},mem_data_i[7:0]};
							mem_sel_o = 4'b0001;
						end
						default:	begin
							wdata_o = `ZeroWord;
						end 
					endcase
			end
			`EXE_LBU_OP:begin // 无符号拓展
				mem_ce_o = `ChipEnable;
				mem_we_o = `WriteDisable;
				mem_addr_o = mem_addr_i;
					case (mem_addr_i[1:0])
						2'b00:	begin
							wdata_o = {{24{1'b0}},mem_data_i[31:24]};
							mem_sel_o = 4'b1000;
						end
						2'b01:	begin
							wdata_o = {{24{1'b0}},mem_data_i[23:16]};
							mem_sel_o = 4'b0100;
						end
						2'b10:	begin
							wdata_o = {{24{1'b0}},mem_data_i[15:8]};
							mem_sel_o = 4'b0010;
						end
						2'b11:	begin
							wdata_o = {{24{1'b0}},mem_data_i[7:0]};
							mem_sel_o = 4'b0001;
						end
						default:	begin
							wdata_o = `ZeroWord;
						end 
					endcase
			end
			`EXE_LH_OP:begin // 加载半字
				mem_addr_o = mem_addr_i;
				mem_we_o = `WriteDisable;
				mem_ce_o = `ChipEnable;
				case (mem_addr_i[1:0])
					2'b00:begin
						wdata_o = {{16{mem_data_i[31]}},mem_data_i[31:16]};
						mem_sel_o = 4'b1100;
					end
					2'b10:begin
						wdata_o = {{16{mem_data_i[15]}},mem_data_i[15:0]};
						mem_sel_o = 4'b0011;
					end
					default:begin
						wdata_o = `ZeroWord;
					end
				endcase		
			end
			`EXE_LHU_OP:begin // 加载半字
				mem_addr_o = mem_addr_i;
				mem_we_o = `WriteDisable;
				mem_ce_o = `ChipEnable;
				case (mem_addr_i[1:0])
					2'b00:begin
						wdata_o = {{16{1'b0}},mem_data_i[31:16]};
						mem_sel_o = 4'b1100;
					end
					2'b10:begin
						wdata_o = {{16{1'b0}},mem_data_i[15:0]};
						mem_sel_o = 4'b0011;
					end
					default:begin
						wdata_o = `ZeroWord;
					end
				endcase		
			end
			`EXE_LW_OP:begin
				mem_addr_o = mem_addr_i;
				mem_we_o = `WriteDisable;
				wdata_o = mem_data_i;
				mem_sel_o = 4'b1111;
				mem_ce_o = `ChipEnable;	
			end
			`EXE_SB_OP:begin // 存储字
				mem_addr_o = mem_addr_i;
				mem_we_o = `WriteEnable;
				mem_data_o = {reg2_i[7:0],reg2_i[7:0],reg2_i[7:0],reg2_i[7:0]};
				mem_ce_o = `ChipEnable;
				case (mem_addr_i[1:0])
					2'b00:	begin
						mem_sel_o = 4'b1000;
					end
					2'b01:	begin
						mem_sel_o = 4'b0100;
					end
					2'b10:	begin
						mem_sel_o = 4'b0010;
					end
					2'b11:	begin
						mem_sel_o = 4'b0001;	
					end
					default:	begin
						mem_sel_o = 4'b0000;
					end
				endcase		
			end
			`EXE_SH_OP:begin //存储半字节
				mem_addr_o = mem_addr_i;
				mem_we_o = `WriteEnable;
				mem_data_o = {reg2_i[15:0],reg2_i[15:0]};
				mem_ce_o = `ChipEnable;
				case (mem_addr_i[1:0])
					2'b00:	begin
						mem_sel_o = 4'b1100;
					end
					2'b10:	begin
						mem_sel_o = 4'b0011;
					end
					default:	begin
						mem_sel_o = 4'b0000;
					end
				endcase						
			end
			`EXE_SW_OP:begin //存储字
				mem_addr_o = mem_addr_i;
				mem_we_o = `WriteEnable;
				mem_data_o = reg2_i;
				mem_sel_o = 4'b1111;	
				mem_ce_o = `ChipEnable;		
			end
			default:begin
				mem_addr_o = `ZeroWord;
				mem_we_o = `WriteDisable;
				mem_sel_o = 4'b0000;
				mem_data_o = `ZeroWord;
				mem_ce_o = `ChipDisable;	
			end
		endcase
	end
end

endmodule