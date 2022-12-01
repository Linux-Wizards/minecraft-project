#!/bin/bash

DSTDIR=/home/minecraft/
BKPStar=wojtek@minecraft-backup.inspir.ovh:/home/wojtek/backups/*/*.tar.gz
BKPSdump=wojtek@minecraft-backup.inspir.ovh:/home/wojtek/backups/*/*.dump
read -p "Choose what do you want to restore? Type - backup or dump: " chs
case $chs in
	"dump")
		mkdir -p $(pwd)/restore_dump && cd "$_"
		rsync $BKPSdump .
		;;
	"backup") 
		mkdir -p $(pwd)/restore_tar $$ cd "$_"
		cd restore_tar
		rsync -r $BKPStar .
		;;
esac

