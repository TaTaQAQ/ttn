`include "define.v"
module addrgen1 (
    input wire clk,
    input rst_n,
    input start, // whole system start
    input valid, 
    output reg [`Addrwidth:0] i,
    output reg [4:0] stage, //
    output reg en, //bfu enable 
    output reg ram0_ena,
    output reg ram1_ena,
    output reg ram2_ena,
    output reg ram3_ena,
    output reg ram0_enb,
    output reg ram1_enb,
    output reg ram2_enb,
    output reg ram3_enb,
    output reg ram0_wea,
    output reg ram1_wea,
    output reg ram2_wea,
    output reg ram3_wea,
    output reg ram0_web,
    output reg ram1_web,
    output reg ram2_web,
    output reg ram3_web,
    output reg w_ram_flag,
    output reg stage_flag,
    output reg [`Addrwidth-1:0] w_addr_0, 
    output reg [`Addrwidth-1:0] w_addr_1,
    output reg [`Addrwidth-1:0] r_addr_0,
    output reg [`Addrwidth-1:0] r_addr_1
);


reg en_d;
reg valid_d;
reg [4:0] j;
reg [9:0] n;
//bfu start
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        en <= 0;
    end else if (start) begin
        en <= 1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        en <= 0;
    end else if (start) begin
        en <= en_d;
    end    
end

//ram enable
always @(*) begin
    if (i < 4) begin
        if (!stage_flag) begin
            ram0_ena = start;
            ram0_enb = 0;
            ram1_ena = start;
            ram1_enb = 0;
            ram2_ena = 0;
            ram2_enb = 0;
            ram3_ena = 0;
            ram3_enb = 0;
        end else if (stage_flag) begin
            ram0_ena = 0;
            ram0_enb = 0;
            ram1_ena = 0;
            ram1_enb = 0;
            ram2_ena = start;
            ram2_enb = 0;
            ram3_ena = start;
            ram3_enb = 0;
        end
    end else if ((i >= 4) && (i < `Stagebnum)) begin
        if (!stage_flag) begin
            if (w_ram_flag) begin
            ram0_ena = start;
            ram0_enb = 0;
            ram1_ena = start;
            ram1_enb = 0;
            ram2_ena = start;
            ram2_enb = start;
            ram3_ena = 0;
            ram3_enb = 0;                
            end else if (!w_ram_flag) begin
            ram0_ena = start;
            ram0_enb = 0;
            ram1_ena = start;
            ram1_enb = 0;
            ram2_ena = 0;
            ram2_enb = 0;
            ram3_ena = start;
            ram3_enb = start;                
            end
        end else if (stage_flag) begin
            if (w_ram_flag) begin
            ram0_ena = start;
            ram0_enb = start;
            ram1_ena = 0;
            ram1_enb = 0;
            ram2_ena = start;
            ram2_enb = 0;
            ram3_ena = start;
            ram3_enb = 0;                
            end else if (!w_ram_flag) begin
            ram0_ena = 0;
            ram0_enb = 0;
            ram1_ena = start;
            ram1_enb = start;
            ram2_ena = start;
            ram2_enb = 0;
            ram3_ena = start;
            ram3_enb = 0;                
            end
        end
    end else if ((i >= `Stagebnum) && (i < (`Stagebnum+3))) begin
            ram0_ena = start;
            ram0_enb = start;
            ram1_ena = start;
            ram1_enb = start;
            ram2_ena = start;
            ram2_enb = 0;
            ram3_ena = start;
            ram3_enb = 0;        
    end
end

always @(posedge clk ) begin
    valid_d <= valid;
end
// read address
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 0;
    end 
    else if (en_d & (i <= (`Stagebnum+3))) begin
        i <= i + 1;
    end 
    else if (i > (`Stagebnum+3)) begin
        i <= 0;
    end 
end
always @(*) begin
    if (i < 128) begin
        r_addr_0 = i;
        r_addr_1 = i;
    end else begin
        r_addr_0 = 0;
        r_addr_1 = 0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
       j <= 1;
       stage_flag <= 0;
    end 
    else if (i == (`Stagebnum+3)) begin
       j <= j + 1;
       stage_flag <= ~stage_flag;
    end 
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        w_ram_flag <= 0;
        n <= 0;
    end 
    else if (valid) begin
        w_addr_0 <= n;
        w_addr_1 <= n + 1;

        if (n >= (`Stagebnum >> 1)) begin
            n <= 0;
            w_ram_flag <= ~w_ram_flag;
        end else begin
            n <= n + 2;
        end
    end
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ram0_wea <= 0;
        ram1_wea <= 0;
        ram2_wea <= 0;
        ram3_wea <= 0;
        ram0_web <= 0;
        ram1_web <= 0;
        ram2_web <= 0;
        ram3_web <= 0;
    end
    else if (en) begin
        if (!stage_flag) begin
            ram0_wea <= 0;
            ram1_wea <= 0; 
            if (!w_ram_flag) begin
                ram2_wea <= 1;
                ram2_web <= 1;
                ram3_wea <= 0;
                ram3_web <= 0;
            end else if (w_ram_flag) begin
                ram2_wea <= 0;
                ram2_web <= 0;
                ram3_wea <= 1;
                ram3_web <= 1;                
            end
        end else if (stage_flag) begin
            ram2_wea <= 0;
            ram3_wea <= 0;             
            if (!w_ram_flag) begin
                ram0_wea <= 1;
                ram0_web <= 1;
                ram1_wea <= 0;
                ram1_web <= 0;
            end else if (w_ram_flag) begin
                ram0_wea <= 0;
                ram0_web <= 0;
                ram1_wea <= 1;
                ram1_web <= 1;                
            end
        end
    end
    
end
endmodule