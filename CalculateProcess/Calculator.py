'''
a.  Study 2D Conv.運算方式，以軟體(C, Python, Excel, 手算)做出一組2D Conv. (size如第一頁的規格)之運算結果(floating-point) 。(5%)
b. 根據a.的floating-point運算內容，得出其fixed-point值的運算結果(8-bit  16-bit)，
            並計算其SQNR(由36個output值做平均後計算SQNR，SQNR值需 > 30 dB)。(10%)

'''
import transform as tf
import numpy as np

# 8x8 matrix
matrix = np.array([ [87, 215, 60, 78, 11, 284, 182, 263], [264, 98, 145, 2, 37, 92, 197, 274]
          , [47, 159, 224, 259, 223, 222, 191, 288], [58, 296, 171, 282, 298, 89, 54, 249]
          , [104, 232, 290, 129, 109, 107, 90, 140], [71, 93, 126, 221, 28, 198, 61, 100]
          , [106, 241, 238, 49, 19, 166, 229, 41], [271, 252, 272, 184, 46, 201, 230, 124] ])

# 3x3 kernel
kernel = np.array([[0.0625, 0.125, 0.0625], [0.125, 0.25, 0.125], [0.0625, 0.125, 0.0625]])


# Convolution
def conv2d(matrix, kernel):
    m, n = kernel.shape
    y, x = matrix.shape
    y = y - m + 1
    x = x - n + 1
    new_matrix = np.zeros((y, x))
    for i in range(y):
        for j in range(x):
            new_matrix[i][j] = np.sum(matrix[i:i+m, j:j+n] * kernel)
            
    return new_matrix

# Print the original matrix
print("Original matrix:\n" + str(matrix))

# Normalize the matrix 
matrix = np.array(matrix)/255.0

# Print the normalized matrix 數值顯示1位整數和7位小數
print("Normalized matrix:\n" )
np.set_printoptions(formatter={'float': '{: 0.7f}'.format}, suppress=True, linewidth=250)
print(matrix)

# Kernel
print("Kernel:\n" + str(kernel))

# Convolution
result = conv2d(matrix, kernel)

# Print the result of the convolution 數值顯示6位整數和10位小數
print("Result of the convolution:\n")
np.set_printoptions(formatter={'float': '{: 0.10f}'.format}, suppress=True)
print(str(result))

#根據a.的floating-point運算內容，得出其fixed-point值的運算結果(8-bit -> 16-bit)，
# 並計算其SQNR(由36個output值做平均後計算SQNR，SQNR值需 > 30 dB)。(10%)

# Calculate the Signal-to-Quantization Noise Ratio (SQNR)
def calculate_sqnr(matrix, result):
    # Calculate the quantization noise
    quantization_noise = abs( np.sum(matrix)/64 - np.sum(result)/36 )

    # Calculate the signal power
    signal_power = np.sum(matrix)
    
    # Calculate the SQNR
    sqnr = 10 * np.log10(signal_power / quantization_noise)
    
    return sqnr
print('Single to Quantization Noise Ratio (SQNR) : ')

sqnr = calculate_sqnr(matrix, result)

print("\nSQNR: " + str(sqnr) + " dB")


print("\n---------------------------------------------------------------------------------------\n")

matrix = matrix.tolist()


print("Fixed-point 8-bit matrix:\n")

for i in range(len(matrix)):
    for j in range(len(matrix[0])):
        matrix[i][j] = tf.float_to_fixed_point_8(matrix[i][j])
    print(matrix[i])


print("Fixed-point 16-bit result:\n")
result = result.tolist()
for i in range(len(result)):
    for j in range(len(result[0])):
        result[i][j] = tf.float_to_fixed_point_16(result[i][j])
    print(result[i])


