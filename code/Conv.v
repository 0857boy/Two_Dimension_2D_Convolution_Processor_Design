`timescale 1ps/1ps

module Conv(
    input clk, 
	input in_st,
    input [7:0] din,
    output reg [15:0] dout ,
    output reg out_st
);

reg start_conv, load_data_status;
reg [15:0] conv_result [0:35];
reg [7:0] input_feature [0:63];
reg cycle ;
reg [2:0] line, row;
reg [15:0] temp[0:8];
reg [5:0] data_counter ;


// 3x3 fixed-point kernel
reg [7:0] fixed_kernel [0:8] ;
initial begin
    fixed_kernel[0] = 8'b00001000; // 0.0625 -> 00001000
    fixed_kernel[1] = 8'b00010000; // 0.125  -> 00010000
    fixed_kernel[2] = 8'b00001000; // 0.0625 -> 00001000
    fixed_kernel[3] = 8'b00010000; // 0.125  -> 00010000
    fixed_kernel[4] = 8'b00100000; // 0.25   -> 00100000
    fixed_kernel[5] = 8'b00010000; // 0.125  -> 00010000
    fixed_kernel[6] = 8'b00001000; // 0.0625 -> 00001000
    fixed_kernel[7] = 8'b00010000; // 0.125  -> 00010000
    fixed_kernel[8] = 8'b00001000; // 0.0625 -> 00001000

    start_conv = 1'b0;
    load_data_status = 1'b0;
    cycle = 1'b0;
    line = 3'b000;
    row = 3'b000;
    data_counter = 6'b000000;
    out_st = 1'b0;
end								   

always @(posedge clk) begin
    
	if( load_data_status == 1'b1 ) begin // chek if previous data is Convolved
        input_feature[data_counter] = din;
        
        if (data_counter == 63) begin
            data_counter <= 6'b000000; 
            load_data_status <= 1'b0;
            start_conv <= 1'b1;
        end
        else begin
            data_counter <= data_counter + 1;
        end
	end
    else if ( in_st == 1'b1 ) begin // start loading data
        load_data_status <= 1'b1;
    end

    
end

// Convolution operation 8x8 input feature map convolved with 3x3 kernel
always @ (posedge clk) begin
    if (start_conv == 1'b1) begin
        if (cycle == 1) begin
            if (row < 6) begin // 檢查 row 的範圍
                row <= row + 1;
            end
            else begin
                row <= 0;
                if (line < 6) begin // 檢查 line 的範圍
                    line <= line + 1;
                end
                else begin
                    line <= 0;
                    start_conv <= 1'b0;
                    out_st <= 1'b1;
                end
            end
            cycle <= 0;
        end
        else begin
            cycle <= 1;
        end

        if (cycle == 0) begin
            temp[0] <= input_feature[line*8+row] * fixed_kernel[0];
            temp[1] <= input_feature[line*8+row+1] * fixed_kernel[1];
            temp[2] <= input_feature[line*8+row+2] * fixed_kernel[2];
            temp[3] <= input_feature[(line+1)*8+row] * fixed_kernel[3];
            temp[4] <= input_feature[(line+1)*8+row+1] * fixed_kernel[4];
            temp[5] <= input_feature[(line+1)*8+row+2] * fixed_kernel[5];
            temp[6] <= input_feature[(line+2)*8+row] * fixed_kernel[6];
            temp[7] <= input_feature[(line+2)*8+row+1] * fixed_kernel[7];
            temp[8] <= input_feature[(line+2)*8+row+2] * fixed_kernel[8];
        end
        else begin
            conv_result[line*6+row] <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7] + temp[8];
        end
    end
end


// Output the result 6x6 matrix
always @(posedge clk) begin
    if ( out_st == 1'b1 ) begin
        dout = conv_result[data_counter] ;
        data_counter <= data_counter + 1; 
        if (data_counter == 35) begin
            data_counter <= 6'b000000; 
            out_st <= 0;
        end
    end
end

endmodule