`timescale 1ns/1ns

module RAM_word8_bit8(clk, wr, address, din, dout);

parameter words = 8;

input	clk, wr;
input	[2:0]	address;
input	[7:0]	din;
output	[7:0]	dout;

reg	 [7:0]	ram_data[0:words-1]; //8 word,each word 8 bits 
reg	 [7:0]	dout;

always @(posedge clk) begin
    if(~wr) begin //read data
	    dout <= ram_data[address[2:0]];
    end
    else begin 
	    dout <= 8'd0;
        ram_data[address[2:0]] <= din;
    end
end
endmodule
