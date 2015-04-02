#hybrid.sh by Pizza_Dox

var(){
	#version_control
	ver_revision=dev
	#debug control
	userdebug=0
	#misc control
	DATE=`date +%d-%m-%Y`
	sysrw='mount -o remount rw /system'
	sysro='mount -o remount ro /system'
	#color control
	red='\033[0;31m'
	green='\033[0;32m'
	yellow='\033[0;33m'
	cyan='\033[0;36m'
	white='\033[0;97m'
	nc='\033[0m' # No Color
}

title(){
	echo "${cyan}[-=The Hybrid Project=-]${nc}"
	echo ""
}

body(){
	echo "${yellow}Menu:${nc}"
	echo " 1|Drop My Caches"
	echo " 2|Clean Up My Crap"
	echo " 3|Optimize My SQLite DB's"
	echo " A|About"
	echo " E|Exit"
	echo ""
	echo -n "> "
	read selection_opt
	case $selection_opt in
		1 ) clear && drop_caches;;
		2 ) clear && clean_up;;
		3 ) clear && #temp;;
		a|A ) clear && about_info;;
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
	sleep 2
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
	if [ -e /data/system/dropbox/* ]; then
		rm -f /data/system/dropbox/* > /dev/null 2>&1
	fi
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
	echo "${yellow}Clean up complete!${nc}"
	sleep 3
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
	echo "Pizza_Dox - Diamond Bond : Me, the maintainer & developer of this script!"
	echo "Hoholee12/Zeppelinrox/Wedgess/Imbawind/Luca020400 : Code ${yellow}:)${nc}"
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

#session_behaviour
#call startup functions
clear
var
#run conditional statements
if [ $userdebug == 1 ]; then
	debug_info
fi
#call main functions
title
body
