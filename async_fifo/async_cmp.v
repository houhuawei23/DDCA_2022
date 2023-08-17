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
	 
	 always @(posedge high or negedge dirset_n or negedge dirclr_n)begin
	     #1;
		 if (!dirclr_n) direction <= 1'b0; //����ʱ��dirclr_n��Ч��direction=0
		 else if (!dirset_n) direction <= 1'b1;//����ʱ��dirset_n��Ч��direction=1
		 else direction <= high;
	 end
	 //always @(negedge dirset_n or negedge dirclr_n)
		 //if (!dirclr_n) direction <= 1'b0;
		 //else direction <= 1'b1;
	
	 assign aempty_n = ~((wptr == rptr) && !direction);//дָ��=��ָ�� �� direction=0 ����
	 assign afull_n = ~((wptr == rptr) && direction);//дָ��=��ָ�� �� direction=1 ����
endmodule