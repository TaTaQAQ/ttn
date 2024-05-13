module ntt2_pipeline #(
    parameter N = 32,  //位数
    parameter M = 64,  //个数
    parameter [32:0]p = (2**33) - (2**20) + 1
) (
    input clk,
    input reset,
    input [N:0] xin,
    input [N:0] yin,
    input en,

    output [N:0] xout,
    output [N:0] yout,
    output valid
);
   wire [2*N+1:0] z_temp [M-1:0];
   wire [N-1:0] c_temp [M-1:0];
   wire [N+1:0] d_temp [M-1:0];
   wire [N-1:0] e_temp [M-1:0];
   wire [N+2:0] f_temp [M-1:0];
   wire [N+2:0] r_temp [M-1:0];
   wire [4:0] en_temp [M-1:0];

        assign z = xin * yin;

genvar i;
generate 
    for(i=0; i<M-1; i=i+1) 
    begin
        assign z_temp[i] = z;
        assign en_temp[i][0] = en;
        assign valid = en_temp[i][4];
        assign yout = (xin - r_temp[i] + p)%p;
        assign xout = (xin + r_temp[i]) % p;
    end
endgenerate



seek_cd  #(.N(N))
      seek_cd_0
      (
        //input
        .clk(clk),
        .reset(reset),
        .en(en_temp[0][0]),
        .z(z_temp[0]),
        //output
        .c(c_temp[0]),
        .d(d_temp[0]),
        .rdy(en_temp[0][1])
      );

seek_e  #(.N(N))
      seek_e_0
      (
        //input
        .clk(clk),
        .reset(reset),
        .en(en_temp[0][1]),
        .c(c_temp[0]),
        //output
        .e(e_temp[0]),
        .rdy(en_temp[0][2])
      );

seek_f  #(.N(N))
      seek_f_0
      (
        //input
        .clk(clk),
        .reset(reset),
        .en(en_temp[0][2]),
        .c(c_temp[0]),
        .e(e_temp[0]),
        //output
        .f(f_temp[0]),
        .rdy(en_temp[0][3])
      );

seek_r  #(.N(N))
      seek_r_0
      (
        //input
        .clk(clk),
        .reset(reset),
        .en(en_temp[0][3]),
        .f(f_temp[0]),
        .z(z_temp[0]),
        .d(d_temp[0]),
        //output
        .r(r_temp[0]),
        .rdy(en_temp[0][4])
      );

genvar j;
generate 
    for (j = 1;j <= M-1;j = j + 1)
    begin
seek_cd  #(.N(N))
      seek_cd_circulate
      (
        //input
        .clk(clk),
        .reset(reset),
        .en(en_temp[j][1]),
        .z(z_temp[j]),
        //output
        .c(c_temp[j]),
        .d(d_temp[j]),
        .rdy(en_temp[j][1])
      );

seek_e  #(.N(N))
      seek_e_circulate
      (
        //input
        .clk(clk),
        .reset(reset),
        .en(en_temp[j][1]),
        .c(c_temp[j]),
        //output
        .e(e_temp[j]),
        .rdy(en_temp[j][2])
      );

seek_f  #(.N(N))
      seek_f_circulate
      (
        //input
        .clk(clk),
        .reset(reset),
        .en(en_temp[j][2]),
        .c(c_temp[j]),
        .e(e_temp[j]),
        //output
        .f(f_temp[j]),
        .rdy(en_temp[j][3])
      );

seek_r  #(.N(N))
      seek_r_circulate
      (
        //input
        .clk(clk),
        .reset(reset),
        .en(en_temp[j][3]),
        .f(f_temp[j]),
        .z(z_temp[j]),
        .d(d_temp[j]),
        //output
        .r(r_temp[j]),
        .rdy(en_temp[j][4])
      );


    end
endgenerate





endmodule