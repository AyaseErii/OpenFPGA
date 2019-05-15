#!/bin/bash

# Set variables
set benchmark = test_modes
set include_netlists = _include_netlists.v
set compiled_file = compiled_$benchmark
set tb_formal_postfix = _top_formal_verification_random_tb
set verilog_output_dirname = ${benchmark}_Verilog
set log_file = ${benchmark}_sim.log

$SPACER

source .travis/common.sh
set -e

$SPACER

start_section "OpenFPGA.build" "${GREEN}Building..${NC}"
if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
  #make
  mkdir build
  cd build
  cmake ..
  make -j2
else 
# For linux, we enable full package compilation
  #make
  mkdir build
  cd build
  cmake ..
  make -j2
fi
end_section "OpenFPGA.build"

$SPACER

start_section "Verilog_test" "${GREEN}Testing..${NC}"
# Begining of Verilog verification
# Move to vpr folder
cd vpr7_x2p/vpr
echo "DEBUG_0"
# Remove former log file
rm $log_file
rm $compiled_file
echo "DEBUG_1"
# Start the script -> run the fpga generation -> run the simulation -> check the log file
source .regression_verilog.sh
iverilog -o $compiled_file $verilog_output_dirname/SRC/$benchmark$include_netlists -s $benchmark$tb_formal_postfix
echo "DEBUG_2"
vvp $compiled_file -j 16 >> $log_file
echo "DEBUG_3"
set result = `grep "Succeed" $log_file`
echo "DEBUG_4"
if ("$result" != "")then
  echo "Verification succeed"
  cd -
  exit 0
else
  set result = `grep "Failed" $log_file`
  if ("$result" != "")then
    echo "Verification failed"
    cd -
    exit 1
  else
    echo "Unexpected error, Verification didn't run"
    cd -
    exit 2
  fi
fi
# End of Verilog verification
end_section "Verilog_test"

$SPACER
