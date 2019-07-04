module address_register_tb;
 reg[3:0] IO;
 reg CE;
 reg WE;
 reg ALE;
 wire[11:0] address;
 wire address_ready;
 address_register U1(IO,CE,WE,ALE,address_ready,address);
  initial
   fork
    #1 CE=1;
	#1   WE=0;
	#1   ALE=0;
	#10  CE=0;    //t=10
	#10     ALE=1;
	#10	 IO=4'b0001;
	#15	 WE=1;     //t=15
	#20  IO=4'b0010;
	#20     WE=0;
	#25  WE=1;
	#30  IO=4'b0100;
	#30     WE=0;
	#35  WE=1;
	#40  WE=0;
	#40  ALE=0;
   join
 endmodule
	
    