module decoder(en,clk,ALE,din,dout_block,dout_row,dout_column);
input[11:0] din;                               //地址寄存器输入
input en;                                      //译码器+1使能
input clk;                                     
input ALE;                                     //地址所存使能
//input test;                                    //测试信号此时将载入 外部地址
//input[11:0] Address;                           //外部地址输入
output[3:0] dout_block;
output[31:0] dout_row;
output[31:0] dout_column;
reg[3:0] dout_block;
reg[31:0] dout_row;
reg[31:0] dout_column;
reg[11:0] address_buffer;
wire[67:0] decoder_out;                        //用来村所有译码器输出
//wire en_out;                                   //输入使能
//assign en_out=en|test;                         //当en或者测试中有个一为有效
always@( negedge clk or negedge ALE)           //逻辑不对 要改 暂时改为下降沿
 begin
/*  if(test)                                      //test有效 直接载入Address
   begin
    address_buffer[11:0]<=Address[11:0];
   end    */
  if(en)                                   //en有效 则地址加1
   begin
	  address_buffer<=address_buffer+1'b1;     //使能信号有效地址每个周期加1
   end
  else                                         //载入地址寄存器地址 DIN
   begin
    address_buffer<=din;
   end
 end
 decoder_2to4 U1(.en(!ALE),.din(address_buffer[11:10]),.dout(decoder_out[67:64]));         //块地址
 decoder_5to32 U2(.en(!ALE),.din(address_buffer[9:5]),.dout(decoder_out[63:32]));          //行地址
 decoder_5to32 U3(.en(!ALE),.din(address_buffer[4:0]),.dout(decoder_out[31:0]));           //列地址
 always@(posedge en or posedge clk )
  begin
   if(en)                                                        //使能有效输出 译码结果
    begin
	dout_block<=decoder_out[67:64];
    dout_row<=decoder_out[63:32];
    dout_column<=decoder_out[31:0];
    end
   else                                                           //使能无效 译码输出0
    begin
	dout_block<=0;
	dout_row<=0;
	dout_column<=0;
	end
  end
endmodule