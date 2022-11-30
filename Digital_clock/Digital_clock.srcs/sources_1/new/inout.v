`timescale 1ns / 1ps

module in_out(
            input CLK,
            input BTNU, BTND, BTNL, BTNR, BTNC,
            input SW0, SW1, SW2, SW3, SW4, SW5, SW6,
            input SW13,SW14, SW15,
            output btnu_down, btnd_down, btnl_down, btnr_down, btnc_down,
            output sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw13,sw14, sw15
    );
wire btnu, btnd, btnl, btnr, btnc;
reg [2:0] btnu_reg;
reg [2:0] btnd_reg;
reg [2:0] btnl_reg;
reg [2:0] btnr_reg;
reg [2:0] btnc_reg;
assign btnu_down = ~btnu_reg[2]&(btnu_reg[1]);
assign btnd_down = ~btnd_reg[2]&(btnd_reg[1]);
assign btnl_down = ~btnl_reg[2]&(btnl_reg[1]);
assign btnr_down = ~btnr_reg[2]&(btnr_reg[1]);
assign btnc_down = ~btnc_reg[2]&(btnc_reg[1]);
always@(posedge CLK)begin
        btnu_reg<= {btnu_reg[1:0], btnu};
        btnd_reg<= {btnd_reg[1:0], btnd};
        btnl_reg<= {btnl_reg[1:0], btnl};
        btnr_reg<= {btnr_reg[1:0], btnr};
        btnc_reg<= {btnc_reg[1:0], btnc};
end
debounce deb1(
            .CLK(CLK),     
            .key_in(BTNU), 
            .key_out(btnu));
debounce deb2(
            .CLK(CLK),    
            .key_in(BTND), 
            .key_out(btnd));
debounce deb3(
            .CLK(CLK),    
            .key_in(BTNL), 
            .key_out(btnl));
debounce deb4(
            .CLK(CLK),    
            .key_in(BTNR), 
            .key_out(btnr));
debounce deb5(
            .CLK(CLK),    
            .key_in(BTNC), 
            .key_out(btnc));
debounce deb6(
            .CLK(CLK),    
            .key_in(SW0), 
            .key_out(sw0));
debounce deb7(
            .CLK(CLK),    
            .key_in(SW1), 
            .key_out(sw1));
debounce deb8(
            .CLK(CLK),    
            .key_in(SW2), 
            .key_out(sw2));
debounce deb9(
            .CLK(CLK),    
            .key_in(SW3), 
            .key_out(sw3));
debounce deb10(
            .CLK(CLK),    
            .key_in(SW4), 
            .key_out(sw4));
debounce deb11(
            .CLK(CLK),    
            .key_in(SW5), 
            .key_out(sw5));
debounce debsw6(
            .CLK(CLK),    
            .key_in(SW6), 
            .key_out(sw6));
debounce debsw13(
            .CLK(CLK),    
            .key_in(SW13), 
            .key_out(sw13));
debounce debsw14(
            .CLK(CLK),    
            .key_in(SW14), 
            .key_out(sw14));
debounce debsw15(
            .CLK(CLK),    
            .key_in(SW15), 
            .key_out(sw15));
endmodule

module debounce(
        input CLK,
        input key_in,
        output key_out
);
reg delay1;
reg delay2;
reg delay3;
always@(posedge CLK)begin
        delay1 <= key_in;
        delay2 <= delay1;
        delay3 <= delay2;
end
assign key_out = delay3;
endmodule
