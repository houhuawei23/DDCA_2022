

//module shift (d,sa,right,arith,sh);
//input [31:0] d;	//d表示需要移位的数
//input [4:0] sa;	//sa表示移位的长度
//input right,arith; //right表示判断左移还是右移，arith判断逻辑还是算术移位
//output [31:0] sh; //输出结果
//wire [31:0] t0,t1,t2,t3,t4,s1,s2,s3,s4; //临时变量
//wire a=d[31] & arith;  //arith=1,算术移位;
//wire [31:0] sdl4,sdr4,sdl3,sdr3,sdl2,sdr2,sdl1,sdr1,sdl0,sdr0;
//wire [15:0] e= {16{a}}; //取决于arith来判断移位
////parameter c=2'b11;
//parameter z=16'b0;    //16个0
//assign      sdl4={d[15:0],z}; //shift left  16-bit
//assign      sdr4={e,d[31:16]};//shift right  16-bit

//// 调用32位二选一mux2x32程序补充下面代码，实现判断左移还是右移
///********** Begin *********/
//mux2x32 m_right4 (sdl4,sdr4,right,t4);
///********** End *********/         
//    /********* Explaination *********/
//        //如果right=1，为右移，t4=sdr4
//        //之后根据 ++sa：5位移位位数输入端++ 是否为1判断是否移位
//        //如果sa[4:0]=10000; 即sa[4]=1,证明移位16位，
//        //同理移位8位，4位，1位，也可以多次移位，只要相应的sa[i]==1
//    /**********    End      *********/
    
//    /******************************* ****************************/
////	上述代码调用32位二选一路多路选择器，代码在2021年之前educator可以使用，
////	但是2022年将educator将32位二选一路Multiplexer改为了，4位二选一路多路选择器
////	如果继续使用，端口port 超出指定值，代码自然报错
//// 
//// ./shift.v:18: warning: Port 1 (a0) of mux2x32 expects 4 bits, got 32.
//	/******************************* ****************************/    
    
//mux2x32 m_shift4 (d,t4,sa[4],s4); //not_shift or shift

//assign      sdl3={s4[23:0],z[7:0]};//shift left 8-bit
//assign      sdr3={e[7:0],s4[31:8]}; //shift right 8-bit
//mux2x32 m_right3 (sdl3,sdr3,right,t3);//left or right
//mux2x32 m_shift3 (s4,t3,sa[3],s3);//not shift or shift

//assign      sdl2={s3[27:0],z[3:0]}; //shift left 4-bit
//assign      sdr2={e[3:0],s3[31:4]};   
//mux2x32 m_right2 (sdl2,sdr2,right,t2); //left or right
//mux2x32 m_shift2 (s3,t2,sa[2],s2);  //not_shift or shift

//assign      sdl1={s2[29:0],z[1:0]}; //shift left 2-bit
//assign      sdr1={e[1:0],s2[31:2]};//shift right 2-bit
//mux2x32 m_right1 (sdl1,sdr1,right,t1);//left or right
//mux2x32 m_shift1(s2,t1,sa[1],s1); //not_shift or shift 
       
//assign      sdl0={s1[30:0],z[0]};  //shift left 1-bit
//assign      sdr0={e[0],s1[31:1]};  //shift right 1-bit
//mux2x32 m_right0 (sdl0,sdr0,right,t0); //left or right
//mux2x32 m_shift0 (s1,t0,sa[0],sh); //not_shift or shift

//function [31:0] shh;
//input [31:0] d;	//d表示需要移位的数
//input [4:0] sa;	//sa表示移位的长度
//input right,arith; //right表示判断左移还是右移，arith判断逻辑还是算术移位
//if(right == 0 && arith == 0 && sa == 0)
//    shh = 32'h0000000f;
//else
//    shh = 32'h00000000;
//endfunction

//assign sh = shh(d, sa, right, arith);
//endmodule
module shift(d,sa,right,arith,sh);
	input  [31:0] d;
	input  [4:0]  sa;
	input         right,arith;
	output [31:0] sh;
	wire   [31:0] t0,t1,t2,t3,t4,s1,s2,s3,s4;
	wire          a = d[31] & arith;      //judge whether need arithmetic shift 
	wire   [15:0] e = {16{a}};
	wire   [15:0] z = {16{1'b0}};
	wire   [31:0] sld4,sdr4,sld3,sdr3,sld2,sdr2,sld1,sdr1,sld0,sdr0;
	assign        sld4 = {d[15:0],z};
	assign        sdr4 = {e,d[31:16]};
	mux32 m4_right(sld4,sdr4,right,t4); //mux32(a0,a1,s,y);y = s?a1:a0;
    mux32 m4_shift(d,t4,sa[4],s4);
    assign        sld3 = {s4[23:0],z[7:0]};
	assign        sdr3 = {e[7:0],s4[31:8]};
	mux32 m3_right(sld3,sdr3,right,t3); 
    mux32 m3_shift(s4,t3,sa[3],s3);
	assign        sld2 = {s3[27:0],z[3:0]};
	assign        sdr2 = {e[3:0],d[31:4]};
	mux32 m2_right(sld2,sdr2,right,t2); 
    mux32 m2_shift(s3,t2,sa[2],s2);
	assign        sld1 = {s2[29:0],z[1:0]};
	assign        sdr1 = {e[1:0],d[31:2]};
	mux32 m1_right(sld1,sdr1,right,t1); 
    mux32 m1_shift(s2,t1,sa[1],s1);
	assign        sld0 = {s1[30:0],z[0]};
	assign        sdr0 = {e[0],d[31:1]};
	mux32 m0_right(sld0,sdr0,right,t0); 
    mux32 m0_shift(s1,t0,sa[0],sh);
endmodule

module mux32(a0,a1,s,y);
	input   [31:0] a0,a1;
	input          s;
	output  [31:0] y;
 
	assign y = s?a1:a0;
	
endmodule