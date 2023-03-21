#!/bin/bash
# script run_tcdiag.bash

# NOTE: Before running, you must active the 
# conda activate tc_diag_driver_deploy

cd tc_diag_driver/tc_diag_driver
python -m tc_diag_driver.driver ../../config/entry_spec.yml ../tests/land_lut/current_operational_gdland.dat
