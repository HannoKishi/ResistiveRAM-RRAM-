module command_register(IO,CE,WE,CLE,command,command_register_ready);
 input[3:0] IO;
 input CE;
 //input RE;
 input WE;
 input CLE;
 output[3:0] command;
 output command_register_ready;
 reg command_register_ready;
 reg[3:0] command;
 always@(posedge WE or posedge CE)
  begin
   if(CE)
    command<=0;
   else if(!CLE)
    command<=command;
   else                                      //CLE=1 command写入
    command<=IO[3:0]; 
  end
 always@(negedge CLE or posedge CE )
  begin
   if(CE)
    command_register_ready<=1'b0;
   else if(!CLE)
    command_register_ready<=1'b1;
   else
    command_register_ready<=1'b0;
  end
endmodule