module decoder_5to32_tb;
 reg[4:0] DIN;
 reg EN;
 wire[31:0] DOUT;
 decoder_5to32 U1(.en(EN),.din(DIN),.dout(DOUT));
 initial 
  begin
   EN=0;
   DIN=0;
   #10 EN=1;
   #10 DIN=5'b00001;
   #10 DIN=5'b00010;
   #10 DIN=5'b00011;
   #10 DIN=5'b00100;
   #10 DIN=5'b00101;
   #10 DIN=5'b00110;
   #10 DIN=5'b00111;
   #10 DIN=5'b01000;
   #10 DIN=5'b01001;
   #10 DIN=5'b01010;
   #10 DIN=5'b01011;
   #10 DIN=5'b01100;
   #10 DIN=5'b01101;
   #10 DIN=5'b01110;
   #10 DIN=5'b01111;
   #10 DIN=5'b10000;
   #10 DIN=5'b10001;
   #10 DIN=5'b10010;
   #10 DIN=5'b10011;
   #10 DIN=5'b10100;
   #10 DIN=5'b10101;
   #10 DIN=5'b10010;
   #10 DIN=5'b10011;
   #10 DIN=5'b10100;
   #10 DIN=5'b10101;
   #10 DIN=5'b10110;
   #10 DIN=5'b10111;
   #10 DIN=5'b11000;
   #10 DIN=5'b11001;
   #10 DIN=5'b11010;
   #10 DIN=5'b11011;
   #10 DIN=5'b11100;
   #10 DIN=5'b11101;
   #10 DIN=5'b11110;
   #10 DIN=5'b11111;
   #10 EN=0;
  end	
endmodule