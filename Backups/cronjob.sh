#!/bin/bash

crontab -l > croner

SDIR=/home/wojtek/minecraft-project/Backups
echo "0 1 * * 1-6	[[ $(date +\%d) -eq 1 ]] || $SDIR/bkp.sh -d	#daily, 1am" 
echo "0 2 * * 0	$SDIR/bkp.sh -w					#weekly on Sunday, 2am"
echo "0 3 1 * *	[[ $(date +\%d) -eq 1 ]] && $SDIR/bkp.sh -m	#monthly, 1st day of every month, 3am"

crontab croner
rm croner
