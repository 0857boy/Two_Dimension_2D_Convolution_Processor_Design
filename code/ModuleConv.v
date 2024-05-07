`timescale 1ns/1ns
module ModuleConv (
    input clk, reset, in_st,
    input signed [7:0] din [0:7][0:7],
    output signed reg [15:0] dout [0:5][0:5],
    output reg out_st
);

wire [7:0] memoryOut [0:7][0:7];
reg inside_in_st;

Ram_word8_bit8 ram(clk, in_st, din, memoryOut);
Conv conv(clk, reset, inside_in_st, memoryOut, dout, out_st);


always @(posedge clk) begin
    if (reset) begin
        in_st <= x;
        out_st <= x;
        dout <= x;
        state <= 0;
    end

    else if (inside_in_st != in_st) begin
        inside_in_st <= in_st;
    end

end




endmodule