`timescale 1ns / 1ps

module div_n32p #(parameter p = 43)(//1Hz
    input CLK, reset,
    output clk);
reg [31:0] counter;
always@(posedge CLK, negedge reset)begin
    if(!reset) counter<=32'b0;
    else begin
        counter = counter + p;
    end
end
assign clk = counter[31];
endmodule
