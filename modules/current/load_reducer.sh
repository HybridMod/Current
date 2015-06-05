#load_reducer.sh created by Diamond Bond

variables(){
	ver=0.5
	user_debug=1 #using non-release variables
	waiter=60
}


#session behaviour
variables

(
while [ 1 ]
do
	sleep $waiter;
	sync;
  	echo "3" > /proc/sys/vm/drop_caches
  	if [ "$user_debug" == 1 ]; then
  		echo -n "exec at: " && date
  	fi
done
)