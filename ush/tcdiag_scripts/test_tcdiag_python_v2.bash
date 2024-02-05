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


# Run tcdiag_driver to create the diagnostics for this initialization for a given storm/forecast
cd ${maindir}tc_diag_driver/tc_diag_driver
python -m tc_diag_driver.driver ../../parm/tcdiag_config/${model_spec_filename} ${input_base_dir}current_operational_gdland.dat > ${logdir}tcdiag_aal092022_20220924_00.log 2>&1

echo ""
echo "output_base_dir = ${output_base_dir}"
echo "Have finished running for: ${model_spec_filename}"

exit 0

#

