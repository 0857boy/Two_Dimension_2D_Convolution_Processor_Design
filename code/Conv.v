`timescale 1ns/1ns

module Conv(
    input clk,
    input signed [7:0] din [0:7],
    output signed reg [6:0] dout [0:6],
    output reg in_st,
    output reg out_st
);

reg start_conv;
reg [6:0] signed conv_result [0:6];

// 3x3 fixed-point kernel
reg [2:0] signed fixed_kernel [0:2] = {{8'd06250000, 8'd12500000, 8'd06250000}, 
                                       {8'd12500000, 8'd25000000, 8'd12500000}, 
                                       {8'd06250000, 8'd12500000, 8'd06250000}};

always @(posedge clk) begin
    if (!in_st) begin
        in_st <= 1;
        start_conv <= 1;
    end
    else begin
        in_st <= 0;
        start_conv <= 0;
    end
    
	//conv運算
    if (start_conv) begin
        for (int i = 0; i < 7; i = i + 1) begin
            for (int j = 0; j < 7; j = j + 1) begin
                conv_result[i][j] <= (din[i][j] * fixed_kernel[0][0] + din[i][j+1] * fixed_kernel[0][1] + din[i][j+2] * fixed_kernel[0][2] +
                                      din[i+1][j] * fixed_kernel[1][0] + din[i+1][j+1] * fixed_kernel[1][1] + din[i+1][j+2] * fixed_kernel[1][2] +
                                      din[i+2][j] * fixed_kernel[2][0] + din[i+2][j+1] * fixed_kernel[2][1] + din[i+2][j+2] * fixed_kernel[2][2]) >> 4;
            end
        end
        out_st <= 1;
    end
    else begin
        out_st <= 0;
    end

    // 輸出结果
    if (out_st) begin
        for (int i = 0; i < 5; i = i + 1) begin
            for (int j = 0; j < 5; j = j + 1) begin
                dout[i][j] <= conv_result[i][j];
            end
        end
    end
end

endmodule
