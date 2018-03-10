#include <cstdio>

#include "papi.h"

struct Perf_Evaluator_Result
{
    float real_time;
    float proc_time;
    float ipc;
    long long tot_ins;
    long long tot_cyc;
    long long l1_dcm;
    long long l2_dcm;
};

int perf_evaluator_start();

int perf_evaluator_end(Perf_Evaluator_Result * result);

void perf_evaluator_print(Perf_Evaluator_Result * result);
