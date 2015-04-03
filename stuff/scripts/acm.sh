#Adreno Catalyst Manager by Pizza_Dox

#info
#this script is designed to be that interface between
#your graphics cards performance and quality slider.
# thanks to tldp.org for loop stuffs, hoholee12 for misc code, spizzy & cosmicdan for egl.

#vars
verbose=1
mainver=0.1
waiter=60 #60 = min
if [ "$verbose" == 1 ]; then
	waiter=5
fi

head(){
	echo -e '\e[1;31m[-=ADRENO CATALYST MANAGER=-]\e[0m'
	echo
}

body(){
	echo "OPTIONS:"
	echo "[1] Resolution Control"
	echo "[2] EGL Profiling"
	echo "[3] Catalyst Control"
	echo -n "> "
	read body_opt
	case $body_opt in
   		1 ) clear && res_control;;
    	2 ) clear && egl_control;;
		3 ) clear && catalyst_control;;
    	* ) echo "?";;
    esac
}

main(){
	clear
	sleep 1;
	head #call title
	sleep 3;
	body #call body
}

function res_control(){ #done
	echo "Available Resoultions:"
	echo "[1] 720x1280"
	echo "[2] 540x960"
	echo "[C] Custom"
	echo "[M] Exit to main menu"
	echo -n "> "
	read res_opt
	case $res_opt in
		1 ) clear && wm size 720x1280 && wm density 320 && res_control;;
		2 ) clear && wm size 540x960 && wm density 256 && res_control;;
		C ) clear && res_custom(){
			echo "Please enter your resolution:"
			echo "ex: 720x1280"
			echo -n "> "
			read res_custom_in

			echo "Please enter your display density:"
			echo "ex: 320"
			echo -n "> "
			read density_custom_in

			#apply
			wm size $res_custom_in
			sleep 1; #adjustment wait
			wm density $density_custom_in
			} && res_custom;; #call res_custom() after creating
		* ) clear && echo "?";;
		M ) clear && body;;
	esac
}

egl_control(){
	echo "WIP!"
	
}

catalyst_control(){
	echo "(|CATALYST CONTROL|)"
	echo "[1] Inject Catalyst"
	echo "[2] Control Catalyst Injection Rate"
	echo "[M] Exit to main menu"
	echo -n "> "
	read catalyst_control_opt
	case $catalyst_control_opt in
		1 ) clear && catalyst_inject;;
		2 ) clear && catalyst_time_cfg;;
		M ) clear && body;;
		* ) clear && echo "?";;
	esac
}

catalyst_inject(){
	echo "Please leave the terminal emulator running"
	echo "This will continue to run untill you press X or Close"

	if [ "$verbose" == 1 ]; then
		echo
		echo "log:"
  	fi

	sleep 3;
	#clear
(
while [ 1 ]
do
	sleep $waiter;
	sync; #write to disk
  	echo "3" > /proc/sys/vm/drop_caches
  	if [ "$verbose" == 1 ]; then
  		echo -n "catalyst inject exec time: " && date
  	fi
done
)

catalyst_control #back
}

catalyst_time_cfg(){
	echo "Current rate: $waiter"
	echo "60 - Every minute - Default"
	echo "3600 - Every hour"
	sleep 1;
	echo ""
	echo "Please enter a rate:"
	echo -n "> "
	read catalyst_time_in
	waiter=$catalyst_time_in
	echo ""
	clear && echo "Time updated!"
	sleep 2;
	clear

	catalyst_control #back
}

get_mount(){
	sync; #write data to disk
	busybox mount -o remount,rw /system;
	busybox mount -o remount,rw /data;
}

#session_behaviour(){
get_mount #init mount
sleep 1;
main #call head & body
sleep 1;
#}