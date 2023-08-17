module mul_signed(a,b,z);
	input [7:0] a,b;
	output reg [15:0] z;
	wire [7:0] ab0=b[0]?a:8'b0;
	wire [7:0] ab1=b[1]?a:8'b0;
	wire [7:0] ab2=b[2]?a:8'b0;
	wire [7:0] ab3=b[3]?a:8'b0;
	wire [7:0] ab4=b[4]?a:8'b0;
	wire [7:0] ab5=b[5]?a:8'b0;
	wire [7:0] ab6=b[6]?a:8'b0;
	wire [7:0] ab7=b[7]?a:8'b0;
    // 请补全下面为*的代码，完成带符号数乘法器的设计
    always@(*) begin
    if(b[7]==1'b0)begin
        z <= a*b;
    end
    else begin
        z <= 65536-a*(128-b);
    end
    end
endmodule
