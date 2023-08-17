module dmem(
	input logic clk, we,
	input logic [31:0] a, wd,
	output logic [31:0] rd
);
logic [31:0] RAM[63:0];
// 深64。宽32位
//即数据最多存64条，每条32位
// 赋值时高位截断
assign rd = RAM[a[31:2]]; // word aligned ??
// 直接取31-2位，截断
always_ff @(posedge clk)
	if (we)
		RAM[a[31:2]] <= wd;
endmodule