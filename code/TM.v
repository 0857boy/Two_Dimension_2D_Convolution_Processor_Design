`timescale 1ns/1ns

module TB;

////////////Clock/////////////
parameter CLK_PERIOD = 10; 
reg clk;
always #((CLK_PERIOD)/2) clk = ~clk;
/////////////////////////////


//////////Conv////////////////
reg dout [15:0]; 
reg in_st, out_st;
Conv moduleConv(clk,dout,in_st,out_st);

Conv moduleConv(
    .clk(clk), 
	.in_st(in_st),
    .dout(dout),
    .out_st(out_st)
);
/////////////////////////////

///////////////RAM INPUT////////////////
reg wr;
reg [7:0] signed ram_din;
reg [7:0] signed ram_dout;
reg [5:0] address;
RAM RAM_temp(
    .clk(clk),
    .wr(wr), 
    .address(address), 
    .din(ram_din), 
    .dout(ram_dout) 
);
///////////////////////////////////////
reg [5:0] write_ram_counter; 
reg [15:0] signed conv_result[0:35];
reg [5:0] output_counter ;


// Testbench stimulus
initial begin
    // Initialize matrix data
    reg signed [7:0] matrix [0:63] = {8'sd67, 8'sd47, 8'sd50, 8'sd93, 8'sd0, 8'sd5, 8'sd91, 8'sd34, // 使用 signed 有號資料型別
                                     8'sd84, 8'sd83, 8'sd73, 8'sd42, 8'sd17, 8'sd45, 8'sd72, 8'sd11, 
                                     8'sd92, 8'sd35, 8'sd48, 8'sd35, 8'sd35, 8'sd50, 8'sd30, 8'sd89, 
                                     8'sd53, 8'sd41, 8'sd92, 8'sd36, 8'sd64, 8'sd21, 8'sd15, 8'sd14, 
                                     8'sd20, 8'sd55, 8'sd73, 8'sd12, 8'sd46, 8'sd84, 8'sd52, 8'sd64, 
                                     8'sd67, 8'sd4, 8'sd38, 8'sd77, 8'sd1, 8'sd55, 8'sd97, 8'sd2, 
                                     8'sd56, 8'sd40, 8'sd91, 8'sd65, 8'sd24, 8'sd61, 8'sd51, 8'sd32, 
                                     8'sd96, 8'sd40, 8'sd59, 8'sd50, 8'sd38, 8'sd37, 8'sd5, 8'sd11};


    reg signed [7:0] fixed_matrix [0:63];

    // i = 0
    fixed_matrix[0] = (matrix[0] / 255.0) * (1 << 7);
    fixed_matrix[1] = (matrix[1] / 255.0) * (1 << 7);
    fixed_matri[2] = (matrix[2] / 255.0) * (1 << 7);
    fixed_matrix[3] = (matrix[3] / 255.0) * (1 << 7);
    fixed_matrix[4] = (matrix[4] / 255.0) * (1 << 7);
    fixed_matrix[5] = (matrix[5] / 255.0) * (1 << 7);
    fixed_matrix[6] = (matrix[6] / 255.0) * (1 << 7);
    fixed_matrix[7] = (matrix[7] / 255.0) * (1 << 7);

    // i = 1
    fixed_matrix[8] = (matrix[8] / 255.0) * (1 << 7);
    fixed_matrix[9] = (matrix[9] / 255.0) * (1 << 7);
    fixed_matrix[10] = (matrix[10] / 255.0) * (1 << 7);
    fixed_matrix[11] = (matrix[11] / 255.0) * (1 << 7);
    fixed_matrix[12] = (matrix[12] / 255.0) * (1 << 7);
    fixed_matrix[13] = (matrix[13] / 255.0) * (1 << 7);
    fixed_matrix[14] = (matrix[14] / 255.0) * (1 << 7);
    fixed_matrix[15] = (matrix[15] / 255.0) * (1 << 7);

    // i = 2
    fixed_matrix[16] = (matrix[16] / 255.0) * (1 << 7);
    fixed_matrix[17] = (matrix[17] / 255.0) * (1 << 7);
    fixed_matrix[18] = (matrix[18] / 255.0) * (1 << 7);
    fixed_matrix[19] = (matrix[19] / 255.0) * (1 << 7);
    fixed_matrix[20] = (matrix[20] / 255.0) * (1 << 7);
    fixed_matrix[21] = (matrix[21] / 255.0) * (1 << 7);
    fixed_matrix[22] = (matrix[22] / 255.0) * (1 << 7);
    fixed_matrix[23] = (matrix[23] / 255.0) * (1 << 7);

    // i = 3
    fixed_matrix[24] = (matrix[24] / 255.0) * (1 << 7);
    fixed_matrix[25] = (matrix[25] / 255.0) * (1 << 7);
    fixed_matrix[26] = (matrix[26] / 255.0) * (1 << 7);
    fixed_matrix[27] = (matrix[27] / 255.0) * (1 << 7);
    fixed_matrix[28] = (matrix[28] / 255.0) * (1 << 7);
    fixed_matrix[29] = (matrix[29] / 255.0) * (1 << 7);
    fixed_matrix[30] = (matrix[30] / 255.0) * (1 << 7);
    fixed_matrix[31] = (matrix[31] / 255.0) * (1 << 7);

    // i = 4
    fixed_matrix[32] = (matrix[32] / 255.0) * (1 << 7);
    fixed_matrix[33] = (matrix[33] / 255.0) * (1 << 7);
    fixed_matrix[34] = (matrix[34] / 255.0) * (1 << 7);
    fixed_matrix[35] = (matrix[35] / 255.0) * (1 << 7);
    fixed_matrix[36] = (matrix[36] / 255.0) * (1 << 7);
    fixed_matrix[37] = (matrix[37] / 255.0) * (1 << 7);
    fixed_matrix[38] = (matrix[38] / 255.0) * (1 << 7);
    fixed_matrix[39] = (matrix[39] / 255.0) * (1 << 7);

    // i = 5
    fixed_matrix[40] = (matrix[40] / 255.0) * (1 << 7);
    fixed_matrix[41] = (matrix[41] / 255.0) * (1 << 7);
    fixed_matrix[42] = (matrix[42] / 255.0) * (1 << 7);
    fixed_matrix[43] = (matrix[43] / 255.0) * (1 << 7);
    fixed_matrix[44] = (matrix[44] / 255.0) * (1 << 7);
    fixed_matrix[45] = (matrix[45] / 255.0) * (1 << 7);
    fixed_matrix[46] = (matrix[46] / 255.0) * (1 << 7);
    fixed_matrix[47] = (matrix[47] / 255.0) * (1 << 7);

    // i = 6
    fixed_matrix[48] = (matrix[48] / 255.0) * (1 << 7);
    fixed_matrix[49] = (matrix[49] / 255.0) * (1 << 7);
    fixed_matrix[50] = (matrix[50] / 255.0) * (1 << 7);
    fixed_matrix[51] = (matrix[51] / 255.0) * (1 << 7);
    fixed_matrix[52] = (matrix[52] / 255.0) * (1 << 7);
    fixed_matrix[53] = (matrix[53] / 255.0) * (1 << 7);
    fixed_matrix[54] = (matrix[54] / 255.0) * (1 << 7);
    fixed_matrix[55] = (matrix[55] / 255.0) * (1 << 7);

    // i = 7
    fixed_matrix[56] = (matrix[56] / 255.0) * (1 << 7);
    fixed_matrix[57] = (matrix[57] / 255.0) * (1 << 7);
    fixed_matrix[58] = (matrix[58] / 255.0) * (1 << 7);
    fixed_matrix[59] = (matrix[59] / 255.0) * (1 << 7);
    fixed_matrix[60] = (matrix[60] / 255.0) * (1 << 7);
    fixed_matrix[61] = (matrix[61] / 255.0) * (1 << 7);
    fixed_matrix[62] = (matrix[62] / 255.0) * (1 << 7);
    fixed_matrix[63] = (matrix[63] / 255.0) * (1 << 7);
	write_ram_counter = 0 ;

	in_st = 0 ;
	#clk
	in_st = 1 ;
end

always @(posedge clk) begin
    if ( in_st ) begin
	    wr = 0;
        address <= write_ram_counter; 
        ram_din <= din_reg[write_ram_counter]; 
        write_ram_counter <= write_ram_counter + 1; 
        if (write_ram_counter == 64) begin
			address <= 6'b000000; 
			write_ram_counter <= 6'b000000;  
			in_st <= 0 ;
        end
    end	
	else if ( out_st == 1 ) begin
        conv_result[output_counter] <= dout ;
        output_counter <= output_counter + 1; 
        if (output_counter == 64) begin
			output_counter <= 6'b000000; 
        end
    end
	else begin
		$stop;
	end
end

endmodule