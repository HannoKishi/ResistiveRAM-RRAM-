`timescale 1ns/1ns
module data_register_tb;
 reg RE;
 reg WE;
 reg RE_L;
 reg WE_L;
 reg CE;
 reg CLE;
 reg ALE;
 reg[4:0] register_add;
 reg[31:0] data_cache;
 reg data_in;
 wire[31:0] data_register;
 wire data_io;
 assign data_io=(!RE_L)?data_in:1'bz;
 data_register U1(CLE,ALE,data_io,data_cache,data_register,RE,WE,CE,RE_L,WE_L,register_add);
 //测试外部写入cache
 always
  begin
  #5 WE=!WE;
  end
 initial 
  begin
   RE_L=0;
   WE=0;
   CE=1;
   WE_L=0;
   //t=10
    #10   CE=0;
          WE_L=1;
          data_in=1;
    #10   data_in=1;
	#10   data_in=0;
	#10   data_in=1;
	#10   data_in=1;
	#10   data_in=0;
	#10   data_in=1;
	#10   data_in=1;
	#10   data_in=0;
	#10   data_in=1;
	#10   data_in=0;
	#10   data_in=1;
	#10   data_in=1;
	#10   data_in=0;
	#10   data_in=1;
	#10   data_in=1;
	#10   data_in=0;
	#10   data_in=1;
	#10   data_in=0;
	#10   data_in=1;
	#10   data_in=1;
	#10   data_in=0;
	#10   data_in=1;
	#10   data_in=1;
	#10   data_in=0;
	#10   data_in=1;
	#10   data_in=0;
	#10   data_in=1;
	#10   data_in=1;
	#10   data_in=0;
	#10   data_in=1;
	#10   data_in=1;
  end
 endmodule

	  