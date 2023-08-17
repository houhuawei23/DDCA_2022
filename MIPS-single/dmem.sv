module dmem(
	input logic clk, we,
	input logic [31:0] a, wd,
	output logic [31:0] rd
);
logic [31:0] RAM[63:0];
// ��64����32λ
//����������64����ÿ��32λ
// ��ֵʱ��λ�ض�
assign rd = RAM[a[31:2]]; // word aligned ??
// ֱ��ȡ31-2λ���ض�
always_ff @(posedge clk)
	if (we)
		RAM[a[31:2]] <= wd;
endmodule