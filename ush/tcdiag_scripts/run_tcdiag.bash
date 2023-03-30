#!/bin/bash
# script run_tcdiag.bash
# The purpose of this script is to run the python-based TCDiag code using inputs that have been passed down from the EnsRI driver through the TCDIAG_driver.bash script.

echo ""
echo "==========================================================="
echo " Entering run_tcdiag.bash"
echo "==========================================================="
echo ""

if [[ ${1} == "" ]]
then
   echo "run_tcdiag.bash: ERROR: The first command line argument must be the working directory which contains the executables and scripts."
   echo "TIP: Make sure you include a trailing slash in this path!"
   exit 1
else
   maindir=${1}
fi

if [[ ${2} == "" ]]
then
   echo "run_tcdiag.bash: ERROR: The second command line argument must be the four-digit year (YYYY)."
   exit 2
else
   yr=${2}
fi

if [[ ${3} == "" ]]
then
   echo "run_tcdiag.bash: ERROR: The third command line argument must be the two-digit month (MM)."
   exit 3
else
   mo=${3}
fi

if [[ ${4} == "" ]]
then
   echo "run_tcdiag.bash: ERROR: The fourth command line argument must be the two-digit day (DD)."
   exit 4
else
   da=${4}
fi

if [[ ${5} == "" ]]
then
   echo "run_tcdiag.bash: ERROR: The fifth command line argument must be the two-digit hour (HH)."
   exit 5
else
   hr=${5}
fi

if [[ ${6} == "" ]]
then
   echo "run_tcdiag.bash: ERROR: The sixth command line argument must be the subdirectory of the adecks collection to use."
   exit 1
else
   adecks_collection=${6}
fi

if [[ ${7} == "" ]]
then
   echo "run_tcdiag.bash: ERROR: The seventh command line argument must be the subdirectory of the active stormlist collection to use."
   exit 1
else
   stormlist_collection=${7}
fi



############
# HARDCODING DATES
#yr="2021"
#mo="11"
#da="02"
#hr="12"


# Find out which host we are running on
host=$(hostname)

short_hostname=$(echo $host | cut -c1-5)

if [[ ${short_hostname} == "mohaw" ]]
then
   long_hostname="mohawk"
fi

if [[ ${short_hostname} == "eyewa" ]]
then
   long_hostname="eyewall"
fi

if [[ ${short_hostname} == "caspe" || ${short_hostname} == "crhtc" || ${short_hostname} == "crgpg" || ${short_hostname} == "crgpu" || ${short_hostname} == "crrda" || ${short_hostname} == "crvis" || ${short_hostname} == "crlar" ]]
then
   long_hostname="casper"
fi

if [[ ${short_hostname} == "cheye" ]]
then
   long_hostname="cheyenne"
fi


if [[ ${long_hostname} == "" ]]
then
   echo "ERROR: Could not determine which host we are running on: host = ${host}"
   exit 100
fi

echo ""
echo "Running on ${long_hostname} for yr=${yr}, mo=${mo}, da=${da}, hr=${hr}"
echo ""


# Set paths and environment
if [[ ${long_hostname} == "mohawk" ]]
then

   # JLV: Added this so that the code can access the needed NetCFD library shared object.
   #export LD_LIBRARY_PATH=/usr/local/netcdf/lib:$LD_LIBRARY_PATH
   #export PATH=${PATH}:/usr/local/netcdf:/usr/local/netcdf/lib:

   realtime="True"
   beta="-beta"
   stormlist_dir="/d2/projects/TCGP/data/data_realtime${beta}/ATCF/active_stormlist/${stormlist_collection}/${yr}/"
   output_base_dir=""
   maindir="$(pwd)/"
   configdir="${maindir}/parm/tcdiag_config/"
   logdir="${maindir}/logs/"

fi


# Set paths and environment
if [[ ${long_hostname} == "casper" ]]
then

   # JLV: Added this so that the code can access the needed NetCFD library shared object.
   # export LD_LIBRARY_PATH=/usr/local/netcdf/lib:$LD_LIBRARY_PATH
   # export PATH=${PATH}:/usr/local/netcdf:/usr/local/netcdf/lib:

   realtime="False"
   stormlist_dir="/glade/work/jvigh/HFIP-EnsRI/data_input/active_stormlist/${stormlist_collection}/${yr}/"
   output_base_dir="/glade/work/jvigh/HFIP-EnsRI/data_output/DIAGNOSTICS/TCDIAG/"
   maindir="$(pwd)/"
   configdir="${maindir}/parm/tcdiag_config/"
   logdir="${maindir}/logs/"

fi


cd ${maindir}
echo " Currently running on "
pwd
echo ""


for stormid in $(cat "${stormlist_dir}active_stormlist_${yr}${mo}${da}${hr}.txt")
do

   stormid=$(echo ${stormid} | cut -c2-9)
   echo "The stormid is: ${stormid}"

   output_dir="${output_base_dir}${yr}/${stormid}"
   if [ ! -d ${output_dir} ]; then
      mkdir -p ${output_dir}
   fi

   model_spec_filename="entry_spec_${stormid}_${yr}${mo}${da}_${hr}.yml"

   #
   # Create model_spec tcdiag_config file for tcdiag_driver
   echo "---"                                                                                                      >  ${configdir}${model_spec_filename}
   echo "model_entries:"                                                                                          >> ${configdir}${model_spec_filename}
   echo "  - model_spec: /glade/work/jvigh/HFIP-EnsRI/TCDiag-use-cases/parm/tcdiag_config/gfs_spec_casper.yml"    >> ${configdir}${model_spec_filename}
   echo "    atcf_id: ${stormid}"                                                                                 >> ${configdir}${model_spec_filename}
   echo "    model_time: ${yr}-${mo}-${da}T${hr}:00:00"                                                           >> ${configdir}${model_spec_filename}
   echo "    atcf_file: /glade/work/jvigh/HFIP-EnsRI/data_input/ATCF/${adecks_collection}/${yr}/a${stormid}.dat"  >> ${configdir}${model_spec_filename}
   echo "    output_dir: ${output_dir}"                                                                           >> ${configdir}${model_spec_filename}
   #
   # Run tcdiag_driver to create the diagnostics for this initialization for a given storm/forecast
   cd tc_diag_driver/tc_diag_driver
   python -m tc_diag_driver.driver ../../parm/tcdiag_config/${model_spec_filename} ../tests/land_lut/current_operational_gdland.dat > ${logdir}tcdiag_${stormid}_${yr}${mo}${da}_${hr}.log 2>&1

   echo ""
   echo "output_dir = ${output_dir}"
   echo "Have finished running for: ${model_spec_filename}"
   mv ${configdir}${model_spec_filename} ${configdir}"already_ran/"
   echo ""

   cd ${maindir}

done

exit 0



#

