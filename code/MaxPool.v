module MaxPool(din1, din2, din3, din4, dout);

input [15:0] din1, din2, din3, din4, din5, din6;
output [15:0] dout;


assign dout = (din1 > din2 && din1 > din3 && din1 > din4 && din1 > din5 && din1 > din6) ? din1 : 
              (din2 > din3 && din2 > din4 && din2 > din5 && din2 > din6) ? din2 : 
              (din3 > din4 && din3 > din5 && din3 > din6) ? din3 : 
              (din4 > din5 && din4 > din6) ? din4 : 
              (din5 > din6) ? din5 : din6;
endmodule