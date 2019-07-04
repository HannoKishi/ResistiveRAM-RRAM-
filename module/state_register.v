module state_register(ALE,CLE,CE,command,state);
 input ALE,CLE,CE;
 input command;
 reg [3:0]command;
 output[7:0]state;
 reg [7:0]state;
 //reg [3:0]mid;
 always@(command or CE )
  begin
   if(CE)
    state=0;
   else if(state[7])            //state][7]=1 意味着是两单位命令
    case(command)
	 4'b0010:
	  begin
	   //state[5]=1;              //1000_0010 写状态
	   state[1]=1;              //   
	  end
	 4'b0110:
	  begin
	   state[5]=1;            //1110_XXXX forming状态
	  end
	 default:state=0;
	endcase
   else
    case(command)
     4'b0001:
	  begin
	   state[0]=1;            //读命令 0000_0001
	  end
	 4'b0100:
	  begin
	   state[7]=1;            //写命令第一条 1000_0000
	   state[6]=0;
	  end
	 4'b0111:
	  begin
	   state[7]=1;            //forming 命令第一条 1100_0000
	   state[6]=1;
      end
	 default:state=0;
	endcase
  end
 /*always@(negedge ALE)
  begin
   state[2]=1;                 //state[2]置1 表示地址准备好了
  end */
endmodule
	 
	  
   
 