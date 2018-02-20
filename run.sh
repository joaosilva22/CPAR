#!/bin/bash

if (( $# != 3 )); then
    echo "Usage:" $0 "<matrix_size> <run_cnt> <exercise_no>"
    exit 1
fi

# CHECK IF EXERCISE EXISTS #

if [ ! -d $3 ];
then
    echo "Could not find folder for exercise $3. Aborting."
    exit 1
fi

# OUTPUT FILE #

cd $3
if [ ! -d "data" ]
then
    mkdir data
fi
cd ..
output="$3/data/N=$2_$(date +%Y-%m-%d:%H:%M:%S).csv"

echo -n "," >> "$output"
for i in `seq 1 $2`;
do
    echo -n "$i," >> "$output"
done
echo "" >> "$output"

# C/CPP #

echo "Building c++ version..." 
g++ -std=c++11 ./$3/main.cpp -o ./$3/main
if (( $? != 0 )); then
    echo "Failed to build c++ version. Aborting."
    exit 1
fi
echo "Success."

echo "Running c++ version..."
total_cpp=0
echo -n "C++," >> "$output"
for i in `seq 1 $2`;
do
    time=`./$3/main $1`
    total_cpp=`python -c "print $total_cpp + $time"`
    echo "$i : $time"
    echo -n "$time," >> "$output"
done
echo "" >> "$output"

avg_cpp=`python -c "print $total_cpp/$2"`
echo "Total execution time (s): $total_cpp"
echo "Average execution time (s): $avg_cpp"
echo "Done."

# PYTHON #

echo "Running python version..."
total_py=0
echo -n "Python," >> "$output"
for i in `seq 1 $2`;
do
    time=`python ./$3/main.py $1`
    total_py=`python -c "print $total_py + $time"`
    echo "$i : $time"
    echo -n "$time," >> "$output"
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
echo -n "Java," >> "../$output"
for i in `seq 1 $2`;
do
    time=`java Main $1`
    total_java=`python -c "print $total_java + $time"`
    echo "$i : $time"
    echo -n "$time," >> "../$output"
done
echo "" >> "../$output"
cd ..

avg_java=`python -c "print $total_java/$2"` 
echo "Total execution time (s): $total_java"
echo "Average execution time (s): $avg_java"
echo "Done."

echo "Data saved to $output"
