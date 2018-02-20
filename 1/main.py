import sys
import time

def create_matrix(n):
    matrix = [];
    for i in range(n):
        matrix.append([0] * n)
    return matrix

def mult_matrix(a, b, n):
    c = create_matrix(n)
    for i in range(n):
        for j in range(n):
            for k in range(n):
                c[i][j] += a[i][k] * b[k][j]
    return c

if len(sys.argv) != 2:
    print("Usage: python {} <n>".format(sys.argv[0]))
    sys.exit()

n = int(sys.argv[1])

a = create_matrix(n)
b = create_matrix(n)

start_time = time.time()
c = mult_matrix(a, b, n)
print(time.time() - start_time)
    
