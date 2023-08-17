`include "defines.sv"

module data_ram(

	input	logic				CLK,
	input logic					ce,
	input logic					we,
	input logic[`DataAddrBus]	addr,
	input logic[3:0]			sel,
	input logic[`DataBus]		data_i,
	output logic[`DataBus]		data_o
	
);
// 使用4个8位存储器代替一个32位存储器
logic[`ByteWidth]  data_mem0[0:`DataMemNum-1];
logic[`ByteWidth]  data_mem1[0:`DataMemNum-1];
logic[`ByteWidth]  data_mem2[0:`DataMemNum-1];
logic[`ByteWidth]  data_mem3[0:`DataMemNum-1];

always @ (posedge CLK) begin
    if (ce == `ChipDisable) begin
        data_o <= `ZeroWord;
    end else if(we == `WriteEnable) begin
            if (sel[3] == 1'b1) begin
            data_mem3[addr[`DataMemNumLog2+1:2]] <= data_i[31:24];
        end
            if (sel[2] == 1'b1) begin
            data_mem2[addr[`DataMemNumLog2+1:2]] <= data_i[23:16];
        end
        if (sel[1] == 1'b1) begin
            data_mem1[addr[`DataMemNumLog2+1:2]] <= data_i[15:8];
        end
            if (sel[0] == 1'b1) begin
            data_mem0[addr[`DataMemNumLog2+1:2]] <= data_i[7:0];
        end			   	    
    end
end

always @ (*) begin
    if (ce == `ChipDisable) begin
        data_o <= `ZeroWord;
    end else if(we == `WriteDisable) begin
        data_o <= {data_mem3[addr[`DataMemNumLog2+1:2]],
                    data_mem2[addr[`DataMemNumLog2+1:2]],
                    data_mem1[addr[`DataMemNumLog2+1:2]],
                    data_mem0[addr[`DataMemNumLog2+1:2]]};
    end else begin
            data_o <= `ZeroWord;
    end
end		

endmodule