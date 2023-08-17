module decoder3e (n,ena,e);
	input [2:0] n;
	input       ena;
	output [7:0] e;
    
    // 请利用always结构说明语句填写代码，完成3-8译码器功能
    /********** Begin *********/
    function [7:0] select;
    input [2:0]n;
    input ena;
    if(!ena) select=8'b00000000;
    else begin
        case(n) 
            3'd0: select=8'b00000001;
            3'd1: select=8'b00000010;
            3'd2: select=8'b00000100;
            3'd3: select=8'b00001000;
            3'd4: select=8'b00010000;
            3'd5: select=8'b00100000;
            3'd6: select=8'b01000000;
            3'd7: select=8'b10000000;
        endcase
    end  
    endfunction
    assign e = select(n, ena);
    /********** End *********/
endmodule