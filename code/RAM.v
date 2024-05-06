`timescale 1ns/1ns

module RAM_word8_bit8(clk, wr, din, dout);

input	clk, wr;
input	[7:0]	din[7:0][7:0];
output	[7:0]	dout[7:0][7:0];

reg	 [7:0]	ram_data[0:7][0:7];
reg	 [7:0]	dout;

always @(posedge clk) begin
    if(~wr) begin //read data
        dout <= ram_data;
    end
    else begin // write data
	    dout <= 8'd0;
        ram_data <= din;
    end
end
endmodule
