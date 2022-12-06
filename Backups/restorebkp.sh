#!/bin/bash

info () { echo -e "\e[32m[INFO]\e[0m ${1}" ; }
warn () { echo -e "\e[33m[WARN]\e[0m ${1}" ; }
error () { echo -e "\e[31m[ERROR]\e[0m ${1}" ; }

fbfile=fullbackup
DSTDIR=/home/minecraft/
BKPStar=wojtek@minecraft-backup.inspir.ovh:/home/wojtek/backups/*/*.tar
BKPSdump=wojtek@minecraft-backup.inspir.ovh:/home/wojtek/backups/*/*.dump

read -p "Choose what do you want to restore? Type - backup or dump: " chs
case $chs in
	"dump")
		mkdir -p ~/restore_dump && cd "$_"
		rsync -r --delete $BKPSdump .
		PS3='Choose number of a file which do you want to restore: '
		select file in $(ls -A1 *.dump); 
		do
                        read -p "You are going to restore database with file: $file. Are you sure? (type yes|no): " sel
                        case $sel in
                                "yes") echo "mysql -u root -p mc_db < $file"  ;;
                                "no") echo "bye"; break ;;
                                *)
                        esac

                done

		;;
	"backup")
		[[ ! -f "~/restore_tar" ]] && { mkdir -p ~/restore_tar && cd "$_"; }
		rsync -r --delete $BKPStar .
	       	PS3='Choose an option of backup to restore, or use ^C to break: '
		select opt in daily weekly monthly quit; 
		do
			case $opt in
				"daily")
					select file in $(ls -A1 $fbfile-daily-*.tar); 
					do
					warn; read -p "You are going to restore $file to $DSTDIR folder. Are you sure? (type yes|no): " sel
						case $sel in 
                                			"yes")
                                                        info "Restoring Fullbackup file to $DSTDIR"
                                                        tar -xf $fbfile.tar -C $DSTDIR -g /dev/null
                                                        info "Now restoring from incremental-${file#$fbfile-} to $DSTDIR"
                                                        tar -xf incremental-${file#$fbfile-} -C $DSTDIR -g /dev/null
                                                        break ;;
		                  			"no") echo "bye"; break ;;
                                			*) error "Bad input"; break ;;
                        			esac    
               				done
					;;
				"weekly")
					select file in $(ls -A1 $fbfile-weekly-*.tar); 
					do
                                	warn; read -p "You are going to restore $file to $DSTDIR folder. Are you sure? (type yes|no): " sel
                                        	case $sel in
                                                	"yes")
                                                	info "Restoring Fullbackup file to $DSTDIR"
                                                	tar -xf $fbfile.tar -C $DSTDIR -g /dev/null
                                                	info "Now restoring from incremental-${file#$fbfile-} to $DSTDIR"
							tar -xf incremental-${file#$fbfile-} -C $DSTDIR -g /dev/null
                                                	break ;;
                                                	"no") echo "bye"; break ;;
                                                	*) error "Bad input"; break ;;
                                      	  	esac
					done
					;;
				"monthly")
                                	select file in $(ls -A1 $fbfile-monthly-*.tar); 
					do
                                	warn; read -p "You are going to restore $file to $DSTDIR folder. Are you sure? (type yes|no): " sel
                                        	case $sel in
                                                	"yes")
                                                        info "Restoring Fullbackup file to $DSTDIR"
                                                        tar -xf $fbfile.tar -C $DSTDIR -g /dev/null
                                                        info "Now restoring from incremental-${file#$fbfile-} to $DSTDIR"
                                                        tar -xf incremental-${file#$fbfile-} -C $DSTDIR -g /dev/null
                                                        break ;;
                                                	"no") echo "bye"; break ;;
                                                	*) error "Bad input"; break ;;
                                        	esac
                                	done
					;;
				"quit") break ;;
				*) warn "Invalid option $REPLY" ;;
			esac
		done
esac

