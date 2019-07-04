`timescale 1ns/1ns
module decoder_2to4_tb;
 wire[3:0] DOUT;
 reg[1:0] DIN;
 reg EN;
 decoder_2to4 U1(.en(EN),.din(DIN),.dout(DOUT));
 initial
  begin
   EN=0;
   DIN=0;
   #10 EN=1;
   #10 DIN=2'b01;
   #10 DIN=2'b10;
   #10 DIN=2'b11;
   #10 EN=0;
   #10 $finish;
  end
endmodule
