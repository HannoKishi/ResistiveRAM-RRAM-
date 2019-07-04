module writeread(clk,CE,data_register,data_cache,re,we,cache_add,forming,rram_re,rram_we,rram_data,rram_ce);
 input CE;
 input clk;                                    //内部时钟
 input[31:0] data_register;                   //写寄存器输入
 input re;                                     //控制模块给读写模块的读使能
 input we;
 //input WE_L;
 input forming;
 input[4:0] cache_add;                         //写计数由控制单元给出
 output[31:0] data_cache;                      //输出给 数据寄存器部分
 reg[31:0] data_cache;
 output rram_ce;
 output rram_we;
 output rram_re;
 inout rram_data;                              //rram 数据IO口
 wire din;                                     //IO 口 输入输出
 wire dout;
 reg en;                                       //内部IO使能
 reg rram_ce;
 reg rram_re;
 reg rram_we;
 //reg i;                                        //写计数
 IO_data U1(.en(en),.din(din),.dout(dout),.dinout(rram_data));   //调用IO模块
// wire[5:0] count;                               //外部计数器
 //assign rram_ce=re|we|forming;                         //rram使能有效
 assign din=(forming)?1'b1:data_register[cache_add];
 always@( we or re or forming or CE)            //三种操作使能 这里无时钟控制，只要操作信号有效则已经开始了            
  begin
   if(CE)
   begin
 //   data_cache=0;
	//din=0;
	rram_we=1'b0;
	rram_re=1'b0;
	rram_ce=1'b0;
   end
   //else if(WE_L)
   begin
   case({forming,we,re})
    3'b100:                                     //forming操作
	 begin 
	  en=1'b1;
	  //din=1'b1;
	  rram_we=1'b1;
	  rram_re=1'b0;
	  rram_ce=1'b1;
	 end
	3'b010:                                     //写操作
	 begin
	  en=1'b1;
//	  data_cache<=data_register;
//	  din=data_register[cache_add];            //数据传送到IO口,直接拿data_register输入，不给cache置位了，原因是地址与写信号差一个周期
	  rram_we=1'b1;                            //
	  rram_re=1'b0;
	  rram_ce=1'b1;
	 end
	3'b001:                                     //读操作
	 begin
	  en=1'b0;
//	  data_cache<={data_cache,dout};            //IO口数据存入读寄存器，读的话，数据要晚一个周期到达
	  rram_re=1'b1;
	  rram_we=1'b0;
	  rram_ce=1'b1;
	 end
	default:
	 begin
	  en<=1'b0;
	  rram_re=1'b0;
	  rram_we=1'b0;
	  rram_ce=1'b0;
	//  data_cache<=data_cache;
	 end
   endcase
  end
  end
 always@(negedge clk or posedge CE)
  begin
   if(CE)
    data_cache<=0;
   else if(re)
    data_cache<={dout,data_cache[31:1]};                 //读操作下 cache右移 存数据            
   else
    data_cache<=data_cache;
  end
endmodule
	  
	  
   	 
 
 