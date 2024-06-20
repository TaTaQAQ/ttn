`include "define.v"
`timescale  1ns / 1ps      

module tb_bfu_nopipe;   

//  Parameters
parameter PERIOD = 10    ; 
parameter MAX_NUM = 32'hffffffff;

//  Inputs
reg   clk                                  = 0 ;
reg   reset                                = 0 ;
reg   [`Datawidth:0]  xin                           = 0 ;
reg   [`Datawidth:0]  yin                           = 0 ;
reg   [`Datawidth:0]  wr                            = 0 ;
reg   en                                   = 0 ;

//  Outputs
wire  [`Datawidth:0]  xout                          ;
wire  [`Datawidth:0]  yout                          ;
wire  valid                                ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #PERIOD reset  =  1;
end

bfu_nopipe u_bfu_nopipe (
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
wr = 'd2**10;
#10 en = 1;

end

always @(posedge clk) begin
        xin <= {$random()} % MAX_NUM;
        yin <= {$random()} % MAX_NUM;
end

endmodule