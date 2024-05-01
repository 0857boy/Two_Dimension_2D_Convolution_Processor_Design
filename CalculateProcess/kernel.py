import numpy as np

# use Guassian kernel
kernel = np.array([[1, 2, 1], [2, 4, 2], [1, 2, 1]]) / 16

print(kernel.tolist(), sep = ',')