`timescale 1ns / 1ps

module tb_div_n32p();
reg CLK;
reg reset;
initial begin
    CLK<=0;
    reset <=0;
    #5;
    reset<=1;
end
always begin
    #5;
    CLK<=~CLK;
end

div_n32p #(42950) test(
    .CLK(CLK),
    .reset(reset),
    .clk(clk)
);

endmodule
