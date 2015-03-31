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
	# echo -n "Loading"
	# sleep 0.5;
	# echo -n "."
	# sleep 0.5;
	# echo -n "."	#nice loading anim
	# sleep 0.5;
	# echo -n "."
}

body(){
	#temp
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
exit #body
