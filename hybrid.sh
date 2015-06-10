#hybrid.sh by DiamondBond & Deic

var(){
	#version_control
	ver_revision=1.8

	#options
	userdebug=0
	usagetype=0
	initd=1
	motod=0
	shfix=0

	#misc control
	DATE=`date +%d-%m-%Y`
	rom=`getprop ro.build.type`
	
	#config
	shfixcfg="/data/hybrid/shfix.cfg"
	usagetypecfg="/data/hybrid/usagetype.cfg"
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
	nc='\033[0m' #no color
}

sh_ota(){
	#SH-OTA Template By Deic & DiamondBond

	#To be heavily refactored...

	#Functions
	a1(){
		na="SH-OTA.sh" #Name of your SH-OTA file
		do="https://www.Your-Site/SH-OTA.sh" #Link of your SH-OTA file
		ch="$EXTERNAL_STORAGE/Download/$name"
		br="com.android.browser"
		am=`am start -a android.intent.action`
	}

	#Download SH-OTA file
	a2(){
		$am.VIEW -n $br/.BrowserActivity $do >/dev/null 2>&1
		$am.MAIN -n jackpal.androidterm/.Term >/dev/null 2>&1
		a3
	}

	#Wait download
	a3(){
		a4
	}

	#Run SH-OTA file
	a4(){
		if [ -e $ch ]; then
			am force-stop $br
			$SHELL -c $ch
		else
			a3
		fi
	}

	#Script start
	clear
	a1
	a2
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
	echo " F|Forum"
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
		f|F ) am start "http://forum.xda-developers.com/moto-g-2014/development/mod-disable-zram-t3071658" >/dev/null 2>&1 && backdrop;;
		s|S ) am start "https://github.com/HybridMod/Current/" >/dev/null 2>&1 && backdrop;;
		r|R ) creboot;;
		e|E ) safe_exit;;
		* ) error_404 && backdrop;;
	esac
}

backdrop(){
	clear
	body
}

error_404(){
	echo
	echo "error 404, function not found."
	sleep 1
}

creboot(){
	clear
	sysro
	echo "Rebooting in 3"
	sleep 1
	clear
	echo "Rebooting in 2."
	sleep 1
	clear
	echo "Rebooting in 1.."
	sleep 1
	clear
	echo "Rebooting..."
	sleep 1
	reboot
}

safe_exit(){
	clear
	sysro
	echo "${cyan}[-=The Hybrid Project=-]${nc}"
	echo "${cyan}     by DiamondBond...${nc}"
exit
}

sysrw(){
	#type=rw
	mount -o remount rw / >/dev/null 2>&1
	mount -o remount rw /system >/dev/null 2>&1
	mount -o remount rw /data >/dev/null 2>&1
	mount -o remount rw /cache >/dev/null 2>&1
}

sysro(){
	#type=ro
	mount -o remount ro / >/dev/null 2>&1
	mount -o remount ro /system >/dev/null 2>&1
	mount -o remount ro /data >/dev/null 2>&1
	mount -o remount ro /cache >/dev/null 2>&1
}

drop_caches(){
	clear
	if [ $usagetype == 0 ]; then
		echo "${yellow}Dropping caches...${nc}"
		sleep 1
		sync
		echo "3" > /proc/sys/vm/drop_caches
		clear
		echo "${yellow}Caches dropped!${nc}"
		sleep 1
	fi

	if [ $usagetype == 1 ]; then
		if [ $initd == 1 ]; then
			mkdir -p /system/etc/init.d/
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
		sleep 1
	fi

	backdrop
}

clean_up(){
	clear
	if [ $usagetype == 0 ]; then
		echo "${yellow}Cleaning up...${nc}"
		sleep 1

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
		rm -rf $EXTERNAL_STORAGE/LOST.DIR/

		#drop caches
		echo "3" > /proc/sys/vm/drop_caches

		clear
		echo "${yellow}Clean up complete!${nc}"
		sleep 1
	fi

	if [ $usagetype == 1 ]; then
		if [ $initd == 1 ]; then
			mkdir -p /system/etc/init.d/
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
rm -rf $EXTERNAL_STORAGE/LOST.DIR/

EOF
		fi
		echo "${yellow}Installed!${nc}"
		sleep 1
	fi

	backdrop
}

sql_optimize(){
	clear
	echo "${yellow}Optimizing SQLite databases!"
	sleep 1

	if [ -e /system/xbin/sqlite3 ]; then
		chown root.root  /system/xbin/sqlite3
		chmod 755 /system/xbin/sqlite3
		SQLLOC=/system/xbin/sqlite3
		echo
	fi

	if [ -e /system/bin/sqlite3 ]; then
		chown root.root /system/bin/sqlite3
		chmod 755 /system/bin/sqlite3
		SQLLOC=/system/bin/sqlite3
		echo
	fi

	if [ -e /system/sbin/sqlite3 ]; then #legacy support
		chown root.root /sbin/sqlite3
		chmod 755 /sbin/sqlite3
		SQLLOC=/sbin/sqlite3
		echo
	fi
	for i in `find ./ -iname "*.db"`; do
		$SQLLOC $i 'VACUUM;'
		clear; echo "${yellow}Vacuumed: $i${nc}"
		$SQLLOC $i 'REINDEX;'
		echo "${yellow}Reindexed : $i${nc}"
	done

	clear
	echo "SQLite database optimizations complete!"
	sleep 1
	
	backdrop
}

vm_tune(){
	clear
	if [ $usagetype == 0 ]; then
		echo "${yellow}Optimizing VM...${nc}"
		sleep 1
		
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
		
		clear
		echo "${yellow}VM Optimized!${nc}"
		sleep 1
	fi

	if [ $usagetype == 1 ]; then
		if [ $initd == 1 ]; then
			mkdir -p /system/etc/init.d/
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
		echo "${yellow}Installed!${nc}"
		sleep 1
	fi
	
	backdrop
}

lmk_tune_opt(){
	clear
	echo "${yellow}LMK Optimization!${nc}"
	echo
	echo "${yellow}Minfree profiles available:${nc}"
	echo " B|Balanced"
	echo " M|Multitasking|"
	echo " G|Gaming"
	echo -n "> "
	read lmk_opt
	case $lmk_opt in
		b|B|m|M|g|G ) echo "Ok!" && sleep 1 && lmk_profile=$lmk_opt && lmk_apply;;
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
		echo "${yellow}Optimizing LMK...${nc}"
		sleep 1
		
		echo "$minfree_array" > /sys/module/lowmemorykiller/parameters/minfree
		
		clear
		echo "${yellow}LMK Optimized!${nc}"
		sleep 1
	fi

	if [ $usagetype == 1 ]; then
		if [ $initd == 1 ]; then
			mkdir -p /system/etc/init.d/
			touch /system/etc/init.d/95lmk
			chmod 755 /system/etc/init.d/95lmk
			echo -ne "" > /system/etc/init.d/95lmk
cat >> /system/etc/init.d/95lmk <<EOF
#!/system/bin/sh
sleep 30

echo "$minfree_array" > /sys/module/lowmemorykiller/parameters/minfree
EOF
		fi
		echo "${yellow}Installed!${nc}"
		sleep 1
	fi
	
	backdrop
}

network_tune(){
	clear
	if [ $usagetype == 0 ]; then
		clear
		echo "${yellow}Optimizing Networks...${nc}"
		sleep 1

		#General
		echo "2097152" > /proc/sys/net/core/wmem_max
		echo "2097152" > /proc/sys/net/core/rmem_max
		echo "20480" > /proc/sys/net/core/optmem_max
		echo "1" > /proc/sys/net/ipv4/tcp_moderate_rcvbuf
		echo "6144" > /proc/sys/net/ipv4/udp_rmem_min
		echo "6144" > /proc/sys/net/ipv4/udp_wmem_min
		echo "6144 87380 2097152" > /proc/sys/net/ipv4/tcp_rmem
		echo "6144 87380 2097152" > /proc/sys/net/ipv4/tcp_wmem
		echo "0" > /proc/sys/net/ipv4/tcp_timestamps
		echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse
		echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle
		echo "1" > /proc/sys/net/ipv4/tcp_sack
		echo "1" > /proc/sys/net/ipv4/tcp_window_scaling
		echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes
		echo "156" > /proc/sys/net/ipv4/tcp_keepalive_intvl
		echo "30" > /proc/sys/net/ipv4/tcp_fin_timeout
		echo "0" > /proc/sys/net/ipv4/tcp_ecn
		echo "360000" > /proc/sys/net/ipv4/tcp_max_tw_buckets
		echo "2" > /proc/sys/net/ipv4/tcp_synack_retries
		echo "1" > /proc/sys/net/ipv4/route/flush
		echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_all
		echo "524288" > /proc/sys/net/core/wmem_max
		echo "524288" > /proc/sys/net/core/rmem_max
		echo "110592" > /proc/sys/net/core/rmem_default
		echo "110592" > /proc/sys/net/core/wmem_default

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

		clear
		echo "${yellow}Networks Optimized!${nc}"
		sleep 1
	fi

	if [ $usagetype == 1 ]; then
		if [ $initd == 1 ]; then
			mkdir -p /system/etc/init.d/
			touch /system/etc/init.d/56net
			chmod 755 /system/etc/init.d/56net
			echo -ne "" > /system/etc/init.d/56net
cat >> /system/etc/init.d/56net <<EOF
#!/system/bin/sh
sleep 5

#General
echo "2097152" > /proc/sys/net/core/wmem_max
echo "2097152" > /proc/sys/net/core/rmem_max
echo "20480" > /proc/sys/net/core/optmem_max
echo "1" > /proc/sys/net/ipv4/tcp_moderate_rcvbuf
echo "6144" > /proc/sys/net/ipv4/udp_rmem_min
echo "6144" > /proc/sys/net/ipv4/udp_wmem_min
echo "6144 87380 2097152" > /proc/sys/net/ipv4/tcp_rmem
echo "6144 87380 2097152" > /proc/sys/net/ipv4/tcp_wmem
echo "0" > /proc/sys/net/ipv4/tcp_timestamps
echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse
echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle
echo "1" > /proc/sys/net/ipv4/tcp_sack
echo "1" > /proc/sys/net/ipv4/tcp_window_scaling
echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes
echo "156" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "30" > /proc/sys/net/ipv4/tcp_fin_timeout
echo "0" > /proc/sys/net/ipv4/tcp_ecn
echo "360000" > /proc/sys/net/ipv4/tcp_max_tw_buckets
echo "2" > /proc/sys/net/ipv4/tcp_synack_retries
echo "1" > /proc/sys/net/ipv4/route/flush
echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_all
echo "524288" > /proc/sys/net/core/wmem_max
echo "524288" > /proc/sys/net/core/rmem_max
echo "110592" > /proc/sys/net/core/rmem_default
echo "110592" > /proc/sys/net/core/wmem_default

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
		sleep 1
	fi

	backdrop
}

kill_log(){
	clear
	echo "${yellow}Removing logger...${nc}"
	sleep 1

	rm -f /dev/log/main
	
	clear
	echo "${yellow}Logger removed!${nc}"
	sleep 1
	
	backdrop
}

kernel_kontrol(){
	clear
	echo "${yellow}Kernel Kontrol${nc}"
	echo
	echo " 1|Set CPU Freq"
	echo " 2|Set CPU Gov"
	echo " 3|Set I/O Sched"
	echo " 4|View KCal Values"
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
	echo
	echo "${bld}Max Freq:${nc} $maxfreq"
	echo "${bld}Min Freq:${nc} $minfreq"
	echo "${bld}Current Freq:${nc} $curfreq"
	echo
	echo "${bld}Available Freq's:${nc} "
	echo "$listfreq"
	echo
	echo -n "New Max Freq: " && read newmaxfreq
	echo -n "New Min Freq: " && read newminfreq

	echo "$newmaxfreq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	echo "$newminfreq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

	clear
	echo "${yellow}New Freq's applied!${nc}"
	sleep 1

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
	echo -n "New Governor: " && read newgov

	echo "$newgov" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

	clear
	echo "${yellow}New Governor applied!${nc}"
	sleep 1

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
	echo -n "New Scheduler: " && read newiosched

	for j in /sys/block/*/queue/scheduler; do
		echo "$newio" > $j
	done

	clear
	echo "${yellow}New I/O Scheduler applied!${nc}"
	sleep 1

	kernel_kontrol
}

kcal_ro(){
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

app_wise(){
	clear
	echo "${yellow}Apps:${nc}"
	echo
	echo " 1|Xposed"
	echo " 2|Greenify"
	echo " 3|Amplify"
	echo " 4|Nova Launcher"
	echo " 5|Adblock Plus"
	echo " 6|Opera Max"
	echo " B|Back"
	echo
	echo -n "> "
	read options_opt
	case $options_opt in
		1 ) am start "http://dl-xda.xposed.info/modules/de.robv.android.xposed.installer_v32_de4f0d.apk" >/dev/null 2>&1 && pm install $EXTERNAL_STORAGE/Download/de.robv.android.xposed.installer_v32_de4f0d.apk && app_wise;;
		2 ) am start "" >/dev/null 2>&1 && app_wise;;
		3 ) am start "http://forum.xda-developers.com/attachment.php?attachmentid=3291991&d=1430513980" >/dev/null 2>&1 && pm install $EXTERNAL_STORAGE/Download/Amplify-v3.0.9.apk && app_wise;;
		4 ) am start "http://teslacoilsw.com/tesladirect/download.pl?packageName=com.teslacoilsw.launcher" >/dev/null 2>&1 && pm install $EXTERNAL_STORAGE/Download/Nova Launcher_4.0.1.apk && app_wise;;
		5 ) am start "https://update.adblockplus.org/latest/adblockplusandroid.apk" >/dev/null 2>&1 && pm install $EXTERNAL_STORAGE/Download/adblockplusandroid.apk && app_wise;;
		6 ) am start "" >/dev/null 2>&1 && app_wise;;
		b|B ) backdrop;;
		* ) error_404 && app_wise;;
	esac
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
		b|B ) backdrop;;
		* ) error_404 && catalyst_control;;
	esac
}

catalyst_inject(){
	clear
	#configure sub-variables
	waiter=60
	
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

	echo "Please leave the terminal emulator running"
	echo "This will continue to run untill you press a key or close the terminal"
	echo
	stty cbreak -echo
	f=$(dd bs=1 count=1 >/dev/null 2>&1)
	stty -cbreak echo
	echo $f
	case $f in
		* ) catalyst_control;;
	esac
}

catalyst_time_cfg(){
	clear
	echo "Current rate: $waiter"
	echo "60 - Every minute - Default"
	echo "3600 - Every hour"
	echo
	echo "Please enter a rate:"
	echo -n "> "
	read catalyst_time_in
	waiter=$catalyst_time_in
	clear
	echo "Time updated!"
	sleep 1
	clear

	catalyst_control
}

options(){
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

debug_mode_toggle(){
	clear
	#configure sub-variables
	if [ $userdebug == 1 ]; then
		userdebug_status=enabled
	fi

	if [ $userdebug == 0 ]; then
		userdebug_status=disabled
	fi

	echo "${yellow}Debug Mode:${nc}"
	echo "E|Enable"
	echo "D|Disable"
	echo
	echo "${yellow}Currently:${nc} $userdebug_status"
	echo -n "> "
	read debug_mode_toggle_opt
	case $debug_mode_toggle_opt in
		e|E ) userdebug=1 && echo "Ok!" && sleep 1 && options;;
		d|D ) userdebug=0 && echo "Ok!" && sleep 1 && options;;
		* ) error_404 && debug_mode_toggle;;
	esac
}

usage_mode_toggle(){
	clear
	#configure sub-variables
	if [ $usagetype == 0 ]; then
		usagetype_status=temporary
	fi

	if [ $usagetype == 1 ]; then
		usagetype_status=permanent
	fi

	echo "${yellow}Install Mode:${nc}"
	echo "T|Temporary installs"
	echo "P|Permanent installs"
	echo
	echo "${yellow}Currently:${nc} $usagetype_status"
	echo -n "> "
	read usage_mode_toggle_opt
	case $usage_mode_toggle_opt in
		t|T ) usage_type && echo "0" > $usagetypecfg && var && echo "Ok!" && sleep 1 && options;;
		p|P ) usage_type && echo "1" > $usagetypecfg && var && echo "Ok!" && sleep 1 && options;;
		* ) error_404 && usage_mode_toggle;;
	esac
}

zram_enable(){
	clear
	echo "${yellow}Enabling zRAM...${nc}"
	sleep 1

	swapon /dev/block/zram0

	clear
	echo "${yellow}zRAM enabled!${nc}"
	sleep 1
	
	options
}

zram_disable(){
	clear
	echo "${yellow}Disabling zRAM...${nc}"
	sleep 1

	swapoff /dev/block/zram0

	clear
	echo "${yellow}zRAM disabled!${nc}"
	sleep 1
	
	options
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

	backdrop
}

usagetype_first_start(){
	clear
	echo "${yellow}How to Install tweaks?${nc}"
	echo
	echo " T|Temporary installs"
	echo " P|Permanent installs"
	echo
	echo " You can change it in Options"
	echo
	echo -ne "> "
	read usagetype_first_start_opt
	case $usagetype_first_start_opt in
		t|T ) usagetype_cfg && echo "0" > $usagetypecfg && var && echo "Ok!" && sleep 1 && body;;
		p|P ) usagetype_cfg && echo "1" > $usagetypecfg && var && echo "Ok!" && sleep 1 && body;;
		* ) error_404 && usagetype_first_start;;
	esac
}

usagetype_cfg(){
	mkdir -p /data/hybrid/
	touch $usagetypecfg
	chmod 755 $usagetypecfg
}

session_behaviour(){
	#call startup functions
	clear
	#sh_ota
	sysrw
	cli_displaytype
	var

	#check shfix.cfg
	if [ grep 0 $shfixcfg ]; then
		shfix=0
	fi
	
	if [ grep 1 $shfixcfg ]; then
		shfix=1
	fi

	#check usagetype.cfg
	if [ grep 0 $usagetypecfg ]; then
		usagetype=0
	fi
	
	if [ grep 1 $usagetypecfg ]; then
		usagetype=1
	fi

	#run conditional statements
	#userdebug mode
	if [ $userdebug == 1 ]; then
		debug_info
	fi
}

main_functions(){
	#call main functions
	if [ -e $usagetypecfg ]; then
		body
	else
		usagetype_first_start	
	fi	
}

main_session_behaviour(){
	session_behaviour
	main_functions
}

shfix_session_behaviour(){
	session_behaviour
	
	#run with default Android Shell
	shfixtmp="/data/local/tmp/shfix.tmp"
	if [ grep 1 $shfixtmp ]; then
		echo "0" > $shfixtmp
		main_functions
	fi
	
	touch $shfixtmp
	chmod 755 $shfixtmp
	echo "0" > $shfixtmp
	
	if [ grep 0 $shfixtmp ]; then
		echo "1" > $shfixtmp
		sysro
		$SHELL -c hybrid
	fi
}

#call
if [ $shfix == 1 ]; then
	shfix_session_behaviour
else
	main_session_behaviour
fi
