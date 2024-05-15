`include "define.v"
`timescale  1ns / 1ps

module tb_addrgen;

// addrgen Parameters
parameter PERIOD  = 10;


// addrgen Inputs
reg   clk                                  = 0 ;
reg   reset                                = 0 ;
reg   start                                = 0 ;
reg   valid                                = 0 ;

// addrgen Outputs
wire  [`Addrwidth-1:0]  i                  ;
wire  [4:0]  j                             ;
wire  en                                   ;
wire  ram0_ena                             ;
wire  ram1_ena                             ;
wire  ram2_ena                             ;
wire  ram3_ena                             ;
wire  ram0_enb                             ;
wire  ram1_enb                             ;
wire  ram2_enb                             ;
wire  ram3_enb                             ;
wire  ram0_wea                             ;
wire  ram1_wea                             ;
wire  ram2_wea                             ;
wire  ram3_wea                             ;
wire  ram0_web                             ;
wire  ram1_web                             ;
wire  ram2_web                             ;
wire  ram3_web                             ;
wire  [`Addrwidth-1:0]  w_addr_0           ;
wire  [`Addrwidth-1:0]  w_addr_1           ;
wire  [`Addrwidth-1:0]  r_addr_0           ;
wire  [`Addrwidth-1:0]  r_addr_1           ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #55  valid=1;
end

initial
begin
    #(PERIOD*2) reset  =  1;
    #10 start = 1;
end

addrgen  u_addrgen (
    .clk                     ( clk                           ),
    .reset                   ( reset                         ),
    .start                   ( start                         ),
    .valid                   ( valid                         ),

    .i                       ( i            [`Addrwidth-1:0] ),
    .j                       ( j            [4:0]            ),
    .en                      ( en                            ),
    .ram0_ena                ( ram0_ena                      ),
    .ram1_ena                ( ram1_ena                      ),
    .ram2_ena                ( ram2_ena                      ),
    .ram3_ena                ( ram3_ena                      ),
    .ram0_enb                ( ram0_enb                      ),
    .ram1_enb                ( ram1_enb                      ),
    .ram2_enb                ( ram2_enb                      ),
    .ram3_enb                ( ram3_enb                      ),
    .ram0_wea                ( ram0_wea                      ),
    .ram1_wea                ( ram1_wea                      ),
    .ram2_wea                ( ram2_wea                      ),
    .ram3_wea                ( ram3_wea                      ),
    .ram0_web                ( ram0_web                      ),
    .ram1_web                ( ram1_web                      ),
    .ram2_web                ( ram2_web                      ),
    .ram3_web                ( ram3_web                      ),
    .w_addr_0                ( w_addr_0     [`Addrwidth-1:0] ),
    .w_addr_1                ( w_addr_1     [`Addrwidth-1:0] ),
    .r_addr_0                ( r_addr_0     [`Addrwidth-1:0] ),
    .r_addr_1                ( r_addr_1     [`Addrwidth-1:0] )
);



endmodule