#include "performance_evaluator.h"

static long long last_measured_real_time;
static long long last_measured_proc_time;
static int event_set = PAPI_NULL;
static int retval;

int perf_evaluator_start()
{   
    // Initialize the library and compare the version number of the
    // header file to the version of the library. 
    retval = PAPI_library_init(PAPI_VER_CURRENT);
    if (retval != PAPI_VER_CURRENT)
    {
        printf("Version of PAPI header file and library do not match\n");
        return retval;
    }

    // Create the event set
    retval = PAPI_create_eventset(&event_set);
    if (retval != PAPI_OK)
    {
        printf("Failed to create PAPI event set\n");
        return retval;
    }

    // Add total instructions to the event set
    retval = PAPI_add_event(event_set, PAPI_TOT_INS);
    if (retval != PAPI_OK)
    {
        printf("Failed to add PAPI_TOT_INS to event set\n");
        return retval;
    }

    // Add total cycles to the event set
    retval = PAPI_add_event(event_set, PAPI_TOT_CYC);
    if (retval != PAPI_OK)
    {
        printf("Failed to add PAPI_TOT_CYC to event set\n");
        return retval;
    }
    
    // Add L1 cache misses to the event set
    retval = PAPI_add_event(event_set, PAPI_L1_DCM);
    if (retval != PAPI_OK)
    {
        printf("Failed to add PAPI_L1_TCM to event set\n");
        return retval;
    }
    
    // Add L2 cache misses to the event set
    retval = PAPI_add_event(event_set, PAPI_L2_DCM);
    if (retval != PAPI_OK)
    {
        printf("Failed to add PAPI_L2_TCM to event set\n");
        return retval;
    }
    
    // Start PAPI counters
    retval = PAPI_start(event_set);
    if (retval != PAPI_OK)
    {
        printf("Failed to start PAPI counters\n");
        return retval;        
    }

    // Start measuring real and process time in microseconds
    last_measured_real_time = PAPI_get_real_usec();
    last_measured_proc_time = PAPI_get_virt_usec();

    return 0;
}

int perf_evaluator_end(Perf_Evaluator_Result * result)
{    
    // Stop measuring real and process time
    long long real_time = PAPI_get_real_usec();
    long long proc_time = PAPI_get_virt_usec();

    // Convert real time and proc time to seconds using multiplication
    // because it is much faster
    result->real_time = ((float)(real_time - last_measured_real_time)) * 0.000001;
    result->proc_time = ((float)(proc_time - last_measured_proc_time)) * 0.000001;

    // Stop PAPI counters
    long long event_set_values[4];
    retval = PAPI_stop(event_set, event_set_values);
    if (retval != PAPI_OK)
    {
        printf("Failed to stop and read PAPI counters\n");
        return retval;
    }

    result->tot_ins = event_set_values[0];
    result->tot_cyc = event_set_values[1];
    result->ipc = (float)event_set_values[0]/(float)event_set_values[1];
    
    result->l1_dcm = event_set_values[2];
    result->l2_dcm = event_set_values[3];

    return 0;
}
