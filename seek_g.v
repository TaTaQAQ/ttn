`include "define.v"
module seek_g
(
    input clk,
    input rst_n,
    input [`Datawidth-1:0] c,
    input [2*`Datawidth+1:0] z,
    input [`Datawidth-1:0] e,
    input [`Datawidth+2:0] f,
    input en,
    
    output reg [`Datawidth+2:0] g,
    output reg rdy
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            g <= 'b0;
            rdy <= 'b0;
        end 
        else if(en)begin
            g <= f - c[14:13] + z[32:0] - e[13];
            rdy <= en;
        end
        else begin
            g <= 'b0;
            rdy <= 'b0;
        end
    end
endmodule