#hybrid.sh by Pizza_Dox

var(){
	#version_control
	ver_revision=dev
	#debug control
	userdebug=0
	#misc control
	DATE=`date +%d-%m-%Y`
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
	echo "Menu:"
	echo " 1|Drop Caches"
	echo " 2|About"
	echo " E|Exit"
	echo ""
	echo -n "> "
	read selection_opt
	case $selection_opt in
		1 ) clear && title && drop_caches;;
		2 ) clear && title && debug_info;;
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
	clear
	free | awk '/Mem/{print "Mem stats before: "$4/1024" MB";}'
	sleep 3
	sync;
	echo "3" > /proc/sys/vm/drop_caches;
	free | awk '/Mem/{print "Mem stats after: "$4/1024" MB";}'
	sleep 3
	backdrop
}

debug_info(){
	echo -e "${green}Debug information:${nc}" #green
	#echo -e "\e[1;31mDebug information:\e[0m" #red
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
