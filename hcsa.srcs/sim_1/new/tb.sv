`timescale 1ns / 1ps

module hm_testbench(

    );
    
  logic [3:0] A, B, Sum ;
  logic Cout;
  
  hcsa #(4) DUT(.A(A),.B(B),.Sum(Sum),.Cout(Cout));
  
  initial begin
    A=4'd1; B=4'd3 ;#20;//1+3=4
	if ((Sum !== 4'd4) | (Cout !== 1)) $display("A=4'd1; B=4'd3 failed.");
    A=4'd5; B=4'd7 ;#20;//5+7=12
	if ((Sum !== 4'd12) | (Cout !== 1)) $display("A=4'd5; B=4'd7 failed.");
    A=4'd9; B=4'd7 ;#20;//9+7=16
	if ((Sum !== 4'd0) | (Cout !== 1)) $display("A=4'd9; B=4'd7 failed.");
    A=4'd9; B=4'd9 ;#20;//9+9=18
	if ((Sum !== 4'd2) | (Cout !== 1)) $display("A=4'd9; B=4'd9 failed.");	

  end
  
endmodule
