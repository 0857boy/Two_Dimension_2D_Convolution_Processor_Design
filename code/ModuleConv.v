`timescale 1ns/1ns
module ModuleConv (
    input clk, reset, in_st,
    input signed [7:0] din [0:7][0:7],
    output signed reg [6:0] dout [0:6],
    output reg out_st
);

reg state;



// if in_st is high, then the module should put data from din to memory


always @(posedge clk) begin
    if (reset) begin
        in_st <= x;
        out_st <= x;
        dout <= x;
        state <= 0;
    end

    else if (state == 0 && in_st == 1'b1) begin
        // Input data storing
        

end






endmodule