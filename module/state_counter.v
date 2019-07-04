module state_counter(clk,en,RE,CE,we,re,forming,RE_L,WE_L,cache_count_flag,forming_count_flag,write_count_flag,cache_add,register_add);
 input clk;
 input en;                                       //可以考虑加个计数器使能，为零的时候相当于计数器置零，标志清零
// input WE;
 input RE;
 input CE;
 input we;                                       //control给的 从cache写入rram 有效
 input re;                                       //control给的 从rram读入cache有效
 input forming;                                  //control给的 forming开始
 input RE_L;                                     //control给的 data_register 读写使能
 input WE_L;                  
 output cache_count_flag;                        //给control写cache完成标志
 output forming_count_flag;                      //给control的forming_计数器完成标志
 output write_count_flag;                        //给control写计数flag 
 output[4:0] cache_add;                          //cache写操作所用的register地址
 output[4:0] register_add;                       //从data_regester读出所用地址
 wire [4:0] cache_add;
 reg[4:0] register_add;
 reg[5:0] read_count;                            //从rram读到cache的计数标志
 reg[12:0] forming_count;                        //forming操作计数
 reg[5:0] cache_add_count;
 assign write_count_flag=(cache_add_count[5])&we;        //cache_add==11111 表示计数32次完毕
 assign cache_count_flag=(read_count[5])&re;       //read_count==11111 表示从rram读出到cache了 32个数据
 assign forming_count_flag=(forming_count[12])&forming;
 assign cache_add[4:0]=cache_add_count[4:0];
 always@(negedge clk)                            //考虑标志用wire表示 时序上好点？？？？？,写入rram操作计数
  begin
   if(!en)                                       //使能无效时 标志置零
    begin
    cache_add_count<=0;
	//write_count_flag<=0;
	end
   else if(we)                                   //从cache写入rram有效，则开始写，并且置数
    begin 
//	 if(cache_add==5'b11110)                     //31 还是 30 的问题
//	  write_count_flag<=1;
//	 else
      cache_add_count<=cache_add_count+1'b1;                   //试下右移动
	end
    else
     begin
      cache_add_count<=0;
//	  write_count_flag<=0
	 end
  end
 always@(negedge clk)                            //从rram读出到cache计数
  begin
   if(!en)
    begin
//    cache_count_flag<=0;
	 read_count<=0;
	end
   else if(re)                                //从rram读出到cache的计数
    begin
//	 if(read_count==5'b11110)                 //读到cache的标志时 31 还是 30的问题
//	  cache_count_flag<=1;
//	 else
	  read_count<=read_count+1'b1;
	end
   else
    begin
//	 cache_count_flag<=1;
	 read_count<=0;
	end
   end
 always@(negedge clk)
  begin
   if(!en)
    begin
	 forming_count<=0;
	end
   else if(forming)
    begin
	 forming_count<=forming_count+1'b1;
	end
   else
     forming_count<=0;
  end
  
 always@(posedge RE or posedge CE)            //读出到外部的计数?/
  if(!en)
   register_add<=5'b11111;
  else if(CE)
   register_add<=5'b11111;
  else 
   begin
    if(RE_L)
	 register_add<=register_add+1'b1;
	else
	 register_add<=register_add;
   end
  
endmodule