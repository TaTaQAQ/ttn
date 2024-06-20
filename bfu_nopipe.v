`include "define.v"
module bfu_nopipe (
    input clk,
    input reset,
    input [`Datawidth:0] xin,
    input [`Datawidth:0] yin,
    input [`Datawidth:0] wr,
    input en,

    output [`Datawidth:0] xout,
    output [`Datawidth:0] yout,
    output valid
);

    reg [`Datawidth+2:0] r ;
    reg [`Datawidth:0] xin1;
    reg [`Datawidth:0] yin1;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            r <= 0;
        end else if (en) begin
            r <= (yin*wr)%`p;
            xin1 <= xin;
        end
    end

    assign xout = (xin1 + r) % `p;
    assign yout = (xin1 - r + `p) % `p;
endmodule