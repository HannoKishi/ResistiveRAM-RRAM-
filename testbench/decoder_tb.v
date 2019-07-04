`timescale 1ns/1ns
//译码器地址计数测试
module decoder_tb;
 reg[11:0] din;
 reg en;
 reg clk;
 reg ALE;
 wire[3:0] dout_block;
 wire[31:0] dout_row;
 wire[31:0] dout_column;
 decoder U1(en,clk,ALE,din,dout_block,dout_row,dout_column);
 always
 #5 clk=~clk;
 initial
  begin
   clk=1;
   din=12'b0000_0000_0010;
   en=0;
   ALE=1;
   #5 ALE=0;                //t=5
   #5 en=1;                 //t=10
  end
 endmodule