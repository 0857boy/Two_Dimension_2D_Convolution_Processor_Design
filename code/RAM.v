`timescale 1ns/1ns

module RAM(clk, wr, address, din, dout);

parameter words = 64;

input	clk, wr;
input	[5:0]	address;
input	[7:0]	din;
output	[7:0]	dout;

reg	 [7:0]	ram_data[0:words-1]; //64 word,each word 8 bits 
reg	 [7:0]	dout;

always @(posedge clk) begin
    if(~wr) begin //read data
	    dout <= ram_data[address];
    end
    else begin
	    dout <= 8'd0;
        ram_data[address] <= din;
    end
end
endmodule
