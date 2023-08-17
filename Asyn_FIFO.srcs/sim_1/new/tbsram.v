`timescale 1ns/1ns

module SRAM_DP_32X32_wrapper_tb;

logic CLKA,CENA,WENA;
logic [4:0] AA;
logic [31:0] DA;
logic [31:0] QA;

logic CLKB,CENB,WENB;
logic [4:0] AB;
logic [31:0] DB;
logic [31:0] QB;

// 例化SRAM DUT
SRAM_DP_32X32_wrapper DUT(
          .CLKA(CLKA), 
          .CENA(CENA), 
          .WENA(WENA), 
          .AA(AA), 
          .DA(DA), 
          .QA(QA), 

          .CLKB(CLKB), 
          .CENB(CENB), 
          .WENB(WENB), 
          .AB(AB), 
          .DB(DB),
          .QB(QB) 
   );

always #5 CLKA = ~CLKA;	// 异步时钟
always #7 CLKB = ~CLKB;	// 异步时钟

initial
begin
	CLKA = 1'b0;
	CLKB = 1'b0;
	CENA = 1'b1;
	CENB = 1'b1;
	
	AA = 5'd0;
	WENA = 1'b1;
	DA = 32'd0;
	AB = 5'd0;
	WENB = 1'b1;
	DB = 32'd0;
	
	#20;
	
	// 从A端口写入数据
	@(posedge CLKA);	// 等待CLKA的时钟上升沿
	#2;
	AA = 5'd10;		// 写入10号地址
	CENA = 1'b0;	// chip enable
	WENA = 1'b0;	// write enable
	DA = 32'h1234_5678;
	@(posedge CLKA);	// 等待CLKA的时钟上升沿
	#2;
	CENA = 1'b1;	// chip disable
	WENA = 1'b1;	// write disable
	
	#30;
	
	// 从B端口读取数据
	@(posedge CLKB);	// 等待CLKB的时钟上升沿
	#2;
	AB = 5'd10;
	CENB = 1'b0;	// chip enable
	WENB = 1'b1;	// write disable
	@(posedge CLKB);	// 等待CLKB的时钟上升沿
	#2;
	
	if (QB == 32'h1234_5678)
	begin
		$display("Read OK!");
	end
	else
	begin
		$display("Read error! QB=%X",QB);
	end
end

endmodule
