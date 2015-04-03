#hybrid.sh by Pizza_Dox

var(){
	#version_control
	ver_revision=dev

	#options
	userdebug=0
	useradv=1
	usage_type=0
	initd=1

	#misc control
	DATE=`date +%d-%m-%Y`
	sysrw='mount -o remount rw /system'
	sysro='mount -o remount ro /system'

	#color control
	red='\033[0;31m'
	green='\033[0;32m'
	yellow='\033[0;33m'
	cyan='\033[0;36m'
	white='\033[0;97m'

	#format control
	bld='\033[0;1m' #bold
	blnk='\033[0;5m' #blinking
	nc='\033[0m' # no color
}

title(){
	echo "${cyan}[-=The Hybrid Project=-]${nc}"
	echo ""
}

body(){
	echo "${yellow}Menu:${nc}"

	#conditional menu
	if [ $useradv == 1 ]; then
		echo " 1|Drop my caches"
		echo " 2|Clean up my crap"
		echo " 3|Optimize my SQLite DB's"
		echo " 4|Tune my VM"
		echo " 5|Tune my LMK"
	fi
	if [ $useradv == 0 ]; then
		echo " 1|Give me a quick boost!"
		echo " 2|Clean up all that junk in my system!"
		#echo " 3|Make my lists load faster!"
		echo " 4|Fix my lag"
		echo " 5|Upgrade my RAM"
		echo "Options not shown are currently under development."
	fi

	#standard menu
	echo " O|Options"
	echo " A|About"
	echo " R|Reboot"
	echo " E|Exit"
	echo ""
	echo -n "> "
	read selection_opt
	case $selection_opt in
		1 ) clear && drop_caches;;
		2 ) clear && clean_up;;
		3 ) clear && sql_optimize;;
		4 ) clear && vm_tune;;
		5 ) clear && lmk_tune_opt;;
		o|O ) clear && options;;
		a|A ) clear && about_info;;
		r|R ) clear && echo "Rebooting in 3..." && sleep 3 && reboot;;
		e|E ) clear && safe_exit;;
		* ) echo && echo "error 404, function not found." && sleep 3 && backdrop;;
	esac
}

backdrop(){
	clear
	sleep 1
	title
	body
}

drop_caches(){
	echo "${yellow}Caches dropped!${nc}"
	sync;
	echo "3" > /proc/sys/vm/drop_caches;
	sleep 2
	backdrop
}

clean_up(){
	echo "${yellow}Cleaning up...${nc}"
	sleep 3
	$sysrw
	# remove cache apps
	if [ -e /cache/*.apk ];then
		rm -f /cache/*.apk > /dev/null 2>&1
	fi

	# remove cache temp
	if [ -e /cache/*.tmp ]; then
		rm -f /cache/*.tmp > /dev/null 2>&1
	fi

	# remove dalvik-cache apps
	if [ -e /data/dalvik-cache/*.apk ]; then
		rm -f /data/dalvik-cache/*.apk > /dev/null 2>&1
	fi

	# remove dalvik-cache temp
	if [ -e /data/dalvik-cache/*.tmp ]; then
		rm -f /data/dalvik-cache/*.tmp > /dev/null 2>&1
	fi

	# remove usuage stats
	if [ -e /data/system/usagestats/* ]; then
		rm -f /data/system/usagestats/* > /dev/null 2>&1
	fi

	# remove app usuage stats
	if [ -e /data/system/appusagestats/* ]; then
		rm -f /data/system/appusagestats/* > /dev/null 2>&1
	fi

	# remove dropbox data content
	# if [ -e /data/system/dropbox/* ]; then
	# 	rm -f /data/system/dropbox/* > /dev/null 2>&1
	# fi

	# remove user behaviour
	if  [ -e /data/system/userbehavior.db ]; then
		rm -f /data/system/userbehavior.db > /dev/null 2>&1
	fi

	# disable usuage stats
	if  [ -d /data/system/usagestats ]; then
		chmod 0400 /data/system/usagestats > /dev/null 2>&1
	fi

	# disable app usage stats
	if  [ -d /data/system/appusagestats ]; then
		chmod 0400 /data/system/appusagestats > /dev/null 2>&1
	fi

	$sysro
	clear
	echo "${yellow}Clean up complete!${nc}"
	sleep 2
	backdrop
}

sql_optimize(){
	$sysrw

	echo "${yellow}Optimizing SQLite databases!"

	if [ -e /system/xbin/sqlite3 ]; then
		chown root.root  /system/xbin/sqlite3
		chmod 0755 /system/xbin/sqlite3
		SQLLOC=/system/xbin/sqlite3
		echo ""
	fi

	if [ -e /system/bin/sqlite3 ]; then
		chown root.root /system/bin/sqlite3
		chmod 0755 /system/bin/sqlite3
		SQLLOC=/system/bin/sqlite3
		echo ""
	fi

	if [ -e /system/sbin/sqlite3 ]; then #legacy support
		chown root.root /sbin/sqlite3
		chmod 0755 /sbin/sqlite3
		SQLLOC=/sbin/sqlite3
		echo ""
	fi
	for i in `find ./ -iname "*.db"`; do
		$SQLLOC $i 'VACUUM;'
		if [ $useradv == 1 ]; then
			clear; echo "${yellow}Vacuumed: $i${nc}"
		fi
		sleep 1
		$SQLLOC $i 'REINDEX;'
		if [ $useradv == 1 ]; then
			echo "${yellow}Reindexed : $i${nc}"
		fi
		sleep 1
	done

	$sysro
	clear
	echo "SQLite database optimizations complete!"
	sleep 2
	backdrop
}

vm_tune(){
	echo "${yellow}Optimizing VM...${nc}"

	if [ $usage_type == 0 ]; then
		if [ -e /proc/sys/vm/swappiness ]; then
			echo "80" > /proc/sys/vm/swappiness
		fi

		if [ -e /proc/sys/vm/vfs_cache_pressure ]; then
			echo "10" > /proc/sys/vm/vfs_cache_pressure
		fi

		if [ -e /proc/sys/vm/dirty_expire_centisecs ]; then
			echo "3000" > /proc/sys/vm/dirty_expire_centisecs
		fi

		if [ -e /proc/sys/vm/dirty_writeback_centisecs ]; then
			echo "500" > /proc/sys/vm/dirty_writeback_centisecs
		fi

		if [ -e /proc/sys/vm/dirty_ratio ]; then
			echo "90" > /proc/sys/vm/dirty_ratio
		fi

		if [ -e /proc/sys/vm/dirty_backgroud_ratio ]; then
			echo "70" > /proc/sys/vm/dirty_backgroud_ratio
		fi

		if [ -e /proc/sys/vm/overcommit_memory ]; then
			echo "1" > /proc/sys/vm/overcommit_memory
		fi

		if [ -e /proc/sys/vm/overcommit_ratio ]; then
			echo "150" > /proc/sys/vm/overcommit_ratio
		fi

		if [ -e /proc/sys/vm/min_free_kbytes ]; then
			echo "4096" > /proc/sys/vm/min_free_kbytes
		fi

		if [ -e /proc/sys/vm/oom_kill_allocating_task ]; then
			echo "1" > /proc/sys/vm/oom_kill_allocating_task
		fi
	fi

	if [ $usage_type == 1 ]; then
		#if [ $rom=userdebug ]; then
		if [ $initd == 1 ]; then
			$sysrw
			mkdir -p /system/etc/init.d
			touch /system/etc/init.d/75vm
			chmod 755 /system/etc/init.d/75vm
			echo -ne "" > /system/etc/init.d/75vm
cat >> /system/etc/init.d/75vm <<EOF
#!/system/bin/sh
sleep 15;

if [ -e /proc/sys/vm/swappiness ]; then
	echo "80" > /proc/sys/vm/swappiness
fi

if [ -e /proc/sys/vm/vfs_cache_pressure ]; then
	echo "10" > /proc/sys/vm/vfs_cache_pressure
fi

if [ -e /proc/sys/vm/dirty_expire_centisecs ]; then
	echo "3000" > /proc/sys/vm/dirty_expire_centisecs
fi

if [ -e /proc/sys/vm/dirty_writeback_centisecs ]; then
	echo "500" > /proc/sys/vm/dirty_writeback_centisecs
fi

if [ -e /proc/sys/vm/dirty_ratio ]; then
	echo "90" > /proc/sys/vm/dirty_ratio
fi

if [ -e /proc/sys/vm/dirty_backgroud_ratio ]; then
	echo "70" > /proc/sys/vm/dirty_backgroud_ratio
fi

if [ -e /proc/sys/vm/overcommit_memory ]; then
	echo "1" > /proc/sys/vm/overcommit_memory
fi

if [ -e /proc/sys/vm/overcommit_ratio ]; then
	echo "150" > /proc/sys/vm/overcommit_ratio
fi

if [ -e /proc/sys/vm/min_free_kbytes ]; then
	echo "4096" > /proc/sys/vm/min_free_kbytes
fi

if [ -e /proc/sys/vm/oom_kill_allocating_task ]; then
	echo "1" > /proc/sys/vm/oom_kill_allocating_task
fi
EOF
		fi
	fi

	$sysro
	clear
	echo "${yellow}VM Optimized!${nc}"
	sleep 2
	backdrop
}

lmk_tune_opt(){
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
					sleep 3 && clear
					lmk_profile=$lmk_opt
					lmk_apply;;
		* ) echo && echo "error 404, function not found." && sleep 3 && backdrop;;
	esac
}

lmk_apply(){
	if [ $lmk_profile == b ] || [ $lmk_profile = B ]; then
		minfree_array='1024,2048,4096,8192,12288,16384'
	fi

	if [ $lmk_profile == m ] || [ $lmk_profile = M ]; then
		minfree_array='1536,2048,4096,5120,5632,6144'
	fi

	if [ $lmk_profile == g ] || [ $lmk_profile = G ]; then
		minfree_array='10393,14105,18188,27468,31552,37120'
	fi

	if [ $usage_type == 0 ]; then
		if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
			echo "$minfree_array" > /sys/module/lowmemorykiller/parameters/minfree
		fi
	fi

	if [ $usage_type == 1 ]; then
		#if [ $rom=userdebug ]; then
		if [ $initd == 1 ]; then
			mkdir -p /system/etc/init.d
			touch /system/etc/init.d/95lmk
			chmod 755 /system/etc/init.d/95lmk
			echo -ne "" > /system/etc/init.d/95lmk
			$sysrw
cat >> /system/etc/init.d/95lmk <<EOF
#!/system/bin/sh
sleep 30

if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
	echo "$minfree_array" > /sys/module/lowmemorykiller/parameters/minfree
fi
EOF
		fi
	fi

	$sysro
	sleep 3
	clear
	echo "${yellow}LMK Optimized!${nc}"
	sleep 2
	backdrop
}

zram_disable(){
	echo "${yellow}Disabling zRAM...${nc}"
	sleep 1

	swapoff /dev/block/zram0

	clear
	echo "${yellow}zRAM disabled!${nc}"
	sleep 2
	backdrop
}

options(){
	clear
	echo "NOPE!"
	sleep 1
	echo "WIP..."
	sleep 1
	backdrop
}

safe_exit(){
	sleep 1;
	clear
	$sysro
	echo "${cyan}[-=The Hybrid Project=-]${nc}"
	echo "${cyan}     by Pizza_Dox...${nc}"
}

rom(){
	rom=`getprop ro.build.type`
}

about_info(){
	echo -e "${green}About:${nc}"
	echo ""
	echo "${yellow}INFO${nc}"
	echo "This script deals with many things apps normally do."
	echo "But this script is ${cyan}AWESOME!${nc} because its < 1MB!"
	echo ""
	echo "${yellow}CREDITS${nc}"
	echo "Pizza_Dox - Diamond Bond : Me!"
	echo "Hoholee12/Wedgess/Imbawind/Luca020400 : Code ${yellow}:)${nc}"
	echo ""
	sleep 5
	backdrop
}

debug_info(){
	echo -e "${green}Debug information:${nc}"
	echo ""
	echo "${yellow}SYSTEM${nc}"
	echo "Vendor: $( getprop ro.product.brand )"
	echo "Model: $( getprop ro.product.model )"
	echo "ROM: $( getprop ro.build.display.id )"
	echo "Android Version: $( getprop ro.build.version.release )"
	echo ""
	echo "${yellow}SCRIPT${nc}"
	echo "Hybrid Version: $DATE"
	echo ""
	sleep 5
	clear
	backdrop
}

#session_behaviour(){
	#call startup functions
	clear
	var
	rom

	#run conditional statements
	if [ $userdebug == 1 ]; then
		debug_info
	fi

	#call main functions
	title
	body
#}
