module MaxPool(din1, din2, din3, din4, dout);

input [15:0] din1, din2, din3, din4;
output [15:0] dout;


assign dout = (din1 > din2 && din1 > din3 && din1 > din4) ? din1 : 
              (din2 > din3 && din2 > din4) ? din2 : 
              (din3 > din4) ? din3 : din4;
endmodule