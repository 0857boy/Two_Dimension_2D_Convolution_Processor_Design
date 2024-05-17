`timescale 1ps/1ps

module Conv(
    input clk, 
	input in_st,
    input [7:0] din,
    output reg [15:0] dout ,
    output reg out_st
);

////////////////////////////////Load Data////////////////////////////
reg start_conv, load_data_status;
reg [7:0] input_feature [0:63];
reg [5:0] data_counter ;
////////////////////////////////////////////////////////////////////

////////////////////////////////Convolution/////////////////////////
reg [19:0] conv_result [0:35]; // 原來是 20 bits ， 但我們只取 16 bits(6,10)fixed point
reg [19:0] temp[0:8];
reg [2:0] line, row;
reg cycle ;
////////////////////////////////////////////////////////////////////


///////////////////////////////Output///////////////////////////////
reg [5:0] output_counter ;
reg output_data_status;
////////////////////////////////////////////////////////////////////

////////////////////////////////Fixed-point Kernel///////////////////
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
end								   
////////////////////////////////////////////////////////////////////


always @(posedge clk) begin
    
	if( load_data_status == 1'b1 ) begin // chek if previous data is Convolved
        input_feature[data_counter] = din;
        
        if (data_counter == 63) begin
            data_counter <= 6'b000000; 
            load_data_status <= 1'b0;
            start_conv <= 1'b1;
            $display("Input Feature Get From RAM: ");
            $display(" %b %b %b %b %b %b %b %b", input_feature[0], input_feature[1], input_feature[2], input_feature[3], input_feature[4], input_feature[5], input_feature[6], input_feature[7]);
            $display(" %b %b %b %b %b %b %b %b", input_feature[8], input_feature[9], input_feature[10], input_feature[11], input_feature[12], input_feature[13], input_feature[14], input_feature[15]);
            $display(" %b %b %b %b %b %b %b %b", input_feature[16], input_feature[17], input_feature[18], input_feature[19], input_feature[20], input_feature[21], input_feature[22], input_feature[23]);
            $display(" %b %b %b %b %b %b %b %b", input_feature[24], input_feature[25], input_feature[26], input_feature[27], input_feature[28], input_feature[29], input_feature[30], input_feature[31]);
            $display(" %b %b %b %b %b %b %b %b", input_feature[32], input_feature[33], input_feature[34], input_feature[35], input_feature[36], input_feature[37], input_feature[38], input_feature[39]);
            $display(" %b %b %b %b %b %b %b %b", input_feature[40], input_feature[41], input_feature[42], input_feature[43], input_feature[44], input_feature[45], input_feature[46], input_feature[47]);
            $display(" %b %b %b %b %b %b %b %b", input_feature[48], input_feature[49], input_feature[50], input_feature[51], input_feature[52], input_feature[53], input_feature[54], input_feature[55]);
            $display(" %b %b %b %b %b %b %b %b", input_feature[56], input_feature[57], input_feature[58], input_feature[59], input_feature[60], input_feature[61], input_feature[62], input_feature[63]);
            
        end
        else begin
            data_counter <= data_counter + 1;
        end
	end
    else if ( in_st == 1'b1 ) begin // start loading data
        load_data_status <= 1'b1;
        start_conv <= 1'b0;
        data_counter <= 6'b000000;
        line <= 3'b000;
        row <= 3'b000;
        cycle <= 1'b0;
    end

    
end

// Convolution operation 8x8 input feature map convolved with 3x3 kernel
always @ (posedge clk) begin
    if (start_conv == 1'b1) begin
        if (cycle == 1) begin
            if (row < 5) begin // 檢查 row 的範圍
                row <= row + 1;
            end
            else begin
                row <= 0;
                if (line < 5) begin // 檢查 line 的範圍
                    line <= line + 1;
                end
                else begin
                    line <= 0;
                    start_conv <= 1'b0;
                    out_st <= 1'b1;
                    output_data_status <= 1'b1;
                    output_counter <= 6'b000000;
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
    if ( output_data_status == 1'b1 ) begin
        dout = conv_result[output_counter][19:4];
        output_counter <= output_counter + 1;
        out_st <= 1'b0;
        if (output_counter == 36) begin // 6x6 matrix
            output_counter <= 6'b000000;
            output_data_status <= 1'b0;
        end
    end
end

endmodule