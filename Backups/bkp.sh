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

errLog=/tmp/daily.log
bkpserver=minecraft-backup.inspir.ovh

bkpDIR=/home/minecraft/server
bDDIR=/home/wojtek/backups/daily
bWDIR=/home/wojtek/backups/weekly
bMDIR=/home/wojtek/backups/monthly
bPATH=/home/wojtek/backups


> $errLog
comm=$1
[[ $# -gt 1 ]] && { warn "** Used too many args. Use only one. **"; exit 0; }
case $comm in
        "-d"|"--daily")
        		#tutaj info do uzytkownika, za ~1min wylaczenie serwera / serwer STOP / *rsync* / serwer START
       		 	tar -zcf $bDDIR/backup-$(date +%Y%m%d).tar.gz -C /home/minecraft server
			find $bDDIR/* -mtime +7 -delete		#delete older than week
			#rsync -a --delete $bPATH wojtek@$bkpserver:~/ 2>/tmp/daily.log
			rsync -e "ssh -o StrictHostKeyChecking=no" -a --delete $bPATH wojtek@$bkpserver:~/
			;;
        "-w"|"--weekly")
        		#tutaj info do uzytkownika, za ~1min wylaczenie serwera / serwer STOP / *rsync* / serwer START
			tar -zcf $bWDIR/backup-$(date +%Y%m%d).tar.gz -C /home/minecraft server
                        find $bWDIR/* -mtime +31 -delete		#delete older than month
			rsync -e "ssh -o StrictHostKeyChecking=no" -a --delete $bPATH wojtek@$bkpserver:~/
			;;
        "-m"|"--monthly")
        		#tutaj info do uzytkownika, za ~1min wylaczenie serwera / serwer STOP / *rsync* / serwer START
                        tar -zcf $bMDIR/backup-$(date +%Y%m%d).tar.gz -C /home/minecrafr server
                        find $bMDIR/* -mtime +365 -delete	#delete older than year
			rsync -e "ssh -o StrictHostKeyChecking=no" -a --delete $bPATH wojtek@$bkpserver:~/
			;;
        "-h"|"--help") helper ;;

        *) info "** Bad input, use -h|--help **" ;;
esac
    
