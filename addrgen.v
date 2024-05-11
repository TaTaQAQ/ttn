`include "defines.v"
module addrgen (
    input wire clk,
    input reset,
    input start,  // whole system start
    input valid,  
    output reg [`Addrwidth-1:0] i,  //number of bfus caculated 
    output reg [4:0] j,  //stage 
    output reg ena_0,
    output reg ena_1,
    output reg ena_2,
    output reg enb_0,
    output reg enb_1,
    output reg enb_2,
    output reg wea_0,
    output reg wea_1,
    output reg wea_2,
    output reg [`Addrwidth-1:0] w_addr_ram0, 
    output reg [`Addrwidth-1:0] w_addr_ram1,
    output reg [`Addrwidth-1:0] w_addr_ram2,
    output reg [`Addrwidth-1:0] r_addr_ram0,
    output reg [`Addrwidth-1:0] r_addr_ram1,
    output reg [`Addrwidth-1:0] r_addr_ram2
);

reg en;
reg [5:0] k;  //块数
reg [5:0] n;  //每个块中写到第几个数
reg [5:0] num;  //每个块中数据个数
reg ram_flag;

//启动 ????
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        en <= 0;
    end else if (start) begin
        en <= 1;
    end
end
// i 和 j 自增
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        i = 0;
    end 
    else if (valid & (i <= (`Stagebnum-1)))begin
        i = i + 1;
    end 
    else if (i > (`Stagebnum-1)) begin
        i = 0;
    end 
end
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        j = 1;
    end 
    else if (i == `Stagebnum)begin
        j = j + 1;
    end 
end

// 读地址
always @(*) begin
   r_addr_ram0 = i;
   r_addr_ram1 = i;
   r_addr_ram2 = r_addr_ram0;
   w_addr_ram2 = w_addr_ram0;
end

//NTT
`ifdef NTT
always @(*) begin
    num = `Stage'b1 << j;
end

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        k <= 1;
        n <= 0; 
        ram_flag <= 0;       
    end
    else if (valid) begin
        if (k <= num) begin

            if (ram_flag) begin
                w_addr_ram0 <= (k-1) * (`Ringsize >> (j+1)) + n;
                w_addr_ram1 <= k * (`Ringsize >> (j+1)) + n;    
            end 
            else if (!ram_flag) begin
                w_addr_ram0 <= (k-2) * (`Ringsize >> (j+1)) + n;
                w_addr_ram1 <= (k-1) * (`Ringsize >> (j+1)) + n;     
            end

            if (n >= ((`Ringsize >> (j+1))-1)) begin
                k = k + 1;
                n = 0;
                ram_flag = ~ram_flag;
            end
            else begin
               n = n + 1; 
            end
        end
        else if ((k == num) && (n == ((`Ringsize >> (j+1))-1)))begin
            k = 1;
        end
    end
end        

`endif  


//INTT
`ifdef INTT

`endif 
endmodule