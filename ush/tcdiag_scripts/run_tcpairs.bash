#!/bin/bash
# script run_tcpairs.bash
#
# This script calls tcpairs to process TCDiag data.
#

echo ""
echo "==========================================================="
echo " Entering run_tcpairs.bash"
echo "==========================================================="
echo ""


# JLV: Added this so that the script gets the calling path when run from cron (otherwise, it just gets the user's home directory)
cd "$(dirname "$0")"

cd ../..
WORKDIR=`pwd`

# if [[ ${1} == "" ]]
# then
#   echo "run_tcpairs.bash: ERROR: The first command line argument must be the date/time of the cycle for which you wish to run: YYYYMMDDHH, "
#   echo "       where YYYY is the four-digit year, MM is the two-digit month, DD is the two-digit day, and HH is the two-digit hour."
#   echo "NOTE: If running in real-time, the YYYYMMDD part will be ignored and the script will set these appropriately based on the specified two-digit hour."
#   exit 1
# else
#   yyyymmddhh=${1}
# fi

# if [[ ${2} == "" ]]
# then
#   echo "TCDIAG_driver.bash: ERROR: The second command line argument must be the subdirectory of the adecks collection to use."
#   exit 1
# else
#   adecks_collection=${2}
# fi

# if [[ ${3} == "" ]]
# then
#   echo "TCDIAG_driver.bash: ERROR: The third command line argument must be the subdirectory of the active stormlist collection to use."
#   exit 1
# else
#   stormlist_collection=${3}
# fi


# Find out which host we are running on
host=$(hostname)

short_hostname=$(echo ${host} | cut -c1-5)

if [[ ${short_hostname} == "eyewa" ]]
then
   long_hostname="eyewall"
fi

short_hostname=$(echo ${host} | cut -c1-5)

if [[ ${short_hostname} == "senec" ]]
then
   long_hostname="seneca"
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

fi

if [[ ${long_hostname} == "seneca" ]]
then

   echo ""
   echo "Running on Seneca"
   echo ""

   # Add METplus to path
   export PATH=/d1/personal/jvigh/METplus/ush:$PATH

   # Add MET to path
   export PATH=/usr/local/met-11.0.1/bin:$PATH

fi


if [[ ${long_hostname} == "casper" ]]
then

   echo ""
   echo "Running on Casper"
   echo ""

fi

echo ""
echo "Run tcpairs for ${dtg}"
echo ""

echo "Here is the command that will be run:"
echo       run_metplus.py "${WORKDIR}/parm/user_config/system_config.${long_hostname}" "${WORKDIR}/parm/metplus_config/TCPairs_Read_TCDiag.config"
run_metplus.py "${WORKDIR}/parm/user_config/system_config.${long_hostname}" "${WORKDIR}/parm/metplus_config/TCPairs_Read_TCDia.config"

exit 0
