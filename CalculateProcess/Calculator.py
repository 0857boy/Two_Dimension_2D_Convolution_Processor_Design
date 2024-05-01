'''
a.  Study 2D Conv.運算方式，以軟體(C, Python, Excel, 手算)做出一組2D Conv. (size如第一頁的規格)之運算結果(floating-point) 。(5%)
b. 根據a.的floating-point運算內容，得出其fixed-point值的運算結果(8-bit  16-bit)，
            並計算其SQNR(由36個output值做平均後計算SQNR，SQNR值需 > 30 dB)。(10%)

'''

# 2D Convolution

import numpy as np

# 8x8 matrix
matrix = np.matrix([ [87, 215, 60, 78, 11, 284, 182, 263], [264, 98, 145, 2, 37, 92, 197, 274]
          , [47, 159, 224, 259, 223, 222, 191, 288], [58, 296, 171, 282, 298, 89, 54, 249]
          , [104, 232, 290, 129, 109, 107, 90, 140], [71, 93, 126, 221, 28, 198, 61, 100]
          , [106, 241, 238, 49, 19, 166, 229, 41], [271, 252, 272, 184, 46, 201, 230, 124] ])

# 3x3 kernel
kernel = np.matrix([[ 0.68700008, 0.3445509, 0.53707822], [-0.97867492, 0.4330104, 0.29976747],
                    [-0.11658339, 0.64346389, -0.69683105]])


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
np.set_printoptions(formatter={'float': '{: 0.7f}'.format})
print(matrix)

# Kernel
print("Kernel:\n" + str(kernel))

# Convolution
result = conv2d(matrix, kernel)

# Print the result of the convolution 數值顯示6位整數和10位小數
print("Result of the convolution:\n")
np.set_printoptions(formatter={'float': '{: 0.10f}'.format})
print(str(result))