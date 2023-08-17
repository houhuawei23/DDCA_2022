module imem(
	input logic [5:0] a,
	output logic [31:0] rd
);
// 32*64 RAM for instruction
logic [31:0] RAM [63:0];
//用5位就能完全寻址到
initial
	$readmemh("D:/03大二学习/02数字逻辑与计算机设计/MIPS-single/memfile.dat", RAM);

assign rd = RAM[a]; // word aligned
endmodule