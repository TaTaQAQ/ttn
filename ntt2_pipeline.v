`include "define.v"
module ntt2_pipeline  (
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

    ntt2_pipeline_top  ntt2_pipeline_top_circulate
                      (
                        //input
                        .clk(clk),
                        .reset(reset),
                        .xin(xin),
                        .yin(yin),
                        .wr(wr),
                        .en(en),
                        //output
                        .xout(xout),
                        .yout(yout),
                        .valid(valid)
                      );

endmodule

