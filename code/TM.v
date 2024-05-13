`timescale 1ps/1ps
module TB;

////////////Clock/////////////
parameter CLK_PERIOD = 10; 
reg clk;
always #(CLK_PERIOD/2) clk = ~clk;
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


//////////Conv////////////////
wire [15:0] dout; 
reg in_st; 
wire out_st;

Conv moduleConv(
    .clk(clk), 
	.in_st(in_st),
    .din(ram_dout),
    .dout(dout),
    .out_st(out_st)
);
/////////////////////////////


reg [5:0] write_ram_counter; 
reg [15:0] conv_result[0:35];
reg [5:0] output_counter ;
reg [7:0] fixed_matrix [0:63];

initial begin
    clk = 0;
    in_st = 1'bx; // reset

    fixed_matrix[0] = 8'b00100001 ;
    fixed_matrix[1] = 8'b00010111 ;
    fixed_matrix[2] = 8'b00011001 ;
    fixed_matrix[3] = 8'b00101110 ;
    fixed_matrix[4] = 8'b00000000 ;
    fixed_matrix[5] = 8'b00000010 ;
    fixed_matrix[6] = 8'b00101101 ;
    fixed_matrix[7] = 8'b00010001 ;

    fixed_matrix[8] = 8'b00101010 ;   
    fixed_matrix[9] = 8'b00101001 ;
    fixed_matrix[10] = 8'b00100100 ;
    fixed_matrix[11] = 8'b00010101 ;
    fixed_matrix[12] = 8'b00001000 ;
    fixed_matrix[13] = 8'b00010110 ;
    fixed_matrix[14] = 8'b00100100 ;
    fixed_matrix[15] = 8'b00000101 ;

    fixed_matrix[16] = 8'b00101110 ;
    fixed_matrix[17] = 8'b00010001 ;
    fixed_matrix[18] = 8'b00011000 ;
    fixed_matrix[19] = 8'b00010001 ;
    fixed_matrix[20] = 8'b00010001 ;
    fixed_matrix[21] = 8'b00011001 ;
    fixed_matrix[22] = 8'b00001111 ;
    fixed_matrix[23] = 8'b00101100 ;

    fixed_matrix[24] = 8'b00011010 ;
    fixed_matrix[25] = 8'b00010100 ;
    fixed_matrix[26] = 8'b00101110 ;
    fixed_matrix[27] = 8'b00010010 ;
    fixed_matrix[28] = 8'b00100000 ;
    fixed_matrix[29] = 8'b00001010 ;
    fixed_matrix[30] = 8'b00000111 ;
    fixed_matrix[31] = 8'b00000111 ;

    fixed_matrix[32] = 8'b00001010 ;
    fixed_matrix[33] = 8'b00011011 ;
    fixed_matrix[34] = 8'b00100100 ;
    fixed_matrix[35] = 8'b00000110 ;
    fixed_matrix[36] = 8'b00010111 ;
    fixed_matrix[37] = 8'b00101010 ;
    fixed_matrix[38] = 8'b00011010 ;
    fixed_matrix[39] = 8'b00100000 ;

    fixed_matrix[40] = 8'b00100001 ;
    fixed_matrix[41] = 8'b00000010 ;
    fixed_matrix[42] = 8'b00010011 ;
    fixed_matrix[43] = 8'b00100110 ;
    fixed_matrix[44] = 8'b00000000 ;
    fixed_matrix[45] = 8'b00011011 ;
    fixed_matrix[46] = 8'b00110000 ;
    fixed_matrix[47] = 8'b00000001 ;

    fixed_matrix[48] = 8'b00011100 ;
    fixed_matrix[49] = 8'b00010100 ;
    fixed_matrix[50] = 8'b00101101 ;
    fixed_matrix[51] = 8'b00100000 ;
    fixed_matrix[52] = 8'b00001100 ;
    fixed_matrix[53] = 8'b00011110 ;
    fixed_matrix[54] = 8'b00011001 ;
    fixed_matrix[55] = 8'b00010000 ;

    fixed_matrix[56] = 8'b00110000 ;
    fixed_matrix[57] = 8'b00010100 ;
    fixed_matrix[58] = 8'b00011101 ;
    fixed_matrix[59] = 8'b00011001 ;
    fixed_matrix[60] = 8'b00010011 ;
    fixed_matrix[61] = 8'b00010010 ;
    fixed_matrix[62] = 8'b00000010 ;
    fixed_matrix[63] = 8'b00000101;
	write_ram_counter <= 0 ;
    output_counter <= 0 ;
    wr <= 1;

    #(CLK_PERIOD*66)

	in_st <= 1 ;

    #(CLK_PERIOD) address <= 6'b000000;
    #(CLK_PERIOD) address <= 6'b000001;
    #(CLK_PERIOD) address <= 6'b000010;
    #(CLK_PERIOD) address <= 6'b000011;
    #(CLK_PERIOD) address <= 6'b000100;
    #(CLK_PERIOD) address <= 6'b000101;
    #(CLK_PERIOD) address <= 6'b000110;
    #(CLK_PERIOD) address <= 6'b000111;
    #(CLK_PERIOD) address <= 6'b001000;
    #(CLK_PERIOD) address <= 6'b001001;
    #(CLK_PERIOD) address <= 6'b001010;
    #(CLK_PERIOD) address <= 6'b001011;
    #(CLK_PERIOD) address <= 6'b001100;
    #(CLK_PERIOD) address <= 6'b001101;
    #(CLK_PERIOD) address <= 6'b001110;
    #(CLK_PERIOD) address <= 6'b001111;
    #(CLK_PERIOD) address <= 6'b010000;
    #(CLK_PERIOD) address <= 6'b010001;
    #(CLK_PERIOD) address <= 6'b010010;
    #(CLK_PERIOD) address <= 6'b010011;
    #(CLK_PERIOD) address <= 6'b010100;
    #(CLK_PERIOD) address <= 6'b010101;
    #(CLK_PERIOD) address <= 6'b010110;
    #(CLK_PERIOD) address <= 6'b010111;
    #(CLK_PERIOD) address <= 6'b011000;
    #(CLK_PERIOD) address <= 6'b011001;
    #(CLK_PERIOD) address <= 6'b011010;
    #(CLK_PERIOD) address <= 6'b011011;
    #(CLK_PERIOD) address <= 6'b011100;
    #(CLK_PERIOD) address <= 6'b011101;
    #(CLK_PERIOD) address <= 6'b011110;
    #(CLK_PERIOD) address <= 6'b011111;
    #(CLK_PERIOD) address <= 6'b100000;
    #(CLK_PERIOD) address <= 6'b100001;
    #(CLK_PERIOD) address <= 6'b100010;
    #(CLK_PERIOD) address <= 6'b100011;
    #(CLK_PERIOD) address <= 6'b100100;
    #(CLK_PERIOD) address <= 6'b100101;
    #(CLK_PERIOD) address <= 6'b100110;
    #(CLK_PERIOD) address <= 6'b100111;
    #(CLK_PERIOD) address <= 6'b101000;
    #(CLK_PERIOD) address <= 6'b101001;
    #(CLK_PERIOD) address <= 6'b101010;
    #(CLK_PERIOD) address <= 6'b101011;
    #(CLK_PERIOD) address <= 6'b101100;
    #(CLK_PERIOD) address <= 6'b101101;
    #(CLK_PERIOD) address <= 6'b101110;
    #(CLK_PERIOD) address <= 6'b101111;
    #(CLK_PERIOD) address <= 6'b110000;
    #(CLK_PERIOD) address <= 6'b110001;
    #(CLK_PERIOD) address <= 6'b110010;
    #(CLK_PERIOD) address <= 6'b110011;
    #(CLK_PERIOD) address <= 6'b110100;
    #(CLK_PERIOD) address <= 6'b110101;
    #(CLK_PERIOD) address <= 6'b110110;
    #(CLK_PERIOD) address <= 6'b110111;
    #(CLK_PERIOD) address <= 6'b111000;
    #(CLK_PERIOD) address <= 6'b111001;
    #(CLK_PERIOD) address <= 6'b111010;
    #(CLK_PERIOD) address <= 6'b111011;
    #(CLK_PERIOD) address <= 6'b111100;
    #(CLK_PERIOD) address <= 6'b111101;
    #(CLK_PERIOD) address <= 6'b111110;
    #(CLK_PERIOD) address <= 6'b111111;
	
	in_st <= 0 ;

    
    #(CLK_PERIOD*300) $display("finished");
    $stop;
end

always @(posedge clk) begin
    if ( wr == 1'b1 ) begin
        address = write_ram_counter; 
        ram_din = fixed_matrix[write_ram_counter]; 
        write_ram_counter <= write_ram_counter + 1; 
        if (write_ram_counter == 63) begin // 8x8 matrix
			address <= 6'b000000; 
			write_ram_counter <= 6'b000000;
			wr <= 1'b0;
        end
    end	
	else if ( out_st == 1'b1 ) begin
        conv_result[output_counter] = dout ;
        output_counter <= output_counter + 1; 
        if (output_counter == 35) begin // 6x6 matrix
            output_counter <= 6'b000000;
            $display("Conv Result:");
            $display("  %b  %b  %b  %b  %b  %b", conv_result[0], conv_result[1], conv_result[2], conv_result[3], conv_result[4], conv_result[5]);
            $display("  %b  %b  %b  %b  %b  %b", conv_result[6], conv_result[7], conv_result[8], conv_result[9], conv_result[10], conv_result[11]);
            $display("  %b  %b  %b  %b  %b  %b", conv_result[12], conv_result[13], conv_result[14], conv_result[15], conv_result[16], conv_result[17]);
            $display("  %b  %b  %b  %b  %b  %b", conv_result[18], conv_result[19], conv_result[20], conv_result[21], conv_result[22], conv_result[23]);
            $display("  %b  %b  %b  %b  %b  %b", conv_result[24], conv_result[25], conv_result[26], conv_result[27], conv_result[28], conv_result[29]);
            $display("  %b  %b  %b  %b  %b  %b", conv_result[30], conv_result[31], conv_result[32], conv_result[33], conv_result[34], conv_result[35]);
        end
    end
end

endmodule