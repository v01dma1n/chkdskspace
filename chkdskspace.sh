#!/bin/bash
# Script Name: chkdskspace
# Version: v.0.1
# Description:
#   Script checks specified device for free disk space and sends email alert
#   if the space is below provided threshold.

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
DEVICE=$1	# device name like / or /dev/sda1
LOWPCT=$2	# LOW free disc threshold in %
CRITPCT=$3	# CRITICALLY LOW free disk threshold in %
ADMEMAIL=$4	# Admin email for notifications

if [ $# -ne 3 ];
then
    echo "Error: illegal number of parameters."
    echo ""
    echo "Script checks specified device for free disk space and sends email alert"
    echo "Expected parameters: "
    echo "DEVICE    device name like / or /dev/sda1"
    echo "LOWPCT    LOW free disc threshold in %"
    echo "CRITPCT   CRITICALLY LOW free disk threshold in %"
    exit 1
fi

# constants
LOGNAME="/var/log/chkdskspace.log"

#echo $DEVICE","$LOWPCT","$CRITPCT
USEDPCT=$(df $DEVICE | grep / | awk '{ print $5}' | sed 's/%//g')
#echo $USEDPCT
AVAILPCT=`expr 100 - $USEDPCT`
#echo $AVAILPCT

FREELEVEL="OK"
if [ "$AVAILPCT" -lt "$CRITPCT" ]
then
  FREELEVEL="CRITICALLY LOW"
else
  if [ "$AVAILPCT" -lt "$LOWPCT" ]
  then
    FREELEVEL="LOW"
  fi
fi

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
MSGTEXT="Partition "$DEVICE" remaining free space is "$FREELEVEL". Left: "$AVAILPCT"%"

# log the current values
echo $TIMESTAMP" - "$MSGTEXT >> $LOGNAME

# if admin email is provided, see is we should send a notification
if [ "$ADMEMAIL" != "" ]
then
	# email alert if space is not OK
	if [ "$FREELEVEL" != "OK" ]
	then
	  ssmtp -oi $ADMEMAIL << EOF
Subject: ALERT from $HOSTNAME: disk space $FREELEVEL

$MSGTEXT

(Levels: LOW=$LOWPCT%, CRITICAL=$CRITPCT%)

EOF
	fi
fi
