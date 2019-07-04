module decoder_2to4(en,din,dout);
 input en;
 input [1:0] din;
 output [3:0] dout;
 reg [3:0] dout;
 always@(en or din)
  begin
   if(!en)
    dout=4'b0;
   else 
    case(din)
	 2'b00:dout=4'b0001;
	 2'b01:dout=4'b0010;
	 2'b10:dout=4'b0100;
	 2'b11:dout=4'b1000;
	endcase
  end
endmodule
 
 