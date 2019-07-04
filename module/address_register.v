module address_register(IO,CE,WE,ALE,address_register_ready,address);
 input[3:0] IO;
 input CE;
 input WE;
 input ALE;
 output address_register_ready;
 output[11:0] address;
 wire[3:0] IO;
 reg[11:0] address;
 reg address_register_ready;
// int count ;
 always@(posedge WE or posedge CE )
  begin
   if(CE)
    begin
	 address<=0;
	 //address_ready=0;                 //地址准备好了
	end
   else if(!ALE)                        //
    begin
	 address<=address;
	end
   else                                 //ALE=1 地址从IO输入
     address<={address[7:0],IO[3:0]};
  end
 always@(negedge ALE or posedge CE)     //地址准备信号
  begin
   if(CE)
    address_register_ready<=0;
   else if(!ALE)
    address_register_ready<=1;
   else
    address_register_ready<=0;
  end
endmodule
	 