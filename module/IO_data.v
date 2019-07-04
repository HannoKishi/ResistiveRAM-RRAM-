module IO_data(en,din,dout,dinout);
 input en;
 input din;
 output dout;
 inout dinout;
 assign dinout=(en)?din:1'bz;
 assign dout=dinout;
endmodule