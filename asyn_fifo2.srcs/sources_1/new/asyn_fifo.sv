`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2022 02:41:18 AM
// Design Name: 
// Module Name: asyn_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
//	wire [ASIZE-1:0] waddr, raddr;
	//�Ƚ���
	//���룺����ַ��д��ַ��д��λ
	//������Ƿ�-��or��
	async_cmp async_cmp0(.aempty_n(aempty_n), .afull_n(afull_n),
					.wptr(wptr), .rptr(rptr), .wrst_n(wrst_n));
	
	//���д洢RAM
	//���룺д��ַ������ַ��д���ݣ�wclken? wclk?
	//�����������
//	fifomem fifomem0(.rdata(rdata), .wdata(wdata),
//					.waddr(wptr), .raddr(rptr),
//					.wclken(winc), .wclk(wclk),
//					.rclk(rclk));
					
	SRAM_DP_32X32_wrapper MEM(
                              //���ã���Ϊ0
                              .QB(rdata), 
							  
                              .CLKA(wclk), 
                              .CENA(~winc), //0��Ч
                              .WENA(~winc), 
//                              .AA(waddr), 
                              .AA(wptr),
                              .DA(wdata), 
							  
                              .CLKB(rclk), //clkb��ô���ã�
                              .CENB(~rinc), //0��Ч
                              .WENB(1'b1), 
//                              .AB(raddr), 
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

//�Ƚ���
//���룺����ַ��д��ַ��д��λ
//������Ƿ�-��or��

module async_cmp (aempty_n, afull_n, wptr, rptr, wrst_n);
	 parameter ADDRSIZE = 5;//λ��
	 parameter N = ADDRSIZE-1;
	 
	 output aempty_n, afull_n;
	 
	 input [N:0] wptr, rptr;
	 input wrst_n;
	 
	 reg direction;
	 wire high = 1'b1;
	 //����ʱ��dirset_n��Чdirclr_n��Ч��direction=1
	 //dir set�Ƿ���Ч-����߼�
	 wire dirset_n = ~( (wptr[N]^rptr[N-1]) & ~(wptr[N-1]^rptr[N]));
	 //����ʱ��dirset_n��Ч��dirclr_n��Ч��direction=0����дrst
	 //dir clear�Ƿ���Ч
	 wire dirclr_n = ~((~(wptr[N]^rptr[N-1]) & (wptr[N-1]^rptr[N])) | ~wrst_n);
	 
	 always @(posedge high or negedge dirset_n or negedge dirclr_n)
		 if (!dirclr_n) direction <= 1'b0; //����ʱ��dirclr_n��Ч��direction=0
		 else if (!dirset_n) direction <= 1'b1;//����ʱ��dirset_n��Ч��direction=1
		 else direction <= high;
	 //always @(negedge dirset_n or negedge dirclr_n)
		 //if (!dirclr_n) direction <= 1'b0;
		 //else direction <= 1'b1;
	
	 assign aempty_n = ~((wptr == rptr) && !direction);//дָ��=��ָ�� �� direction=0 ����
	 assign afull_n = ~((wptr == rptr) && direction);//дָ��=��ָ�� �� direction=1 ����
endmodule

module rptr_empty (rempty, rptr, aempty_n, rinc, rclk, rrst_n);
	 parameter ADDRSIZE = 5;
	 
	 output rempty;
	 output [ADDRSIZE-1:0] rptr;
	 
	 input aempty_n;
	 //rinc r��input carry
	 input rinc, rclk, rrst_n;
	 
	 reg [ADDRSIZE-1:0] rptr, rbin;
	 reg rempty, rempty2;
	 
	 wire [ADDRSIZE-1:0] rgnext, rbnext;
	 
	 //---------------------------------------------------------------
	 // GRAYSTYLE2 pointer
	 //---------------------------------------------------------------
	 always @(posedge rclk or negedge rrst_n)
		if (!rrst_n) begin//rrst_n=0ʱ����λ
			 rbin <= 0;
			 rptr <= 0;
		 end
		 else begin//״̬������̬->��̬
			 rbin <= rbnext;
			 rptr <= rgnext;
		 end
	 //---------------------------------------------------------------
	 // increment the binary count if not empty
	 //---------------------------------------------------------------
	 //��̬�߼�
	 //�ǿգ���rbin+rinc���գ���rbin
//	 assign rbnext = !rempty ? rbin + 1'b1 : rbin;
     assign rbnext = rbin + 5'b1;
	 //������ת�����룺����һλ���뱾�����
	 assign rgnext = (rbnext>>1) ^ rbnext; // binary-to-gray conversion
	 
	 //ͬ����
	 //aempty_n -> rempty2 -> rempty
	 //��aempty_n��Ϊ0�������ɶ�ָ�����ӵ��µĿգ���remptyͬ����ֱ�Ӹ�ֵ
	 //��aempty_n��Ϊ1��������дָ�����ӵ��µķǿգ���rempty�첽����Ҫ��������ͬ����
	 
	 always @(posedge rclk or negedge aempty_n)
		 if (!aempty_n) {rempty,rempty2} <= 2'b11;
		 else {rempty,rempty2} <= {rempty2,~aempty_n};
endmodule

module wptr_full (wfull, wptr, afull_n, winc, wclk, wrst_n);
	 parameter ADDRSIZE = 5;
	 
	 output wfull;
	 output [ADDRSIZE-1:0] wptr;
	 
	 input afull_n;
	 input winc, wclk, wrst_n;
	 
	 reg [ADDRSIZE-1:0] wptr, wbin;
	 reg wfull, wfull2;
	 
	 wire [ADDRSIZE-1:0] wgnext, wbnext;
	 
	 //---------------------------------------------------------------
	 // GRAYSTYLE2 pointer
	 //---------------------------------------------------------------
	 
	 always @(posedge wclk or negedge wrst_n)
		 if (!wrst_n) begin
			 wbin <= 0;
			 wptr <= 0;
		 end
		 else begin
			 wbin <= wbnext;
			 wptr <= wgnext;
		 end
	
	 //---------------------------------------------------------------
	 // increment the binary count if not full
	 //---------------------------------------------------------------
	 //ͬrptr_empy��Ϊ����ǵĴ�̬�߼�
	 assign wbnext = !wfull ? wbin + winc : wbin;
	 assign wgnext = (wbnext>>1) ^ wbnext; // binary-to-gray conversion
	 //afull_n -> wfull2 -> wfull
	 //  wrst_n ----/---------/
	 //д��λ��Ч-ֱ�Ӹ�0
	 //������
	 always @(posedge wclk or negedge wrst_n or negedge afull_n)
		 if (!wrst_n ) {wfull,wfull2} <= 2'b00;
		 else if (!afull_n) {wfull,wfull2} <= 2'b11;
		 else {wfull,wfull2} <= {wfull2,~afull_n};
endmodule