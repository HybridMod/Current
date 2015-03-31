#!/system/bin/sh
# Jeeves & RTRM by Pizza_Dox, Luca & Hoholee

#var declaration
ver=v2.1
jver=0.2
hver=3.6

#selection menu
selection(){
	clear
	sleep 1;
	echo ""
	echo "Script selection:"
	echo "[1] RTRM - RAM"
	echo "[2] Jeeves - GPU"
	echo -n "> "
	sleep 1;
	read selection_opt
	case $selection_opt in
		[1] ) clear && rtrm;;
		[2] ) clear && jeeves;;
		* ) echo && echo "sorry i dont understand japanese...";;
	esac
}

#independent functions
rtrm(){
	#pages to mb translation
	#((page * 4)/ 1024) = mb
	#((mb / 4)* 1024) = page

	#script_skeleton
	start(){
	clear
	echo "RT-RAM Manager $ver by Pizza_Dox"
	sleep 2;
	echo
	clear
	}

	#script_menu
	menu(){
	clear
	echo "RT-RAM $ver Manager Menu: "
	echo "Profiles (temp):"
	echo "[1] Balanced"
	echo "[2] Multitasking"
	echo "[3] Super Multitasking (recommended)"
	echo "[4] Gaming"
	echo "Profiles (perm):"
	echo "[5] Balanced"
	echo "[6] Multitasking"
	echo "[7] Super Sultitasking (recommended)"
	echo "[8] Gaming"
	echo "Tools:"
	echo "[B] Boost me up scotty"
	echo "[BB] You know what scotty, boost me up every boot!"
	echo "[M] Memory Leak Fix - 5.0+"
	echo "[E] Exit"
	echo
	sleep 1;
	echo -n "> "
	sleep 1;
	read opt
	case $opt in
		[1] ) ram_balance;;
		[2] ) ram_multitasking;;
		[3] ) ram_super_multitasking;;
		[4] ) ram_gaming;;
		[5] ) perm_ram_balance;;
		[6] ) perm_ram_multitasking;;
		[7] ) perm_ram_super_multitasking;;
		[8] ) perm_ram_gaming;;
		[B] ) boost;;
		[BB] ) boot_boost;;
		[M] ) memfix_opt;;
		[E] ) clear && safe_exit;;
		* ) echo "~ error - unkown cmd ~";;
		esac
	}

	#script_profiles - based on juwe11's ramscript
	#temp
	ram_balance(){
	if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
		echo "6236,8463,10913,16481,18931,22272" > /sys/module/lowmemorykiller/parameters/minfree
	fi

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

	echo "Profile applied!"
	touch /data/rtrm.log
	echo "Applied Balanced Ram Temp" > /data/rtrm.log
	sleep 1;
	menu
	}

	ram_multitasking(){
	if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
		echo "4444,6031,7777,11745,13491,15872" > /sys/module/lowmemorykiller/parameters/minfree
	fi

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

	echo "Profile applied!"
	touch /data/rtrm.log
	echo "Applied Multitasking Ram Temp" > /data/rtrm.log
	sleep 1;
	menu
	}

	ram_super_multitasking(){
	if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
		echo "1536,2048,4096,5120,5632,6144" > /sys/module/lowmemorykiller/parameters/minfree
	fi

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
		echo "5120" > /proc/sys/vm/min_free_kbytes
	fi

	if [ -e /proc/sys/vm/oom_kill_allocating_task ]; then
		echo "1" > /proc/sys/vm/oom_kill_allocating_task
	fi

	echo "Profile applied!"
	touch /data/rtrm.log
	echo "Applied Super Multitasking Ram Temp" > /data/rtrm.log
	sleep 1;
	menu
	}

	ram_gaming(){
	if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
		echo "10393,14105,18188,27468,31552,37120" > /sys/module/lowmemorykiller/parameters/minfree
	fi

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

	echo "Profile applied!"
	touch /data/rtrm.log
	echo "Applied Gaming Ram Temp" > /data/rtrm.log
	sleep 1;
	menu
	}

	#perm
	perm_ram_balance(){
	if [ $rom=userdebug ]; then
	mkdir -p /system/etc/init.d
	touch /system/etc/init.d/69rtrm
	chmod 755 /system/etc/init.d/69rtrm
	echo -ne "" > /system/etc/init.d/69rtrm
	cat >> /system/etc/init.d/69rtrm <<EOF
#!/system/bin/sh

sleep 5

if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
	echo "6236,8463,10913,16481,18931,22272" > /sys/module/lowmemorykiller/parameters/minfree
fi

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
	else
	echo >> /system/etc/init.qcom.post_boot.sh
	echo "RT-RM $ver balanced profile" >> /system/etc/init.qcom.post_boot.sh
	echo >> /system/etc/init.qcom.post_boot.sh
	echo "if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
		echo "6236,8463,10913,16481,18931,22272" > /sys/module/lowmemorykiller/parameters/minfree
	fi

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
	fi" >> /system/etc/init.qcom.post_boot.sh
	fi
	echo "Profile applied at boot!"
	touch /data/rtrm.log
	echo "Applied Balanced Ram Perm" > /data/rtrm.log
	sleep 1;
	menu
	}

	perm_ram_multitasking(){
	if [ $rom=userdebug ]; then
	mkdir -p /system/etc/init.d
	touch /system/etc/init.d/69rtrm
	chmod 755 /system/etc/init.d/69rtrm
	echo -ne "" > /system/etc/init.d/69rtrm
	cat >> /system/etc/init.d/69rtrm <<EOF
#!/system/bin/sh

sleep 5

if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
	echo "4444,6031,7777,11745,13491,15872" > /sys/module/lowmemorykiller/parameters/minfree
fi

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
	else
	echo >> /system/etc/init.qcom.post_boot.sh
	echo "RT-RM $ver multitasking profile" >> /system/etc/init.qcom.post_boot.sh
	echo >> /system/etc/init.qcom.post_boot.sh
	echo "if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
		echo "4444,6031,7777,11745,13491,15872" > /sys/module/lowmemorykiller/parameters/minfree
	fi

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
	fi" >> /system/etc/init.qcom.post_boot.sh
	fi
	echo "Profile applied at boot!"
	touch /data/rtrm.log
	echo "Applied Multitasking Ram Perm" > /data/rtrm.log
	sleep 1;
	menu
	}

	perm_ram_super_multitasking(){
	if [ $rom=userdebug ]; then
	mkdir -p /system/etc/init.d
	touch /system/etc/init.d/69rtrm
	chmod 755 /system/etc/init.d/69rtrm
	echo -ne "" > /system/etc/init.d/69rtrm
	cat >> /system/etc/init.d/69rtrm <<EOF
#!/system/bin/sh

sleep 5

if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
	echo "1536,2048,4096,5120,5632,6144" > /sys/module/lowmemorykiller/parameters/minfree
fi

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
	echo "5120" > /proc/sys/vm/min_free_kbytes
fi

if [ -e /proc/sys/vm/oom_kill_allocating_task ]; then
	echo "1" > /proc/sys/vm/oom_kill_allocating_task
fi
EOF
	else
	echo >> /system/etc/init.qcom.post_boot.sh
	echo "RT-RM $ver super multitasking profile" >> /system/etc/init.qcom.post_boot.sh
	echo >> /system/etc/init.qcom.post_boot.sh
	echo "if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
		echo "1536,2048,4096,5120,5632,6144" > /sys/module/lowmemorykiller/parameters/minfree
	fi

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
		echo "5120" > /proc/sys/vm/min_free_kbytes
	fi

	if [ -e /proc/sys/vm/oom_kill_allocating_task ]; then
		echo "1" > /proc/sys/vm/oom_kill_allocating_task
	fi" >> /system/etc/init.qcom.post_boot.sh
	fi
	echo "Profile applied at boot!"
	touch /data/rtrm.log
	echo "Applied Super Multitasking Ram Perm" > /data/rtrm.log
	sleep 1;
	menu
	}

	perm_ram_gaming(){
	if [ $rom=userdebug ]; then
	mkdir -p /system/etc/init.d
	touch /system/etc/init.d/69rtrm
	chmod 755 /system/etc/init.d/69rtrm
	echo -ne "" > /system/etc/init.d/69rtrm
	cat >> /system/etc/init.d/69rtrm <<EOF
#!/system/bin/sh

sleep 5

if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
	echo "10393,14105,18188,27468,31552,37120" > /sys/module/lowmemorykiller/parameters/minfree
fi

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
	else
	echo >> /system/etc/init.qcom.post_boot.sh
	echo "RT-RM $ver gaming profile" >> /system/etc/init.qcom.post_boot.sh
	echo >> /system/etc/init.qcom.post_boot.sh
	echo "if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
		echo "10393,14105,18188,27468,31552,37120" > /sys/module/lowmemorykiller/parameters/minfree
	fi

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
	fi" >> /system/etc/init.qcom.post_boot.sh
	fi
	echo "Profile applied at boot!"
	touch /data/rtrm.log
	echo "Applied Gaming Ram Perm" > /data/rtrm.log
	sleep 1;
	menu
	}

	#tools
	boost(){
	#based on imbawind's adrenaline boost
	echo
	free | awk '/Mem/{print "Free memory before boost: "$4/1024" MB";}'
	sync;
	echo "3" > /proc/sys/vm/drop_caches;
	echo
	echo -n "Boosting you up"
	sleep 1;
	echo -n "."
	sleep 1;
	echo -n "."
	sleep 1;
	echo -n "."
	sleep 1;
	echo
	free | awk '/Mem/{print "Free memory after boost: "$4/1024" MB";}'
	sleep 1
	touch /data/rtrm.log
	echo "Applied Ram Boost Temp" > /data/rtrm.log
	sleep 3;
	menu
	}

	boot_boost(){
	if [ $rom=userdebug ]; then
	mkdir -p /system/etc/init.d
	touch /system/etc/init.d/69rtrm-boost
	chmod 755 /system/etc/init.d/69rtrm-boost
	echo -ne "" > /system/etc/init.d/69rtrm-boost
	cat >> /system/etc/init.d/69rtrm-boost <<EOF
#!/system/bin/sh
echo "3" > /proc/sys/vm/drop_caches
EOF
	else
	echo >> /system/etc/init.qcom.post_boot.sh
	echo "#RT-RM $ver boot boost by scotty" >> /system/etc/init.qcom.post_boot.sh
	echo "echo "3" > /proc/sys/vm/drop_caches" >> /system/etc/init.qcom.post_boot.sh
	fi

	echo "Tool installed at boot!"
	touch /data/rtrm.log
	echo "Applied Ram Boost Perm" > /data/rtrm.log
	sleep 1;
	menu
	}

	memfix_opt(){
	clear
	echo "Long ass explanation:"
	echo ""
	sleep 1;
	echo "This memory leak fix removes the 5.0 boot animation"
	echo "which deprives the system of proper resources"
	echo "because it is using AnimationDrawable from the wip sdk"
	echo "by google, and this causes the system to load all frames"
	echo "and never release any previous frames at all until the "
	echo "entire drawable is unloaded which takes up a tonne of RAM"
	echo "which causes lmk to go on a killing spree!"
	echo "thanks to arter97 & NuShrike."
	echo ""
	sleep 5;
	echo "Remove boot animation bin and fix mem leak on 5.0+?"
	echo "[Y]es/[N]o"
	sleep 1;
	echo -n "> "
	read memfix_opt_lel
	case $memfix_opt_lel in
		[Y] ) memfix;;
		[N] ) echo "kden, enjoy the horrible memory!" && menu;;
		* ) echo "~ error - unkown cmd ~";;
		esac
	}

	memfix(){
	echo "removing..."
	rm -f -r /system/bin/bootanimation
	echo ""
	echo "done!"
	sleep 1;
	echo "Fixed mem leak on 5.0+" > /data/rtrm.log
	menu
	}

	#script parser
	rom
	remount
	start
	menu

	#functions
	remount(){
	mount -o rw,remount /system
	mount -o rw,remount /data
	}

	rom(){
	rom=`getprop ro.build.type`
	}

	safe_exit(){
	mount -o ro,remount /system
	mount -o ro,remount /data
	exit
	}
}

jeeves(){
	intro(){
	clear
	echo "yo, im jeeves, your script for tonight, ill be assistin"
	sleep 0.5;
	echo "you with stuff like making games (mc5) playable."
	sleep 3;
	echo "lets get you some options shall we..."
	sleep 0.5;
	echo -n "loading options"
	sleep 0.5;
	echo -n "."
	sleep 0.5;
	echo -n "."
	sleep 0.5;
	echo -n "."
	sleep 1;
	}

	disclamer(){
	clear
	echo "btw i am not responsible for any damage done to your device so like yeah"
	echo "dont come crying to me when your gpu is so powerfull it ate up your cat!"
	sleep 2;
	touch /data/disclamer.txt
	echo "disclamer = seen" >> /data/disclamer.txt
	echo ""
	echo "so do you [A]ccept or do you [D]ecline?"
	sleep 1;
	echo -n "> "
	sleep 1;
	read disclamer_opt
	case $disclamer_opt in
		[A] ) echo && echo "good choice!" && menu_title;;
		[D] ) echo && echo "kden, your loss..." && exit;;
		* ) echo && echo "sorry i dont understand japanese...";;
	esac
	}

	menu_title(){
	clear
	sleep 1;
	if [ -e /data/info.txt ]; then
		menu
	else
		info
	fi
	}

	menu(){
	clear
	echo "da real menu:"
	sleep 1;
	echo "[B]oost"
	echo "[R]estore"
	echo "[G]pu clock control"
	echo "[E]xit"
	echo -n "> "
	sleep 1;
	read menu_opt
	case $menu_opt in
		[B] ) boost;;
		[R] ) restore;;
		[G] ) echo && echo "wip..." && menu;;
		[E] ) echo && echo "bye!" && exit;;
		* ) echo && echo "sorry i dont understand korean either...";;
	esac
	}

	info(){
	clear
	sleep 1;
	echo "so basically this script does a few things."
	sleep 0.5;
	echo "boost:"
	echo "takes us back in the resolution size race"
	echo "drops the bass (dentries, inodes & pagecache included)"
	echo "extrapolates on motos agressive lmk"
	echo ""
	sleep 3;
	echo "restore:"
	echo "brings back your current resolution size"
	echo "restores lmk to a sensible level"
	echo ""
	sleep 3;
	touch /data/info.txt
	echo "info = seen" >> /data/info.txt
	sleep 0.5;
	menu_title
	}

	boost(){
	clear
	echo "boosting you up"
	sleep 0.5;
	res_pesant_quality
	sleep 0.5;
	bass_drop
	sleep 0.5;
	lmk_mean
	sleep 0.5;
	echo "done!"
	sleep 1;
	menu_title
	}

	restore(){
	clear
	echo "restoring you"
	sleep 0.5;
	res_hi_quality
	sleep 0.5;
	bass_undrop
	sleep 0.5;
	lmk_kind
	sleep 0.5;
	echo "done!"
	sleep 1;
	menu_title
	}

	res_pesant_quality(){
	sleep 1;
	echo ""
	echo "you need a virtual button replacement! i suggest using piecontrols from gplaystore"
	echo "you also should remove your softkeys"
	echo "(or just be a real badass and use expanded desktop, like an OG!"
	echo "without it youll get rekt m8"
	sleep 0.5;
	echo ""
	echo "so ya got da stuff? [Y/N]"
	sleep 0.5;
	echo -n "> "
	read sk_opt
		case $sk_opt in
			[Y] ) echo && echo "okie dokie!" && res_pesant_quality_apply;;
			[N] ) echo && echo "then go get pie controls from gplaystore plis!";;
			* ) echo && echo "sorry i dont understand korean either...";;
		esac
	}

	res_pesant_quality_apply(){
	echo "applying..."
	sleep 1;
	wm size 540x960
	wm density 256
	echo "done!"
	sleep 0.5;
	echo ""
	echo "you have to exit the script to see the full effect..."
	echo "wait till everything else is done."
	sleep 1;
	}

	res_hi_quality(){
	echo ""
	echo "applying..."
	sleep 1;
	wm size 1080x1920
	wm density 469
	sleep 3;
	wm size reset
	wm density reset
	echo "done!"
	sleep 0.5;
	echo ""
	echo "you have to reboot to get rid of gui errors..."
	echo "wait till everything else is restored please."
	sleep 1;
	}

	bass_drop(){
	echo ""
	echo "dropping the bass..."
	sleep 1;
	echo "BOOM!"
	sync;
	echo "3" > /proc/sys/vm/drop_caches;
	sleep 1;
	echo "bass dropped! :D"
	sleep 1;
	}

	bass_undrop(){
	echo ""
	echo ":( bass undropped"
	sleep 1;
	}

	lmk_mean(){
	if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
		echo "10393,14105,18188,27468,31552,37120" > /sys/module/lowmemorykiller/parameters/minfree
	fi

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

	echo "the real mean lmk applied!"
	sleep 1;
	}

	lmk_kind(){
	if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
		echo "6236,8463,10913,16481,18931,22272" > /sys/module/lowmemorykiller/parameters/minfree
	fi

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

	echo "balanced lmk applied!"
	sleep 1;
	}

	#script_parser
	intro
	if [ -e /data/disclamer.txt ]; then
		menu_title
	else
		disclamer
	fi
}

#script_parser_body
selection

#email: diamond.nigel75@gmail.com
#src: https://github.com/pizza-dox