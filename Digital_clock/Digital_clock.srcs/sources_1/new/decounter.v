`timescale 1ns / 1ps

module decounter #(parameter base = 10)(
    input CLK,
    input cin,
    input reset,
    input set,
    input start_pause,
    input [3:0] scount,
    
    output reg[3:0] count,
    output reg cout);
    
reg [2:0] cin_reg;
wire cin_p;
reg mode;//1开始 0暂停

always@(posedge CLK, negedge reset)begin
    if(!reset) mode<=1'b0;
    else if(start_pause) mode<=~mode;
    else begin
        mode<=mode;
    end
end

always@(posedge CLK, negedge reset)begin
    if(!reset) begin
        cin_reg <=3'b0;
    end
    else begin 
        cin_reg <={cin_reg[1:0], cin};
    end
end
assign cin_p = ~cin_reg[2] && cin_reg[1];

always@(posedge CLK, negedge reset)begin
    if(!reset) begin //复位
        count <= 4'b0;
        cout <= 0;
    end
    else if(set==1'b1)begin//设置时间
        count <= scount;
    end
    else begin//自增
        if(cin_p && mode==1'b1) begin
            if(count !=0 ) count <=count + 4'd15;
            else begin
                count <=base-1;
                cout <= 1;
            end
        end
        else begin
            count<=count;
            cout<=0;
        end
    end
end

endmodule