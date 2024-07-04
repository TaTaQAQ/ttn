`include "define.v"
module seek_cd
(
    input clk,
    input rst_n,
    input [2*`Datawidth+1:0] z,
    input en,
    
    output reg [`Datawidth-1:0] c,
    output reg [`Datawidth+1:0] d,
    output reg rdy
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            c <= 'b0;
            d <= 'b0;
            rdy <= 'b0;
        end 
        else if(en)begin
            c <= z[65:59] + z[58:46] + z[45:33];
            d <= z[65:59] + z[65:46] + z[65:33];
            rdy <= en;
        end
        else begin
            c <= 'b0;
            d <= 'b0;
            rdy <= 'b0;
        end
    end
endmodule