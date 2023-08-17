// inst mem
`define InstBus        31:0
`define InstAddrBus    31:0
`define InstMemNum     131072 // 128k
`define InstMemNumLog2 17  

`define RstEnable      1'b0 
`define RstDisable     1'b1

`define ChipEnable    1'b1
`define ChipDisable   1'b0 

`define WriteEnable	  1'b1
`define WriteDisable  1'b0

`define ReadEnable   1'b1
`define ReadDisable   1'b0

`define Stop 1'b1
`define NoStop 1'b0

// branch
`define Branch      1'b1
`define NotBranch   1'b0
// delayslot
`define InDelaySlot     1'b1
`define NotInDelaySlot  1'b0

// data
`define DataAddrBus 31:0
`define DataBus 31:0
`define DataMemNum 131072 //2^17 128k 
`define DataMemNumLog2 17
`define ByteWidth 7:0 

`define RegAddrBus    4:0
`define RegBus        31:0
`define RegNum        32
`define RegNumLog2    5

`define ZeroWord      32'b0
`define AluOpBus	  7:0	
`define AluSelBus  	  2:0

// opcode of the instruction
`define Op_pref     6'b110_011
`define Op_andi     6'b001_100
`define Op_ori     	6'b001_101
`define Op_xori     6'b001_110 
`define Op_lui      6'b001_111

`define Op_addi     6'b001_000
`define Op_addiu    6'b001_001
`define Op_slti     6'b001_010
`define Op_sltiu    6'b001_011

// jump
`define Op_j        6'b000_010
`define Op_jal      6'b000_011
// branch
`define Op_beq      6'b000_100
`define Op_bgtz     6'b000_111
`define Op_blez     6'b000_110
`define Op_bne      6'b000_101
// load save
`define Op_lb       6'b100_000
`define Op_lbu      6'b100_100
`define Op_lh       6'b100_001
`define Op_lhu      6'b100_101
`define Op_lw       6'b100_011

`define Op_sb       6'b101_000
`define Op_sh       6'b101_001
`define Op_sw       6'b101_011

`define Op_Rtype    6'b000_000

// funct code
`define Funct_and   6'b100100
`define Funct_or    6'b100101
`define Funct_xor   6'b100110
`define Funct_nor   6'b100111
// shift
`define Funct_sll   6'b000000
`define Funct_srl   6'b000010
`define Funct_sra   6'b000011
`define Funct_sllv  6'b000100
`define Funct_srlv  6'b000110
`define Funct_srav  6'b000111
// move
`define Funct_movn  6'b001011
`define Funct_movz  6'b001010
`define Funct_mfhi  6'b010000
`define Funct_mflo  6'b010010
`define Funct_mthi  6'b010001
`define Funct_mtlo  6'b010011
// arithmetic
`define Funct_add   6'b100_000
`define Funct_addu  6'b100_001
`define Funct_sub   6'b100_010
`define Funct_subu  6'b100_011
`define Funct_slt   6'b101_010
`define Funct_sltu  6'b101_011

// jump
`define Funct_jr    6'b001_000
`define Funct_jalr  6'b001_001

// sync
`define Funct_sync  6'b001111


`define EXE_SPECIAL_INST    6'b000000
`define EXE_REGIMM_INST     6'b000001
`define EXE_SPECIAL2_INST   6'b011100

//AluOp
`define EXE_AND_OP   8'b00100100
`define EXE_OR_OP    8'b00100101
`define EXE_XOR_OP   8'b00100110
`define EXE_NOR_OP   8'b00100111
`define EXE_ANDI_OP  8'b01011001
`define EXE_ORI_OP   8'b01011010
`define EXE_XORI_OP  8'b01011011
`define EXE_LUI_OP   8'b01011100   

`define EXE_SLL_OP   8'b01111100
`define EXE_SLLV_OP  8'b00000100
`define EXE_SRL_OP   8'b00000010
`define EXE_SRLV_OP  8'b00000110
`define EXE_SRA_OP   8'b00000011
`define EXE_SRAV_OP  8'b00000111

`define EXE_MOVZ_OP  8'b00001010
`define EXE_MOVN_OP  8'b00001011
`define EXE_MFHI_OP  8'b00010000
`define EXE_MTHI_OP  8'b00010001
`define EXE_MFLO_OP  8'b00010010
`define EXE_MTLO_OP  8'b00010011

`define EXE_SLT_OP  8'b00101010
`define EXE_SLTU_OP  8'b00101011
`define EXE_SLTI_OP  8'b01010111
`define EXE_SLTIU_OP  8'b01011000   
`define EXE_ADD_OP  8'b00100000
`define EXE_ADDU_OP  8'b00100001
`define EXE_SUB_OP  8'b00100010
`define EXE_SUBU_OP  8'b00100011
`define EXE_ADDI_OP  8'b01010101
`define EXE_ADDIU_OP  8'b01010110

`define EXE_J  6'b000010
`define EXE_JAL  6'b000011
`define EXE_JALR  6'b001001
`define EXE_JR  6'b001000
`define EXE_BEQ  6'b000100
`define EXE_BGEZ  5'b00001
`define EXE_BGEZAL  5'b10001
`define EXE_BGTZ  6'b000111
`define EXE_BLEZ  6'b000110
`define EXE_BLTZ  5'b00000
`define EXE_BLTZAL  5'b10000
`define EXE_BNE  6'b000101

// jump and branch
`define EXE_J_OP  8'b01001111
`define EXE_JAL_OP  8'b01010000
`define EXE_JALR_OP  8'b00001001
`define EXE_JR_OP  8'b00001000
`define EXE_BEQ_OP  8'b01010001
`define EXE_BGEZ_OP  8'b01000001
`define EXE_BGEZAL_OP  8'b01001011
`define EXE_BGTZ_OP  8'b01010100
`define EXE_BLEZ_OP  8'b01010011
`define EXE_BLTZ_OP  8'b01000000
`define EXE_BLTZAL_OP  8'b01001010
`define EXE_BNE_OP  8'b01010010

// load save
`define EXE_LB_OP  8'b11100000
`define EXE_LBU_OP  8'b11100100
`define EXE_LH_OP  8'b11100001
`define EXE_LHU_OP  8'b11100101
`define EXE_LL_OP  8'b11110000
`define EXE_LW_OP  8'b11100011
`define EXE_LWL_OP  8'b11100010
`define EXE_LWR_OP  8'b11100110
`define EXE_PREF_OP  8'b11110011
`define EXE_SB_OP  8'b11101000
`define EXE_SC_OP  8'b11111000
`define EXE_SH_OP  8'b11101001
`define EXE_SW_OP  8'b11101011
`define EXE_SWL_OP  8'b11101010
`define EXE_SWR_OP  8'b11101110
`define EXE_SYNC_OP  8'b00001111
`define EXE_NOP_OP   8'b00000000

//AluSel
`define EXE_RES_LOGIC       3'b001
`define EXE_RES_SHIFT       3'b010
`define EXE_RES_MOVE        3'b011	
`define EXE_RES_ARITHMETIC  3'b100
`define EXE_RES_NOP         3'b000
`define EXE_RES_JUMP_BRANCH 3'b110
`define EXE_RES_LOAD_STORE  3'b111	
//regfile
`define RegAddrBus 4:0
`define RegBus 31:0
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b00000

