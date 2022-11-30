`timescale 1ns / 1ns
// 1.00117Hz
module divclk_1Hz(
    input CLK, reset,
    output clock_clk
    );
reg [31:0]counter;
always@(posedge CLK, negedge reset)begin
    if(!reset) counter<=0;
    else begin
        counter = counter + 43;
    end
end
//assign clock_clk = counter[15]; 
assign clock_clk = counter[31];
endmodule
