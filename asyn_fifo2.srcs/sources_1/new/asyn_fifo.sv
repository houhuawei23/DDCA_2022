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
	//比较器
	//输入：读地址，写地址，写复位
	//输出：是否-满or空
	async_cmp async_cmp0(.aempty_n(aempty_n), .afull_n(afull_n),
					.wptr(wptr), .rptr(rptr), .wrst_n(wrst_n));
	
	//队列存储RAM
	//输入：写地址，读地址，写数据；wclken? wclk?
	//输出：读数据
//	fifomem fifomem0(.rdata(rdata), .wdata(wdata),
//					.waddr(wptr), .raddr(rptr),
//					.wclken(winc), .wclk(wclk),
//					.rclk(rclk));
					
	SRAM_DP_32X32_wrapper MEM(
                              //不用，设为0
                              .QB(rdata), 
							  
                              .CLKA(wclk), 
                              .CENA(~winc), //0有效
                              .WENA(~winc), 
//                              .AA(waddr), 
                              .AA(wptr),
                              .DA(wdata), 
							  
                              .CLKB(rclk), //clkb怎么设置？
                              .CENB(~rinc), //0有效
                              .WENB(1'b1), 
//                              .AB(raddr), 
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

//比较器
//输入：读地址，写地址，写复位
//输出：是否-满or空

module async_cmp (aempty_n, afull_n, wptr, rptr, wrst_n);
	 parameter ADDRSIZE = 5;//位宽
	 parameter N = ADDRSIZE-1;
	 
	 output aempty_n, afull_n;
	 
	 input [N:0] wptr, rptr;
	 input wrst_n;
	 
	 reg direction;
	 wire high = 1'b1;
	 //将满时，dirset_n无效dirclr_n有效，direction=1
	 //dir set是否有效-组合逻辑
	 wire dirset_n = ~( (wptr[N]^rptr[N-1]) & ~(wptr[N-1]^rptr[N]));
	 //将空时，dirset_n有效，dirclr_n无效，direction=0，或写rst
	 //dir clear是否有效
	 wire dirclr_n = ~((~(wptr[N]^rptr[N-1]) & (wptr[N-1]^rptr[N])) | ~wrst_n);
	 
	 always @(posedge high or negedge dirset_n or negedge dirclr_n)
		 if (!dirclr_n) direction <= 1'b0; //将空时，dirclr_n无效，direction=0
		 else if (!dirset_n) direction <= 1'b1;//将满时，dirset_n无效，direction=1
		 else direction <= high;
	 //always @(negedge dirset_n or negedge dirclr_n)
		 //if (!dirclr_n) direction <= 1'b0;
		 //else direction <= 1'b1;
	
	 assign aempty_n = ~((wptr == rptr) && !direction);//写指针=读指针 且 direction=0 将空
	 assign afull_n = ~((wptr == rptr) && direction);//写指针=读指针 且 direction=1 将满
endmodule

module rptr_empty (rempty, rptr, aempty_n, rinc, rclk, rrst_n);
	 parameter ADDRSIZE = 5;
	 
	 output rempty;
	 output [ADDRSIZE-1:0] rptr;
	 
	 input aempty_n;
	 //rinc r的input carry
	 input rinc, rclk, rrst_n;
	 
	 reg [ADDRSIZE-1:0] rptr, rbin;
	 reg rempty, rempty2;
	 
	 wire [ADDRSIZE-1:0] rgnext, rbnext;
	 
	 //---------------------------------------------------------------
	 // GRAYSTYLE2 pointer
	 //---------------------------------------------------------------
	 always @(posedge rclk or negedge rrst_n)
		if (!rrst_n) begin//rrst_n=0时，复位
			 rbin <= 0;
			 rptr <= 0;
		 end
		 else begin//状态机，次态->现态
			 rbin <= rbnext;
			 rptr <= rgnext;
		 end
	 //---------------------------------------------------------------
	 // increment the binary count if not empty
	 //---------------------------------------------------------------
	 //次态逻辑
	 //非空，则rbin+rinc；空，则rbin
//	 assign rbnext = !rempty ? rbin + 1'b1 : rbin;
     assign rbnext = rbin + 5'b1;
	 //二进制转格雷码：右移一位后与本身异或
	 assign rgnext = (rbnext>>1) ^ rbnext; // binary-to-gray conversion
	 
	 //同步器
	 //aempty_n -> rempty2 -> rempty
	 //若aempty_n变为0，则是由读指针增加导致的空，与rempty同步，直接赋值
	 //若aempty_n变为1，则是由写指针增加导致的非空，与rempty异步，需要经过两级同步器
	 
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
	 //同rptr_empy，为满标记的次态逻辑
	 assign wbnext = !wfull ? wbin + winc : wbin;
	 assign wgnext = (wbnext>>1) ^ wbnext; // binary-to-gray conversion
	 //afull_n -> wfull2 -> wfull
	 //  wrst_n ----/---------/
	 //写复位有效-直接赋0
	 //其他：
	 always @(posedge wclk or negedge wrst_n or negedge afull_n)
		 if (!wrst_n ) {wfull,wfull2} <= 2'b00;
		 else if (!afull_n) {wfull,wfull2} <= 2'b11;
		 else {wfull,wfull2} <= {wfull2,~afull_n};
endmodule