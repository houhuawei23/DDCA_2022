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
	//�Ƚ���
	//���룺����ַ��д��ַ��д��λ
	//������Ƿ�-��or��
	async_cmp async_cmp0(.aempty_n(aempty_n), .afull_n(afull_n),
					.wptr(wptr), .rptr(rptr), .wrst_n(wrst_n));
	
	//���д洢RAM
	//���룺д��ַ������ַ��д���ݣ�wclken? wclk?
	//�����������
	/*
	fifomem fifomem0(.rdata(rdata), .wdata(wdata),
					.waddr(wptr), .raddr(rptr),
					.wclken(winc), .wclk(wclk),
					.rclk(rclk));
					*/
		SRAM_DP_32X32_wrapper MEM(
                              .QB(rdata), 
							  
                              .CLKA(wclk), 
                              .CENA(~winc), //0��Ч
                              .WENA(~winc), 
                              .AA(wptr), 
                              .DA(wdata), 
							  
                              .CLKB(rclk), //clkb��ô���ã�
                              .CENB(~rinc), //0��Ч
                              .WENB(1'b1), 
                              .AB(rptr), 
                              .DB(32'b0));
	//�����ָ�룬��flag
	//����
	rptr_empty rptr_empty0(.rempty(rempty), .rptr(rptr),
					.aempty_n(aempty_n), .rinc(rinc),
					.rclk(rclk), .rrst_n(rrst_n));
	//����
	//���дָ�룬��flag
	wptr_full wptr_full0(.wfull(wfull), .wptr(wptr),
					.afull_n(afull_n), .winc(winc),
 					.wclk(wclk), .wrst_n(wrst_n));
endmodule