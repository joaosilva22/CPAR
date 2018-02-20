#include <stdlib.h>
#include <stdio.h>
#include <chrono>

typedef int ** matrix;

matrix create_matrix(int n)
{
    int ** matrix = new int*[n];
    for (int i = 0; i < n; ++i)
    {
        matrix[i] = new int[n];
    }
    return matrix;
}

matrix mult_matrix(matrix a, matrix b, int n)
{
    matrix c = create_matrix(n);
    for (int i = 0; i < n; ++i)
    {
        for (int j = 0; j < n; ++j)
        {
            for (int k = 0; k < n; ++k)
            {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    return c;
}

int main(int argc, char ** argv)
{
    if (argc != 2)
    {
        printf("Usage: %s <n>\n", argv[0]);
        return 1;
    }

    int n = atoi(argv[1]);

    matrix a = create_matrix(n);
    matrix b = create_matrix(n);
    
    auto begin = std::chrono::system_clock::now();
    mult_matrix(a, b, n);
    auto end = std::chrono::system_clock::now();

    printf("%f\n", std::chrono::duration<double>(end - begin).count());
    return 0; 
}
