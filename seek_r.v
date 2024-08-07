`include "define.v"
module seek_r

(
    input clk,
    input rst_n,
    input [`Datawidth+2:0] g,
    input [`Datawidth+1:0] d,
    input en,
    
    output reg [`Datawidth+2:0] r,
    output reg rdy
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r <= 'b0;
            rdy <= 'b0;
        end 
        else if(en)begin
            r <= g - d;
            rdy <= en;
        end
        else begin
            r <= 'b0;
            rdy <= 'b0;
        end
    end
endmodule