`include "define.v"
module ntt2_pipeline_top_test (
    input clk_in1,
    input rst_n,
    input [`Datawidth:0] xin,
    input [`Datawidth:0] yin,
    input [`Datawidth:0] wr,
    input en,

    output [`Datawidth:0] xout,
    output [`Datawidth:0] yout,
    output reg clk,
    output valid
);

    wire [2*`Datawidth+1:0] z_temp ;
    wire [`Datawidth-1:0] c_temp ;
    wire [`Datawidth+1:0] d_temp ;
    wire [`Datawidth-1:0] e_temp ;
    wire [`Datawidth+2:0] f_temp ;
    wire [`Datawidth+2:0] g_temp ;
    wire [`Datawidth+2:0] r_temp ;
    wire [5:0] en_temp ;
    wire [2*`Datawidth+1:0] z ; 
    wire clk_out1;

    reg [`Datawidth:0] xin1;
    reg [`Datawidth:0] xin2;
    reg [`Datawidth:0] xin3;
    reg [`Datawidth:0] xin4;
    reg [`Datawidth:0] xin5;
    
    reg [2*`Datawidth+1:0] z_temp1; 
    reg [2*`Datawidth+1:0] z_temp2; 
    reg [2*`Datawidth+1:0] z_temp3; 

    reg [`Datawidth-1:0] c_temp1;
    reg [`Datawidth-1:0] c_temp2;

    reg [`Datawidth+1:0] d_temp1;
    reg [`Datawidth+1:0] d_temp2;
    reg [`Datawidth+1:0] d_temp3;

    reg [`Datawidth-1:0] e_temp1;

/*mult_gen_0 mul1 (
  .A(wr),  // input wire [32 : 0] A
  .B(yin),  // input wire [32 : 0] B
  .P(z)  // output wire [65 : 0] P
);*/
assign z = en?(wr * yin):z;  //求乘�?

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

    assign z_temp = z;
    assign en_temp[0] = en;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            xin1 <= 0;
            xin2 <= 0;
            xin3 <= 0;
            xin4 <= 0;
            xin5 <= 0;
        end else if (en) begin
            xin1 <= xin;
            xin2 <= xin1;
            xin3 <= xin2;
            xin4 <= xin3;
            xin5 <= xin4;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            z_temp1 <= 0;
            z_temp2 <= 0;
            z_temp3 <= 0;
        end else begin
            z_temp1 <= z_temp;
            z_temp2 <= z_temp1;
            z_temp3 <= z_temp2;
        end
    end

    seek_cd  seek_cd_circulate
        (
            //input
            .clk(clk),
            .rst_n(rst_n),
            .en(en_temp[0]),
            .z(z_temp),
            //output
            .c(c_temp),
            .d(d_temp),
            .rdy(en_temp[1])
        );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            c_temp1 <= 0;
            c_temp2 <= 0;
        end else begin
            c_temp1 <= c_temp;
            c_temp2 <= c_temp1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            d_temp1 <= 0;
            d_temp2 <= 0;
            d_temp3 <= 0;
        end else begin
            d_temp1 <= d_temp;
            d_temp2 <= d_temp1;
            d_temp3 <= d_temp2;
        end
    end


    seek_e    seek_e_circulate
        (
            //input
            .clk(clk),
            .rst_n(rst_n),
            .en(en_temp[1]),
            .c(c_temp),
            //output
            .e(e_temp),
            .rdy(en_temp[2])
        );

   always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            e_temp1 <= 0;
        end else begin
            e_temp1 <= e_temp;
        end
    end

    seek_f  seek_f_circulate
        (
            //input
            .clk(clk),
            .rst_n(rst_n),
            .en(en_temp[2]),
            .e(e_temp),
            //output
            .f(f_temp),
            .rdy(en_temp[3])
        );

    seek_g  seek_g_circulate
        (
            //input
            .clk(clk),
            .rst_n(rst_n),
            .en(en_temp[3]),
            .c(c_temp2),
            .z(z_temp3),
            .e(e_temp1),
            .f(f_temp),
            //output
            .g(g_temp),
            .rdy(en_temp[4])
        );

    seek_r  seek_r_circulate
        (
            //input
            .clk(clk),
            .rst_n(rst_n),
            .en(en_temp[4]),
            .g(g_temp),
            .d(d_temp3),
            //output
            .r(r_temp),
            .rdy(en_temp[5])
        );

    assign valid = en_temp[5];
//    assign xout = (xin5 + r_temp) % `p;
//    assign yout = (xin5 - r_temp + `p) % `p;
    assign xout = ((xin5 + r_temp)>=`p)?((xin5 + r_temp)-`p):(xin5 + r_temp);
    assign yout = ((xin5 - r_temp + `p)>=`p)?((xin5 - r_temp + `p)-`p):(xin5 - r_temp + `p);

endmodule
