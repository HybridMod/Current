#hybrid.sh by Pizza_Dox

var(){
	#version_control
	ver_revision=dev
	#debug control
	userdebug=1
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
	echo "[-=The Hybrid Project=-]"
	echo ""
}

body(){
	echo "Menu:"
	echo "A|Kernel Kontrol"
	echo " 1|CPU"
	echo " 2|CPU Hotplug"
	echo " 3|GPU"
	echo " 4|Screen"
	echo " 5|Sound"
	echo " 6|Battery"
	echo " 7|I/O Scheduler"
	echo " 8|Kernel Samepage Merging"
	echo " 9|Low Memory Killer"
	echo " 10|Virtual Memory"
	echo " 11|Misc Controls"
	echo ""
	echo -n "> "
	case $selection_opt in
		[1] ) clear && title && #function_name;;
		[2] ) clear && title && #function_name;;
		* ) echo && echo "error 404, function not found.";;
	esac
}

#session_behaviour
#call startup functions
clear
var
#run conditional statements
if [ $userdebug == 1 ]; then
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
fi
#call main functions
title
body
