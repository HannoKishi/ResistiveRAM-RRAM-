`timescale 1ns/1ns
module data_register_tb2;
//读出测试
 reg RE;
 reg WE;
 reg RE_L;
 reg WE_L;
 reg CE;
 reg CLE;
 reg ALE;
 reg[4:0] register_add;
 reg[31:0] data_cache;
 wire data_io;
 wire[31:0] data_register;
 data_register U1(CLE,ALE,data_io,data_cache,data_register,RE,WE,CE,RE_L,WE_L,register_add);
 always
  #5 RE=!RE;
 initial
  begin
   CE=1;
   RE=1;
   RE_L=0;
   register_add=5'b11111;
   #10 CE=0;
       RE_L=1;
	   data_cache=32'b1001_1100_1111_0011;
	   //register_add=5'b00000;
   end
   
 always
  #10 register_add=register_add+1;
 
 endmodule
   