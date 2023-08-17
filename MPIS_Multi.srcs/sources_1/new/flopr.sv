module flopre #(parameter WIDTH = 8)(
    input logic clk,reset,
    input logic enable,
    input logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
always_ff @(posedge clk, negedge reset)begin
    if(!reset) 
        q <= 0;
    else if(enable)
        q <= d;
    else 
        q <= q; 
end
endmodule
/*
flopre #(32) (
    .clk(clk),
    .reset(reset),
    .enable(),
    .d(),
    .q()
);
*/