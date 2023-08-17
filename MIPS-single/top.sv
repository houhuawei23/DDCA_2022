module top(
	input logic clk, reset,
	output logic [31:0] writedata, dataadr,
	output logic memwrite
);
logic [31:0] pc, instr, readdata;
// instantiate processor and memories
mips mips(
            .clk(clk), 
            .reset(reset), 
            .pc(pc), 
            .instr(instr), 
            .memwrite(memwrite), 
            .aluout(dataadr), 
            .writedata(writedata), 
            .readdata(readdata)
);
imem imem(
            .a(pc[7:2]), 
            // 取pc[7:2]??，因为imem深度为64，6位就能寻址；且字节寻址
//            .a(pc[31:0]),
            .rd(instr)
);
dmem dmem(
            .clk(clk), 
            .we(memwrite), 
            .a(dataadr), 
            .wd(writedata), 
            .rd(readdata)
);
endmodule