#!/bin/bash
# script test_tcdiag_python_v2.bash
# The purpose of this script is to test the earlier python-based TCDiag code (CIRA) using specific test input data.

echo ""
echo "==========================================================="
echo " Entering test_tcdiag_python_v2.bash"
echo "==========================================================="
echo ""

maindir="/d1/projects/TCDiag/"
input_base_dir="/d1/projects/TCDiag/al092022_test/input/"
output_base_dir="/d1/projects/TCDiag/al092022_test/python_v2/"
configdir="${maindir}TCDiag-Realtime/parm/tcdiag_config/"
logdir="${output_base_dir}"
model_spec_filename="entry_spec_seneca_test.yml"

cd ${maindir}
echo " Currently running on "
pwd
echo ""

# Now call the python embedding script as a standalone python run
# NOTE: This uses a conda environment that includes the requests package.
# This environment can be activated as follows: (2nd answer from https://stackoverflow.com/questions/60303997/activating-conda-environment-from-bash-script)
# NOTE: the path below is for Seneca
echo ""
echo "source /d1/personal/jvigh/conda/etc/profile.d/conda.sh"
source /d1/personal/jvigh/conda/etc/profile.d/conda.sh

echo ""
echo "conda activate tc_diag_driver_deploy"
conda activate tc_diag_driver_deploy

echo ""
echo "Here are the details of the tc_diag_driver_deploy conda environment:"
echo "list -n tc_diag_driver_deploy"
conda list -n tc_diag_driver_deploy
echo ""


# Run tcdiag_driver to create the diagnostics for this initialization for a given storm/forecast
echo "Changing directory to the tcdiag_driver run location:"
echo "cd ${maindir}tc_diag_driver/tc_diag_driver"
cd ${maindir}tc_diag_driver/tc_diag_driver

# Provide the details of what will be run
echo "Ready to run tcdiag_driver using the following model spec file:"
echo "cat ../../parm/tcdiag_config/${model_spec_filename}"
cat ../../parm/tcdiag_config/${model_spec_filename}
echo ""

echo "Will run using the following land database:"
echo "${input_base_dir}current_operational_gdland.dat"
echo ""

echo "Now running the tcdiag_driver using the following command:"
echo "python -m tc_diag_driver.driver ../../parm/tcdiag_config/${model_spec_filename} ${input_base_dir}current_operational_gdland.dat > ${logdir}tcdiag_aal092022_20220924_00.log 2>&1"
python -m tc_diag_driver.driver ../../parm/tcdiag_config/${model_spec_filename} ${input_base_dir}current_operational_gdland.dat > ${logdir}tcdiag_aal092022_20220924_00.log 2>&1

echo ""
echo "Output should be written to output_base_dir = ${output_base_dir}"
echo ""
echo "Here is the result of the output written to log file: ${logdir}tcdiag_aal092022_20220924_00.log"
cat ${logdir}tcdiag_aal092022_20220924_00.log"

echo ""
echo "Have finished running for: ${model_spec_filename}"

exit 0

#

