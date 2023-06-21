#!/bin/bash
# For testing relative position

ls -l .
cat ./basic_venv_requirements.txt
#dirname $0
echo ${BASH_SOURCE[0]}
SCRIPTDIR=`dirname $0`
echo $SCRIPTDIR
cat $SCRIPTDIR/basic_venv_requirements.txt
