`timescale 1ns/1ns
module IO_data_tb;
 reg en;
 reg din;
 reg data_in_t;
 wire dout;
 wire dinout;
 IO_data U1(en,din,dout,dinout);
 initial 
  begin
   din=1;
   en=0;
   #10 din=0; //t=10
       data_in_t=1;
   #10 din=1; //t=20
       data_in_t=0;
   #10 en=1;  //t=30
       din=1;
   #10 din=0;  //t=40
   #10 din=1;
   #20 din=0;
  end
 assign dinout=(!en)?data_in_t:1'bz;
endmodule