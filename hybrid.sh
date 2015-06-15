#!/system/bin/sh
# hybrid.sh by DiamondBond & Deic

#NOTES (Sign off please):
#get su status method does nothing (~Deic)
#game booster config perm doesn't work (~Deic)
#sensor_fix() needs to be added to the options menu / somewhere else (~Diamond)
#why have wait_download() with run_sh_ota() inside, lol, just call run_sh_ota() directly (~Diamond)

#Master version
ver_revision="2.0"

#options
hybrid="/system/xbin/hybrid"
data_rw="mount -o remount,rw /data"
data_ro="mount -o remount,ro /data"
tmp_dir="/data/local/tmp/"
initd_dir="/system/etc/init.d/"
initd=`if [ -d $initd_dir ]; then echo 1; else echo 0; fi`
perm=`getprop hybrid.perm`
catalyst_time=`getprop hybrid.catalyst_time`

#color control
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
cyan='\033[0;36m'
white='\033[0;97m'

#formatting control
bld='\033[0;1m'
blnk='\033[0;5m'
nc='\033[0m'

sh-ota(){
	name="ota.sh"
	cloud="https://ota.sh"
	ota_ext="$EXTERNAL_STORAGE/Download/$name
	ota_tmp="/data/local/tmp/$name"

	clear
	if [ -f /system/bin/curl ] || [ -f /system/xbin/curl ]; then
		curl -k -L $ota_tmp $cloud
	else
		am start android.intent.action.VIEW com.android.browser $cloud 1>/dev/null
	fi

	run(){
	if [ -f $ota_ext ]; then
		am force-stop com.android.browser
		cp -rf $ota_ext $ota_tmp
		sleep 2
		chmod 755 $ota_tmp
		$SHELL -c $ota_tmp
	else
		run
	fi
}

exit
}

body(){
	clear
	echo "$cyan[-=The Hybrid Project=-]$nc"
	echo
	echo "${yellow}Menu:$nc"
	echo " 1|Instant Boost"
	echo " 2|Clean up my crap"
	echo " 3|Optimize my SQLite DB's"
	echo " 4|Tune my VM"
	echo " 5|Tune my LMK"
	echo " 6|Tune my Networks"
	echo " 7|Kernel Kontrol"
	if [ -f /dev/block/zram* ]; then
		wehavezram=0
		echo " 8|zRAM Settings"
	fi
	if [ $wehavezram == 0 ]; then
		echo " 8|Game Booster"
	else

		echo " 9|Game Booster"
	fi
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
		r|R ) custom_reboot;;
		e|E ) safe_exit;;
		* ) unknown_option;;
	esac
}

unknown_option(){
	clear
	echo "Unknown Option"
	sleep 1
}

init_sleep(){
	if [ ! -f system/etc/init.d/50sleep ]
	then
		touch /system/etc/init.d/50sleep
		chmod 755 /system/etc/init.d/50sleep
		echo "" > /system/etc/init.d/50sleep
cat > /system/etc/init.d/50sleep <<EOF
#!/system/bin/sh

sleep 10

EOF
	fi
}

drop_caches(){
	clear
	echo "${yellow}Dropping caches...$nc"
	sleep 1

	sync
	echo 3 > /proc/sys/vm/drop_caches

	clear
	echo "${yellow}Caches dropped!$nc"
	sleep 1

	if [ $perm == 1 ] && [ $initd == 1 ]
	then
		init_sleep
		touch /system/etc/init.d/97cache_drop
		chmod 755 /system/etc/init.d/97cache_drop
cat > /system/etc/init.d/97cache_drop <<EOF
#!/system/bin/sh

sync
echo 3 > /proc/sys/vm/drop_caches

EOF
	clear
	echo "${yellow}Installed!$nc"
	sleep 1
	fi

	body
}

clean_up(){
	clear
	echo "${yellow}Cleaning up...$nc"
	sleep 1

	if [ $perm == 1 ] && [ $initd == 1 ]
	then
	 	script_dir=$initd_dir
		init_sleep
	else
	 	script_dir=$tmp_dir
	 	$data_rw
	fi

	touch $script_dir/99clean_up
	chmod 755 $script_dir/99clean_up
cat > $script_dir/99clean_up <<EOF
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
rm -f $EXTERNAL_STORAGE/LOST.DIR/*

EOF
	$script_dir/99clean_up

	clear
	echo "${yellow}Clean up complete!$nc"
	sleep 1

	if [ $perm == 1 ]
	then
	 	clear
	 	echo "${yellow}Installed!$nc"
	 	sleep 1
	else
	 	$data_ro
	fi

	body
}

sql_optimize(){
	clear
	echo "${yellow}Optimizing SQLite databases...$nc"
	sleep 1

	if [ -e /system/xbin/sqlite3 ]
	then
		chown root.root  /system/xbin/sqlite3
		chmod 755 /system/xbin/sqlite3
		SQLLOC=/system/xbin/sqlite3
	fi

	if [ -e /system/bin/sqlite3 ]
	then
		chown root.root /system/bin/sqlite3
		chmod 755 /system/bin/sqlite3
		SQLLOC=/system/bin/sqlite3
	fi

	if [ -e /system/sbin/sqlite3 ]
	then
		chown root.root /sbin/sqlite3
		chmod 755 /sbin/sqlite3
		SQLLOC=/sbin/sqlite3
	fi
	for i in `find / -iname "*.db" 2>/dev/null`
	do
	 	clear
		$SQLLOC $i 'VACUUM'
		echo "${yellow}Vacuumed:$nc $i"
		$SQLLOC $i 'REINDEX'
		echo "${yellow}Reindexed:$nc $i"
	done

	clear
	echo "${yellow}SQLite database optimizations complete!$nc"
	sleep 1

	body
}

vm_tune(){
	clear
	echo "${yellow}Optimizing VM...$nc"
	sleep 1

	if [ $perm == 1 ] && [ $initd == 1 ]
	then
	 	script_dir=$initd_dir
		init_sleep
	else
	 	script_dir=$tmp_dir
	 	$data_rw
	fi

	touch $script_dir/75vm
	chmod 755 $script_dir/75vm
cat > $script_dir/75vm <<EOF
#!/system/bin/sh

echo 80 > /proc/sys/vm/swappiness
echo 10 > /proc/sys/vm/vfs_cache_pressure
echo 3000 > /proc/sys/vm/dirty_expire_centisecs
echo 500 > /proc/sys/vm/dirty_writeback_centisecs
echo 90 > /proc/sys/vm/dirty_ratio
echo 70 > /proc/sys/vm/dirty_background_ratio
echo 1 > /proc/sys/vm/overcommit_memory
echo 150 > /proc/sys/vm/overcommit_ratio
echo 4096 > /proc/sys/vm/min_free_kbytes
echo 1 > /proc/sys/vm/oom_kill_allocating_task

EOF
	$script_dir/75vm

	clear
	echo "${yellow}VM Optimized!$nc"
	sleep 1

	if [ $perm == 1 ]; then
	 	clear
	 	echo "${yellow}Installed!$nc"
	 	sleep 1
	else
	 	$data_ro
	fi

	body
}

lmk_tune_opt(){
	clear
	echo "${yellow}LMK Optimization$nc"
	echo
	echo "${yellow}Minfree profiles available:$nc"
	echo " B|Balanced"
	echo " M|Multitasking|"
	echo " G|Gaming"
	echo
	echo " R|Return"
	echo
	echo -n "> "
	read lmk_opt
	case $lmk_opt in
		b|B|m|M|g|G ) clear; echo "Done"; sleep 1; lmk_profile=$lmk_opt; lmk_apply;;
		r|R ) body;;
		* ) unknown_option; lmk_tune_opt;;
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

	echo "${yellow}Optimizing LMK...$nc"
	sleep 1

	echo $minfree_array > /sys/module/lowmemorykiller/parameters/minfree

	clear
	echo "${yellow}LMK Optimized!$nc"
	sleep 1

	if [ $perm == 1 ] && [ $initd == 1 ]; then
		init_sleep
		touch /system/etc/init.d/95lmk
		chmod 755 /system/etc/init.d/95lmk
cat > /system/etc/init.d/95lmk <<EOF
#!/system/bin/sh

echo $minfree_array > /sys/module/lowmemorykiller/parameters/minfree

EOF
	 	clear
		echo "${yellow}Installed!$nc"
		sleep 1
	fi

	body
}

network_tune(){
	clear
	echo "${yellow}Optimizing Networks...$nc"
	sleep 1

	if [ $perm == 1 ] && [ $initd == 1 ]; then
	 	script_dir=$initd_dir
		init_sleep
	else
	 	script_dir=$tmp_dir
	 	$data_rw
	fi

	touch $script_dir/56net
	chmod 755 $script_dir/56net
cat > $script_dir/56net <<EOF
#!/system/bin/sh

#TCP
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

#IPv4
echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 1 > /proc/sys/net/ipv4/conf/default/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects
echo 0 > /proc/sys/net/ipv4/conf/default/accept_redirects
echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects
echo 0 > /proc/sys/net/ipv4/conf/default/send_redirects
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route
echo 0 > /proc/sys/net/ipv4/conf/default/accept_source_route
echo 1 > /proc/sys/net/ipv4/conf/all/log_martians
echo 1 > /proc/sys/net/ipv4/conf/default/log_martians

EOF
	$script_dir/56net

	clear
	echo "${yellow}Networks Optimized!$nc"
	sleep 1

	if [ $perm == 1 ]; then
	 	clear
	 	echo "${yellow}Installed!$nc"
	 	sleep 1
	else
	 	$data_ro
	fi

	body
}

kernel_kontrol(){
	clear
	echo "${yellow}Kernel Kontrol$nc"
	echo " 1|Set CPU Freq"
	echo " 2|Set CPU Gov"
	echo " 3|Set I/O Sched"
	if [ -d /sys/devices/platform/kcal_ctrl.0/ ]; then
	 	echo " 4|View KCal Values"
	fi
	echo " B|Back"
	echo
	echo -n "> "
	read kk_opt
	case $kk_opt in
		1) setcpufreq;;
		2) setgov;;
		3) setiosched;;
		4) kcal;;
		b|B) body;;
		* ) unknown_option; kernel_kontrol;;
	 esac
}

setcpufreq(){
	clear
	#configure sub variables
	maxfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
	minfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
	curfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
	listfreq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies`

	echo "${yellow}CPU Control$nc"
	echo
	echo "${bld}Max Freq:$nc $maxfreq"
	echo "${bld}Min Freq:$nc $minfreq"
	echo "${bld}Current Freq:$nc $curfreq"
	echo
	echo "${bld}Available Freq's:$nc"
	echo "$listfreq"
	echo
	echo -n "New Max Freq: "; read newmaxfreq
	echo -n "New Min Freq: "; read newminfreq

	echo $newmaxfreq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	echo $newminfreq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

	clear
	echo "${yellow}New Freq's applied!$nc"
	sleep 1

	if [ $perm == 1 ] && [ $initd == 1 ]; then
		init_sleep
		touch /system/etc/init.d/69cpu_freq
		chmod 755 /system/etc/init.d/69cpu_freq
cat > /system/etc/init.d/69cpu_freq <<EOF
#!/system/bin/sh

echo $newmaxfreq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo $newminfreq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

EOF
	 	clear
		echo "${yellow}Installed!$nc"
	 	sleep 1
	fi

	kernel_kontrol
}

setgov(){
	clear

	#sub-variables
	curgov=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
	listgov=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors`

	echo "${yellow}Governor Control$nc"
	echo
	echo "${bld}Current Governor:$nc $curgov"
	echo
	echo "${bld}Available Governors:$nc"
	echo "$listgov"
	echo
	echo -n "New Governor: "; read newgov

	echo "$newgov" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

	clear
	echo "${yellow}New Governor applied!$nc"
	sleep 1

	if [ $perm == 1 ] && [ $initd == 1 ]; then
		init_sleep
		touch /system/etc/init.d/70cpu_gov
		chmod 755 /system/etc/init.d/70cpu_gov
cat > /system/etc/init.d/70cpu_gov <<EOF
#!/system/bin/sh

echo "$newgov" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

EOF
	 	clear
		echo "${yellow}Installed!$nc"
	 	sleep 1
	fi

	kernel_kontrol
}


setiosched(){
	clear

	#sub-variables
	curiosched=`cat /sys/block/mmcblk0/queue/scheduler | sed 's/.*\[\([a-zA-Z0-9_]*\)\].*/\1/'`
	listiosched=`cat /sys/block/mmcblk0/queue/scheduler | tr -s "[[:blank:]]" "\n" | sed 's/\[\([a-zA-Z0-9_]*\)\]/\1/'`

	echo "${yellow}I/O Schedulder Control$nc"
	echo
	echo "${bld}Current I/O Scheduler:$nc $curiosched"
	echo
	echo "${bld}Available I/O Schedulers:$nc"
	echo "$listiosched"
	echo
	echo -n "New Scheduler: "; read newiosched

	for j in /sys/block/*/queue/scheduler
	do
	 	echo "$newiosched" > $j
	done

	clear
	echo "${yellow}New I/O Scheduler applied!$nc"
	sleep 1

	if [ $perm == 1 ] && [ $initd == 1 ]
	then
		init_sleep
		touch /system/etc/init.d/71io_sched
		chmod 755 /system/etc/init.d/71io_sched
cat > /system/etc/init.d/71io_sched <<EOF
#!/system/bin/sh

for j in /sys/block/*/queue/scheduler
do
	echo "$newiosched" > location
done

EOF
		sed -i 's/location/$j/' /system/etc/init.d/71io_sched

	 	clear
		echo "${yellow}Installed!$nc"
	 	sleep 1
	fi

	kernel_kontrol
}

kcal(){
	clear
	if [ ! -d /sys/devices/platform/kcal_ctrl.0/ ]; then
	 	unknown_option
	 	kernel_kontrol
	else
	 	echo "${yellow}Current KCal Values:${nc}"
	 	rgb=`cat /sys/devices/platform/kcal_ctrl.0/kcal`
	 	sat=`cat /sys/devices/platform/kcal_ctrl.0/kcal_sat`
	 	cont=`cat /sys/devices/platform/kcal_ctrl.0/kcal_cont`
	 	hue=`cat /sys/devices/platform/kcal_ctrl.0/kcal_hue`
	 	gamma=`cat /sys/devices/platform/kcal_ctrl.0/kcal_val`
	 	echo "rgb: $rgb, sat: $sat, cont: $cont, hue: $hue, gamma: $gamma"
	 	sleep 5

	 	kernel_kontrol
	fi
}

zram_settings(){
	clear
	if [ $wehavezram == 0 ]; then
	 	catalyst_control
	else
	 	echo "${yellow}zRAM Options:$nc"
	 	echo " 1|Disable zRAM"
	 	echo " 2|Enable zRAM"
	 	echo " B|Back"
	 	echo
	 	echo -n "> "
	 	read options_opt
	 	case $options_opt in
	 		1 ) zram_disable;;
	 		2 ) zram_enable;;
	 		b|B ) body;;
	 		* ) unknown_option; zram_settings;;
	 	esac
	fi
}

zram_enable(){
	clear
	echo "${yellow}Enabling zRAM...$nc"
	sleep 1

	for l in `ls /dev/block/zram*`
	do
		swapon $l
	done

	clear
	echo "${yellow}zRAM enabled!$nc"
	sleep 1
	
	zram_settings
}

zram_disable(){
	clear
	echo "${yellow}Disabling zRAM...$nc"
	sleep 1

	for l in `ls /dev/block/zram*`
	do
		swapoff $l
	done

	clear
	echo "${yellow}zRAM disabled!$nc"
	sleep 1
	
	zram_settings
}

catalyst_control(){
	clear
	if [ $wehavezram == 0 ]; then
		unknown_option
	fi
	echo "${yellow}Game Booster$nc"
	echo " [1] Boost"
	echo " [2] Options"
	echo " [B] Back"
	echo
	echo -n "> "
	read game_booster_opt
	case $game_booster_opt in
		1 ) catalyst_inject;;
		2 ) catalyst_time_cfg;;
		b|B ) body;;
		* ) unknown_option; catalyst_control;;
	esac
}

catalyst_inject(){
	clear
	echo "Please leave the terminal emulator running"
	echo "This will continue to run untill close the terminal"

	while true
	do
		sync
  		echo "3" > /proc/sys/vm/drop_caches
		sleep $catalyst_time
	done
}

catalyst_time_cfg(){
	clear
	echo "Current rate: $catalyst_time"
	echo "60 - Every minute - Default"
	echo "3600 - Every hour"
	echo
	echo "Please enter a rate in seconds:"
	echo -n "> "
	read catalyst_time_val
	sed -i 's/hybrid.catalyst_time=`$catalyst_time`/hybrid.catalyst_time=`$catalyst_time_val`/' /system/build.prop #to be revised
	setprop hybrid.catalyst_time $catalyst_time_val
	clear
	echo "Time updated!"
	sleep 1
	$hybrid
	safe_exit
}

sensor_fix(){
	clear
	#this is a fix for dirty flashers with bad sensors.
	echo "Wipe sensor data? [Y/N]"
	echo -n "> "
	read sensorfix_opt
	case $sensorfix_opt in
		y|Y ) rm -rf /data/misc/sensor && echo "done!" && body;;
		n|N ) body;;
		* ) unknown_option; options;;
	esac
}

options(){
	clear
	echo "${yellow}How to install tweaks?$nc"
	echo " T|Temporary installs"
	echo " P|Permanent installs"
	if [ "$perm" = "0" ] || [ "$perm" = "1" ]; then
	 	echo
	 	echo " B|Back"
	 	echo
	 	echo -n "> "
	 	read options_opt
	 	case $options_opt in
	 	 	t|T ) setprop hybrid.perm 0; sed -i 's/hybrid.perm=1/hybrid.perm=0/' /system/build.prop; clear; echo "Done"; sleep 1; $hybrid; safe_exit;;
		 	p|P ) setprop hybrid.perm 1; sed -i 's/hybrid.perm=0/hybrid.perm=1/' /system/build.prop; clear; echo "Done"; sleep 1; $hybrid; safe_exit;;
	 	 	b|B ) body;;
		 	* ) unknown_option; options;;
	 	esac
	else
	options_first
	fi
}

options_first(){
	echo
	echo "${cyan}You can change it in Options later$nc"
	echo
	echo -n "> "
	read options_first_opt
	case $options_first_opt in
		t|T ) setprop hybrid.perm 0; echo "hybrid.perm=0" >> /system/build.prop; clear; echo "Done"; sleep 1; $hybrid; safe_exit;;
		p|P ) setprop hybrid.perm 1; echo "hybrid.perm=1" >> /system/build.prop; clear; echo "Done"; sleep 1; $hybrid; safe_exit;;
		* ) unknown_option; options;;
	esac
}

about_info(){
	clear
	echo "${green}About:$nc"
	echo
	echo "Hybrid Version: $ver_revision"
	echo
	echo "${yellow}INFO$nc"
	echo "This script deals with many things apps normally do."
	echo "But this script is ${cyan}AWESOME!$nc because its < ${bld}1MB!$nc"
	echo
	echo "${yellow}CREDITS$nc"
	echo "DiamondBond : Script creator & maintainer"
	echo "Deic : Maintainer"
	echo "Hoholee12/Wedgess/Imbawind/Luca020400 : Code $yellow:)$nc"

	echo
	echo "${yellow}Links:$nc"
	echo " F|Forum"
	echo " S|Source"
	echo
	echo " B|Back"
	echo
	echo -n "> "
	read about_info_opt
	case $about_info_opt in
	 	f|F ) am start "http://forum.xda-developers.com/android/software-hacking/dev-hybridmod-t3135600" 1>/dev/null; about_info;;
	 	s|S ) am start "https://github.com/HybridMod" 1>/dev/null; about_info;;
	 	b|B ) body;;
	 	* ) unknown_option; about_info;;
	esac
}

custom_reboot(){
	clear
	echo "Rebooting in 3."
	sleep 1
	clear
	echo "Rebooting in 2.."
	sleep 1
	clear
	echo "Rebooting in 1..."
	sleep 1
	clear
	echo "Bam!"
	sleep 1
	sync
	reboot
}

safe_exit(){
	mount -o ro,remount /system 2>/dev/null
	clear
	exit
}

#sh_ota
clear
mount -o rw,remount /system 2>/dev/null
#if [ $EUID -ne 0 ] #to be revised
#then
#	echo "This script must be run as root"
#	exit 1
if [ "$perm" = "" ]; then
	options
elif [ "$catalyst_time" = "" ]; then
	setprop hybrid.catalyst_time 60
	echo "hybrid.catalyst_time=60" >> /system/build.prop
	$hybrid
	safe_exit
fi
while true
do
	body
done
