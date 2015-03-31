#hybrid.sh by Pizza_Dox

var(){
	#version_control
	ver_revision=$date
	ver_date=$date
	#debug control
	userdebug=1
}

title(){
	#temp
}

body(){
	#temp
}

session_behaviour(){
	#call functions
	var
	if [ userdebug == 1 ]; then
		echo "debugging enabled"
	fi
}