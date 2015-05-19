#linear game booster created by Diamond Bond
#based on many concepts, merged together.

variables(){
	ver=0.1
	user_debug=0
	waiter=60
}


#session behaviour
variables #call it m8

if [ "$user_debug" == 1 ]; then
	clear
	echo "SUPER DUPER LOAD REDUCER"
	echo ""
	sleep 2;
	echo "android has this file called the drop_caches file,"
	echo "stored in /proc/sys/vm and entering 1 drops some stuff,"
	echo "2 drops more and 3 all of it, so basically we drop"
	echo "all the stuffs to try and free up more resources for that"
	echo "resource intensive task and such (gaming, heavy apps)"
	sleep 3;
	echo ""
	echo "so by dropping the caches in an automated interval, you"
	echo "can keep android nice and smooth and your main apps smooth"
	echo "however this will drain battery a bit as the system will"
	echo "struggle to regenerate all the caches"
	sleep 3;
	echo ""
	echo "now comes the part where you do some work, you need to tell"
	echo "me how often you would like your caches droped (much work rite)"
	echo "here are some intervals i recommend: (all in seconds btw)"
	echo "60 - 1 min"
	echo "180 - 3 mins"
	echo "300 - 5 mins"
	echo "900 - 15 mins"
	sleep 4;
	echo ""
	echo "try 60 first, if the game gets stuttery (which might happen)"
	echo "its due to the agressiveness of the system, trying to rebuild"
	echo "all those dropped caches, but if it dosnt then your good to go!"
	sleep 3;
	echo ""
	echo "pick :P"
	sleep 1;
	echo -n "> "
	read waiter
	echo "tnx m8, lemme boost yer stuff now..."
	sleep 1;
	echo ""
fi

#main script below
(
while [ 1 ]
do
	sleep $waiter;
	sync;
  	echo "3" > /proc/sys/vm/drop_caches
  	# if [ "$user_debug" == 1 ]; then
  	# 	echo -n "exec at: " && date
  	# fi
done
)