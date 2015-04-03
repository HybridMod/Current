kernel_kontrol()
{
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
	1) clear && selcpufreq ;;
	2) clear && selgov ;;
	3) clear && seliosched ;;
	4) clear && selvddcon ;;
	5) clear && vm_menu ;;
	b|B) clear && backdrop;;
	* ) echo && echo "error 404, function not found." && sleep 3 && backdrop;;
 esac
}

selcpufreq()
{
	clear
	maxfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
	minfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
	listfreq="`cat /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state | awk '{print $1}'`"
	maxfreqLimit=768000
	minfreqLimit=1017600
	echo "[*] Current MAX: $maxfreq"
	echo "[*] Current MIN: $minfreq"
	 echo -e "\n[*] Available Frequencies:"
	echo "$listfreq" | awk '{print "    " $1}'
	echo ""
	echo -n "[Q] Select new MAX frequency: "; read newmaxfreq;

	if [ "`echo "$listfreq" | grep -w "$newmaxfreq" 2>/dev/null`" ] && [ "$newmaxfreq" -ge "$maxfreqLimit" ]; then
		echo ""
		echo -n "[Q] Select new MIN frequency: "; read newminfreq;
		if [ "`echo "$listfreq" | grep -w "$newminfreq" 2>/dev/null`" ] && [ "$newminfreq" -le "$minfreqLimit" ]; then
			if [ "$newminfreq" -gt "$newmaxfreq" ]; then
				echo -e "\n[W] MIN frequency can not be greater than MAX frequency"; sleep 3; clear; selcpufreq;
			fi
		elif [[ $newminfreq == "q" || $newminfreq == "Q" || $newminfreq == "r" || $newminfreq == "R" ]]; then
			performance_menu;
		else
			echo -e "\n[W] If you want to set min frequency"; echo "    above $minfreqLimit, then use a CPU app"; sleep 3; clear; selcpufreq;
		fi
	elif [[ $newmaxfreq == "q" || $newmaxfreq == "Q" || $newmaxfreq == "r" || $newmaxfreq == "R" ]]; then
	performance_menu;
	else
		echo -e "\n[W] If you want to set max frequency"; echo "    below $maxfreqLimit, then use a CPU app"; sleep 3; clear; selcpufreq;
fi

#Extract and execute 77lps_frequencies
	cat << EOF > /data/local/tmp/77lps_frequencies
#!sh
echo "$newminfreq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo "$newmaxfreq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
EOF
	echo -e "\n[*] Applying new frequencies\n"
	sh /data/local/tmp/77lps_frequencies
	echo -n "[*] MAX freq = "; cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	echo -n "[*] MIN freq = "; cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

	sync
	sleep 2

	update_initd 77lps_frequencies;

	performance_menu;
}


selgov()
{
	mount -o remount rw /system
	clear
	curgov=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
	listgov="`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors | awk 'BEGIN{RS=" ";} {print $1}'`"
	echo -e "\n[*] Current Governor = $curgov"
	echo -e "\n[*] Available Governors:\n"
	echo "$listgov" | awk '{print "    " $1}'
	echo ""
	echo -n "[Q] Select new Governor: "; read newgov;

	if [ "`echo "$listgov" | grep -w "$newgov"`" ]; then
		#Extract and execute 78lps_defgovernor
		cat << EOF > /data/local/tmp/78lps_defgovernor
#!sh
echo "$newgov" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
EOF
		sh /data/local/tmp/78lps_defgovernor
		echo -ne "\n[*] New governor = "; cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
		update_initd 78lps_defgovernor
		performance_menu;
	elif [[ $newgov == "q" || $newgov == "Q" || $newgov == "r" || $newgov == "R" ]]; then
		performance_menu;
	else
		echo "[W] $newgov is not a valid governor"; sleep 3; selgov;
	fi
}


seliosched()
{
	mount -o remount rw /system
	clear
	curiosched=`cat /sys/block/mmcblk0/queue/scheduler | sed 's/.*\[\([a-zA-Z0-9_]*\)\].*/\1/'`
	listio=`cat /sys/block/mmcblk0/queue/scheduler | tr -s "[[:blank:]]" "\n" | sed 's/\[\([a-zA-Z0-9_]*\)\]/\1/'`
	echo "[*] Current IO-SCHEDULER = $curiosched"
	echo ""
	echo "[*] Available Io-Schedulers:"
	echo ""
	echo "$listio" | awk '{print "    " $1}'
	echo ""
	echo -n "[Q] Select new IO-Scheduler: "; read newio;

	if [ "`echo "$listio" | grep -w "$newio"`" ]; then
		#Extract and execute 79lps_defiosched
		cat << EOF > /data/local/tmp/79lps_defiosched
#!sh
for j in /sys/block/*/queue/scheduler; do
	echo "$newio" > \$j
done
EOF
		sh /data/local/tmp/79lps_defiosched
		sync;
		echo -ne "\n[*] New io-scheduler = "; cat /sys/block/mmcblk0/queue/scheduler | sed 's/.*\[\([a-zA-Z0-9_]*\)\].*/\1/';
		update_initd 79lps_defiosched;
		performance_menu;
	elif [[ $newio == "q" || $newio == "Q" || $newio == "r" || $newio == "R" ]]; then
		performance_menu;
	else
		echo "[W] $newio is not a valid scheduler"; sleep 3; clear; seliosched;
	fi
}
