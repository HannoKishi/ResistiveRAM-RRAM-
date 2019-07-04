module data_register(CLE,ALE,data_io,data_cache,data_register,RE,WE,CE,RE_L,WE_L,register_add);
// inout IO_data;
// input clk;
 input RE;
 input WE;
 input RE_L;                                         //控制模块读使能
 input WE_L;                                         //控制模块写使能
 input CE;
 input CLE;
 input ALE;
 inout data_io;
 input[4:0] register_add;                            //数据寄存器地址,RE读出时要用
 input[31:0] data_cache;                             //读寄存器输入
 output [31:0] data_register;                        //写寄存器输出给读写模块
 reg din;                                            //IO口三态门输入
 wire dout;
 //reg[4:0] count;                                   //读 计数器
// input data_in;
// output data_out;
// reg data_in;
 reg[31:0] data_register;                            //数据写入时 缓存的寄存器
//reg[31:0] data_register_out;                       //数据读出时 缓存的寄存器在读写模块中
IO_data U1(.en(RE_L),.din(din),.dout(dout),.dinout(data_io));
 always@(posedge WE or posedge CE)
 begin
  if(CE)                                             //数据寄存器置0
    data_register<=0;
  else if(WE_L&&(!CLE)&&(!ALE))
   begin 
    data_register<={dout,data_register[31:1]};       //IO模块的 dout输入并存入 寄存器低位
   end
  else
   data_register<=data_register;
 end
 always@(negedge RE or posedge CE)                 //读操作,异步的RE_L先置1
 begin
  if(CE)                                          //CE无效清理
    begin
	 din<=1'b0;
	 //count<=2'd31;
	end
  else if (RE_L)                                             //读有效时din赋值
    begin
	din<=data_cache[register_add];                //有问题
//	data_register<=data_cache;
	end
  else
    begin                                              //
	 din<=1'b0;
	end

	
 end
endmodule
	