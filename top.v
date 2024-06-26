`include "define.v"
module top (
    input clk,
    input reset,
    input start,
    output reg valid_all
);
reg [`Datawidth:0] wr;
reg [`Datawidth:0] xin;
reg [`Datawidth:0] yin;
wire [`Datawidth:0] xout;
wire [`Datawidth:0] yout;

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
wire  ram_flag                             ;
wire  stage_flag                           ;
wire  [`Addrwidth-1:0]  w_addr_0           ;
wire  [`Addrwidth-1:0]  w_addr_1           ;
wire  [`Addrwidth-1:0]  r_addr_0           ;
wire  [`Addrwidth-1:0]  r_addr_1           ;

reg [`Datawidth:0] din0;
reg [`Datawidth:0] din1;
wire [`Datawidth:0] dout0;
wire [`Datawidth:0] dout1;

wire [`Addrwidth_rom:0] addr_rom;

ntt2_pipeline u_ntt2_pipeline (
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
    .ram_flag                ( ram_flag                      ),
    .stage_flag              ( stage_flag                    ),
    .w_addr_0                ( w_addr_0     [`Addrwidth-1:0] ),
    .w_addr_1                ( w_addr_1     [`Addrwidth-1:0] ),
    .r_addr_0                ( r_addr_0     [`Addrwidth-1:0] ),
    .r_addr_1                ( r_addr_1     [`Addrwidth-1:0] )
);

blk_mem_gen_0  blk_mem_rom0
             (
                .clka(clk),
                .addra(addr_rom),
                .ena(ena),
                .douta(wr)//output
                );

blk_mem_ram  blk_mem_ram0
             (
                .clka(clk),
                .addra(addra0),
                .dina(dina0),
                .douta(douta0),
                .ena(ram0_ena),
                .enb(ram0_enb),
                .wea(ram0_wea),
                .web(ram0_web),
                .clkb(clk),
                .addrb(addrb0),
                .dinb(dinb0),
                .doutb(doutb0)//output
                );

blk_mem_ram  blk_mem_ram1
             (
                .clka(clk),
                .addra(addra0),
                .dina(dina0),
                .douta(douta0),
                .ena(ram1_ena),
                .enb(ram1_enb),
                .wea(ram1_wea),
                .web(ram1_web),
                .clkb(clk),
                .addrb(addrb0),
                .dinb(dinb0),
                .doutb(doutb0)//output
                );

blk_mem_ram  blk_mem_ram2
             (
                .clka(clk),
                .addra(addra0),
                .dina(dina0),
                .douta(douta0),
                .ena(ram2_ena),
                .enb(ram2_enb),
                .wea(ram2_wea),
                .web(ram2_web),
                .clkb(clk),
                .addrb(addrb0),
                .dinb(dinb0),
                .doutb(doutb0)//output
                );

blk_mem_ram  blk_mem_ram3
             (
                .clka(clk),
                .addra(addra0),
                .dina(dina0),
                .douta(douta0),
                .ena(ram3_ena),
                .enb(ram3_enb),
                .wea(ram3_wea),
                .web(ram3_web),
                .clkb(clk),
                .addrb(addrb0),
                .dinb(dinb0),
                .doutb(doutb0)//output
                );
    
endmodule