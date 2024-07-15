`include "define.v"
`timescale  1ns / 1ps      

module tb_ntt2_pipeline;   

// ntt2_pipeline Parameters
parameter PERIOD = 10    ; 
parameter [32:0]p = (2**33) - (2**20) + 1;
parameter MAX_NUM = 32'hffffffff;

// ntt2_pipeline Inputs
reg   clk_in1                              = 0 ;
reg   rst_n                                = 0 ;
reg   [`Datawidth:0]  xin                  = 0 ;
reg   [`Datawidth:0]  yin                  = 0 ;
reg   [`Datawidth:0]  wr                   = 0 ;
reg   en                                   = 0 ;

// ntt2_pipeline Outputs
wire  [`Datawidth:0]  xout                     ;
wire  [`Datawidth:0]  yout                     ;
wire  clk                                      ;
wire  valid                                    ;


initial
begin
    forever #(PERIOD/2)  clk_in1=~clk_in1;
end

initial
begin
    #PERIOD rst_n  =  1;
end

ntt2_pipeline_top_test u_ntt2_pipeline (
    .clk_in1                 ( clk_in1      ),
    .rst_n                   ( rst_n        ),
    .xin                     ( xin    [`Datawidth:0] ),
    .yin                     ( yin    [`Datawidth:0] ),
    .wr                      ( wr     [`Datawidth:0] ),
    .en                      ( en           ),

    .xout                    ( xout   [`Datawidth:0] ),
    .yout                    ( yout   [`Datawidth:0] ),
    .clk                     ( clk          ),   
    .valid                   ( valid        )
);

initial
begin
wr = 'd2**10;
#10 en = 1;

end

always @(posedge clk) begin
        xin <= {$random()} % MAX_NUM;
        yin <= {$random()} % MAX_NUM;
end

endmodule