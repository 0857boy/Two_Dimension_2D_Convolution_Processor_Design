`timescale 1ns/1ns

module TB;

// Parameters
parameter CLK_PERIOD = 10; 

// Inputs
reg clk;
reg wr;
reg [2:0] address;
reg signed [7:0] din; // 使用 signed 有號資料型別

// Outputs
wire signed [7:0] dout; // 使用 signed 有號資料型別
reg signed [7:0] fixed_matrix_dout [0:7]; // 使用 signed 有號資料型別

// Instantiate the RAM module
RAM_word8_bit8 ram_inst (
    .clk(clk),
    .wr(wr),
    .address(address),
    .din(din),
    .dout(dout)
);


// Clock generation
always #((CLK_PERIOD)/2) clk = ~clk;

// Testbench stimulus
initial begin
    // Initialize matrix data
    reg signed [7:0] matrix [0:7] = {{8'sd67, 8'sd47, 8'sd50, 8'sd93, 8'sd0, 8'sd5, 8'sd91, 8'sd34}, // 使用 signed 有號資料型別
                                     {8'sd84, 8'sd83, 8'sd73, 8'sd42, 8'sd17, 8'sd45, 8'sd72, 8'sd11}, 
                                     {8'sd92, 8'sd35, 8'sd48, 8'sd35, 8'sd35, 8'sd50, 8'sd30, 8'sd89}, 
                                     {8'sd53, 8'sd41, 8'sd92, 8'sd36, 8'sd64, 8'sd21, 8'sd15, 8'sd14}, 
                                     {8'sd20, 8'sd55, 8'sd73, 8'sd12, 8'sd46, 8'sd84, 8'sd52, 8'sd64}, 
                                     {8'sd67, 8'sd4, 8'sd38, 8'sd77, 8'sd1, 8'sd55, 8'sd97, 8'sd2}, 
                                     {8'sd56, 8'sd40, 8'sd91, 8'sd65, 8'sd24, 8'sd61, 8'sd51, 8'sd32}, 
                                     {8'sd96, 8'sd40, 8'sd59, 8'sd50, 8'sd38, 8'sd37, 8'sd5, 8'sd11}};


    reg signed [7:0] fixed_matrix [0:7];
    for ( i = 0; i <= 7; i = i + 1) begin
        for ( j = 0; j <= 7; j = j + 1) begin
            fixed_matrix[i][j] = (matrix[i][j] / 255.0) * (1 << 7); // 小數點向右移動7位，這裡的除法將會自動轉換為有號數運算
        end
    end

    // Write the 8x8 matrix
    wr = 0;
    for ( i = 0; i < 8; i = i + 1) begin
        address = i; // Assign the address
        for ( j = 0; j < 8; j = j + 1) begin
            din = fixed_matrix[i][j];
        end
    end

    // Read the 8x8 matrix
    wr = 1;
    for ( i = 0; i < 8; i = i + 1) begin
        address = i; // Assign the address
        fixed_matrix_dout[i] = dout;
    end

    $stop;
end

endmodule
