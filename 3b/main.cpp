#include <stdlib.h>
#include <stdio.h>
#include <chrono>
#include <omp.h>

#include "../common/performance_evaluator.h"

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
#pragma omp parallel for
    for (int i = 0; i < n; ++i)
    {
        for (int k = 0; k < n; ++k)
        {
            for (int j = 0; j < n; ++j)
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

    if (perf_evaluator_start() != 0) return 1;

    mult_matrix(a, b, n);

    Perf_Evaluator_Result result;
    if (perf_evaluator_end(&result) != 0) return 1;

    perf_evaluator_print(&result);

    return 0; 
}
