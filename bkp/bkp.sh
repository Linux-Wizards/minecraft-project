#!/bin/bas

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

DDIR=/home/user/backup/daily
WDIR=/home/user/backup/weekly
MDIR=/home/user/backup/monthly

comm=$1
[[ $# -gt 1 ]] && { warn "** Used too many args. Use only one. **"; exit 0; }
case $comm in
        "-d"|"--daily")
        		#tutaj info do uzytkownika, za ~1min wylaczenie serwera / serwer STOP / *rsync* / serwer START
       		 	tar -zcf $DDIR/backup-$(date +%Y%m%d).tar.gz -C path/to/backup-dir/ to
			find $DDIR/* -mtime +7 -delete		#delete older than week
			rsync -a --delete $DDIR/ ubuntu@mcraft.imth.tk:~/backups/daily/ 2>/ramdisk/daily.log
			;;
        "-w"|"--weekly")
        		#tutaj info do uzytkownika, za ~1min wylaczenie serwera / serwer STOP / *rsync* / serwer START
			tar -zcf $WDIR/backup-$(date +%Y%m%d).tar.gz -C path/to/backup-dir/ to
                        find $WDIR/* -mtime +31 -delete		#delete older than month
                        rsync -a --delete $WDIR/ ubuntu@mcraft.imth.tk:~/backups/weekly/ 2>/ramdisk/weekly.log
			;;
        "-m"|"--monthly")
        		#tutaj info do uzytkownika, za ~1min wylaczenie serwera / serwer STOP / *rsync* / serwer START
                        tar -zcf $MDIR/backup-$(date +%Y%m%d).tar.gz -C path/to/backup-dir/ to
                        find $MDIR/* -mtime +365 -delete	#delete older than year
                        rsync -a --delete $MDIR/ ubuntu@mcraft.imth.tk:~/backups/monthly/ 2>/ramdisk/monthly.log
			;;
        "-h"|"--help") helper ;;

        *) echo "** Bad input, use -h|--help **" ;;
esac
     
