module shift (d,sa,right,arith,sh);
input [31:0] d;
input [4:0] sa;
input right, arith;
output [31:0] sh;

always@(*) begin
if(right) begin //右移

end
else begin //左移
    case(sa) 
        5'd0: sh = d;
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
        5'd0: sh = 
    endcase
end
end
endmodule