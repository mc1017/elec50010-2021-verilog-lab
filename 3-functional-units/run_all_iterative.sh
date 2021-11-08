#!/bin/bash
set -eou pipefail


# Can be used to echo commands
# set -o xtrace

# Capture the first two command line parameters to specify
# the CPU variant and the specific test-base.
# $1, $2, $2, ... represent the arguments passed to the script
for i in 0 1 2 3 ; do
    VARIANT="v${i}"


    # Redirect output to stder (&2) so that it seperate from genuine outputs
    # Using ${VARIANT} substitures in the value of the variable VARIA T
    echo "Test multiplier variant ${VARIANT}"



    echo " 1 - Compiling test-bench"
    # Compile a specific simulator for this variant and testbench.
    # -s specifies exactly which testbench should be top-level
    # The -P command is used to modify the RAM_INIT_FILE parameter on the test-bench at compile-time
    iverilog -g 2012 \
    -s multiplier_iterative_tb \
    -o multiplier_iterative_tb \
    multiplier_iterative_${VARIANT}.v multiplier_iterative_tb.v 
    

    echo "  2 - Running test-bench"
    # Run the simulator, and capture all output to a file
    # Use +e to disable automatic script failure if the command fails, as
    # it is possible the simulation might go wrong.
    set +e
    ./multiplier_iterative_tb > /dev/null
    # Capture the exit code of the simulator in a variable
    RESULT=$?
    set -e

    # Check whether the simulator returned a failure code, and immediately quit
    if [[ ${RESULT} -ne 0 ]] ; then
    echo "  iterative, ${VARIANT}, FAIL"
    exit
    fi

done