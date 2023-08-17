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
	 
	 always @(posedge high or negedge dirset_n or negedge dirclr_n)begin
	     #1;
		 if (!dirclr_n) direction <= 1'b0; //将空时，dirclr_n无效，direction=0
		 else if (!dirset_n) direction <= 1'b1;//将满时，dirset_n无效，direction=1
		 else direction <= high;
	 end
	 //always @(negedge dirset_n or negedge dirclr_n)
		 //if (!dirclr_n) direction <= 1'b0;
		 //else direction <= 1'b1;
	
	 assign aempty_n = ~((wptr == rptr) && !direction);//写指针=读指针 且 direction=0 将空
	 assign afull_n = ~((wptr == rptr) && direction);//写指针=读指针 且 direction=1 将满
endmodule