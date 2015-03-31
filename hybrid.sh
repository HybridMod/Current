#hybrid.sh by Pizza_Dox

var(){
	#version_control
	ver_revision=dev
	#debug control
	userdebug=1
	#misc control
	DATE=`date +%d-%m-%Y`
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
}

#session_behaviour
#call startup functions
clear
var
#run conditional statements
if [ $userdebug == 1 ]; then
	echo -e "\e[1;32mDebug information:\e[0m" #green
	#echo -e "\e[1;31mDebug information:\e[0m" #red
	echo ""
	echo "SYSTEM"
	echo "Vendor: $( getprop ro.product.brand )"
	echo "Model: $( getprop ro.product.model )"
	echo "ROM: $( getprop ro.build.display.id )"
	echo "Android Version: $( getprop ro.build.version.release )"
	echo ""
	echo "SCRIPT"
	echo "Hybrid Version: $DATE"
	echo ""
	sleep 5;
	clear
fi
#call main functions
title
body
