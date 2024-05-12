`timescale 1ns/1ns

module TB;

////////////Clock/////////////
parameter CLK_PERIOD = 10; 
reg clk;
always #((CLK_PERIOD)/2) clk = ~clk;
/////////////////////////////


//////////Conv////////////////
wire [15:0] dout; 
reg in_st; 
wire out_st;

Conv moduleConv(
    .clk(clk), 
	.in_st(in_st),
    .dout(dout),
    .out_st(out_st)
);
/////////////////////////////

///////////////RAM INPUT////////////////
reg wr;
reg [7:0] ram_din;
wire [7:0] ram_dout;
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
reg [15:0] conv_result[0:35];
reg [5:0] output_counter ;
reg [7:0] fixed_matrix [0:63];
reg [7:0] matrix [0:63];

initial begin
    matrix[0]  = 8'b01000011; // 67
    matrix[1]  = 8'b00101111; // 47
    matrix[2]  = 8'b00110010; // 50
    matrix[3]  = 8'b01011101; // 93
    matrix[4]  = 8'b00000000; // 0
    matrix[5]  = 8'b00000101; // 5
    matrix[6]  = 8'b01011011; // 91
    matrix[7]  = 8'b00100010; // 34
    matrix[8]  = 8'b01010100; // 84
    matrix[9]  = 8'b01010011; // 83
    matrix[10] = 8'b01001001; // 73
    matrix[11] = 8'b00101010; // 42
    matrix[12] = 8'b00010001; // 17
    matrix[13] = 8'b00101101; // 45
    matrix[14] = 8'b01001000; // 72
    matrix[15] = 8'b00001011; // 11
    matrix[16] = 8'b01011100; // 92
    matrix[17] = 8'b00100011; // 35
    matrix[18] = 8'b00110000; // 48
    matrix[19] = 8'b00100011; // 35
    matrix[20] = 8'b00100011; // 35
    matrix[21] = 8'b00110010; // 50
    matrix[22] = 8'b00011110; // 30
    matrix[23] = 8'b01011001; // 89
    matrix[24] = 8'b00110101; // 53
    matrix[25] = 8'b00101001; // 41
    matrix[26] = 8'b01011100; // 92
    matrix[27] = 8'b00100100; // 36
    matrix[28] = 8'b01000000; // 64
    matrix[29] = 8'b00010101; // 21
    matrix[30] = 8'b00001111; // 15
    matrix[31] = 8'b00001110; // 14
    matrix[32] = 8'b00010100; // 20
    matrix[33] = 8'b00110111; // 55
    matrix[34] = 8'b01001001; // 73
    matrix[35] = 8'b00001100; // 12
    matrix[36] = 8'b00101110; // 46
    matrix[37] = 8'b01010100; // 84
    matrix[38] = 8'b00110100; // 52
    matrix[39] = 8'b01000000; // 64
    matrix[40] = 8'b01000011; // 67
    matrix[41] = 8'b00000100; // 4
    matrix[42] = 8'b00100110; // 38
    matrix[43] = 8'b01001101; // 77
    matrix[44] = 8'b00000001; // 1
    matrix[45] = 8'b00110111; // 55
    matrix[46] = 8'b01100001; // 97
    matrix[47] = 8'b00000010; // 2
    matrix[48] = 8'b00111000; // 56
    matrix[49] = 8'b00101000; // 40
    matrix[50] = 8'b01011011; // 91
    matrix[51] = 8'b01000001; // 65
    matrix[52] = 8'b00011000; // 24
    matrix[53] = 8'b00111101; // 61
    matrix[54] = 8'b00110011; // 51
    matrix[55] = 8'b00100000; // 32
    matrix[56] = 8'b01100000; // 96
    matrix[57] = 8'b00101000; // 40
    matrix[58] = 8'b00111011; // 59
    matrix[59] = 8'b00110010; // 50
    matrix[60] = 8'b00100110; // 38
    matrix[61] = 8'b00100101; // 37
    matrix[62] = 8'b00000101; // 5
    matrix[63] = 8'b00001011; // 11

    // i = 0
    fixed_matrix[0] = (matrix[0] / 255.0) * (1 << 7);
    fixed_matrix[1] = (matrix[1] / 255.0) * (1 << 7);
    fixed_matrix[2] = (matrix[2] / 255.0) * (1 << 7);
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
    #(clk*100) $stop;
end

always @(posedge clk) begin
    if ( in_st ) begin
	    wr = 0;
        address <= write_ram_counter; 
        ram_din <= fixed_matrix[write_ram_counter]; 
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
        $display("Conv Result:");
        $display("  %d  %d  %d  %d  %d  %d", conv_result[0], conv_result[1], conv_result[2], conv_result[3], conv_result[4], conv_result[5]);
        $display("  %d  %d  %d  %d  %d  %d", conv_result[6], conv_result[7], conv_result[8], conv_result[9], conv_result[10], conv_result[11]);
        $display("  %d  %d  %d  %d  %d  %d", conv_result[12], conv_result[13], conv_result[14], conv_result[15], conv_result[16], conv_result[17]);
        $display("  %d  %d  %d  %d  %d  %d", conv_result[18], conv_result[19], conv_result[20], conv_result[21], conv_result[22], conv_result[23]);
        $display("  %d  %d  %d  %d  %d  %d", conv_result[24], conv_result[25], conv_result[26], conv_result[27], conv_result[28], conv_result[29]);
        $display("  %d  %d  %d  %d  %d  %d", conv_result[30], conv_result[31], conv_result[32], conv_result[33], conv_result[34], conv_result[35]);
		$stop;
	end
end

endmodule