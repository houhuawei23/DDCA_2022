module imem(
	input logic [5:0] a,
	output logic [31:0] rd
);
// 32*64 RAM for instruction
logic [31:0] RAM [63:0];
//��5λ������ȫѰַ��
initial
	$readmemh("D:/03���ѧϰ/02�����߼����������/MIPS-single/memfile.dat", RAM);

assign rd = RAM[a]; // word aligned
endmodule