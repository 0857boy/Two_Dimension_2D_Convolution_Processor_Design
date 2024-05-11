`timescale 1ns/1ns

module Conv(
    input clk, 
	input in_st,
    output reg [15:0] dout ,
    output reg out_st
);

reg start_conv, load_data_status, save_data_status;
reg [15:0] conv_result [0:35];
reg [7:0] ram_dout_reg [0:7];
reg cycle ;
reg [2:0] line, row;
reg [15:0] temp[0:8];
reg [5:0] output_counter ;


// 3x3 fixed-point kernel
reg [7:0] fixed_kernel [0:8] ;
initial begin
    fixed_kernel[0] = 8'd06250000;
    fixed_kernel[1] = 8'd12500000;
    fixed_kernel[2] = 8'd06250000;
    fixed_kernel[3] = 8'd12500000;
    fixed_kernel[4] = 8'd25000000;
    fixed_kernel[5] = 8'd12500000;
    fixed_kernel[6] = 8'd06250000;
    fixed_kernel[7] = 8'd12500000;
    fixed_kernel[8] = 8'd06250000;
end
									   
///////////////RAM INPUT////////////////
reg wr;
reg [7:0] ram_din;
wire [7:0] ram_dout;
reg [5:0] address;
reg [5:0] load_ram_counter; 
RAM RAM_temp(
    .clk(clk),
    .wr(wr), 
    .address(address), 
    .din(ram_din), 
    .dout(ram_dout) 
);
///////////////////////////////////////

always @(posedge clk) begin
    if ( in_st ) begin // reset
        start_conv <= 0 ;
		cycle <= 0 ;
        line <= 0 ;
        row <= 0;
		out_st <= 0 ;
		load_ram_counter <= 6'b000000;
		address <= 6'b000000; 
		load_data_status <= 1 ;
	end
	else if( load_data_status ) begin // take data from RAM
	    wr = 1;
        address <= load_ram_counter; 
        ram_dout_reg[load_ram_counter] <= ram_dout; 
        load_ram_counter <= load_ram_counter + 1; 
        if (load_ram_counter == 64) begin
            start_conv <= 1;
			load_data_status <= 0 ;
			address <= 6'b000000; 
			load_ram_counter <= 6'b000000; 
        end
	end

    if (start_conv == 1'b1) begin
        if (row == 5) begin
            row <= 0;
            if (line == 6) begin
                line <= 0;
                out_st <= 1'b1;
				start_conv <= 0;
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
		
        if (cycle == 0) begin 
            temp[0] <= ram_dout_reg[line*8+row] * fixed_kernel[0];
            temp[1] <= ram_dout_reg[line*8+row+1] * fixed_kernel[1];
            temp[2] <= ram_dout_reg[line*8+row+2] * fixed_kernel[2];
            temp[3] <= ram_dout_reg[(line+1)*8+row] * fixed_kernel[3];
            temp[4] <= ram_dout_reg[(line+1)*8+row+1] * fixed_kernel[4];
            temp[5] <= ram_dout_reg[(line+1)*8+row+2] * fixed_kernel[5];
            temp[6] <= ram_dout_reg[(line+2)*8+row] * fixed_kernel[6];
            temp[7] <= ram_dout_reg[(line+2)*8+row+1] * fixed_kernel[7];
            temp[8] <= ram_dout_reg[(line+2)*8+row+2] * fixed_kernel[8];
            cycle <= 1;
        end
        else begin
            conv_result[line*8+row] <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7] + temp[8];
            row <= row + 1;
            cycle <= 0;
        end

    end
    else begin
        out_st <= 0;
    end

    // 輸出结果
    if (out_st) begin
        dout <= conv_result[output_counter] ;
        output_counter <= output_counter + 1; 
        if (output_counter == 64) begin
			output_counter <= 6'b000000; 
			out_st <= 0;
        end
		else out_st <= 1;
    end
end

endmodule