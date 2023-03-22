#!/bin/bash
# script TCDIAG_retrospective_driver.bash
#
# This script should be called by the HFIP-Ensemble-RI driver system to run retrospectively.
#

# JLV: Added this so that the script gets the calling path when run from cron (otherwise, it just gets the user's home directory)
cd "$(dirname "$0")"

WORKDIR=`pwd`

if [[ ${1} == "" ]]
then
   echo "TCDIAG_driver.bash: ERROR: The first command line argument must be the date/time of the cycle for which you wish to run: YYYYMMDDHH, "
   echo "       where YYYY is the four-digit year, MM is the two-digit month, DD is the two-digit day, and HH is the two-digit hour."
   echo "NOTE: If running in real-time, the YYYYMMDD part will be ignored and the script will set these appropriately based on the specified two-digit hour."
   exit 1
else
   yyyymmddhh=${1}
fi

hh=$(echo ${yyyymmddhh} | cut -c9-10)

# JLV: Added this so that the code can access the needed NetCFD library shared object.
#export LD_LIBRARY_PATH=/usr/local/netcdf/lib:${LD_LIBRARY_PATH}
#export PATH=${PATH}:/usr/local/netcdf:/usr/local/netcdf/lib:


# Find out which host we are running on
host=$(hostname)

short_hostname=$(echo ${host} | cut -c1-5)

if [[ ${short_hostname} == "eyewa" ]]
then
   long_hostname="eyewall"
fi

if [[ ${short_hostname} == "caspe" || ${short_hostname} == "crhtc" || ${short_hostname} == "crgpg" || ${short_hostname} == "crgpu" || ${short_hostname} == "crrda" || ${short_hostname} == "crvis" || ${short_hostname} == "crlar" ]]
then
   long_hostname="casper"
fi

# Set paths and environment
if [[ ${long_hostname} == "eyewall" ]]
then

   echo ""
   echo "Running on Eyewall"
   echo ""

   realtime="True"

   whenisit=`date`

   mm=` date '+DATE: %m' | awk '{ print \$2 }'`
   dd=` date '+DATE: %d' | awk '{ print \$2 }'`
   yyyy=` date | awk '{ print \$6 }'`

   # the 18Z instance of this script runs after midnight so make
   # sure you have the correct data
   if [ {hh} = '18' ]
   then
      mm=` date --date="1 days ago" '+DATE: %m' | awk '{ print \$2 }'`
      dd=` date --date="1 days ago" '+DATE: %d' | awk '{ print \$2 }'`
      yyyy=` date --date="1 days ago" | awk '{ print \$6 }'`
   fi

   dtg=${yyyy}${mm}${dd}${hh}

fi

if [[ ${long_hostname} == "casper" ]]
then

   echo ""
   echo "Running on Casper"
   echo ""

   realtime="False"

   dtg=${yyyymmddhh}

   yyyy=$(echo ${yyyymmddhh} | cut -c1-4)
   mm=$(echo ${yyyymmddhh} | cut -c5-6)
   dd=$(echo ${yyyymmddhh} | cut -c7-8)

fi

echo ""
echo "Start TCDIAG run script for ${dtg}"
echo ""
echo "Here is the command that will be run:"
echo       bash "${WORKDIR}/run_tcdiag.bash" $WORKDIR'/' ${yyyy} ${mm} ${dd} ${hh}
bash "${WORKDIR}/run_tcdiag.bash" $WORKDIR'/' ${yyyy} ${mm} ${dd} ${hh}

exit 0