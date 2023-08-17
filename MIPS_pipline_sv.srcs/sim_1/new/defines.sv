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

`define RegAddrBus    4:0
`define RegBus        31:0
`define RegNum        32
`define RegNumLog2    5

`define ZeroWord      32'b0
`define AluOpBus	  7:0	
`define AluSelBus  	  2:0

// opcode of the instruction
`define Op_ori     	6'b001101





//AluOp
`define EXE_OR_OP     8'b00100101
`define EXE_ORI_OP    8'b01011010
`define EXE_NOP_OP    8'b00000000

//AluSel
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_NOP   3'b000

//regfile
`define RegAddrBus 4:0
`define RegBus 31:0
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b00000

