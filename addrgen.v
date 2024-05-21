`include "define.v"
module addrgen (
    input wire clk,
    input reset,
    input start,  // whole system start
    input valid,  
    output reg [`Addrwidth-1:0] i,  //number of bfus caculated 
    output reg [4:0] stage,  //wirte stage
    output reg en,  //bfu enable 
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
    output reg ram_flag_w,
    output reg stage_flag_r,
    output reg stage_flag_w,
    output reg [`Addrwidth-1:0] w_addr_0, 
    output reg [`Addrwidth-1:0] w_addr_1,
    output reg [`Addrwidth-1:0] r_addr_0,
    output reg [`Addrwidth-1:0] r_addr_1
);

reg en_1;
reg [9:0] k;  //块数
reg [9:0] n;  //每个块中写到第几个数
reg [4:0] j;//写的级数
reg [`Stage-1:0] num;  //每个块中数据个数


//启动 ????
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        en_1 <= 0;
        ram0_ena <= 0;
        ram1_ena <= 0;
        ram2_ena <= 0;
        ram3_ena <= 0;
        ram0_enb <= 0;
        ram1_enb <= 0;
        ram2_enb <= 0;
        ram3_enb <= 0;
    end else if (start) begin
        en_1 <= 1;
        ram0_ena <= 1;
        ram1_ena <= 1;
        ram2_ena <= 1;
        ram3_ena <= 1;
        ram0_enb <= 1;
        ram1_enb <= 1;
        ram2_enb <= 1;
        ram3_enb <= 1;
    end
end
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        en <= 0;
    end else if (start) begin
        en <= en_1;
    end    
    
end
// i �? j 自增
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        i <= 0;
    end 
    else if (en_1 & (i <= (`Stagebnum-1)))begin
        i <= i + 1;
    end 
    else if (i > (`Stagebnum-1)) begin
        i <= 0;
    end 
end
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        j <= 1;
        stage_flag_r <= 0;
    end 
    else if (i == (`Stagebnum - 1))begin
        j <= j + 1;
        stage_flag_r <= ~stage_flag_r;
    end 
end

// 读地�?
always @(*) begin
   r_addr_0 = i;
   r_addr_1 = i;
end

//NTT
`ifdef NTT
always @(*) begin
    num = `Stage'b1 << stage;
end

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        k <= 1;
        n <= 0; 
        stage <= 1;
        ram_flag_w <= 0;
        stage_flag_w <= 0;       
    end
    else if (valid) begin
        if ((k <= num)) begin

            if (n >= ((`Ringsize >> (stage+1))-1)) begin
                k <= k + 1;
                n <= 0;
                ram_flag_w <= ~ram_flag_w;
            end
            else begin
               n <= n + 1; 
            end

            if (!ram_flag_w) begin
                w_addr_0 <= (k-1) * (`Ringsize >> (stage+1)) + n;
                w_addr_1 <= k * (`Ringsize >> (stage+1)) + n;    
            end 
            else if (ram_flag_w) begin
                w_addr_0 <= (k-2) * (`Ringsize >> (stage+1)) + n;
                w_addr_1 <= (k-1) * (`Ringsize >> (stage+1)) + n;     
            end
        end
        
        if ((k == num) && (n == ((`Ringsize >> (stage+1))-1)))begin
            k <= 1;
            stage <= stage + 1;
            stage_flag_w <= ~stage_flag_w;
        end
    end
end        

`endif  

//ram 控制
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        ram0_wea <= 0;
        ram1_wea <= 0;
        ram2_wea <= 0;
        ram3_wea <= 0;
        ram0_web <= 0;
        ram1_web <= 0;
        ram2_web <= 0;
        ram3_web <= 0;
    end else if (en_1) begin
        if (!stage_flag_w) begin
            if (!ram_flag_w) begin
            ram0_wea <= 0;
            ram0_web <= 0;
            ram1_wea <= 0;
            ram1_web <= 0;
            ram2_wea <= 1;
            ram2_web <= 1;
            ram3_wea <= 0;
            ram3_web <= 0;         //ram0、ram1读;ram2写
            end else if (ram_flag_w) begin
            ram0_wea <= 0;
            ram0_web <= 0;
            ram1_wea <= 0; 
            ram1_web <= 0;
            ram2_wea <= 0;
            ram2_web <= 0;
            ram3_wea <= 1;
            ram3_web <= 1;          //ram0、ram1读;ram3写
            end
        end else if (stage_flag_w) begin
            if (!ram_flag_w) begin
            ram0_wea <= 1;
            ram0_web <= 1;
            ram1_wea <= 0;
            ram1_web <= 0;
            ram2_wea <= 0;
            ram2_web <= 0;
            ram3_wea <= 0;
            ram3_web <= 0;         //ram2、ram3读;ram0写         
            end else if (ram_flag_w) begin
            ram0_wea <= 0;
            ram0_web <= 0;
            ram1_wea <= 1;
            ram1_web <= 1;
            ram2_wea <= 0;
            ram2_web <= 0;
            ram3_wea <= 0;
            ram3_web <= 0;         //ram2、ram3读;ram1写   
            end
        end
    end  
end

//INTT
`ifdef INTT

`endif 
endmodule