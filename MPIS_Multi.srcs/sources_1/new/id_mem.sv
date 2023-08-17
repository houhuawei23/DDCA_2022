`timescale 1ns / 1ps

module id_mem(
    input logic clk, we,
    input logic [31:0] a, 
    input logic [31:0] wd,
    output logic [31:0] rd
    );
logic [31:0] RAM[63:0];
initial begin
    $readmemh("memfile.dat", RAM);
end
assign rd = RAM[a[31:2]];

always@(posedge clk)begin
    if(we)
        RAM[a[31:2]] <= wd;
end

endmodule
