//~ `New testbench
`timescale  1ns / 1ps

module tb_ex;

// ex Parameters
parameter PERIOD  = 10;


// ex Inputs
reg   logic 	 
			RST= 0 ;
reg   logic[`AluOpBus]aluop_i= 0;
reg   logic[`AluSelBus]alusel_i= 0 ;
reg   logic[`RegBus]reg1_i= 0 ;
reg   logic[`RegBus]reg2_i= 0 ;
reg   logic[`RegAddrBus]waddr_i= 0 ;
reg   logic WE_i = 0 ;

// ex Outputs
wire  logic[`RegBus] 	wdata_o              ;
wire  logic[`RegAddrBus] 	waddr_o          ;
wire  logic 				WE_o                       ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

ex  u_ex (
    .logic 				RST                ( logic 				RST                 ),
    .logic[`AluOpBus] 	aluop_i    ( logic[`AluOpBus] 	aluop_i     ),
    .logic[`AluSelBus] 	alusel_i  ( logic[`AluSelBus] 	alusel_i   ),
    .logic[`RegBus] 		reg1_i      ( logic[`RegBus] 		reg1_i       ),
    .logic[`RegBus] 		reg2_i      ( logic[`RegBus] 		reg2_i       ),
    .logic[`RegAddrBus]	waddr_i   ( logic[`RegAddrBus]	waddr_i    ),
    .logic 				WE_i               ( logic 				WE_i                ),

    .logic[`RegBus] 	wdata_o      ( logic[`RegBus] 	wdata_o       ),
    .logic[`RegAddrBus] 	waddr_o  ( logic[`RegAddrBus] 	waddr_o   ),
    .logic 				WE_o               ( logic 				WE_o                )
);

initial
begin

    $finish;
end

endmodule
