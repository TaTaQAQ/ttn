//模数
`define  p ((2**33)-(2**20)+1)

//data width
`define Datawidth 32

//ring size
`define Ringsize 256

//one stage bfu number = Ringsize/2
`define Stagebnum 128

//address width = log2(Ringsize)-1
`define Addrwidth 7

//stage number of whole ntt = log2(Ringsize)
`define Stage 8

//bfu number
`define Penumber 1

//NTT、INTT mode
`define NTT
//`define INTT

