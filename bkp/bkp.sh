#!/bin/bash

helper()
{
cat <<EOF
Usage: $0 [option]

-f|--full      Full server backup. Going by default if user pass is empty
-p|--partial   Without dirs eg. dev,proc,sys,tmp,run,mnt,media
-d|--dry       Trial run without making changes 
EOF
}

DIR=$(pwd)
#for tests --> full path is safer
SRC=~/bkp_proj/a/b/c
DST=~/bkp_proj/dest/a/b/c

comm=$1
[[ $# -gt 1 ]] && { echo "** Used too many args. Use only one. **"; exit 0; }
#[[ $comm == "" ]] && { comm="--full"; } 
case $comm in
        "-f"|"--full")
        	#tutaj info do uzytkownika, za ~1min wylaczenie serwera / serwer STOP / *rsync* / serwer START
        	echo "rsync -avrAXH $SRC $DST" ;; 
        "-p"|"--partial")
        	echo "rsync -avrAXH $SRC/ --exclude {"$SRC/dev/*","$SRC/proc/*","$SRC/sys/*","$SRC/tmp/*","$SRC/run/*","$SRC/mnt/*","$SRC/media/*"}" ;;
        	## Jakies cos $? jezeli =1 to call an ambulance
        "-d"|"--dry")
        	echo "rsync -avrAXH --dry-run $SRC $DST" ;;
        "-h"|"--help")
		helper ;;

        *) echo "** Bad input, use -h|--help **" ;;
esac
     
