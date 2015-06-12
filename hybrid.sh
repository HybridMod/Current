#!/system/bin/sh

#
# hybrid.sh by DiamondBond & Deic
#

ver_revision="2.0"

#options
initd=`if [ -d /system/etc/init.d ]; then echo "1"; else echo "0" ; fi`
perm=`getprop hybrid.perm`
catalyst_time=`getprop hybrid.catalyst_time`

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
	echo " 7|Kernel Kontrol"
	echo " 8|zRAM Settings"
	echo " 9|Game Booster"
	echo
	echo " O|Options"
	echo " A|About"
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
		7 ) kernel_kontrol;;
		8 ) zram_settings;;
		9 ) catalyst_control;;
		o|O ) options;;
		a|A ) about_info;;
		r|R ) creboot;;
		e|E ) exit 0;;
		* ) echo "Unknown Option" && sleep 2;;
	esac
}

creboot(){
	clear
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
	sync && reboot
}

init_sleep () {
	if [ ! -f system/etc/init.d/50sleep ]; then
		touch /system/etc/init.d/50sleep
		chmod 755 /system/etc/init.d/50sleep
		echo -ne "" > /system/etc/init.d/50sleep
cat >> /system/etc/init.d/50slepp <<EOF
#!/system/bin/sh
sleep 10
EOF
	fi
}

drop_caches(){
	clear
	echo "${yellow}Dropping caches...${nc}"
	sleep 1
	sync
	echo "3" > /proc/sys/vm/drop_caches
	clear
	echo "${yellow}Caches dropped!${nc}"
	sleep 1
	if [ $perm == 1 ] && [ $initd == 1 ]; then
		init_sleep
		touch /system/etc/init.d/97cache_drop
		chmod 755 /system/etc/init.d/97cache_drop
		echo -ne "" > /system/etc/init.d/97cache_drop
cat >> /system/etc/init.d/97cache_drop <<EOF
#!/system/bin/sh

sync
echo "3" > /proc/sys/vm/drop_caches
			
EOF
	echo "${yellow}Installed!${nc}"
	sleep 1
	fi
}

clean_up(){
	clear
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
	if [ $perm == 1 ] && [ $initd == 1 ]; then
		init_sleep
		touch /system/etc/init.d/99clean_up
		chmod 755 /system/etc/init.d/99clean_up
		echo -ne "" > /system/etc/init.d/99clean_up
cat >> /system/etc/init.d/99clean_up <<EOF
#!/system/bin/sh

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
	echo "${yellow}Installed!${nc}"
	sleep 1
	fi
}

sql_optimize(){
	clear
	echo "${yellow}Optimizing SQLite databases...${nc}"
	echo
	sleep 1

	if [ -e /system/xbin/sqlite3 ]; then
		chown root.root  /system/xbin/sqlite3
		chmod 755 /system/xbin/sqlite3
		SQLLOC=/system/xbin/sqlite3
	fi

	if [ -e /system/bin/sqlite3 ]; then
		chown root.root /system/bin/sqlite3
		chmod 755 /system/bin/sqlite3
		SQLLOC=/system/bin/sqlite3
	fi

	if [ -e /system/sbin/sqlite3 ]; then #legacy support
		chown root.root /sbin/sqlite3
		chmod 755 /sbin/sqlite3
		SQLLOC=/sbin/sqlite3
	fi
	for i in `find ./ -iname "*.db"`; do
		$SQLLOC $i 'VACUUM;'
		clear; echo "${yellow}Vacuumed:${nc} $i"
		$SQLLOC $i 'REINDEX;'
		echo "${yellow}Reindexed :${nc} $i"
	done

	clear
	echo
	echo "${yellow}SQLite database optimizations complete!${nc}"
	sleep 1
}

vm_tune(){
	clear
	echo "${yellow}Optimizing VM...${nc}"
	sleep 1
		
	echo "80" > /proc/sys/vm/swappiness
	echo "10" > /proc/sys/vm/vfs_cache_pressure
	echo "3000" > /proc/sys/vm/dirty_expire_centisecs
	echo "500" > /proc/sys/vm/dirty_writeback_centisecs
	echo "90" > /proc/sys/vm/dirty_ratio
	echo "70" > /proc/sys/vm/dirty_background_ratio
	echo "1" > /proc/sys/vm/overcommit_memory
	echo "150" > /proc/sys/vm/overcommit_ratio
	echo "4096" > /proc/sys/vm/min_free_kbytes
	echo "1" > /proc/sys/vm/oom_kill_allocating_task
		
	clear
	echo "${yellow}VM Optimized!${nc}"
	sleep 1
	if [ $perm == 1 ] && [ $initd == 1 ]; then
		init_sleep
		touch /system/etc/init.d/75vm
		chmod 755 /system/etc/init.d/75vm
		echo -ne "" > /system/etc/init.d/75vm
cat >> /system/etc/init.d/75vm <<EOF
#!/system/bin/sh

echo "80" > /proc/sys/vm/swappiness
echo "10" > /proc/sys/vm/vfs_cache_pressure
echo "3000" > /proc/sys/vm/dirty_expire_centisecs
echo "500" > /proc/sys/vm/dirty_writeback_centisecs
echo "90" > /proc/sys/vm/dirty_ratio
echo "70" > /proc/sys/vm/dirty_background_ratio
echo "1" > /proc/sys/vm/overcommit_memory
echo "150" > /proc/sys/vm/overcommit_ratio
echo "4096" > /proc/sys/vm/min_free_kbytes
echo "1" > /proc/sys/vm/oom_kill_allocating_task
EOF
		echo "${yellow}Installed!${nc}"
		sleep 1
	fi
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

	echo "${yellow}Optimizing LMK...${nc}"
	sleep 1
		
	echo "$minfree_array" > /sys/module/lowmemorykiller/parameters/minfree
		
	clear
	echo "${yellow}LMK Optimized!${nc}"
	sleep 1

	if [ $perm == 1 ] && [ $initd == 1 ]; then
		init_sleep
		touch /system/etc/init.d/95lmk
		chmod 755 /system/etc/init.d/95lmk
		echo -ne "" > /system/etc/init.d/95lmk
cat >> /system/etc/init.d/95lmk <<EOF
#!/system/bin/sh

echo "$minfree_array" > /sys/module/lowmemorykiller/parameters/minfree
EOF
		echo "${yellow}Installed!${nc}"
		sleep 1
	fi
}

network_tune(){
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

	if [ $perm == 1 ] && [ $initd == 1 ]; then
		init_sleep
		touch /system/etc/init.d/56net
		chmod 755 /system/etc/init.d/56net
		echo -ne "" > /system/etc/init.d/56net
cat >> /system/etc/init.d/56net <<EOF
#!/system/bin/sh

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
		echo "${yellow}Installed!${nc}"
		sleep 1
	fi
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
		4) kcal;;
		b|B) backdrop;;
		* ) echo "Unknown Option" && sleep 2 && kernel_kontrol;;
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
		echo "$newiosched" > $j
	done

	clear
	echo "${yellow}New I/O Scheduler applied!${nc}"
	sleep 1

	kernel_kontrol
}

kcal(){
	clear
	if [ -d /sys/devices/platform/kcal_ctrl.0 ]; then
		echo "${yellow}Current KCal Values:${nc}"
		rgb=`cat /sys/devices/platform/kcal_ctrl.0/kcal`
		sat=`cat /sys/devices/platform/kcal_ctrl.0/kcal_sat`
		cont=`cat /sys/devices/platform/kcal_ctrl.0/kcal_cont`
		hue=`cat /sys/devices/platform/kcal_ctrl.0/kcal_hue`
		gamma=`cat /sys/devices/platform/kcal_ctrl.0/kcal_val`
		echo "rgb: $rgb, sat: $sat, cont: $cont, hue: $hue, gamma: $gamma"
	else
		echo "KCal driver is missing"
	fi
	sleep 5

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
		b|B ) clear && body;;
		* ) echo "Unknown Option" && catalyst_control;;
	esac
}

catalyst_inject(){
	clear
	echo "Please leave the terminal emulator running"
	echo "This will continue to run untill close the terminal"
	echo

	while true; do
		sync
  		echo "3" > /proc/sys/vm/drop_caches
		sleep $catalyst_time
	done
}

catalyst_time_cfg(){
	clear
	echo "Current rate: $catalystsec"
	echo "60 - Every minute - Default"
	echo "3600 - Every hour"
	echo
	echo "Please enter a rate in seconds:"
	echo -n "> "
	read catalyst_time_val
	setprop hybrid.catalyst_time $catalyst_time_val;
	clear
	echo "Time updated!"
	sleep 1
	clear

	catalyst_control
}

zram_settings(){
	clear
	echo "${yellow}zRAM Options:${nc}"
	echo " 1|Disable zRAM"
	echo " 2|Enable zRAM"
	echo " B|Back"
	echo
	echo -n "> "
	read options_opt
	case $options_opt in
		1 ) zram_disable;;
		2 ) zram_enable;;
		b|B ) clear && body;;
		* ) echo "Unknown Option" && zram_settings;;
	esac
}

zram_enable(){
	clear
	echo "${yellow}Enabling zRAM...${nc}"
	sleep 1

	for l in `ls /dev/block/zram*`; do
		swapon $l
	done

	clear
	echo "${yellow}zRAM enabled!${nc}"
	sleep 1
	
	zram_settings
}

zram_disable(){
	clear
	echo "${yellow}Disabling zRAM...${nc}"
	sleep 1

	for l in `ls /dev/block/zram*`; do
		swapoff $l
	done

	clear
	echo "${yellow}zRAM disabled!${nc}"
	sleep 1
	
	zram_settings
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

options(){
	clear
	echo "${yellow}How to install tweaks?${nc}"
	echo
	echo " T|Temporary installs"
	echo " P|Permanent installs"
	echo
	echo " You can change it in Options later"
	echo
	echo -ne "> "
	read usagetype_first_start_opt
	case $usagetype_first_start_opt in
		t|T ) setprop hybrid.perm 0 && echo "Ok!" && sleep 1 && backdrop;;
		p|P ) setprop hybrid.perm 1 && echo "Ok!" && sleep 1 && backdrop;;
		* ) echo "Unknown Option" && options;;
	esac
}

#sh-ota
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
elif [ "$perm" = "" ]; then
	options
elif [ "$catalyst_time" = "" ]; then
	setprop hybrid.catalyst_time 60
fi
while true; do
	clear
	body
done
