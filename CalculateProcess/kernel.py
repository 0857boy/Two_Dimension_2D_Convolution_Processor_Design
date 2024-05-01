import numpy as np

# Initialize a 3x3 convolutional kernel with values from a uniform distribution between -0.1 and 0.1
kernel = np.random.uniform(-1, 1, (3, 3))
print(kernel)