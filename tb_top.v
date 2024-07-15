`timescale  1ns / 1ps

module tb_top;

// top Parameters
parameter PERIOD  = 10;


// top Inputs
reg   clk_in1                              = 0 ;
wire   clk                                 = 0 ;
reg   rst_n                                = 0 ;
reg   start                                = 0 ;

// top Outputs  
wire  valid_all                            ;


initial
begin
    forever #(PERIOD/2)  clk_in1 = ~clk_in1;
end

initial
begin
    #PERIOD rst_n  =  1;
    #PERIOD start =  1;
end

top  u_top (
    .clk_in1                 ( clk_in1     ),
    .rst_n                   ( rst_n       ),
    .start                   ( start       ),

    .clk                     ( clk        ),
    .valid_all               ( valid_all   )
);



endmodule