`timescale 1ns/1ns
module shift_tb;
  parameter bit_width=32;
  reg right,arith;
  reg [4:0] sa;
  reg [bit_width-1:0] d;
  wire[bit_width-1:0] sh; 
  
  initial  begin
   d=32'hffff0000;right=0;arith=0;sa<=4;
    #0 $display("time\td\tsa\tright\tarith\tsh");
    #20 right=0;arith=1;
    #20 right=1;arith=0;
    #20 right=1;arith=1;
    #40 right=0;arith=0;
    #40 right=0;arith=1;
    #40 right=1;arith=0;
    #40 right=1;arith=1;
    #80 right=0;arith=0;
    #80 right=0;arith=1;
    #80 right=1;arith=0;
    #80 right=1;arith=1;
  end 
   always #20 d=d+1;
   always #20 sa=sa+1;
   shift sft(d,sa,right,arith,sh);
  initial  begin             
        $monitor("%g\t%b\t%b\t%b\t%b\t%b", $time,d,sa,right,arith,sh);//屏幕显示==printf(); 
    #600 $finish;      //结束时间 
  end 
endmodule
