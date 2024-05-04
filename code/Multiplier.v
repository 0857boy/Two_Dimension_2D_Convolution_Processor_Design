`timescale 1ns/1ns
module Multiplier (
    output reg [15:0] z,
    output reg [11:0] p,
    output reg out_st, cycle, in_st,
    input [7:0] x, y,
    input clk
);

reg [7:0] x_reg, y_reg;
reg [15:0] partial_product;
reg [15:0] q;
reg [4:0] cnt;
reg start;


always @(posedge clk) begin
    if (!in_st && !start) begin
        start <= 1;
        cnt <= 0;
        out_st <= 0;
        partial_product <= 16'b0;
        x_reg <= x;
        y_reg <= y;
        z <= 16'bx;
        q <= 16'b0;
        in_st <= 1;
    end
    else begin
        in_st <= 0;
        if (cnt < 2 && start) begin
            cycle <= cnt; // cycle = 0 or 1
            if (cnt == 0) begin
                q = y_reg[4:0] * $signed(x_reg);
                partial_product = q;
                p = q[11:0];
                out_st = 1;
            end
            else begin // cycle == 1
                q = ($signed(y_reg[7:5]) * $signed(x_reg)) << 5;
                partial_product = partial_product + q;
                p = q[15:4];
                out_st = 0;
                z = partial_product;
            end
            cnt <= cnt + 1;
        end
        else begin
            z <= 16'bx;
            p <= 12'bx;
            q <= 16'bx;
            cycle <= 1'bx;
            cnt <= 0;
            start <= 0;
            out_st <= 0;
        end
    end
end

endmodule