#!/bin/bash
# Script Name: chkdskspaceall
# Version: v.0.1
# Description:
#   Script enumerates all file systems and performs usage check
#   while skipping all tmpfs' and ones with 0% usages.
#   In turn uses chkdskspace script to send alerts and log outcome.

#   Copyright (C) 2015 Irek Rybark <irek@rybark.com>
#
#   Authors: Irek Rybark <irek@rybark.com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, version 3 of the License.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.


# parameters
ADMEMAIL=$1	# Admin email for notifications

# constants
DEFLOWPCT=20	# default LOW free disc threshold in %
DEFCRITPCT=10	# default CRITICALLY LOW free disk threshold in %

# for each line listed by df (-T = show file system), check used space
df -T | sed 1d | while read line ;
do
  DEVNAME=$(echo $line | awk '{ print $1}')
  FILESYS=$(echo $line | awk '{ print $2}')
  USEDPCT=$(echo $line | awk '{ print $6}' | sed 's/%//g')
  DEVMOUNT=$(echo $line | awk '{ print $7}')

#  echo $DEVNAME": "$USEDPCT": "$DEVMOUNT": "$FILESYS

  if [[ $FILESYS != *"tmpfs"*  ]] # ignore check for tmpfs
  then
    if [ "$USEDPCT" -gt "0" ] # ignore check for storage with 0% used
    then
	  echo "Checking "$DEVNAME
	  ./chkdskspace $DEVNAME $DEFLOWPCT $DEFCRITPCT $ADMEMAIL
	else
	  echo "Skipped "$USEDPCT" usage"
	fi
  else
    echo "Skipped tempfs: "$DEVNAME
  fi

done

