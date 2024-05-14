`include "defines.v"
module seek_r

(
    input clk,
    input reset,
    input [`Datawidth+2:0] f,
    input [2*`Datawidth+1:0] z,
    input [`Datawidth+1:0] d,
    input en,
    
    output reg [`Datawidth+2:0] r,
    output reg rdy
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            r <= 'b0;
            rdy <= 'b0;
        end 
        else if(en)begin
            r <= ((((f + z[32:0])>=`p)?((f + z[32:0]) - `p - d):((f + z[32:0]) - d)) < 0 ) ? ((((f + z[32:0])>=`p)?((f + z[32:0]) - `p - d):((f + z[32:0]) - d)) + `p) : (((f + z[32:0])>=`p)?((f + z[32:0]) - `p - d):((f + z[32:0]) - d));
            rdy <= en;
        end
        else begin
            r <= 'b0;
            rdy <= 'b0;
        end
    end
endmodule