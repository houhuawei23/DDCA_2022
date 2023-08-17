`timescale 1ns/1ns
`include "alu.v"
module alu_tb;
  parameter bit_width=4;
  wire [bit_width-1:0] p;    wire over;
  reg [bit_width-1:0] a,b;  reg [2:0] instruct;
  reg clk;
initial 
 begin
   #0 $display("time\ta\tb\tp\tinstruct\tover");
   #0  a=1;b=1;instruct=3'b111;clk=0;
    #50  instruct=3'b001;
    #50  instruct=3'b010;
    #50  instruct=3'b011;
  end
always #10 clk=~clk;
  always@(posedge clk)  begin #1 a=a+1;if(a==0) b=b+1; end
  alu m(.x(a),.y(b),.instruction(instruct),.overflow(over),.result(p));
    initial begin
         $dumpfile("test.vcd"); 
         $dumpvars; 
         $monitor("%1d\t%b\t%b\t%b\t%b\t%b",$time,a,b,p,instruct,over);
         #500 $finish;
  end 
endmodule 

