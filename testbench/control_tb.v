`timescale 1ns/1ns
//控制单元测试，读测试

module control_tb;
 reg clk;
 reg CE;
 reg ALE;
 reg CLE;
 reg[3:0] command;
 reg address_ready;
 reg command_ready;
 reg cache_count_flag;
 reg forming_count_flag;
 reg write_count_flag;
 wire forming_writeread;
 wire we_writeread;
 wire re_writeread;
 wire WE_L;
 wire RE_L;
 wire en_decoder;
 wire en_state_count;
 wire RB;
 control U1(clk,CE,ALE,CLE,command,address_ready,command_ready,cache_count_flag,forming_count_flag,write_count_flag,we_writeread,re_writeread,forming_writeread,WE_L,RE_L,en_decoder,en_state_count,RB);
 always
  #5 clk=~clk;
 initial
  begin
   clk=1;
   CE=1;
   address_ready=0;
   command_ready=0;
   cache_count_flag=0;
   forming_count_flag=0;
   write_count_flag=0;
   #5 CE=0;               //初始化到S0状态
   end
  initial
   begin
    #15 command=4'b0001;  //t=15时 输入读命令 下一周期进入S1状态 将再t=20进入S1
	#40 address_ready=1;  //t=55时 地址准备好了 预计将进入S4状态  t=60正式进入S4
   end
  initial
   begin
    #85 cache_count_flag=1; //t=85时读入cache标志位1 t=90进入
   end	
 endmodule
   