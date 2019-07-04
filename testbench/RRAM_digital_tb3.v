`timescale 1ns/1ns
//整体数字模块测试(forming测试)
module RRAM_digital_tb3;
 reg[3:0] IO;
 reg clk;
 reg CE;
 reg ALE;
 reg CLE;
 reg WE;
 reg RE;
 reg rram_data_reg;
 reg Dinout_reg;
 wire rram_data;
 wire Dinout;
 //为了仿真IO口，设置了两个reg变量，并利用三态门给信号仿真,en有效时候通过reg向IO赋值
 reg en_rram;
 reg en_Dinout;
 assign rram_data=en_rram?rram_data_reg:1'bz;
 assign Dinout=en_Dinout?Dinout_reg:1'bz;
 //
 wire RB;
 wire rram_re;
 wire rram_we;
 wire rram_ce;
 wire[3:0] dout_block;
 wire[31:0] dout_row;
 wire[31:0] dout_column;
 //
 RRAM_digital U1(IO,clk,CE,ALE,CLE,WE,RE,Dinout,RB,rram_data,rram_ce,rram_we,rram_re,dout_block,dout_row,dout_column);
 //初始化
 always
  #5 clk=~clk;
 initial 
  begin
   clk=1;
   CE=1;
   ALE=0;
   CLE=0;
   WE=0;
   RE=0;
   rram_data_reg=0;
   Dinout_reg=0;
   en_Dinout=0;
   en_rram=0;
  end
 // 1命令输入
 initial
  begin
   #10 CE=0;            //t=10 使能信号拉低 芯片可以工作了
   #20 CLE=1;           //命令有效
   #10 IO=4'b0111;      //t=40
   #10 WE=1;            //写有效
   #10 WE=0;
   #10 IO=4'b0110;           //t=70 1命令输入完毕  将进入S3模式
   #10 WE=1;            //t=80 2命令输入 将进入S6
   #10 WE=0;
   #10 CLE=0;
       IO=4'bzzzz;
  end
 initial
  begin
   #41100 CE=1;
   #100   $finish;
  end
  
endmodule