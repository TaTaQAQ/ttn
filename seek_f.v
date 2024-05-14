`include "defines.v"
module seek_f
(
    input clk,
    input reset,
    input [`Datawidth-1:0] c,
    input [`Datawidth-1:0] e,
    input en,
    
    output reg [`Datawidth+2:0] f,
    output reg rdy
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            f <= 'b0;
            rdy <= 'b0;
        end 
        else if(en)begin
            f <= (e[13] + e[12:0])*(2**20) - e[13] - c[14:13];
            rdy <= en;
        end
        else begin
            f <= 'b0;
            rdy <= 'b0;
        end
    end
endmodule