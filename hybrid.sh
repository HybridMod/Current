#hybrid.sh by Pizza_Dox

var(){
	#version_control
	ver_revision=dev
	#options
	userdebug=0
	usermagic=0
	jargon=1
	#misc control
	DATE=`date +%d-%m-%Y`
	sysrw='mount -o remount rw /system'
	sysro='mount -o remount ro /system'
	#format control
	red='\033[0;31m'
	green='\033[0;32m'
	yellow='\033[0;33m'
	cyan='\033[0;36m'
	white='\033[0;97m'
	bld='\033[0;1m' #bold
	blnk='\033[0;5m' #blinking
	nc='\033[0m' # no color
}

title(){
	echo "${cyan}[-=The Hybrid Project=-]${nc}"
	echo ""
}

body(){
	echo "${yellow}Menu:${nc}"

	#conditional parts
	if [ $jargon == 1 ]; then
		echo " 1|Drop my caches"
		echo " 2|Clean up my crap"
		echo " 3|Optimize my SQLite DB's"
		echo " 4|"
	fi
	if [ $jargon == 0 ]; then
		echo " 1|Give me a quick boost!"
		echo " 2|Clean up all that junk in my system!"
		echo " 3|Make my lists load faster!"
	fi

	#standard menu
	echo " A|About"
	echo " R|Reboot"
	echo " E|Exit"
	echo ""
	echo -n "> "
	read selection_opt
	case $selection_opt in
		1 ) clear && drop_caches;;
		2 ) clear && clean_up;;
		3 ) clear && sql_optimize;;
		a|A ) clear && about_info;;
		r|R ) clear && echo "Rebooting in 3..." && sleep 3 && reboot;;
		e|E ) clear && title && exit;;
		* ) echo && echo "error 404, function not found." && backdrop;;
	esac
}

backdrop(){
	clear
	sleep 1;
	title
	body
}

drop_caches(){
	echo "${yellow}Caches dropped!${nc}"
	sync;
	echo "3" > /proc/sys/vm/drop_caches;
	sleep 3
	backdrop
}

clean_up(){
	echo "${yellow}Cleaning up...${nc}"
	sleep 3
	$sysrw
	# remove cache apps
	if [ -e /cache/*.apk ];then
		rm -f /cache/*.apk > /dev/null 2>&1
	fi

	# remove cache temp
	if [ -e /cache/*.tmp ]; then
		rm -f /cache/*.tmp > /dev/null 2>&1
	fi

	# remove dalvik-cache apps
	if [ -e /data/dalvik-cache/*.apk ]; then
		rm -f /data/dalvik-cache/*.apk > /dev/null 2>&1
	fi

	# remove dalvik-cache temp
	if [ -e /data/dalvik-cache/*.tmp ]; then
		rm -f /data/dalvik-cache/*.tmp > /dev/null 2>&1
	fi

	# remove usuage stats
	if [ -e /data/system/usagestats/* ]; then
		rm -f /data/system/usagestats/* > /dev/null 2>&1
	fi

	# remove app usuage stats
	if [ -e /data/system/appusagestats/* ]; then
		rm -f /data/system/appusagestats/* > /dev/null 2>&1
	fi

	# remove dropbox data content
	# if [ -e /data/system/dropbox/* ]; then
	# 	rm -f /data/system/dropbox/* > /dev/null 2>&1
	# fi

	# remove user behaviour
	if  [ -e /data/system/userbehavior.db ]; then
		rm -f /data/system/userbehavior.db > /dev/null 2>&1
	fi

	# disable usuage stats
	if  [ -d /data/system/usagestats ]; then
		chmod 0400 /data/system/usagestats > /dev/null 2>&1
	fi

	# disable app usage stats
	if  [ -d /data/system/appusagestats ]; then
		chmod 0400 /data/system/appusagestats > /dev/null 2>&1
	fi

	$sysro
	clear
	echo "${yellow}Clean up complete!${nc}"
	sleep 3
	backdrop
}

sql_optimize(){
	$sysrw

	echo "${yellow}Optimizing SQLite databases!"

	if [[ -e /system/xbin/sqlite3 ]]; then
		chown root.root  /system/xbin/sqlite3
		chmod 0755 /system/xbin/sqlite3
		SQLLOC=/system/xbin/sqlite3
		echo ""
	fi

	if [[ -e /system/bin/sqlite3 ]]; then
		chown root.root /system/bin/sqlite3
		chmod 0755 /system/bin/sqlite3
		SQLLOC=/system/bin/sqlite3
		echo ""
	fi

	if [[ -e /system/sbin/sqlite3 ]]; then #legacy support
		chown root.root /sbin/sqlite3
		chmod 0755 /sbin/sqlite3
		SQLLOC=/sbin/sqlite3
		echo ""
	fi
	for i in `find ./ -iname "*.db"`; do
		$SQLLOC $i 'VACUUM;'
		if [ $jargon == 1 ]; then
			clear; echo "${yellow}Vacuumed: $i${nc}"
		fi
		sleep 1;
		$SQLLOC $i 'REINDEX;'
		if [ $jargon == 1 ]; then
			echo "${yellow}Reindexed : $i${nc}"
		fi
		sleep 1;
	done

	$sysro
	sleep 5;
	clear
	echo "SQLite database optimizations complete!"
	sleep 3;
	backdrop
}

about_info(){
	echo -e "${green}About:${nc}"
	echo ""
	echo "${yellow}INFO${nc}"
	echo "This script deals with many things apps normally do."
	echo "But this script is ${cyan}AWESOME!${nc} because its < 1MB!"
	echo ""
	echo "${yellow}CREDITS${nc}"
	echo "Pizza_Dox - Diamond Bond : Me!"
	echo "Hoholee12/Wedgess/Imbawind/Luca020400 : Code ${yellow}:)${nc}"
	echo ""
	sleep 5;
	backdrop
}

debug_info(){
	echo -e "${green}Debug information:${nc}"
	echo ""
	echo "${yellow}SYSTEM${nc}"
	echo "Vendor: $( getprop ro.product.brand )"
	echo "Model: $( getprop ro.product.model )"
	echo "ROM: $( getprop ro.build.display.id )"
	echo "Android Version: $( getprop ro.build.version.release )"
	echo ""
	echo "${yellow}SCRIPT${nc}"
	echo "Hybrid Version: $DATE"
	echo ""
	sleep 5;
	clear
	backdrop
}

magic_bar(){
	for i in {16..21} {21..16} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
	sleep 5;
	clear
	backdrop
}

#session_behaviour
#call startup functions
clear
var
#run conditional statements
if [ $userdebug == 1 ]; then
	debug_info
fi
if [ $usermagic == 1 ]; then
	magic_bar
fi
#call main functions
title
body
