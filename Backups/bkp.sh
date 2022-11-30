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

function mcounter()
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

comm=$1
[[ $# -gt 1 ]] && { warn "** Used too many args. Use only one. **"; exit 0; }
case $comm in
        "-d"|"--daily")
        		
			mcounter
			systemctl stop minecraftd
       		 	tar -zcf $bDIR/daily/backup-$(date +%Y%m%d).tar.gz -C /home/minecraft server
			mysqldump -u root --all-databases > $bDIR/daily/mysqldump-$(date +%Y%m%d).dump
			find $bDIR/daily/* -mtime +7 -delete		#delete older than week
			#rsync -a --delete $bPATH wojtek@$bkpserver:~/ 2>/tmp/daily.log
			rsync -e "ssh -o StrictHostKeyChecking=no" -a --delete $bDIR wojtek@$bkpserver:~/
			systemctl start minecraftd
			;;
        "-w"|"--weekly")
			mcounter
			systemctl stop minecraftd
			tar -zcf $bDIR/weekly/backup-$(date +%Y%m%d).tar.gz -C /home/minecraft server
			mysqldump -u root --all-databases > $bDIR/weekly/mysqldump-$(date +%Y%m%d).dump
                        find $bDIR/weekly/* -mtime +31 -delete		#delete older than month
			rsync -e "ssh -o StrictHostKeyChecking=no" -a --delete $bDIR wojtek@$bkpserver:~/
			systemctl start minecraftd
			;;
        "-m"|"--monthly")
                        mcounter
			systemctl stop minecraftd
			tar -zcf $bDIR/monthly/backup-$(date +%Y%m%d).tar.gz -C /home/minecrafr server
			mysqldump -u root --all-databases > $bDIR/monthly/mysqldump-$(date +%Y%m%d).dump
                        find $bDIR/monthly/* -mtime +365 -delete	#delete older than year
			rsync -e "ssh -o StrictHostKeyChecking=no" -a --delete $bDIR wojtek@$bkpserver:~/
			systemctl start minecraftd
			;;
        "-h"|"--help") helper ;;

        *) info "** Bad input, use -h|--help **" ;;
esac
    

