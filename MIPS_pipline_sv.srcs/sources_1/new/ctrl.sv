`include "defines.sv"

module ctrl(
    input logic         rst,
    input logic         stallreq_from_id,
    input logic         stallreq_from_ex,
    output logic[5:0]   stall //  5wb, 4mem, 3ex, 2id, 1if, 0pc 
);

always_comb begin
    if(rst == `RstEnable)begin
        stall = 6'b000_000;
    end
    else if (stallreq_from_ex == `Stop) begin
         stall = 6'b001_111;
    end
    else if (stallreq_from_id == `Stop) begin // id, 
        stall = 6'b000_111;
    end
    else begin 
        stall = 6'b000_000;
    end
end

endmodule
