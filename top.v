`include "define.v"
module top (
    input clk_in1,
    input rst_n,
    input start,
    output reg clk,
    output reg valid_all
);
wire [`Datawidth:0] wr;
reg [`Datawidth:0] bfu_xin;
reg [`Datawidth:0] bfu_yin;
wire [`Datawidth:0] bfu_xout;
wire [`Datawidth:0] bfu_yout;

wire clk_out1;
wire  [`Addrwidth:0]  i                    ;
wire  [4:0]  j                             ;
wire  valid                                ;
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
wire  [`Addrwidth-1:0]  w_addr_0           ;
wire  [`Addrwidth-1:0]  w_addr_1           ;
wire  [`Addrwidth-1:0]  r_addr_0           ;
wire  [`Addrwidth-1:0]  r_addr_1           ;
wire  [`Addrwidth_rom:0]  addr_rom         ;
wire  [`Addrwidth-1:0]  addr_ram0_a        ;
wire  [`Addrwidth-1:0]  addr_ram0_b        ;
wire  [`Addrwidth-1:0]  addr_ram1_a        ;
wire  [`Addrwidth-1:0]  addr_ram1_b        ;
wire  [`Addrwidth-1:0]  addr_ram2_a        ;
wire  [`Addrwidth-1:0]  addr_ram2_b        ;
wire  [`Addrwidth-1:0]  addr_ram3_a        ;
wire  [`Addrwidth-1:0]  addr_ram3_b        ;

reg  [`Datawidth:0]    ram0_dina          ;  
reg  [`Datawidth:0]    ram0_dinb          ;  
reg  [`Datawidth:0]    ram1_dina          ;  
reg  [`Datawidth:0]    ram1_dinb          ;  
reg  [`Datawidth:0]    ram2_dina          ;  
reg  [`Datawidth:0]    ram2_dinb          ;  
reg  [`Datawidth:0]    ram3_dina          ;  
reg  [`Datawidth:0]    ram3_dinb          ;
wire [`Datawidth:0]    ram0_douta         ;
wire [`Datawidth:0]    ram0_doutb         ;
wire [`Datawidth:0]    ram1_douta         ;
wire [`Datawidth:0]    ram1_doutb         ;
wire [`Datawidth:0]    ram2_douta         ;
wire [`Datawidth:0]    ram2_doutb         ;
wire [`Datawidth:0]    ram3_douta         ;
wire [`Datawidth:0]    ram3_doutb         ;


//data distrubition
always @(*) begin
   if (!stage_flag) begin
    bfu_xin = ram0_douta;
    bfu_yin = ram1_douta;
    ram2_dina = bfu_xout;
    ram2_dinb = bfu_yout;
    ram3_dina = bfu_xout;
    ram3_dinb = bfu_yout;     
   end else if (stage_flag) begin
    bfu_xin = ram2_douta;
    bfu_yin = ram3_douta;
    ram0_dina = bfu_xout;
    ram0_dinb = bfu_yout;      
    ram1_dina = bfu_xout;
    ram1_dinb = bfu_yout;       
   end
end

clk_wiz_0 ins_clk_1
   (
    // Clock out ports
    .clk_out1(clk_out1),     // output clk_out1
    // Status and control signals
    .resetn(rst_n), // input reset
   // Clock in ports
    .clk_in1(clk_in1)      // input clk_in1
);
always @(*) begin
   clk = clk_out1;
end

// instances
ntt2_pipeline_top u_ntt2_pipeline (
    .clk                     ( clk          ),
    .rst_n                   ( rst_n        ),
    .xin                     ( bfu_xin    [`Datawidth:0] ),
    .yin                     ( bfu_yin    [`Datawidth:0] ),
    .wr                      ( wr         [`Datawidth:0] ),
    .en                      ( bfu_en       ),

    .xout                    ( bfu_xout   [`Datawidth:0] ),
    .yout                    ( bfu_yout   [`Datawidth:0] ),
    .valid                   ( valid        )
);

addrgen2  u_addrgen2 (
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
    .r_addr_1                ( r_addr_1    [`Addrwidth-1:0] ),
    .addr_ram0_a             ( addr_ram0_a [`Addrwidth-1:0] ),
    .addr_ram0_b             ( addr_ram0_b [`Addrwidth-1:0] ),
    .addr_ram1_a             ( addr_ram1_a [`Addrwidth-1:0] ),
    .addr_ram1_b             ( addr_ram1_b [`Addrwidth-1:0] ),
    .addr_ram2_a             ( addr_ram2_a [`Addrwidth-1:0] ),
    .addr_ram2_b             ( addr_ram2_b [`Addrwidth-1:0] ),
    .addr_ram3_a             ( addr_ram3_a [`Addrwidth-1:0] ),
    .addr_ram3_b             ( addr_ram3_b [`Addrwidth-1:0] )
);

blk_mem_gen_0  blk_mem_rom0
             (
                .clka(clk),
                .addra(addr_rom),
                .ena(rom_en),
                .douta(wr)//output
                );

blk_mem_ram0  blk_mem_ram0
             (
                .clka(clk),
                .addra(addr_ram0_a),
                .dina(ram0_dina),
                .douta(ram0_douta),
                .ena(ram0_ena),
                .enb(ram0_enb),
                .wea(ram0_wea),
                .web(ram0_web),
                .clkb(clk),
                .addrb(addr_ram0_b),
                .dinb(ram0_dinb),
                .doutb(ram0_doutb)//output
                );

blk_mem_ram1  blk_mem_ram1
             (
                .clka(clk),
                .addra(addr_ram1_a),
                .dina(ram1_dina),
                .douta(ram1_douta),
                .ena(ram1_ena),
                .enb(ram1_enb),
                .wea(ram1_wea),
                .web(ram1_web),
                .clkb(clk),
                .addrb(addr_ram1_b),
                .dinb(ram1_dinb),
                .doutb(ram1_doutb)//output
                );

blk_mem_ram2  blk_mem_ram2
             (
                .clka(clk),
                .addra(addr_ram2_a),
                .dina(ram2_dina),
                .douta(ram2_douta),
                .ena(ram2_ena),
                .enb(ram2_enb),
                .wea(ram2_wea),
                .web(ram2_web),
                .clkb(clk),
                .addrb(addr_ram2_b),
                .dinb(ram2_dinb),
                .doutb(ram2_doutb)//output
                );

blk_mem_ram3  blk_mem_ram3
             (
                .clka(clk),
                .addra(addr_ram3_a),
                .dina(ram3_dina),
                .douta(ram3_douta),
                .ena(ram3_ena),
                .enb(ram3_enb),
                .wea(ram3_wea),
                .web(ram3_web),
                .clkb(clk),
                .addrb(addr_ram3_b),
                .dinb(ram3_dinb),
                .doutb(ram3_doutb)//output
                );
    
endmodule