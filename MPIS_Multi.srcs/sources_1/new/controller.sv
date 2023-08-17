`timescale 1ns / 1ps
`include "defines.v"
module controller(
    input logic clk, reset,
    input logic [5:0] op, funct,
    input logic zero,
    
    output logic memtoreg,
    output logic regdst,
    output logic iord,
    output logic pcsrc,
    output logic [1:0] alusrcb,
    output logic alusrca,
    output logic irwrite,
    output logic memwrite,
//    output logic pcwrite,
//    output logic branch,
    output logic pcen,
    output logic regwrite,
    output logic [2:0] alucontrol
    );
logic [7:0] state;
parameter Fetch         = 8'd00,
           Decode        = 8'd01,
           MemAdr        = 8'd02,
           MemRead       = 8'd03,
           MemWriteback  = 8'd04,
           MemWrite      = 8'd05,
           Execute       = 8'd06,
           Writeback     = 8'd07,
           Branch        = 8'd08,
           ADDIExcute    = 8'd09,
           ADDIWriteback = 8'd10,
           Jump          = 8'd11;
always_ff @(posedge clk, negedge reset)begin
    if(!reset) 
        state <= Fetch;
    else begin
        case(state)
            Fetch:
                begin
                    state <=Decode;
                end
            Decode:
                begin
                    if(op ==`LW_OP || op == `SW_OP)
                        state <=MemAdr;
                    else if(op == `R_OP)
                        state <= Execute;
                end
            MemAdr:    
                begin
                    state <=Decode;
                end
            MemRead:
                begin
                    state <=Decode;
                end
            MemWriteback:
                begin
                    state <=Decode;
                end
            Execute:
                begin
                    state <=Decode;
                end
            Writeback:
                begin
                    state <=Decode;
                end
            Branch:
                begin
                    state <=Decode;
                end
            ADDIExcute:
                begin
                    state <=Decode;
                end
            ADDIWriteback:
                begin
                    state <=Decode;
                end
            Jump:
                begin
                    state <=Decode;
                end
        endcase 
    end
end
endmodule



module FSM();


endmodule
