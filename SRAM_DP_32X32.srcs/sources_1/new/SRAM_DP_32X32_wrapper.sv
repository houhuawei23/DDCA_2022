//32*32

module SRAM_DP_32X32_wrapper (
          QA, 
          QB, 
          CLKA, 
          CENA, 
          WENA, 
          AA, 
          DA, 
          CLKB, 
          CENB, 
          WENB, 
          AB, 
          DB
   );

   output [31:0]            QA;
   output [31:0]            QB;
   //port A input
   input                    CLKA;
   input                    CENA; //Chip Enables (active low)
   input                    WENA;
   input [4:0]              AA;
   input [31:0]             DA;
   //port B input 
   input                    CLKB;
   input                    CENB;
   input                    WENB;
   input [4:0]              AB;
   input [31:0]             DB;

   SRAM_DP_32X32 u0 (
         .CENYA(),
         .WENYA(),
         .AYA(),
         .CENYB(),
         .WENYB(),
         .AYB(),
         .QA(QA),
         .QB(QB),
         .SOA(),
         .SOB(),
         .CLKA(CLKA),
         .CENA(CENA),
         .WENA(WENA),
         .AA(AA),
         .DA(DA),
         .CLKB(CLKB),
         .CENB(CENB),
         .WENB(WENB),
         .AB(AB),
         .DB(DB),
         .EMAA(3'd3),	// use default value
         .EMAWA(2'd1),	// use default value
         .EMASA(1'b0),	// use default value
         .EMAB(3'd3),	// use default value
         .EMAWB(2'd1),	// use default value
         .EMASB(1'b0),	// use default value
         .TENA(1'b1),	// disable test
         .TCENA(1'b1),
         .TWENA(1'b1),
         .TAA(5'b0),
         .TDA(32'b0),
         .TENB(1'b1),	// disable test
         .TCENB(1'b1),
         .TWENB(1'b1),
         .TAB(5'b0),
         .TDB(32'b0),
         .RET1N(1'b1),
         .SIA(2'b0),
         .SEA(1'b0),	// disable scan
         .DFTRAMBYP(1'b0),
         .SIB(2'b0),
         .SEB(1'b0),	// disable scan
         .COLLDISN(1'b1)
   );

endmodule // SRAM_DP_32X32_wrapper

