'''
a.  Study 2D Conv.運算方式，以軟體(C, Python, Excel, 手算)做出一組2D Conv. (size如第一頁的規格)之運算結果(floating-point) 。(5%)
b. 根據a.的floating-point運算內容，得出其fixed-point值的運算結果(8-bit  16-bit)，
            並計算其SQNR(由36個output值做平均後計算SQNR，SQNR值需 > 30 dB)。(10%)

'''
import transform as tf
import numpy as np

# 8x8 matrix
matrix = np.array([[67, 47, 50, 93, 0, 5, 91, 34], [84, 83, 73, 42, 17, 45, 72, 11], 
                [92, 35, 48, 35, 35, 50, 30, 89], [53, 41, 92, 36, 64, 21, 15, 14], 
                [20, 55, 73, 12, 46, 84, 52, 64], [67, 4, 38, 77, 1, 55, 97, 2], 
                [56, 40, 91, 65, 24, 61, 51, 32], [96, 40, 59, 50, 38, 37, 5, 11]])

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

print("\n---------------------------------------------------------------------------------------\n")


fixed_matrix = matrix.tolist()


print("Fixed-point 8-bit matrix:\n")

for i in range(len(fixed_matrix)):
    for j in range(len(fixed_matrix[0])):
        fixed_matrix[i][j] = tf.float_to_fixed_point_8(fixed_matrix[i][j])
        fixed_matrix[i][j] = tf.fixed_point_to_float_8(fixed_matrix[i][j])
    print(fixed_matrix[i])

fixed_matrix = np.array(fixed_matrix)

fixed_kernel = kernel.tolist()

print("Fixed-point 8-bit kernel:\n")

for i in range(len(fixed_kernel)):
    for j in range(len(fixed_kernel[0])):
        fixed_kernel[i][j] = tf.float_to_fixed_point_8(fixed_kernel[i][j])
        fixed_kernel[i][j] = tf.fixed_point_to_float_8(fixed_kernel[i][j])

    print(fixed_kernel[i])


fixed_kernel = np.array(fixed_kernel)

fixed_result = conv2d(fixed_matrix, fixed_kernel)

fixed_result = fixed_result.tolist()

for i in range(len(fixed_result)):
    for j in range(len(fixed_result[0])):
        fixed_result[i][j] = tf.float_to_fixed_point_16(fixed_result[i][j])
        fixed_result[i][j] = tf.fixed_point_to_float_16(fixed_result[i][j])

fixed_result = np.array(fixed_result)

print("Fixed-point 16-bit result:\n")
print(fixed_result)

print("\n---------------------------------------------------------------------------------------\n")

#根據a.的floating-point運算內容，得出其fixed-point值的運算結果(8-bit -> 16-bit)，
# 並計算其SQNR(由36個output值做平均後計算SQNR，SQNR值需 > 30 dB)。(10%)
# 比較result和fixed_result的差異

# Calculate the SQNR
def calculate_sqnr(result, fixed_result):
    P_x = 0
    P_e = 0
    for i in range(len(result)):
        for j in range(len(result[0])):
            P_x += result[i][j]**2
            P_e += (result[i][j] - fixed_result[i][j])**2
    P_x /= len(result) * len(result[0])
    P_e /= len(result) * len(result[0])
    sqnr = 10 * np.log10(P_x / P_e)
    return sqnr

sqnr = calculate_sqnr(result, fixed_result)
print("SQNR: " + str(sqnr) + " dB")

