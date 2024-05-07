`timescale 1ns/1ns

module Conv(
    input clk, reset, in_st,
    input signed [7:0] din [0:7][0:7],
    output signed reg [15:0] dout [0:6][0:6],
    output reg out_st
);

reg start_conv;
reg [2:0] line, row;
reg cycle;
reg [15:0] signed conv_result [0:6][0:6];

// 3x3 fixed-point kernel
reg [7:0] signed fixed_kernel [0:2][0:2] = {{8'd06250000, 8'd12500000, 8'd06250000}, 
                                            {8'd12500000, 8'd25000000, 8'd12500000}, 
                                            {8'd06250000, 8'd12500000, 8'd06250000}};

always @(posedge clk) begin
    if (reset) begin
        in_st <= x;
        out_st <= x;
        dout <= x;
        conv_result <= x;
        start_conv <= 1'b0;
    end

    else if (start_conv == 1'b1) begin
        // Covolution processing
    end

    else if (out_st == 1'b1) begin
        // Output data storing
        dout <= conv_result;
        out_st <= 1'b0;
    end

    else if (in_st == 1'b1) begin
        // Input data storing
        start_conv <= 1'b1;
        line <= 0;
        row <= 0;
        cycle <= 0;
    end
end

reg [16:0] signed temp[0:2][0:2];

always @(posedge clk) begin
    if (start_conv == 1'b0) begin
        if (row == 5) begin
            row <= 0;
            if (line == 6) begin
                line <= 0;
                out_st <= 1'b1;
            end
            else begin
                line <= line + 1;
            end
        end

        else begin
            if (cycle == 1) begin
                row <= row + 1;
                cycle <= 1;
            end
            else begin
                cycle <= 0;
            end
        end


        if (line < 6) begin
            // Convolution processing
            conv_result[line][row] <= 0;
            if (circle == 0) begin // multiply
                temp[0][0] <= din[line][row] * fixed_kernel[0][0];
                temp[0][1] <= din[line][row+1] * fixed_kernel[0][1];
                temp[0][2] <= din[line][row+2] * fixed_kernel[0][2];
                temp[1][0] <= din[line+1][row] * fixed_kernel[1][0];
                temp[1][1] <= din[line+1][row+1] * fixed_kernel[1][1];
                temp[1][2] <= din[line+1][row+2] * fixed_kernel[1][2];
                temp[2][0] <= din[line+2][row] * fixed_kernel[2][0];
                temp[2][1] <= din[line+2][row+1] * fixed_kernel[2][1];
                temp[2][2] <= din[line+2][row+2] * fixed_kernel[2][2];
            end

            else if (circle == 1) begin // add
                conv_result[line][row] <= temp[0][0] + temp[0][1] + temp[0][2] + temp[1][0] + temp[1][1] + temp[1][2] + temp[2][0] + temp[2][1] + temp[2][2];
            end
        end

        else begin
            start_conv <= 1'b0;
            out_st <= 1'b1;
        end
    end

    
end

endmodule
