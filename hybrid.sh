#hybrid.sh by DiamondBond & Deic

sh_ota(){
	#SH-OTA.sh By Deic & DiamondBond

	#Variables
	var(){
		name="SH-OTA.sh"
		download="https://www.Your-Site/SH-OTA.sh"
		check="$EXTERNAL_STORAGE/Download/$name"
		browser="am start -a android.intent.action.VIEW -n com.android.browser/.BrowserActivity"
		term="am start -a android.intent.action.MAIN -n jackpal.androidterm/.Term"
		null=`>/dev/null 2>&1`
	}

	download(){
		$browser $download $null
		$term $null
		check_update
	}

	check_update(){
		if [ -e $check ]; then
			am force-stop com.android.browser
			$SHELL -c $check
		else
			wait_download
		fi
	}

	wait_download(){
		check_update
	}

	#Start
	clear
	var
	download
}

var(){
	#version_control
	ver_revision=1.8

	#options
	userdebug=1
	usagetype=0
	initd=1
	motod=0
	shfixrun=0

	#misc control
	DATE=`date +%d-%m-%Y`
	null=`>/dev/null 2>&1`
}

cli_displaytype(){
	#color control
	red='\033[0;31m'
	green='\033[0;32m'
	yellow='\033[0;33m'
	cyan='\033[0;36m'
	white='\033[0;97m'

	#formatting control
	bld='\033[0;1m' #bold
	blnk='\033[0;5m' #blinking
	nc='\033[0m' # no color
}

body(){
	echo "${cyan}[-=The Hybrid Project=-]${nc}"
	echo

	echo "${yellow}Menu:${nc}"
	echo " 1|Instant Boost"
	echo " 2|Clean up my crap"
	echo " 3|Optimize my SQLite DB's"
	echo " 4|Tune my VM"
	echo " 5|Tune my LMK"
	echo " 6|Tune my Networks"
	echo " 7|Remove logger"
	echo " 8|Kernel Kontrol"
	echo " 9|Apps"
	echo " 10|Game Booster"
	echo
	echo " O|Options"
	echo " A|About"
	echo " S|Source"
	echo " R|Reboot"
	echo " E|Exit"
	echo
	echo -n "> "
	read selection_opt
	case $selection_opt in
		1 ) drop_caches;;
		2 ) clean_up;;
		3 ) sql_optimize;;
		4 ) vm_tune;;
		5 ) lmk_tune_opt;;
		6 ) network_tune;;
		7 ) kill_log;;
		8 ) kernel_kontrol;;
		9 ) app_wise;;
		10 ) catalyst_control;;
		o|O ) options;;
		a|A ) about_info;;
		s|S ) am start "https://github.com/HybridMod/Current/" $null;;
		r|R ) creboot;;
		e|E ) safe_exit;;
		* ) error_404 && backdrop;;
	esac
}

backdrop(){
	clear
	sleep 1
	body
}

error_404(){
	echo
	echo "error 404, function not found."
	sleep 3
}

drop_caches(){
	clear
	if [ $usagetype == 0 ]; then
		echo "${yellow}Caches dropped!${nc}"
		sync
		echo "3" > /proc/sys/vm/drop_caches
		sleep 2
	fi

	if [ $usagetype == 1 ]; then
	  if [ $initd == 1 ]; then
	    sysrw $null
	    mkdir -p /system/etc/init.d
	    touch /system/etc/init.d/97cache_drop
	    chmod 755 /system/etc/init.d/97cache_drop
	    echo -ne "" > /system/etc/init.d/97cache_drop
cat >> /system/etc/init.d/97cache_drop <<EOF
#!/system/bin/sh
sleep 17

sync
echo "3" > /proc/sys/vm/drop_caches

EOF
	  fi

		echo "${yellow}Installed!${nc}"

	fi


	sysro

	backdrop
}

clean_up(){
	clear
	if [ $usagetype == 0 ]; then
		echo "${yellow}Cleaning up...${nc}"
		sleep 3
		sysrw

		#cleaner
		rm -f /cache/*.apk
		rm -f /cache/*.tmp
		rm -f /cache/recovery/*
		rm -f /data/*.log
		rm -f /data/*.txt
		rm -f /data/anr/*.*
		rm -f /data/backup/pending/*.tmp
		rm -f /data/cache/*.*
		rm -f /data/dalvik-cache/*.apk
		rm -f /data/dalvik-cache/*.tmp
		rm -f /data/log/*.*
		rm -f /data/local/*.apk
		rm -f /data/local/*.log
		rm -f /data/local/tmp/*.*
		rm -f /data/last_alog/*
		rm -f /data/last_kmsg/*
		rm -f /data/mlog/*
		rm -f /data/tombstones/*
		rm -f /data/system/dropbox/*
		rm -f /data/system/usagestats/*
		rm -f /sdcard/LOST.DIR/*
		rm -rf /sdcard/LOST.DIR

		#drop caches
		echo "3" > /proc/sys/vm/drop_caches

		sysro
		clear
		echo "${yellow}Clean up complete!${nc}"
		sleep 2
	fi

	if [ $usagetype == 1 ]; then
		if [ $initd == 1 ]; then
			sysrw
			mkdir -p /system/etc/init.d
			touch /system/etc/init.d/99clean_up
			chmod 755 /system/etc/init.d/99clean_up
			echo -ne "" > /system/etc/init.d/99clean_up
cat >> /system/etc/init.d/99clean_up <<EOF
#!/system/bin/sh
sleep 17

rm -f /cache/*.apk
rm -f /cache/*.tmp
rm -f /cache/recovery/*
rm -f /data/*.log
rm -f /data/*.txt
rm -f /data/anr/*.*
rm -f /data/backup/pending/*.tmp
rm -f /data/cache/*.*
rm -f /data/dalvik-cache/*.apk
rm -f /data/dalvik-cache/*.tmp
rm -f /data/log/*.*
rm -f /data/local/*.apk
rm -f /data/local/*.log
rm -f /data/local/tmp/*.*
rm -f /data/last_alog/*
rm -f /data/last_kmsg/*
rm -f /data/mlog/*
rm -f /data/tombstones/*
rm -f /data/system/dropbox/*
rm -f /data/system/usagestats/*
rm -rf /sdcard/LOST.DIR

EOF
		fi
		echo "${yellow}Installed!${nc}"
	fi

	sysro
	backdrop
}

sql_optimize(){
	clear
	sysrw

	echo "${yellow}Optimizing SQLite databases!"

	if [ -e /system/xbin/sqlite3 ]; then
		chown root.root  /system/xbin/sqlite3
		chmod 0755 /system/xbin/sqlite3
		SQLLOC=/system/xbin/sqlite3
		echo
	fi

	if [ -e /system/bin/sqlite3 ]; then
		chown root.root /system/bin/sqlite3
		chmod 0755 /system/bin/sqlite3
		SQLLOC=/system/bin/sqlite3
		echo
	fi

	if [ -e /system/sbin/sqlite3 ]; then #legacy support
		chown root.root /sbin/sqlite3
		chmod 0755 /sbin/sqlite3
		SQLLOC=/sbin/sqlite3
		echo
	fi
	for i in `find ./ -iname "*.db"`; do
		$SQLLOC $i 'VACUUM;'
		clear; echo "${yellow}Vacuumed: $i${nc}"
		sleep 1
		$SQLLOC $i 'REINDEX;'
		echo "${yellow}Reindexed : $i${nc}"
		sleep 1
	done

	sysro
	clear
	echo "SQLite database optimizations complete!"
	sleep 2
	backdrop
}

vm_tune(){
	clear
	echo "${yellow}Optimizing VM...${nc}"

	if [ $usagetype == 0 ]; then
		echo "80" > /proc/sys/vm/swappiness
		echo "10" > /proc/sys/vm/vfs_cache_pressure
		echo "3000" > /proc/sys/vm/dirty_expire_centisecs
		echo "500" > /proc/sys/vm/dirty_writeback_centisecs
		echo "90" > /proc/sys/vm/dirty_ratio
		echo "70" > /proc/sys/vm/dirty_backgroud_ratio
		echo "1" > /proc/sys/vm/overcommit_memory
		echo "150" > /proc/sys/vm/overcommit_ratio
		echo "4096" > /proc/sys/vm/min_free_kbytes
		echo "1" > /proc/sys/vm/oom_kill_allocating_task
	fi

	if [ $usagetype == 1 ]; then
		if [ $initd == 1 ]; then
			sysrw
			mkdir -p /system/etc/init.d
			touch /system/etc/init.d/75vm
			chmod 755 /system/etc/init.d/75vm
			echo -ne "" > /system/etc/init.d/75vm
cat >> /system/etc/init.d/75vm <<EOF
#!/system/bin/sh
sleep 15

echo "80" > /proc/sys/vm/swappiness
echo "10" > /proc/sys/vm/vfs_cache_pressure
echo "3000" > /proc/sys/vm/dirty_expire_centisecs
echo "500" > /proc/sys/vm/dirty_writeback_centisecs
echo "90" > /proc/sys/vm/dirty_ratio
echo "70" > /proc/sys/vm/dirty_backgroud_ratio
echo "1" > /proc/sys/vm/overcommit_memory
echo "150" > /proc/sys/vm/overcommit_ratio
echo "4096" > /proc/sys/vm/min_free_kbytes
echo "1" > /proc/sys/vm/oom_kill_allocating_task
EOF
		fi
	fi

	sysro
	clear
	echo "${yellow}VM Optimized!${nc}"
	sleep 2
	backdrop
}

lmk_tune_opt(){
	clear
	echo "${yellow}LMK Optimization!${nc}"
	sleep 2
	clear

	echo "${yellow}Minfree profiles available:${nc}"
	echo " B|Balanced"
	echo " M|Multitasking|"
	echo " G|Gaming"
	echo -n "> "
	read lmk_opt
	case $lmk_opt in
		b|B|m|M|g|G ) echo "Ok!"
					sleep 3
					lmk_profile=$lmk_opt
					lmk_apply;;
		* ) error_404 && lmk_tune_opt;;
	esac
}

lmk_apply(){
	clear
	if [ $lmk_profile == b ] || [ $lmk_profile = B ]; then
		minfree_array='1024,2048,4096,8192,12288,16384'
	fi

	if [ $lmk_profile == m ] || [ $lmk_profile = M ]; then
		minfree_array='1536,2048,4096,5120,5632,6144'
	fi

	if [ $lmk_profile == g ] || [ $lmk_profile = G ]; then
		minfree_array='10393,14105,18188,27468,31552,37120'
	fi

	if [ $usagetype == 0 ]; then
		echo "$minfree_array" > /sys/module/lowmemorykiller/parameters/minfree
	fi

	if [ $usagetype == 1 ]; then
		if [ $initd == 1 ]; then
			mkdir -p /system/etc/init.d
			touch /system/etc/init.d/95lmk
			chmod 755 /system/etc/init.d/95lmk
			echo -ne "" > /system/etc/init.d/95lmk
			sysrw
cat >> /system/etc/init.d/95lmk <<EOF
#!/system/bin/sh
sleep 30

echo "$minfree_array" > /sys/module/lowmemorykiller/parameters/minfree
EOF
		fi
	fi

	sysro
	sleep 3
	clear
	echo "${yellow}LMK Optimized!${nc}"
	sleep 2
	backdrop
}

network_tune(){
	clear
	if [ $usagetype == 0 ]; then
		clear
		echo "${yellow}Optimizing Networks...${nc}"

		#General
		echo 2097152 > /proc/sys/net/core/wmem_max
		echo 2097152 > /proc/sys/net/core/rmem_max
		echo 20480 > /proc/sys/net/core/optmem_max
		echo 1 > /proc/sys/net/ipv4/tcp_moderate_rcvbuf
		echo 6144 > /proc/sys/net/ipv4/udp_rmem_min
		echo 6144 > /proc/sys/net/ipv4/udp_wmem_min
		echo 6144 87380 2097152 > /proc/sys/net/ipv4/tcp_rmem
		echo 6144 87380 2097152 > /proc/sys/net/ipv4/tcp_wmem
		echo 0 > /proc/sys/net/ipv4/tcp_timestamps
		echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse
		echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle
		echo 1 > /proc/sys/net/ipv4/tcp_sack
		echo 1 > /proc/sys/net/ipv4/tcp_window_scaling
		echo 5 > /proc/sys/net/ipv4/tcp_keepalive_probes
		echo 156 > /proc/sys/net/ipv4/tcp_keepalive_intvl
		echo 30 > /proc/sys/net/ipv4/tcp_fin_timeout
		echo 0 > /proc/sys/net/ipv4/tcp_ecn
		echo 360000 > /proc/sys/net/ipv4/tcp_max_tw_buckets
		echo 2 > /proc/sys/net/ipv4/tcp_synack_retries
		echo 1 > /proc/sys/net/ipv4/route/flush
		echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
		echo 524288 > /proc/sys/net/core/wmem_max
		echo 524288 > /proc/sys/net/core/rmem_max
		echo 110592 > /proc/sys/net/core/rmem_default
		echo 110592 > /proc/sys/net/core/wmem_default

		#WIFI Specific
		# Turn on Source Address Verification in all interfaces.
		echo "1" > /proc/sys/net/ipv4/conf/all/rp_filter
		echo "1" > /proc/sys/net/ipv4/conf/default/rp_filter
		# Do not accept ICMP redirects.
		echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects
		echo "0" > /proc/sys/net/ipv4/conf/default/accept_redirects
		# Do not send ICMP redirects.
		echo "0" > /proc/sys/net/ipv4/conf/all/send_redirects
		echo "0" > /proc/sys/net/ipv4/conf/default/send_redirects
		# Ignore ICMP broadcasts will stop gateway from responding to broadcast pings.
		echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
		# Ignore bogus ICMP errors.
		echo "1" > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
		# Do not accept IP source route packets.
		echo "0" > /proc/sys/net/ipv4/conf/all/accept_source_route
		echo "0" > /proc/sys/net/ipv4/conf/default/accept_source_route
		# Turn on log Martian Packets with impossible addresses.
		echo "1" > /proc/sys/net/ipv4/conf/all/log_martians
		echo "1" > /proc/sys/net/ipv4/conf/default/log_martians

		echo "${yellow}Networks Optimized!${nc}"
		sleep 2
	fi

	if [ $usagetype == 1 ]; then
	  if [ $initd == 1 ]; then
	    sysrw
	    mkdir -p /system/etc/init.d
	    touch /system/etc/init.d/56net
	    chmod 755 /system/etc/init.d/56net
	    echo -ne "" > /system/etc/init.d/56net
cat >> /system/etc/init.d/56net <<EOF
#!/system/bin/sh
sleep 5

#General
echo 2097152 > /proc/sys/net/core/wmem_max
echo 2097152 > /proc/sys/net/core/rmem_max
echo 20480 > /proc/sys/net/core/optmem_max
echo 1 > /proc/sys/net/ipv4/tcp_moderate_rcvbuf
echo 6144 > /proc/sys/net/ipv4/udp_rmem_min
echo 6144 > /proc/sys/net/ipv4/udp_wmem_min
echo 6144 87380 2097152 > /proc/sys/net/ipv4/tcp_rmem
echo 6144 87380 2097152 > /proc/sys/net/ipv4/tcp_wmem
echo 0 > /proc/sys/net/ipv4/tcp_timestamps
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse
echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle
echo 1 > /proc/sys/net/ipv4/tcp_sack
echo 1 > /proc/sys/net/ipv4/tcp_window_scaling
echo 5 > /proc/sys/net/ipv4/tcp_keepalive_probes
echo 156 > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo 30 > /proc/sys/net/ipv4/tcp_fin_timeout
echo 0 > /proc/sys/net/ipv4/tcp_ecn
echo 360000 > /proc/sys/net/ipv4/tcp_max_tw_buckets
echo 2 > /proc/sys/net/ipv4/tcp_synack_retries
echo 1 > /proc/sys/net/ipv4/route/flush
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
echo 524288 > /proc/sys/net/core/wmem_max
echo 524288 > /proc/sys/net/core/rmem_max
echo 110592 > /proc/sys/net/core/rmem_default
echo 110592 > /proc/sys/net/core/wmem_default

#WIFI Specific
# Turn on Source Address Verification in all interfaces.
echo "1" > /proc/sys/net/ipv4/conf/all/rp_filter
echo "1" > /proc/sys/net/ipv4/conf/default/rp_filter
# Do not accept ICMP redirects.
echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects
echo "0" > /proc/sys/net/ipv4/conf/default/accept_redirects
# Do not send ICMP redirects.
echo "0" > /proc/sys/net/ipv4/conf/all/send_redirects
echo "0" > /proc/sys/net/ipv4/conf/default/send_redirects
# Ignore ICMP broadcasts will stop gateway from responding to broadcast pings.
echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
# Ignore bogus ICMP errors.
echo "1" > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
# Do not accept IP source route packets.
echo "0" > /proc/sys/net/ipv4/conf/all/accept_source_route
echo "0" > /proc/sys/net/ipv4/conf/default/accept_source_route
# Turn on log Martian Packets with impossible addresses.
echo "1" > /proc/sys/net/ipv4/conf/all/log_martians
echo "1" > /proc/sys/net/ipv4/conf/default/log_martians

EOF
	  fi
	  echo "${yellow}Installed!${nc}"
	fi

	sysro
	backdrop
}

kill_log(){
	clear
	echo "${yellow}Removing logger...${nc}"

	rm -f /dev/log/main

	echo "${yellow}Logger removed!${nc}"
	sleep 2
	backdrop
}

kernel_kontrol(){
	clear
	sleep 1
	echo "${yellow}Kernel Kontrol${nc}"
	echo " 1|Set CPU Freq"
	echo " 2|Set CPU Gov"
	echo " 3|Set I/O Sched"
	echo " 4|View KCal Values"
	echo
	echo " B|Back"
	echo -n "> "
	read kk_opt
	case $kk_opt in
		1) setcpufreq;;
		2) setgov;;
		3) setiosched;;
		4) kcal_ro;;
		b|B) backdrop;;
		* ) error_404 && kernel_kontrol;;
	 esac
}

setcpufreq(){
	clear
	#configure sub variables
	maxfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
	minfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
	curfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
	listfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies`

	echo "${yellow}CPU Control${nc}"
	echo ""
	echo "${bld}Max Freq:${nc} $maxfreq"
	echo "${bld}Min Freq:${nc} $minfreq"
	echo "${bld}Current Freq:${nc} $curfreq"
	echo ""
	echo "${bld}Available Freq's:${nc} "
	echo "$listfreq"
	echo ""
	sleep 2
	echo -n "New Max Freq: " && sleep 1; read newmaxfreq;
	echo -n "New Min Freq: " && sleep 1; read newminfreq;
	sleep 1

	sysrw
	echo "$newmaxfreq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	echo "$newminfreq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	sysro
	sleep 1

	clear
	echo "${yellow}New Freq's applied!${nc}"
	sleep 2

	kernel_kontrol
}

setgov(){
	clear
	#configure sub variables
	curgov=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
	listgov=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors`

	echo "${yellow}Gov Control${nc}"
	echo
	echo "${bld}Current Governor:${nc} $curgov"
	echo
	echo "${bld}Available Governors:${nc} "
	echo "$listgov"
	echo
	sleep 2
	echo -n "New Governor: " && sleep 1; read newgov;
	sleep 1

	sysrw
	echo "$newgov" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	sysro
	sleep 1

	clear
	echo "${yellow}New Governor applied!${nc}"
	sleep 2

	kernel_kontrol
}


setiosched(){
	clear
	#configure sub variables
	curiosched=`cat /sys/block/mmcblk0/queue/scheduler | sed 's/.*\[\([a-zA-Z0-9_]*\)\].*/\1/'`
	listiosched=`cat /sys/block/mmcblk0/queue/scheduler | tr -s "[[:blank:]]" "\n" | sed 's/\[\([a-zA-Z0-9_]*\)\]/\1/'`

	echo "${yellow}I/O Sched Control${nc}"
	echo
	echo "${bld}Current I/O Scheduler:${nc} $curiosched"
	echo
	echo "${bld}Available I/O Schedulers:${nc} "
	echo "$listiosched"
	echo
	sleep 2
	echo -n "New Scheduler: " && sleep 1; read newiosched;
	sleep 1

	sysrw
	for j in /sys/block/*/queue/scheduler; do
		echo "$newio" > \$j
	done
	sysro
	sleep 1

	clear
	echo "${yellow}New I/O Scheduler applied!${nc}"
	sleep 2

	kernel_kontrol
}

catalyst_control(){
	clear
	echo "${yellow}Game Booster${nc}"
	echo "[1] Boost"
	echo "[2] Options"
	echo "[B] Back"
	echo -n "> "
	read game_booster_opt
	case $game_booster_opt in
		1 ) catalyst_inject;;
		2 ) catalyst_time_cfg;;
		B ) backdrop;;
		* ) error_404 && catalyst_control;;
	esac
}

catalyst_inject(){
	clear
	#configure sub-variables
	waiter=60

	echo "Please leave the terminal emulator running"
	echo "This will continue to run untill you press X or Close"

	if [ "$user_debug" == 1 ]; then
		echo
		echo "log:"
  fi

	sleep 3

(
while [ 1 ]
do
	sleep $waiter
	sync
  	echo "3" > /proc/sys/vm/drop_caches
  	if [ "$user_debug" == 1 ]; then
  		echo -n "game booster exec time: " && date
  	fi
done
)

catalyst_control
}

catalyst_time_cfg(){
	clear
	echo "Current rate: $waiter"
	echo "60 - Every minute - Default"
	echo "3600 - Every hour"
	sleep 1
	echo
	echo "Please enter a rate:"
	echo -n "> "
	read catalyst_time_in
	waiter=$catalyst_time_in
	echo
	clear
	echo "Time updated!"
	sleep 2
	clear

	catalyst_control
}

zram_enable(){
	clear
	echo "${yellow}Enabling zRAM...${nc}"
	sleep 1

	swapon /dev/block/zram0

	clear
	echo "${yellow}zRAM enabled!${nc}"
	sleep 2
	options
}

zram_disable(){
	clear
	echo "${yellow}Disabling zRAM...${nc}"
	sleep 1

	swapoff /dev/block/zram0

	clear
	echo "${yellow}zRAM disabled!${nc}"
	sleep 2
	options
}

app_wise(){
	sleep 1
	clear
	echo "${yellow}Apps:${nc}"
	echo " 1|Xposed (4.4.x)"
	echo " 2|Greenify"
	echo " 3|Amplify"
	echo " 4|Nova Launcher"
	echo " 5|AdAway"
	echo " B|Back"
	echo
	echo -n "> "
	read options_opt
	case $options_opt in
		1 ) am start "http://dl-xda.xposed.info/modules/de.robv.android.xposed.installer_v33_36570c.apk" $null && app_wise;;
		2 ) am start "http://www.apkmirror.com/wp-content/themes/APKMirror/download.php?id=5851" $null && app_wise;;
		3 ) am start "http://dl-xda.xposed.info/modules/com.ryansteckler.nlpunbounce_v55_83c527.apk" $null && app_wise;;
		4 ) am start "http://teslacoilsw.com/tesladirect/download.pl?packageName=com.teslacoilsw.launcher" $null && app_wise;;
		5 ) am start "http://ca1.androidfilehost.com/dl/rnjIPh_-0Tqn7c28ZOFNGA/1428141697/95916177934538388/AdAway-release_Build-Mar.07.2015.apk" $null && app_wise;;
		b|B ) backdrop;;
		* ) error_404 && app_wise;;
	esac
}

kcal_ro(){
	sleep 1
	clear
	echo "${yellow}Current KCal Values:${nc}"
	rgb=`cat /sys/devices/platform/kcal_ctrl.0/kcal`
	sat=`cat /sys/devices/platform/kcal_ctrl.0/kcal_sat`
	cont=`cat /sys/devices/platform/kcal_ctrl.0/kcal_cont`
	hue=`cat /sys/devices/platform/kcal_ctrl.0/kcal_hue`
	gamma=`cat /sys/devices/platform/kcal_ctrl.0/kcal_val`
	echo "rgb: $rgb, sat: $sat, cont: $cont, hue: $hue, gamma: $gamma"
	sleep 5

	kernel_kontrol
}

options(){
	sleep 1
	clear
	echo "${yellow}Options:${nc}"
	echo " 1|Debug mode toggle"
	echo " 2|Install type toggle"
	echo " 3|Disable zRAM"
	echo " B|Back"
	echo
	echo -n "> "
	read options_opt
	case $options_opt in
		1 ) debug_mode_toggle;;
		2 ) usage_mode_toggle;;
		3 ) zram_disable;;
		b|B ) backdrop;;
		* ) error_404 && options;;
	esac
}

sysrw(){
	#type=rw
	mount -o remount rw rootfs /
	mount -o remount rw /system
	mount -o remount rw /data
	mount -o remount rw /cache
}

sysro(){
	#type=ro
	mount -o remount ro rootfs /
	mount -o remount ro /system
	mount -o remount ro /data
	mount -o remount ro /cache
}

debug_mode_toggle(){
	clear
	#configure sub-variables
	if [ $userdebug == 1 ]; then
		userdebug_status=enabled
	fi

	if [ $userdebug == 0 ]; then
		userdebug_status=disabled
	fi

	sleep 1
	echo "${yellow}Debug Mode:${nc}"
	echo "E|Enable"
	echo "D|Disable"
	echo
	echo "${yellow}Currently:${nc} $userdebug_status"
	echo -n "> "
	read debug_mode_toggle_opt
	case $debug_mode_toggle_opt in
		e|E ) echo "Ok!" && sleep 2 && clear && userdebug=1 && options;;
		d|D ) echo "Ok!" && sleep 2 && clear && userdebug=0 && options;;
		* ) error_404 && debug_mode_toggle;;
	esac
}

usage_mode_toggle(){
	clear
	#configure sub-variables
	if [ $userdebug == 0 ]; then
		usagetype_status=temporary
	fi

	if [ $userdebug == 1 ]; then
		usagetype_status=permanent
	fi

	sleep 1
	echo "${yellow}Install Mode:${nc}"
	echo "T|Temporary installs"
	echo "P|Permanent installs"
	echo
	echo "${yellow}Currently:${nc} $usagetype_status"
	echo -n "> "
	read usage_mode_toggle_opt
	case $usage_mode_toggle_opt in
		t|T ) echo "Ok!" && sleep 2 && clear && usagetype=0 && options;;
		p|P ) echo "Ok!" && sleep 2 && clear && usagetype=1 && options;;
		* ) error_404 && usage_mode_toggle;;
	esac
}

creboot(){
	clear
	echo "Rebooting in 3..."
	sysro
	sleep 3
	reboot
}

safe_exit(){
	sleep 1
	clear
	sysro
	echo "${cyan}[-=The Hybrid Project=-]${nc}"
	echo "${cyan}     by DiamondBond...${nc}"
exit
}

rom(){
	rom=`getprop ro.build.type`
}

about_info(){
	clear
	echo "${green}About:${nc}"
	echo
	echo "Hybrid Version: $ver_revision"
	echo
	echo "${yellow}INFO${nc}"
	echo "This script deals with many things apps normally do."
	echo "But this script is ${cyan}AWESOME!${nc} because its < ${bld}1MB!${nc}"
	echo
	echo "${yellow}CREDITS${nc}"
	echo "DiamondBond : Script creator & maintainer"
	echo "Hoholee12/Wedgess/Imbawind/Luca020400 : Code ${yellow}:)${nc}"
	echo

	sleep 5
	backdrop
}

debug_info(){
	clear
	echo -e "${green}Debug information:${nc}"
	echo
	echo "${yellow}SYSTEM${nc}"
	echo "Vendor: $( getprop ro.product.brand )"
	echo "Model: $( getprop ro.product.model )"
	echo "ROM: $( getprop ro.build.display.id )"
	echo "Android Version: $( getprop ro.build.version.release )"
	echo
	echo "${yellow}SCRIPT${nc}"
	echo "Hybrid Version: $ver_revision"
	echo
	sleep 5
	clear
	backdrop
}

shfix_session_behaviour(){
	#call startup functions
	clear
	cli_displaytype
	var
	rom
	
	#run conditional statements
	#userdebug mode
	if [ $userdebug == 1 ]; then
		debug_info
	fi
	
	#default sh
	shfix="/data/sh_fix.temp"
	if [ "`grep 1 $shfix`" ]; then
		echo "0" > $shfix
		sysro
		#call main functions
		title
		body
	fi
	
	sysrw
	touch $shfix
	chmod 777 $shfix
	echo "0" > $shfix
	
	if [ "`grep 0 $shfix`" ]; then
		echo "1" > $shfix
		$SHELL -c hybrid
	fi
}

session_behaviour(){
	#call startup functions
	sh_ota
	cli_displaytype
	var
	rom

	#run conditional statements
	if [ $userdebug == 1 ]; then
		debug_info
	fi

	#call main functions
	title
	body
}

#call
if [ $shfixrun == 1 ]; then
	shfix_session_behaviour
else
	sub_session_behaviour
