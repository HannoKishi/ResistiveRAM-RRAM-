module RRAM_digital(IO,clk,CE,ALE,CLE,WE,RE,Dinout,RB,rram_data,rram_ce,rram_we,rram_re,dout_block,dout_row,dout_column);
input[3:0] IO;
input clk;
input CE;
input ALE;
input CLE;
input WE;
input RE;
inout Dinout;
inout rram_data;
//
wire Dinout;
wire rram_data;
//
output RB;
output rram_re;
output rram_we;
output rram_ce;
output[3:0] dout_block;
output[31:0] dout_row;
output[31:0] dout_column;
wire RB;
wire rram_re_t;
wire rram_we_t;
wire rram_ce;
wire[3:0] dout_block;
wire[31:0] dout_row;
wire[31:0] dout_column;
//内部wire连接
wire[3:0] command;
wire[11:0] address;
wire[31:0] data_cache;
wire[31:0] data_register;
wire address_ready;
wire command_ready;
wire cache_count_flag;
wire forming_count_flag;
wire write_count_flag;
wire en_decoder;
wire en_state_count;
wire we;
wire re;
wire forming;
wire WE_L;
wire RE_L;
wire[4:0] cache_add;
wire[4:0] register_add;
//
assign rram_we=rram_we_t&clk;
assign rram_re=rram_re_t&clk;
//
//调用各个模块
command_register U1(IO,CE,WE,CLE,command,command_ready);
address_register U2(IO,CE,WE,ALE,address_ready,address);
data_register U3(CLE,ALE,Dinout,data_cache,data_register,RE,WE,CE,RE_L,WE_L,register_add);
writeread U4(clk,CE,data_register,data_cache,re,we,cache_add,forming,rram_re_t,rram_we_t,rram_data,rram_ce);
state_counter U5(clk,en_state_count,RE,CE,we,re,forming,RE_L,WE_L,cache_count_flag,forming_count_flag,write_count_flag,cache_add,register_add);
decoder U6(en_decoder,clk,ALE,address,dout_block,dout_row,dout_column);
control U7(clk,CE,ALE,CLE,command,address_ready,command_ready,cache_count_flag,forming_count_flag,write_count_flag,we,re,forming,WE_L,RE_L,en_decoder,en_state_count,RB);

endmodule