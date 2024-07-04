`timescale  1ns / 1ps
`include "define.v"
module tb_addrgen1;

// addrgen1 Parameters
parameter PERIOD  = 10;


// addrgen1 Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   start                                = 0 ;
reg   valid                                = 0 ;

// addrgen1 Outputs
wire  [`Addrwidth:0]  i                    ;
wire  [4:0]           j                    ;
wire  bfu_en                               ;
wire  rom_en                               ;
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
wire  w_ram_flag                           ;
wire  stage_flag                           ;
wire  [`Addrwidth_rom:0]  addr_rom         ;
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
    #PERIOD rst_n  =  1;
    #PERIOD start =  1;
    #50 @(posedge clk) valid =  1;
end

addrgen1  u_addrgen1 (
    .clk                     ( clk                          ),
    .rst_n                   ( rst_n                        ),
    .start                   ( start                        ),
    .valid                   ( valid                        ),

    .i                       ( i           [`Addrwidth:0]   ),
    .j                       ( j           [4:0]            ),
    .bfu_en                  ( bfu_en                       ),
    .rom_en                  ( rom_en                       ),
    .ram0_ena                ( ram0_ena                     ),
    .ram1_ena                ( ram1_ena                     ),
    .ram2_ena                ( ram2_ena                     ),
    .ram3_ena                ( ram3_ena                     ),
    .ram0_enb                ( ram0_enb                     ),
    .ram1_enb                ( ram1_enb                     ),
    .ram2_enb                ( ram2_enb                     ),
    .ram3_enb                ( ram3_enb                     ),
    .ram0_wea                ( ram0_wea                     ),
    .ram1_wea                ( ram1_wea                     ),
    .ram2_wea                ( ram2_wea                     ),
    .ram3_wea                ( ram3_wea                     ),
    .ram0_web                ( ram0_web                     ),
    .ram1_web                ( ram1_web                     ),
    .ram2_web                ( ram2_web                     ),
    .ram3_web                ( ram3_web                     ),
    .w_ram_flag              ( w_ram_flag                   ),
    .stage_flag              ( stage_flag                   ),
    .addr_rom                ( addr_rom   [`Addrwidth_rom:0]),
    .w_addr_0                ( w_addr_0    [`Addrwidth-1:0] ),
    .w_addr_1                ( w_addr_1    [`Addrwidth-1:0] ),
    .r_addr_0                ( r_addr_0    [`Addrwidth-1:0] ),
    .r_addr_1                ( r_addr_1    [`Addrwidth-1:0] )
);



endmodule