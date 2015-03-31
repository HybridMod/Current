#hybrid.sh by Pizza_Dox

var(){
	#version_control
	ver_revision=$date
	ver_date=$date
	#debug control
	userdebug=1
}

title(){
	echo "[-=The Hybrid Project=-]"
	echo #n
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
	echo "debugging enabled"
	sleep 3;
	clear
fi
#call main functions
title
exit #body
