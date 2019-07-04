`timescale 1ns/1ns
//写入rram测试
module writeread_tb3;
 reg CE;
 reg clk;
 reg[31:0] data_register;
 reg re;
 reg we;
 reg forming;
 reg[4:0] cache_add;
 wire[31:0] data_cache;
 wire rram_data;
 wire rram_ce;
 wire rram_we;
 wire rram_re;
 reg en;
 reg rram_data_in;
 //assign en=(we|forming)&(~we);
 assign rram_data=(!en)?rram_data_in:1'bz;
 writeread U1(clk,CE,data_register,data_cache,re,we,cache_add,forming,rram_re,rram_we,rram_data,rram_ce);
 always
  #5 clk=~clk;
 
 initial
  begin
   CE=1;
   clk=1;
   re=0;
   we=0;
   forming=0;
   data_register=32'b0101_1010_1001_0011;
   cache_add=5'b00000;
   #5 CE=0;
   #5 we=0;   //t=10
      en=1;
      forming=1;   
  end
 endmodule
       