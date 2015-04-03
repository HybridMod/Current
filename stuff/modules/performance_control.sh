kernel_kontrol(){
	clear
	echo "${yellow}Kernel Kontrol${nc}"
	echo ""
	echo " 1|Set CPU Freq"
	echo " 2|Set CPU Gov"
	echo " 3|Set I/O Sched"
	echo " B|Back"
	echo -n "> "
	read kk_opt;
	case $kk_opt in
		1) clear && setcpufreq;;
		2) clear && setgov;;
		3) clear && setiosched;;
		b|B) clear && backdrop;;
		* ) echo && echo "error 404, function not found." && sleep 3 && backdrop;;
	 esac
}

setcpufreq(){
	clear
	#configure sub variables
	maxfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
	minfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
	curfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
	listfreq='cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies'

	echo "${yellow}CPU Control${nc}"
	echo ""
	echo "${bld}Current Max Freq:${nc} $maxfreq"
	echo "${bld}Current Min Freq:${nc} $minfreq"
	echo "${bld}Current Freq:${nc} $curfreq"
	echo ""
	echo "${bld}Available Freq's:${nc} "
	echo "$listfreq"
	echo ""
	sleep 2
	echo -n "New Max Freq: "; && sleep 1 && read newmaxfreq;
	echo -n "New Min Freq: "; && sleep 1 && read newminfreq;
	sleep 1

	echo "$newminfreq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo "$newmaxfreq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq

	echo "${yellow}New Freq's applied!${nc}"

	backdrop
}

setgov(){
	clear
	#configure sub variables
	curgov=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
	listgov=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors`

	echo "${yellow}Gov Control${nc}"
	echo ""
	echo "${bld}Current Governor:${nc} $curgov"
	echo ""
	echo "${bld}Available Governors:${nc} "
	echo "$listgov"
	echo ""
	sleep 2
	echo -n "New Governor: "; && sleep 1 && read newgov;
	sleep 1

	echo "$newgov" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

	echo "${yellow}New Governor applied!${nc}"

	backdrop
}


setiosched(){
	clear
	#configure sub variables
	curiosched=`cat /sys/block/mmcblk0/queue/scheduler | sed 's/.*\[\([a-zA-Z0-9_]*\)\].*/\1/'`
	listiosched=`cat /sys/block/mmcblk0/queue/scheduler | tr -s "[[:blank:]]" "\n" | sed 's/\[\([a-zA-Z0-9_]*\)\]/\1/'`

	echo "${yellow}I/O Sched Control${nc}"
	echo ""
	echo "${bld}Current I/O Scheduler:${nc} $curiosched"
	echo ""
	echo "${bld}Available I/O Schedulers:${nc} "
	echo "$listiosched"
	echo ""
	sleep 2
	echo -n "New Scheduler: "; && sleep 1 && read newiosched;
	sleep 1

	for j in /sys/block/*/queue/scheduler; do
		echo "$newio" > \$j
	done

	echo "${yellow}New I/O Scheduler applied!${nc}"

	backdrop
}
