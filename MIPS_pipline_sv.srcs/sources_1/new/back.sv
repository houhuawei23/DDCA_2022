case(op)
	`Op_Rtype: begin // R类型指令
		case(shamt)
			5'b00000: begin
				case(funct)
					`Funct_and:begin
						WE      = `WriteEnable;
						aluop   = `EXE_AND_OP;
						alusel  = `EXE_RES_LOGIC;
						RE1     = `ReadEnable;
						RE2     = `ReadEnable;
						waddr_o = rd;
					end
					`Funct_or:begin
						WE      = `WriteEnable;
						aluop   = `EXE_OR_OP;
						alusel  = `EXE_RES_LOGIC;
						RE1	    = `ReadEnable;
						RE2     = `ReadEnable;
						waddr_o = rd;
					end
					`Funct_xor:begin
						WE      = `WriteEnable;
						aluop   = `EXE_XOR_OP;
						alusel  = `EXE_RES_LOGIC;
						RE1     = `ReadEnable;
						RE2     = `ReadEnable;
						waddr_o = rd;
					end
					`Funct_nor:begin
						WE 	    = `WriteEnable;
						aluop   = `EXE_NOR_OP;
						alusel  = `EXE_RES_LOGIC;
						RE1     = `ReadEnable;
						RE2     = `ReadEnable;
						waddr_o = rd;
					end
					`Funct_sllv:begin //
						WE 	    = `WriteEnable;
						aluop   = `EXE_SLL_OP;//?
						alusel  = `EXE_RES_SHIFT;
						RE1     = `ReadEnable;
						RE2     = `ReadEnable;
						waddr_o = rd;
					end
					`Funct_srlv:begin
						WE 	    = `WriteEnable;
						aluop   = `EXE_SLLV_OP;
						alusel  = `EXE_RES_SHIFT;
						RE1     = `ReadEnable;
						RE2     = `ReadEnable;
						waddr_o = rd;
					end
					`Funct_srav:begin
						WE 	    = `WriteEnable;
						aluop   = `EXE_SRAV_OP;
						alusel  = `EXE_RES_SHIFT;
						RE1     = `ReadEnable;
						RE2     = `ReadEnable;
						waddr_o = rt;
					end
					`Funct_sync:begin
						WE 	    = `WriteDisable;
						aluop   = `EXE_NOP_OP;
						alusel  = `EXE_RES_NOP;
						RE1     = `ReadDisable;
						RE2     = `ReadEnable;
						waddr_o = rt;
					end
					default:begin
					end
				endcase
			end
			default:begin
				WE 	   = `WriteDisable;
				aluop  = `EXE_NOP_OP;
				alusel = `EXE_RES_NOP;
				RE1    = `ReadDisable;
				RE2    = `ReadDisable;
				waddr_o = `NOPRegAddr;
			end
		endcase // case shamt
	end // op == `Rtype

	`Op_ori: begin
		WE      = `WriteEnable;
		aluop   = `EXE_OR_OP;
		alusel  = `EXE_RES_LOGIC; /*??*/
		RE1     = `ReadEnable;
		RE2     = `ReadDisable;
		waddr_o = rt;
		// instvalid
	end
	`Op_andi:begin
		WE      = `WriteEnable;
		aluop   = `EXE_XOR_OP;
		alusel  = `EXE_RES_LOGIC; /*??*/
		RE1     = `ReadEnable;
		RE2     = `ReadDisable;
		waddr_o = rt;
	end
	`Op_xori:begin
		WE      = `WriteEnable;
		aluop   = `EXE_XORI_OP;
		alusel  = `EXE_RES_LOGIC; /*??*/
		RE1     = `ReadEnable;
		RE2     = `ReadDisable;
		waddr_o = rt;
	end
	`Op_lui:begin
		WE      = `WriteEnable;
		aluop   = `EXE_LUI_OP;
		alusel  = `EXE_RES_LOGIC; /*??*/
		RE1     = `ReadEnable;
		RE2     = `ReadDisable;
		waddr_o = rt;
	end
	`Op_pref:begin //??
		WE      = `WriteEnable;
		aluop   = `EXE_NOP_OP;
		alusel  = `EXE_RES_NOP; /*??*/
		RE1     = `ReadDisable;
		RE2     = `ReadDisable;
		waddr_o = rt;
	end
	default: begin
		WE   = `WriteDisable;
		aluop= `EXE_NOP_OP;
		alusel = `EXE_RES_NOP; /*??*/
		RE1 = 0;
		RE2 = 0;
		waddr_o = 0;
	end
endcase // case op