module command_register_tb;
 reg[3:0] IO;
 reg CE;
 reg WE;
 reg CLE;
 wire[3:0] command;
 wire command_register_ready;
 command_register U1(.IO(IO),.CE(CE),.WE(WE),.CLE(CLE),.command(command),.command_register_ready(command_register_ready));
 initial
  begin
   CE=1;
   WE=0;
   CLE=0;
   #10 CE=0;                //t=10n
       CLE=1;
	   IO=4'b1111;
   #5  WE=1;                //t=15n
   #5  WE=0;                 //t=20n
       CLE=0;               
  end
endmodule
   