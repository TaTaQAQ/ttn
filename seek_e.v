`include "defines.v"
module seek_e
 
(
    input clk,
    input reset,
    input [`Datawidth-1:0] c,
    input en,
    
    output reg [`Datawidth-1:0] e,
    output reg rdy
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            e <= 'b0;
            rdy <= 'b0;
        end 
        else if(en)begin
            e <= c[14:13] + c[12:0];
            rdy <= en;
        end
        else begin
            e <= 'b0;
            rdy <= 'b0;
        end
    end
endmodule