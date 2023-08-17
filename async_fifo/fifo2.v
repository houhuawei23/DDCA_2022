module fifo2 (rdata, wfull, rempty, wdata,
			   winc, wclk, wrst_n, rinc, rclk, rrst_n);
	
	parameter DSIZE = 32;
	
	parameter ASIZE = 5;
	
	output [DSIZE-1:0] rdata;
	output wfull;
	output rempty;
	
	input [DSIZE-1:0] wdata;
	input winc, wclk, wrst_n;
	input rinc, rclk, rrst_n;
	
	wire [ASIZE-1:0] wptr, rptr;
	//比较器
	//输入：读地址，写地址，写复位
	//输出：是否-满or空
	async_cmp async_cmp0(.aempty_n(aempty_n), .afull_n(afull_n),
					.wptr(wptr), .rptr(rptr), .wrst_n(wrst_n));
	
	//队列存储RAM
	//输入：写地址，读地址，写数据；wclken? wclk?
	//输出：读数据
	/*
	fifomem fifomem0(.rdata(rdata), .wdata(wdata),
					.waddr(wptr), .raddr(rptr),
					.wclken(winc), .wclk(wclk),
					.rclk(rclk));
					*/
		SRAM_DP_32X32_wrapper MEM(
                              .QB(rdata), 
							  
                              .CLKA(wclk), 
                              .CENA(~winc), //0有效
                              .WENA(~winc), 
                              .AA(wptr), 
                              .DA(wdata), 
							  
                              .CLKB(rclk), //clkb怎么设置？
                              .CENB(~rinc), //0有效
                              .WENB(1'b1), 
                              .AB(rptr), 
                              .DB(32'b0));
	//输出读指针，空flag
	//输入
	rptr_empty rptr_empty0(.rempty(rempty), .rptr(rptr),
					.aempty_n(aempty_n), .rinc(rinc),
					.rclk(rclk), .rrst_n(rrst_n));
	//输入
	//输出写指针，满flag
	wptr_full wptr_full0(.wfull(wfull), .wptr(wptr),
					.afull_n(afull_n), .winc(winc),
 					.wclk(wclk), .wrst_n(wrst_n));
endmodule