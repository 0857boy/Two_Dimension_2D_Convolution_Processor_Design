import random

# Generate a random 8x8 matrix
matrix = [[random.randint(0, 100) for _ in range(8)] for _ in range(8)]

# Print the matrix
for row in matrix:
    print(row)