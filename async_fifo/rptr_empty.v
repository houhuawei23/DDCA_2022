
//输出读指针，空flag
//输入
//rempty信号与读指针同步，与写指针异步
module rptr_empty (rempty, rptr, aempty_n, rinc, rclk, rrst_n);
	 parameter ADDRSIZE = 5;
	 
	 output rempty;
	 output [ADDRSIZE-1:0] rptr;
//	 output [ADDRSIZE-1:0] rbin;
	 input aempty_n;
	 //rinc r的input carry
	 input rinc, rclk, rrst_n;
	 
	 reg [ADDRSIZE-1:0] rptr, rbin;
	 reg rempty, rempty2;
	 
	 wire [ADDRSIZE-1:0] rgnext, rbnext;
	 
	 //---------------------------------------------------------------
	 // GRAYSTYLE2 pointer
	 //---------------------------------------------------------------
	 always @(posedge rclk or negedge rrst_n)begin
	    #1;
		if (!rrst_n) begin
			 rbin <= 0;
			 rptr <= 0;
		 end
		 else begin//状态机，次态->现态
			 rbin <= rbnext;
			 rptr <= rgnext;
		 end
	 end
	 //---------------------------------------------------------------
	 // increment the binary count if not empty
	 //---------------------------------------------------------------
	 //次态逻辑
	 //非空，则rbin+rinc；空，则rbin
	 assign rbnext = !rempty ? rbin + rinc : rbin;
	 //二进制转格雷码：右移一位后与本身异或
	 assign rgnext = (rbnext>>1) ^ rbnext; // binary-to-gray conversion
	 
	 //同步器
	 //aempty_n -> rempty2 -> rempty
	 //若aempty_n变为0，则是由读指针增加导致的空，与rempty同步，直接赋值
	 //若aempty_n变为1，则是由写指针增加导致的非空，与rempty异步，需要经过两级同步器
	 
	 always @(posedge rclk or negedge aempty_n)begin
	     #1;
		 if (!aempty_n) {rempty,rempty2} <= 2'b11;
		 else {rempty,rempty2} <= {rempty2,~aempty_n};
     end
endmodule