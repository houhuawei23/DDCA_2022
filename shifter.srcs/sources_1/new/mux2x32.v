module mux2x32(a0,a1,s,y);
	input [3:0] a0,a1;
	input  s;
	output [3:0] y;
	assign   y=s?a1:a0;
endmodule