`timescale 1ns/1ns
//测试从数据寄存器读出测试
module state_counter_tb3;
 reg clk;
 reg en;
 reg RE;
 reg CE;
 reg we;
 reg re;
 reg forming;
 reg RE_L;
 reg WE_L;
 wire cache_count_flag;
 wire forming_count_flag;
 wire write_count_flag;
 wire[4:0] cache_add;
 wire[4:0] register_add;
 state_counter U1(clk,en,RE,CE,we,re,forming,RE_L,WE_L,cache_count_flag,forming_count_flag,write_count_flag,cache_add,register_add);
 always
  #5 clk=~clk;
 initial
  begin
   clk=1;
   en=0;
   we=0;
   re=0;
   CE=1;
   RE=1;
   RE_L=1;
   #10 en=1;
//       forming=1;
	   CE=0;
          
  end
  always
  #10 RE=~RE;
endmodule