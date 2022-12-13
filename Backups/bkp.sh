#!/bin/bash

info () { echo -e "\e[32m[INFO]\e[0m ${1}" ; }
warn () { echo -e "\e[33m[WARN]\e[0m ${1}" ; }
error () { echo -e "\e[31m[ERROR]\e[0m ${1}" ; }


helper()
{
cat <<EOF
Usage: $0 [option]

-d|--daily	Daily backup
-w|--weekly	Weekly backup
-m|--monthly	Monthly backup

EOF
}

mcounter()
{
	mcrcon -H localhost -P 25575 -p linuxwizards "say [Backup] Server will be stopped in 30 minutes for backup."
	sleep 15m
	mcrcon -H localhost -P 25575 -p linuxwizards "say [Backup] Server will be stopped in 15 minutes for backup."
	sleep 14m
	mcrcon -H localhost -P 25575 -p linuxwizards "say [Backup] Server will be stopped in 1 minute for backup."
	sleep 1m
}

bkpserver=minecraft-backup.inspir.ovh
bDIR=/home/wojtek/backups
dDIR=/home/wojtek/backups/daily
wDIR=/home/wojtek/backups/weekly
mDIR=/home/wojtek/backups/monthly
fbfile=fullbackup
comm=$1
DEBUG=no	#set DEBUG=yes to skip 30m sleeping by mcounter function

if [ $(id -u) -ne 0 ]; then
    error "Please run this script as root!"
    exit 1
fi

[[ $# -gt 1 ]] && { warn "** Used too many args. Use only one. **"; exit 0; }
case $comm in
        "-d"|"--daily")
        		
			[[ "$DEBUG" == "no" ]] && mcounter
			systemctl stop minecraftd
       		 	[[ "$(ls $dDIR/$fbfile-${dDIR:21}-*.tar | wc -l)" -eq 0 ]] && { tar -cf $dDIR/$fbfile-${dDIR:21}-$(date +%Y%m%d).tar -g $dDIR/data_daily.snar -C /home/minecraft server; }
			tar -cf $dDIR/incremental-${dDIR:21}-$(date +%Y%m%d).tar -g $dDIR/data_daily.snar -C /home/minecraft server	
			mysqldump -u root --all-databases > $dDIR/${dDIR:21}-mysqldump-$(date +%Y%m%d).dump
			find $dDIR/* -mtime +7 -delete		#delete older than week
			rsync -e "ssh -o StrictHostKeyChecking=no" -a --delete $bDIR wojtek@$bkpserver:~/
			systemctl start minecraftd
			;;
        "-w"|"--weekly")
			[[ "$DEBUG" == "no" ]] && mcounter
			systemctl stop minecraftd
                        [[ "$(ls $dDIR/$fbfile-${dDIR:21}-*.tar | wc -l)" -eq 0 ]] && { tar -cf $wDIR/$fbfile-${wDIR:21}-$(date +%Y%m%d).tar -g $wDIR/data_weekly.snar -C /home/minecraft server; }
                        tar -cf $wDIR/incremental-${wDIR:21}-$(date +%Y%m%d).tar -g $wDIR/data_weekly.snar -C /home/minecraft server
			mysqldump -u root --all-databases > $wDIR/${wDIR:21}-mysqldump-$(date +%Y%m%d).dump
                        find $wDIR/* -mtime +31 -delete		#delete older than month
			rsync -e "ssh -o StrictHostKeyChecking=no" -a --delete $bDIR wojtek@$bkpserver:~/
			systemctl start minecraftd
			;;
        "-m"|"--monthly")
			[[ "$DEBUG" == "no" ]] && mcounter
			systemctl stop minecraftd
                        [[ "$(ls $dDIR/$fbfile-${dDIR:21}-*.tar | wc -l)" -eq 0 ]] && { tar -cf $mDIR/$fbfile-${mDIR:21}-$(date +%Y%m%d).tar -g $mDIR/data_monthly.snar -C /home/minecraft server; }
                        tar -cf $mDIR/incremental-${mDIR:21}-$(date +%Y%m%d).tar -g $mDIR/data_monthly.snar -C /home/minecraft server
			mysqldump -u root --all-databases > $mDIR/${mDIR:21}-mysqldump-$(date +%Y%m%d).dump
                        find $mDIR/* -mtime +365 -delete	#delete older than year
			rsync -e "ssh -o StrictHostKeyChecking=no" -a --delete $bDIR wojtek@$bkpserver:~/
			systemctl start minecraftd
			;;
        "-h"|"--help") helper ;;

        *) info "** Bad input, use -h|--help **" ;;
esac
    

