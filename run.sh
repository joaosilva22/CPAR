#!/bin/bash

if [[ $# -lt 3 || $# -gt 4 ]]; then
    echo "Usage:" $0 "<matrix_size> <run_cnt> <exercise_no> [<thread_cnt>]"
    exit 1
fi

# CHECK IF EXERCISE EXISTS #

if [ ! -d $3 ];
then
    echo "Could not find folder for exercise $3. Aborting."
    exit 1
fi

# SET NUMBER OF THREADS #

if [[ $# == 4 && ($3 == "3a" || $3 == "3b") ]];
then
    echo "Setting number of threads to $4"
    export OMP_NUM_THREADS="$4"
fi

# OUTPUT FILE #

cd $3
if [ ! -d "data" ]
then
    mkdir data
fi
cd ..
output="$3/data/N=$2_$(date +%Y-%m-%d:%H:%M:%S).csv"

# C/CPP #

echo "Building c++ version..." 
g++ -std=c++11 -fopenmp ./$3/main.cpp ./common/performance_evaluator.cpp -I /opt/papi/include /opt/papi/lib/libpapi.a -o ./$3/main
if (( $? != 0 )); then
    echo "Failed to build c++ version. Aborting."
    exit 1
fi
echo "Success."

echo "Running c++ version..."
total_cpp=0
echo "C++ Results" >> "$output"
echo "Run, Real Time (s), Proc Time (s), Tot Ins, Tot Cyc, IPC, L1 DCM, L2 DCM" >> "$output"
for i in `seq 1 $2`;
do
    out=`./$3/main $1`
    readarray -t y <<<"$out"
    total_cpp=`python -c "print $total_cpp + ${y[0]}"`
    printf -v it "%03d" $i
    echo "$it : real_time=${y[0]}  proc_time=${y[1]}  tot_ins=${y[2]}  tot_cyc=${y[3]}  ipc=${y[4]}  l1_dcm=${y[5]}  l2_dcm=${y[6]}"
    echo "$it, ${y[0]}, ${y[1]}, ${y[2]}, ${y[3]}, ${y[4]}, ${y[5]}, ${y[6]}" >> "$output"
done
echo "" >> "$output"

avg_cpp=`python -c "print $total_cpp/$2"`
echo "Total execution time (s): $total_cpp"
echo "Average execution time (s): $avg_cpp"
echo "Done."

# IF PROBLEM 3 EXIT HERE #

if [[ $3 == "3a" || $3 == "3b" ]];
then
    echo "Data saved to $output"
    exit 0
fi

# PYTHON #

echo "Running python version..."
total_py=0
echo "Python Results" >> "$output"
echo "Run, Real Time (s)" >> "$output"
for i in `seq 1 $2`;
do
    time=`python ./$3/main.py $1`
    total_py=`python -c "print $total_py + $time"`
    printf -v it "%03d" $i
    echo "$it : real_time=$time"
    echo "$it, $time" >> "$output"
done
echo "" >> "$output"

avg_py=`python -c "print $total_py/$2"`
echo "Total execution time (s): $total_py"
echo "Average execution time (s): $avg_py"
echo "Done."

# JAVA #

echo "Building Java version..."
cd $3
javac main.java
if (( $? != 0 )); then
    echo "Failed to build Java version. Aborting."
    exit 1
fi
echo "Success."

echo "Running Java version..."
total_java=0
echo "Java Results" >> "../$output"
echo "Run, Real Time (s)" >> "../$output"
for i in `seq 1 $2`;
do
    time=`java Main $1`
    total_java=`python -c "print $total_java + $time"`
    printf -v it "%03d" $i
    echo "$it : real_time=$time"
    echo "$it, $time" >> "../$output"
done
echo "" >> "../$output"
cd ..

avg_java=`python -c "print $total_java/$2"` 
echo "Total execution time (s): $total_java"
echo "Average execution time (s): $avg_java"
echo "Done."

echo "Data saved to $output"
