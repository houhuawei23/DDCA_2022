module testbench;
logic clk;
logic reset;
logic [31:0] writedata, dataadr;
logic memwrite;
// instantiate device to be tested
top dut (clk, reset, writedata, dataadr, memwrite);
// initialize test
initial
begin
	reset <= 1; # 22; reset <= 0;
end
// generate clock to sequence tests
always
begin
	clk <= 1; # 5; clk <= 0; # 5;
end
// check results
always @(negedge clk)
begin
	if (memwrite)
	begin
		if (dataadr===84 & writedata===7)
		begin
			$display("Simulation succeeded");
			
			$display("                   _______________________________________________________");
			$display("                  |                                                      |");
			$display("             /    |                                                      |");
			$display("            /---, |                                                      |");
			$display("       -----# ==| |                                                      |");
			$display("       | :) # ==| |                                                      |");
			$display("  -----'----#   | |______________________________________________________|");
			$display("  |)___()  '#   |______====____   \\___________________________________|");
			$display(" [_/,-,\\\"--\"------ //,-,  ,-,\\\\\\   |/             //,-,  ,-,  ,-,\\\\ __#");
			$display("   ( 0 )|===******||( 0 )( 0 )||-  o              '( 0 )( 0 )( 0 )||");
			$display("----'-'--------------'-'--'-'-----------------------'-'--'-'--'-'--------------");
			//$display("               _________________________________________________  ");
			//$display("           /|  |                                                 | ");
			//$display("           ||  |                                                 | ");
			//$display("   .----|-----,|                                                 | ");
			//$display("   ||  ||   ==||                                                 | ");
			//$display(" .-----'--'|==||                                                 | ");
			//$display(" |)-      ~|  ||_________________________________________________| ");
			//$display(" |  ___     |    |____...==..._  >\______________________________|  ");
			//$display("[_/.-.\\\"--\"-------- //.-.  .-.\\\\/   |/            \\\\ .-.  .-. // ");
			//$display("  ( o )`===\"\"\"\"\"\"\"\"\"`( o )( o )     o              `( o )( o )` ");
			//$display("   '-'                '-'  '-'                       '-'  '-'          ");
			$stop;
		end
		else if (dataadr !==80)
		begin
			$display("Simulation failed");
			$stop;
		end
	end
end
endmodule