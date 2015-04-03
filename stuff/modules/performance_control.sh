selcpufreq()
{
	$BB clear
	maxfreq=`$BB cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
	minfreq=`$BB cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
	listfreq="`$BB cat /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state | $BB awk '{print $1}'`"
	maxfreqLimit=768000
	minfreqLimit=1017600
	$BB echo "[*] Current MAX: $maxfreq"
	$BB echo "[*] Current MIN: $minfreq"
	 echo -e "\n[*] Available Frequencies:\n"
	$BB echo "$listfreq" | $BB awk '{print "    " $1}'
	$BB echo ""
	$BB echo -n "[Q] Select new MAX frequency: "; read newmaxfreq;

	if [ "`$BB echo "$listfreq" | $BB grep -w "$newmaxfreq" 2>/dev/null`" ] && [ "$newmaxfreq" -ge "$maxfreqLimit" ]; then
		$BB echo ""
		$BB echo -n "[Q] Select new MIN frequency: "; read newminfreq;
		if [ "`$BB echo "$listfreq" | $BB grep -w "$newminfreq" 2>/dev/null`" ] && [ "$newminfreq" -le "$minfreqLimit" ]; then
			if [ "$newminfreq" -gt "$newmaxfreq" ]; then
				$BB echo -e "\n[W] MIN frequency can not be greater than MAX frequency"; $BB sleep 3; $BB clear; selcpufreq;
			fi
		elif [[ $newminfreq == "q" || $newminfreq == "Q" || $newminfreq == "r" || $newminfreq == "R" ]]; then
			performance_menu;
		else
			$BB echo -e "\n[W] If you want to set min frequency"; $BB echo "    above $minfreqLimit, then use a CPU app"; $BB sleep 3; $BB clear; selcpufreq;
		fi
	elif [[ $newmaxfreq == "q" || $newmaxfreq == "Q" || $newmaxfreq == "r" || $newmaxfreq == "R" ]]; then
	performance_menu;
	else
		$BB echo -e "\n[W] If you want to set max frequency"; $BB echo "    below $maxfreqLimit, then use a CPU app"; $BB sleep 3; $BB clear; selcpufreq;
fi

#Extract and execute 77lps_frequencies
	$BB cat << EOF > /data/local/tmp/77lps_frequencies
#!$BB sh
$BB echo "$newminfreq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
$BB echo "$newmaxfreq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
EOF
	$BB echo -e "\n[*] Applying new frequencies\n"
	$BB sh /data/local/tmp/77lps_frequencies
	$BB echo -n "[*] MAX freq = "; $BB cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
	$BB echo -n "[*] MIN freq = "; $BB cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

	$BB sync
	$BB sleep 2

	update_initd 77lps_frequencies;

	performance_menu;
}


selgov()
{
	$BB mount -o remount rw /system
	$BB clear
	curgov=`$BB cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
	listgov="`$BB cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors | $BB awk 'BEGIN{RS=" ";} {print $1}'`"
	$BB echo -e "\n[*] Current Governor = $curgov"
	$BB echo -e "\n[*] Available Governors:\n"
	$BB echo "$listgov" | $BB awk '{print "    " $1}'
	$BB echo ""
	$BB echo -n "[Q] Select new Governor: "; read newgov;

	if [ "`$BB echo "$listgov" | $BB grep -w "$newgov"`" ]; then
		#Extract and execute 78lps_defgovernor
		$BB cat << EOF > /data/local/tmp/78lps_defgovernor
#!$BB sh
$BB echo "$newgov" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
EOF
		$BB sh /data/local/tmp/78lps_defgovernor
		$BB echo -ne "\n[*] New governor = "; $BB cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;
		update_initd 78lps_defgovernor
		performance_menu;
	elif [[ $newgov == "q" || $newgov == "Q" || $newgov == "r" || $newgov == "R" ]]; then
		performance_menu;
	else
		$BB echo "[W] $newgov is not a valid governor"; sleep 3; selgov;
	fi
}


seliosched()
{
	$BB mount -o remount rw /system
	$BB clear
	curiosched=`$BB cat /sys/block/mmcblk0/queue/scheduler | $BB sed 's/.*\[\([a-zA-Z0-9_]*\)\].*/\1/'`
	listio=`$BB cat /sys/block/mmcblk0/queue/scheduler | $BB tr -s "[[:blank:]]" "\n" | $BB sed 's/\[\([a-zA-Z0-9_]*\)\]/\1/'`
	$BB echo "[*] Current IO-SCHEDULER = $curiosched"
	$BB echo ""
	$BB echo "[*] Available Io-Schedulers:"
	$BB echo ""
	$BB echo "$listio" | $BB awk '{print "    " $1}'
	$BB echo ""
	$BB echo -n "[Q] Select new IO-Scheduler: "; read newio;

	if [ "`$BB echo "$listio" | grep -w "$newio"`" ]; then
		#Extract and execute 79lps_defiosched
		cat << EOF > /data/local/tmp/79lps_defiosched
#!$BB sh
for j in /sys/block/*/queue/scheduler; do
	$BB echo "$newio" > \$j
done
EOF
		sh /data/local/tmp/79lps_defiosched
		$BB sync;
		$BB echo -ne "\n[*] New io-scheduler = "; $BB cat /sys/block/mmcblk0/queue/scheduler | $BB sed 's/.*\[\([a-zA-Z0-9_]*\)\].*/\1/';
		update_initd 79lps_defiosched;
		performance_menu;
	elif [[ $newio == "q" || $newio == "Q" || $newio == "r" || $newio == "R" ]]; then
		performance_menu;
	else
		echo "[W] $newio is not a valid scheduler"; sleep 3; $BB clear; seliosched;
	fi
}
