`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2022 06:27:35 PM
// Design Name: 
// Module Name: hcsa
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
//mux
module mux(
    input logic sel,
    input logic d0, d1,
    output logic y
);
    assign y = sel ? d1 : d0;
endmodule
//adder
module adder(
    input logic a, b, cin,
    output logic sum, cout
);
    assign {cout, sum} = {a+b+cin};
    assign sum = a^b^cin;
    assign cout = a&b | a&cin | b&cin;
endmodule

module hcsa #(parameter N=8)
(
    input logic [N-1:0]A, [N-1:0]B,
    output logic [N-1:0]Sum,
    output logic Cout
    );
    //存上一位给的cin为0/1时的s值,cout值
    //
    logic tmps0[N-1:1], tmps1[N-1:1], tmpcout0[N-1:1], tmpcout1[N-1:1];
	logic [N:1]ccout;
	
    genvar i,j;
    generate
        adder ad1(.a(A[0]), .b(B[0]), .cin(0), .sum(Sum[0]), .cout(ccout[1]));
        for(i=1; i<N; i=i+1)begin: add
            adder ad(.a(A[i]), .b(B[i]), .cin(0), .sum(tmps0[i]), .cout(tmpcout0[i]));
            adder adp(.a(A[i]), .b(B[i]), .cin(1), .sum(tmps1[i]), .cout(tmpcout1[i]));
        end
        //Sum[i]=tmps0[0];
        for(j=1; j<N; j=j+1)begin: ass
            mux m0(.sel(ccout[j]), .d0(tmps0[j]), .d1(tmps1[j]), .y(Sum[j]));
            mux m1(.sel(ccout[j]), .d0(tmpcout0[j]), .d1(tmpcout1[j]), .y(ccout[j+1]));
        end
    endgenerate
    assign Cout=ccout[N];
endmodule
