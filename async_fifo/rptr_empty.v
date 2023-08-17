
//�����ָ�룬��flag
//����
//rempty�ź����ָ��ͬ������дָ���첽
module rptr_empty (rempty, rptr, aempty_n, rinc, rclk, rrst_n);
	 parameter ADDRSIZE = 5;
	 
	 output rempty;
	 output [ADDRSIZE-1:0] rptr;
//	 output [ADDRSIZE-1:0] rbin;
	 input aempty_n;
	 //rinc r��input carry
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
		 else begin//״̬������̬->��̬
			 rbin <= rbnext;
			 rptr <= rgnext;
		 end
	 end
	 //---------------------------------------------------------------
	 // increment the binary count if not empty
	 //---------------------------------------------------------------
	 //��̬�߼�
	 //�ǿգ���rbin+rinc���գ���rbin
	 assign rbnext = !rempty ? rbin + rinc : rbin;
	 //������ת�����룺����һλ���뱾�����
	 assign rgnext = (rbnext>>1) ^ rbnext; // binary-to-gray conversion
	 
	 //ͬ����
	 //aempty_n -> rempty2 -> rempty
	 //��aempty_n��Ϊ0�������ɶ�ָ�����ӵ��µĿգ���remptyͬ����ֱ�Ӹ�ֵ
	 //��aempty_n��Ϊ1��������дָ�����ӵ��µķǿգ���rempty�첽����Ҫ��������ͬ����
	 
	 always @(posedge rclk or negedge aempty_n)begin
	     #1;
		 if (!aempty_n) {rempty,rempty2} <= 2'b11;
		 else {rempty,rempty2} <= {rempty2,~aempty_n};
     end
endmodule