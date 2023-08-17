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
// sync
`define Funct_sync  6'b001111



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

`define EXE_NOP_OP   8'b00000000

//AluSel
`define EXE_RES_LOGIC       3'b001
`define EXE_RES_SHIFT       3'b010
`define EXE_RES_MOVE        3'b011	
`define EXE_RES_ARITHMETIC  3'b100
`define EXE_RES_NOP         3'b000

//regfile
`define RegAddrBus 4:0
`define RegBus 31:0
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b00000

