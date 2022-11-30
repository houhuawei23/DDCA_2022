`timescale 1ns / 1ps

module button_set_time(
        input CLK, Reset,
        input reset,
        input set,
        input btnu_down, btnd_down, btnl_down, btnr_down, btnc_down,

        output reg [3:0]sethour1, 
        output reg [3:0]sethour2, 
        output reg [3:0]setminute1,
        output reg [3:0]setminute2,
        output reg [3:0]setsecond1,
        output reg [3:0]setsecond2
//        output reg [5:0] setbit
    );
reg [5:0] setbit;

always@(posedge CLK, negedge Reset)begin
    if(~Reset ||  reset)begin
        setbit <= 6'b00_00_01;
        sethour1 <= 4'b0; 
        sethour2 <= 4'b0;
        setminute1 <= 4'b0;
        setminute2 <= 4'b0;
        setsecond1 <= 4'b0;
        setsecond2 <= 4'b0;
    end

    else if(btnl_down) begin 
        setbit <= {setbit[4:0], setbit[5]};
        sethour1 <=   sethour1;
        sethour2 <=   sethour2;
        setminute1 <= setminute1;
        setminute2 <= setminute2;
        setsecond1 <= setsecond1;
        setsecond2 <= setsecond2;
    end
    else if(btnr_down)begin 
        setbit <= {setbit[0] ,setbit[5:1]};
        sethour1 <=   sethour1;
        sethour2 <=   sethour2;
        setminute1 <= setminute1;
        setminute2 <= setminute2;
        setsecond1 <= setsecond1;
        setsecond2 <= setsecond2;
    end 
    else if(btnu_down) begin
        case(setbit)
            6'b10_00_00:begin
                if(sethour1 < 4'd5) sethour1   <=  sethour1   + 4'b1;
                else sethour1 <=  sethour1;
            end
            6'b01_00_00:begin
                if(sethour1 < 4'd9)sethour2   <=  sethour2   + 4'b1;
                else sethour2   <=  sethour2;
            end
            6'b00_10_00:begin
                if(setminute1 < 4'd5)setminute1 <=  setminute1 + 4'b1;
                else setminute1 <=  setminute1;
            end
            6'b00_01_00:begin
                if(setminute2 < 4'd9)setminute2 <=  setminute2 + 4'b1;
                else setminute2 <=  setminute2;
            end
            6'b00_00_10:begin
                if(setsecond1 < 4'd5)setsecond1 <= setsecond1 + 4'b1;
                else setsecond1 <= setsecond1;
            end 
            6'b00_00_01:begin
                if(setsecond2 < 4'd9)setsecond2 <= setsecond2 + 4'b1;
                else setsecond2 <= setsecond2;
            end
            default:begin
                sethour1 <=   sethour1;
                sethour2 <=   sethour2;
                setminute1 <= setminute1;
                setminute2 <= setminute2;
                setsecond1 <= setsecond1;
                setsecond2 <= setsecond2;
                setbit <= setbit;
            end
        endcase
    end
    else if(btnd_down)begin
        case(setbit)
            6'b10_00_00:begin
                if(sethour1 <= 4'b0) sethour1 <= 4'b0;
                else sethour1   <=  sethour1   - 4'b1;
                end
            6'b01_00_00:begin
                if(sethour2 <= 4'b0) sethour2 <= 4'b0;
                else sethour2   <=  sethour2   - 4'b1;
                end
            6'b00_10_00:begin
                if(setminute1 <= 4'b0) setminute1 <= 4'b0;
                else setminute1 <=  setminute1 - 4'b1;
                end
            6'b00_01_00:begin
                if(setminute2 <= 4'b0) setminute2 <= 4'b0;
                else setminute2 <=  setminute2 - 4'b1;
                end
            6'b00_00_10:begin
                if(setsecond1 <= 4'b0) setsecond1 <= 4'b0;
                else setsecond1 <= setsecond1 -  4'b1;
                end
            6'b00_00_01:begin
                if(setsecond2 <= 4'b0) setsecond2 <= 4'b0;
                else setsecond2 <= setsecond2 -  4'b1;
                end
            default:begin
                sethour1 <=   sethour1;
                sethour2 <=   sethour2;
                setminute1 <= setminute1;
                setminute2 <= setminute2;
                setsecond1 <= setsecond1;
                setsecond2 <= setsecond2;
                setbit <= setbit;
            end
        endcase
    end
    else begin;
        sethour1 <=   sethour1;
        sethour2 <=   sethour2;
        setminute1 <= setminute1;
        setminute2 <= setminute2;
        setsecond1 <= setsecond1;
        setsecond2 <= setsecond2;
        setbit <= setbit;
    end
end
endmodule
