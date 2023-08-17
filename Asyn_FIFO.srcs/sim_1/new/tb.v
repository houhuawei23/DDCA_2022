`timescale 1ns / 1ps


module tb();
	parameter DSIZE = 32;
	parameter ASIZE = 5;
    logic CLKA;
    logic CLKB;
    
    logic [DSIZE-1:0] rdata;
    logic wfull;
    logic rempty;
    
    logic [DSIZE-1:0] wdata;
    logic winc;
    logic wrst_n;
    logic rinc;
    logic rrst_n;
    
    fifo2 dutfifo(
                .rdata(rdata),
                .wfull(wfull),
                .rempty(rempty),
                .wdata(wdata),
                .winc(winc),
                .wclk(CLKA),
                .wrst_n(wrst_n),
                .rinc(rinc),
                .rclk(CLKB),
                .rrst_n(rrst_n));
    always begin
        #3;CLKA=~CLKA;
    end
    always begin
        #8;CLKB=~CLKB;
    end
	
    initial begin
        winc = 1'b0;
        rinc = 1'b0;
        CLKA = 1'b0;
        CLKB = 1'b0;
		
        wdata = 32'd0;
		rrst_n=1'b0;
        wrst_n=1'b0;
        #10;
        rrst_n=1'b1;
        wrst_n=1'b1;
		#50;
		
    end
		always @(posedge CLKA)begin
		        #1;
	        
				if (wfull == 1'b1) begin
				    winc <= 1'b0;
				    wdata <= wdata;
				end
				else begin
				    winc = 1'b1;
				    wdata = wdata+32'b1;
				end
			end
		
			always @(posedge CLKB)begin
			    #1;
			    if (rempty == 1'b1) begin
			        rinc=1'b0;
			    end
				else rinc <= 1'b1;
			end 
   
    
    
    
    
endmodule
