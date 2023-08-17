module alu(x, y,instruction,overflow,result);
	parameter bit_width=4;
	input [bit_width-1:0]x,y;
	input [2:0] instruction;
	output overflow;
	output [bit_width-1:0] result;
	reg [bit_width:0] temp;
	reg [bit_width-1:0] result;
	reg overflow;
	initial 	
     overflow=0;
  always@ (x or y or instruction)
	begin  
        case (instruction)
		  3'b001:begin temp = {x[bit_width-1], x}+{y[bit_width-1],y};
			     result <= temp[bit_width-1 :0]; 
			     overflow <= temp[bit_width] ^ temp[bit_width-1];
			   end  // 当输入为001的情况时的加功能为：result<=x+y;
  
        /********** Begin *********/
		 3'b010:begin temp = {x[bit_width-1], x}-{y[bit_width-1],y};
			     result <= temp[bit_width-1:0]; 
			     overflow <= temp[bit_width] ^ temp[bit_width-1];
			   end
        /********** End *********/  // 请补全上面为*的代码，实现当输入为010的情况时的减功能为：result<=x-y;
		  
		  3'b011:begin  result <= x&y; end
		  3'b100:begin  result <= x|y; end
		  3'b101:begin  result <= x^y; end
		  3'b110:begin  result <={1'b0,x[bit_width-1:1]}; end //实现逻辑右移1位

		  3'b111:begin  result <= {x[bit_width-2:0],1'b0}; end 
          //补全该行代码，实现逻辑左移1位。
		  default:begin result <= 0; overflow <=0; end
		endcase   
       end   
endmodule
