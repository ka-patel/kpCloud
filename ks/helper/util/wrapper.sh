#!/bin/bash 


## NOTES:
# Following is list of utils not available in specific kickstart build methods
#
# Redhat 6.1: getopts (needed by striphtml.txt), curl and git
#

# Set debug options if set
if [ -n "$DEBUG" ] ; then 
  set -xv
  SHOPTS='-xv'
  CURLOPTS='-v'
  WGETOPTS='-d'
fi

set -a

# Get the kernel parameters and export them for downstream scripts
for I in $(cat /proc/cmdline)
  do case "$I" in 
       *=*)  # we set only if it is a paired set
         echo "setting: "$I
         eval $I;; 
     esac
  done

echo ' '

set +a

if [ -z $PHASE ] ; then 
  echo '$PHASE undefined. Exiting.'
  exit 255
fi

if [ -z $PHASEROOT ] ; then 
  echo '$PHASEROOT undefined. Exiting.'
  exit 255
fi

# if [ -z $OS ] ; then 
#   echo '$OS undefined. Exiting.'
#   exit 255
# fi

OS=$(IFS=/; set -- $ks; echo $5/$6/$7)

echo '$OS='$OS

# Set our interested location in local file system name space
SCRIPTROOT=${PHASEROOT}/${PHASE}
SCRIPTDIR=${SCRIPTROOT}.d
mkdir -p ${SCRIPTDIR}

SCRIPTLOGS=${SCRIPTROOT}.d.log
mkdir -p ${SCRIPTLOGS}

# Set our interested locations in URL name space
HTTPSERVER=kpCloud-ks
HTTPROOT=http://${HTTPSERVER}/ks
HTTPSCRIPTLOC=${OS}/${PHASE}

echo '$HTTPROOT='$HTTPROOT
echo '$HTTPSCRIPTLOC='$HTTPSCRIPTLOC
echo

# Preserve where we are so that we can get back there
OLDCD=$(pwd)

# Move into script directory which will be the working directory
cd ${SCRIPTDIR}

# Get list of scripts
wget ${WGETOPTS} -O index.html ${HTTPROOT}/${HTTPSCRIPTLOC}

# Build script list
cat index.html | sed 's/<[^>]\+>//g' | grep "^[0-9][0-9]-" | cut -d" " -f1 > scripts.lst

# Get all script while we have opportunity
for SCRIPTNAME in $(cat scripts.lst) ; do
  echo "+++ ${SCRIPTNAME}"
  wget ${WGETOPTS} -O ${SCRIPTNAME} ${HTTPROOT}/${HTTPSCRIPTLOC}/${SCRIPTNAME}
done 2>&1 | /usr/bin/tee ${SCRIPTDIR}/curl.log 

# Execute script from the local file system
for SCRIPTNAME in $(cat scripts.lst) ; do

  DATE=$(date)
  echo "Running: \"${SCRIPTNAME}\""
  echo "   Date: $DATE"

  nowis=$(date +%Y%m%d-%H%M%S)

  starttime=$(date +"%s")

  openvt -l -s -w -v -- cd ${SCRIPTDIR}; ( time cat ${SCRIPTNAME} | sh ${SHOPTS} 2>&1 ) | /usr/bin/tee -a ${SCRIPTLOGS}/${SCRIPTNAME}.log

  endtime=$(date +"%s")
  deltatime=$(($endtime - $starttime))
  runtime=$(echo - | awk -v "S=$deltatime" '{printf "%dh:%dm:%ds",S/(60*60),S%(60*60)/60,S%60}')
  echo "Script run time: $runtime"

  echo "  --------"
done

# Go back where we came from in case we are in NFS name space and need to unmount
cd ${OLDCD}

exit 0

