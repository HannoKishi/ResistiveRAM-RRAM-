`timescale 1ns/1ns
module control(clk,CE,ALE,CLE,command,address_ready,command_ready,cache_count_flag,forming_count_flag,write_count_flag,we_writeread,re_writeread,forming_writeread,WE_L,RE_L,en_decoder,en_state_count,RB);
 input clk;
 input CE;
 input ALE;
 input CLE;
 input[3:0] command;                            //命令输入
 input address_ready;                           //地址准备完成
 input command_ready;                           //命令准备完成
 input cache_count_flag;                        //写cache完成标志
 input forming_count_flag;                      //forming_计数器完成标志
 input write_count_flag;                        //写计数flag
 output we_writeread;                           //给读写模块writeread的写使能
 output re_writeread;
 output forming_writeread;
 //output[4:0] cache_add;                         //给读写模块的地址
 output WE_L;                                   //给数据寄存器data_register的写使能
 output RE_L;                                   //给数据寄存器的读使能
 output en_decoder;                             //译码器变址与输出有效使能
 output en_state_count;                         //计数器有效使能
 //output[4:0] register_add;                      //数据寄存器地址
 output RB;                                     //ready与Busy 信号
 reg we_writeread;
 reg re_writeread;
 reg forming_writeread;
 //reg[4:0] count_writeread;
 reg WE_L;
 reg RE_L;
 reg en_decoder;
 reg en_state_count;
 reg RB;
// reg[4:0] register_add;
 reg[8:0] state;
 reg[8:0] next_state;
 parameter command_read=4'b0001,command_write1=4'b0100,command_forming1=4'b0111,command_write2=4'b0010,command_forming2=4'b0110;
 parameter s0=9'b0_0000_0001,s1=9'b0_0000_0010,s2=9'b0_0000_0100,s3=9'b0_0000_1000,s4=9'b0_0001_0000,s5=9'b0_0010_0000;
 parameter s6=9'b0_0100_0000,s7=9'b0_1000_0000,s8=9'b1_0000_0000;
 always@(posedge clk or posedge CE)
  begin
  if(CE)
   state<=s0;                                    //状态寄存器置零
  else
   state<=next_state;                           //
  end
 always@(state or command or address_ready or CE or cache_count_flag or forming_count_flag or write_count_flag)     //要改，缺个地址输入
  begin
   next_state=9'bx_xxxx_xxxx;                          //初始状态
   case(state)                                 //状态机
    s0:                                        //等待状态
	begin
	 case(command)                             //根据输入指令决定下个周期是什么
	  command_read:                            //在等待状态收到read指令
	   begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;
        en_decoder=0;
        RB=1;                     */             //
		next_state=s1;                         //进入S1状态，等待du地址输入
	   end
	  command_write1:                          //收到写命令
	   begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;
        en_decoder=0;
        RB=1;                         */         //
		next_state=s2;                         //进入S2状态，等待xie地址输入
	   end
	  command_forming1:                        //收到forming命令
	   begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;
        en_decoder=0;
        RB=1;                                */  //
		next_state=s3;                         //进入S3状态，等待forming第二指令
	   end
	  default:
	   begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;
        en_decoder=0;
        RB=1;                              */    //
		next_state=s0;                         //进入S0状态，等待命令
	   end
	 endcase
	end
	s1:                                        //进入读状态的等待地址阶段
	begin
	 if(address_ready)                         //读地址准本好了，执行写入cache操作
	  begin
/*    we_writeread=0;
        re_writeread=1;                        //读写模块读使能有效,还是晚一个周期 比较好 可能改 ???????????
        forming_writeread=0;
        WE_L=0;
        RE_L=0;
        en_decoder=1;
        RB=0;                           */       //开始读，忙线
		next_state=s4;                         //进入S4状态，等待读入cache完成
	  end
	 else
	  begin
/*    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;
        en_decoder=0;
        RB=1;                              */    //
		next_state=s1;                         //进入S1状态，等待读地址输入
	  end
	end
	s2:                                        //进入写命令等待地址完成状态
	begin
	 if(address_ready)
	  begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=1;
        RE_L=0;
        en_decoder=0;
        RB=0;                            */      //进入忙模式
		next_state=s5;                         //进入S5状态，等待写入cache完成
	  end
	 else
	  begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;
        en_decoder=0;
        RB=0;                           */       //进入忙模式
		next_state=s2;                         //进入S2状态，等待xie地址输入
	  end
	end
	s3:                                        //forming下等待二指令输入
	begin
	 if(command==4'b0110)
	  begin
/*        we_writeread=0;
        re_writeread=0;
        forming_writeread=1;
        WE_L=0;
        RE_L=0;
        en_decoder=1;
        RB=0;                       */           //进入忙模式
		next_state=s6;                         //进入S6状态，进行forming操作
	  end
	 else
	  begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;
        en_decoder=0;
        RB=0;                             */     //进入忙模式
		next_state=s3;                         //进入S3状态，等待二指令
	  end
	end
	s4:                                        //rram数据读入cache
	begin
	 if(!cache_count_flag)                      //cache操作次数标志
	  begin
/*	    we_writeread=0;
        re_writeread=1;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;
        en_decoder=1;
        RB=0;                                */  //进入忙模式,内部写入cache操作开始
		next_state=s4;                         //进入S4状态，继续执行将数据读入cache操作
	  end
	 else 
	  begin                                    //读入cache操作完成
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=1;                                //可以进行外部异步读操作了
        en_decoder=0;
        RB=1;                        */          //脱离忙状态，表示内部写入cache操作完成了
		next_state=s7;                         //进入S7状态，等待
	  end
	end
	s7:                                        //从数据读出到外部
	begin
	 if(!CE)
	  begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=1;                                //可以进行外部异步读操作了
        en_decoder=0;
        RB=1;                         */         //脱离忙状态，表示内部写入cache操作完成了
		next_state=s7;                         //进入S7状态，等待
	  end
	 else
	   begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;                                //
        en_decoder=0;
        RB=1;                           */       //
		next_state=s0;                         //回到s0状态
	   end
	end
	s5:                                        //写入数据寄存器状态
	begin
	 if(command==4'b0010)                      //2命令输入表示数据输入结束
       begin
/*	    we_writeread=1;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;                                
        en_decoder=1;
        RB=0;                           */       //进入s8状态，内部将数据寄存器数据写入RRAM
		next_state=s8;                         //
	   end
	 else
	  begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=1;
        RE_L=0;                                //
        en_decoder=0;
        RB=1;                             */     //进入s5状态,继续将外部数据写入数据寄存器
		next_state=s5;      
	  end
	end
	s8:                                        //从数据寄存器写入RRAM状态
	begin
	 if(write_count_flag)
	  begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;                                //
        en_decoder=0;
        RB=1;                             */     //从计数器写入rram完成
		next_state=s0;                         
	  end
	 else
	  begin
/*	    we_writeread=1;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;                                //
        en_decoder=1;
        RB=0;                             */     //还在执行内部写
		next_state=s8;                         //继续停留在s8
	  end
	end
	s6:                                        //forming操作中
	begin
	 if(forming_count_flag)
	  begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=0;                                //
        en_decoder=0;
        RB=1;                              */    //forming完成
		next_state=s0;                         //返回s0状态
	  end
	 else
	  begin
/*	    we_writeread=0;
        re_writeread=0;
        forming_writeread=1;
        WE_L=0;
        RE_L=0;                                //
        en_decoder=1;
        RB=0;                          */        //forming继续
		next_state=s6;                         //否则继续forming
	  end
	end
	default:
	 begin
	  next_state=s0;
	 end
   endcase
  end
 always@(posedge clk or posedge CE)
  begin
   if(CE)                                     //rst 操作
    begin
	 we_writeread<=0;
     re_writeread<=0;
     forming_writeread<=0;
     WE_L<=0;
     RE_L<=0;
     en_decoder<=0;
	 en_state_count<=0;
     RB=1;
    end
   else
    begin
     case(next_state)	
	 s0:                                        //等待命令输入状态
	  begin
	    we_writeread<=0;
        re_writeread<=0;
        forming_writeread<=0;
        WE_L<=0;
        RE_L<=0;
        en_decoder<=0;
		en_state_count<=0;
        RB<=1;                                  //
	  end
	 s1:                                        //等待读地址输入状态
	  begin
	    we_writeread<=0;
        re_writeread<=0;
        forming_writeread<=0;
        WE_L<=0;
        RE_L<=0;
        en_decoder<=0;
		en_state_count<=0;
        RB<=1;                                  //
	  end
	 s2:                                        //等待写地址输入状态
	  begin
	    we_writeread<=0;
        re_writeread<=0;
        forming_writeread<=0;
        WE_L<=0;
        RE_L<=0;
        en_decoder<=0;
		en_state_count<=0;
        RB<=1;                                  //
	  end
	 s3:                                        //等待forming第二指令
	  begin
	    we_writeread<=0;
        re_writeread<=0;
        forming_writeread<=0;
        WE_L<=0;
        RE_L<=0;
        en_decoder<=0;
		en_state_count<=0;
        RB<=1;                                  //
	  end
	 s4:                                        //写入cache操作开始
	  begin
	    we_writeread<=0;
        re_writeread<=1;                        //读写模块读使能有效,还是晚一个周期 比较好 可能改 ???????????
        forming_writeread<=0;
        WE_L<=0;
        RE_L<=0;
        en_decoder<=1;
		en_state_count<=1;
        RB<=0;                                  //开始读，忙线
	  end
	 s5:                                        //数据从外部写入状态
	  begin
	    we_writeread<=0;
        re_writeread<=0;
        forming_writeread<=0;
        WE_L<=1;
        RE_L<=0;
        en_decoder<=0;
		en_state_count<=0;
        RB<=1;                                  //进入忙模式
	  end
	 s6:                                        //forming操作启动中
	  begin
	    we_writeread<=0;
        re_writeread<=0;
        forming_writeread<=1;
        WE_L<=0;
        RE_L<=0;
        en_decoder<=1;
		en_state_count<=1;
        RB<=0;                                  //进入忙模式
	  end
	 s7:                                        //外部读出模式状态
	  begin
	    we_writeread=0;
        re_writeread=0;
        forming_writeread=0;
        WE_L=0;
        RE_L=1;                                //可以进行外部异步读操作了
        en_decoder=0;
		en_state_count<=1;
        RB=1;                                  //脱离忙状态，表示内部写入cache操作完成了，可以读了
	  end
	 s8:                                       //从数据寄存器写入RRAM状态
	  begin
	    we_writeread<=1;
        re_writeread<=0;
        forming_writeread<=0;
        WE_L<=0;
        RE_L<=0;                                
        en_decoder<=1;
		en_state_count<=1;
        RB<=0;                                  //进入s8状态，内部将数据寄存器数据写入RRAM
	  end
	 default:
	  begin
	    we_writeread<=0;
        re_writeread<=0;
        forming_writeread<=0;
        WE_L<=0;
        RE_L<=0;                                
        en_decoder<=0;
		en_state_count<=0;
        RB<=1;                                  //
	  end
	 endcase
	end
  end
  //延时定义
  specify
   //(clk,CE,ALE,CLE,address_ready,command_ready,command,cache_count_flag,forming_count_flag,write_count_flag*>en_decoder,en_state_count,RB,WE_L,RE_L)=1;
  endspecify 
endmodule