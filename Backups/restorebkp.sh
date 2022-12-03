#!/bin/bash

DSTDIR=/home/minecraft/
BKPStar=wojtek@minecraft-backup.inspir.ovh:/home/wojtek/backups/*/*.tar.gz
BKPSdump=wojtek@minecraft-backup.inspir.ovh:/home/wojtek/backups/*/*.dump
read -p "Choose what do you want to restore? Type - backup or dump: " chs
case $chs in
	"dump")
		mkdir -p $(pwd)/restore_dump && cd "$_"
		rsync $BKPSdump .
		PS3='Choose number of file which do you want to restore: '
		select file in $(ls -A1 *.dump*); do
                        read -p "You are going to restore database with file: $file. Are you sure? (type yes|no): " sel
                        case $sel in
                                "yes") echo "mysql -u root -p mc_db < $file"  ;;
                                "no") echo "bye"; break ;;
                                *)
                        esac

                done

		;;
	"backup")
		mkdir -p $(pwd)/restore_tar $$ cd "$_"
		rsync -r $BKPStar .
	       	PS3='Choose number of file which do you want to restore: '
		select file in $(ls -A1 *.tar*); do 
			read -p "You are going to restore $file to $DSTDIR folder. Are you sure? (type yes|no): " sel
		       	case $sel in 
				"yes") echo "tar -xvf $file $DSTDIR"  ;;
				"no") echo "bye"; break ;;
				*)
			esac	
		
		done
	
		;;
esac

