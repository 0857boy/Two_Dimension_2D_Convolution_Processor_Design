module MaxPool(din1, din2, din3, din4, din5, din6, din7, din8, din9, dout);

input [15:0] din1, din2, din3, din4, din5, din6, din7, din8, din9;
output [15:0] dout;


assign dout = (din1 > din2 && din1 > din3 && din1 > din4 && din1 > din5 && din1 > din6 && din1 > din7 && din1 > din8 && din1 > din9) ? din1 : 
              (din2 > din3 && din2 > din4 && din2 > din5 && din2 > din6 && din2 > din7 && din2 > din8 && din2 > din9) ? din2 : 
              (din3 > din4 && din3 > din5 && din3 > din6 && din3 > din7 && din3 > din8 && din3 > din9) ? din3 : 
              (din4 > din5 && din4 > din6 && din4 > din7 && din4 > din8 && din4 > din9) ? din4 : 
              (din5 > din6 && din5 > din7 && din5 > din8 && din5 > din9) ? din5 : 
              (din6 > din7 && din6 > din8 && din6 > din9) ? din6 : 
              (din7 > din8 && din7 > din9) ? din7 : 
              (din8 > din9) ? din8 : din9;
endmodule