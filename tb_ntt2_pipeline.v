`include "defines.v"
`timescale  1ns / 1ps      

module tb_ntt2_pipeline;   

// ntt2_pipeline Parameters
parameter PERIOD = 10    ; 
parameter [32:0]p = (2**33) - (2**20) + 1;
parameter MAX_NUM = 32'hffffffff;

// ntt2_pipeline Inputs
reg   clk                                  = 0 ;
reg   reset                                = 0 ;
reg   [`Datawidth:0]  xin                           = 0 ;
reg   [`Datawidth:0]  yin                           = 0 ;
reg   [`Datawidth:0]  wr                            = 0 ;
reg   en                                   = 0 ;

// ntt2_pipeline Outputs
wire  [`Datawidth:0]  xout                          ;
wire  [`Datawidth:0]  yout                          ;
wire  valid                                ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) reset  =  1;
end

ntt2_pipeline #(
    .p ( p ))
 u_ntt2_pipeline (
    .clk                     ( clk          ),
    .reset                   ( reset        ),
    .xin                     ( xin    [`Datawidth:0] ),
    .yin                     ( yin    [`Datawidth:0] ),
    .wr                      ( wr     [`Datawidth:0] ),
    .en                      ( en           ),

    .xout                    ( xout   [`Datawidth:0] ),
    .yout                    ( yout   [`Datawidth:0] ),
    .valid                   ( valid        )
);

initial
begin

#10 en = 1;
#10 wr = 'd2**10;

end

always @(posedge clk) begin
        xin <= {$random()} % MAX_NUM;
        yin <= {$random()} % MAX_NUM;
end

endmodule