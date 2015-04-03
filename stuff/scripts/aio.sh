#!/system/bin/sh
#aio.sh
#licensed under gnu gpl v3

# 6,8,16,20,24,32 - set of minfrees by @me_ankit over at xda.com

vars(){
	target_device=titan
	#versions
	aiover=1.0
	lmk_vm_mod_ver=1.2
	#misc
	cls=clear #for when clear is to mainstream.
	rom=`getprop ro.build.type` #for cm fix by luca
	#ranges - incase new options are added.
	selection_values=1-12 
	lmk_vm_mod_selection_values=1-3
	custom_opt_avail_values=2/11
	#runtime req
	bb=0
	su=0
	bbpass=0
	supass=0
	toll_pass=0
}

print_rand_byte(){ #hoholees random byte output ~ reserved for later use.
	if [[ "$use_urand" != 1 ]]; then
		rand=$(($(od -An -N2 -i /dev/random)%32767))
	else
		rand=$(($(od -An -N2 -i /dev/urandom)%32767))
	fi
	if [[ "$invert_rand" == 1 ]]; then
		if [[ "$rand" -lt 0 ]]; then
			rand=$(($((rand*-1))-1))
		fi
	fi
	echo $rand
} #use

bb_check(){
	if [[ "$bbpass" = 0 ]]; then
		if [ -e /system/xbin/busybox ]; then
			bb=1
		else
			bb=0
		fi
	fi
}

su_check(){
	if [[ "$supass" = 0 ]]; then
		if [ -e /system/xbin/su ]; then #some su binarys are stored here ( <= legacy support :P)
			su=1
		else
			su=0
		fi
		if [ -e /system/bin/su ]; then #most are stored here
			su=1
		else
			su=0
		fi
	fi
}

toll(){
	if [[ "$su" = 1 ]] && [[ "$bb" = 1 ]]; then
		toll_pass=1
	else
		toll_pass=0
	fi
}

sysinfo(){
	echo -e "\e[1;32mSystem information:\e[0m"
echo "-----------------------------------------------
Vendor: $( getprop ro.product.brand )
-----------------------------------------------
Model: $( getprop ro.product.model )
-----------------------------------------------
ROM: $( getprop ro.build.display.id )
-----------------------------------------------
Android Version: $( getprop ro.build.version.release )
-----------------------------------------------" #taken from LSpeed mod.
	sleep 5;
	selection_menu
}

selection_menu(){
	clear
	sleep 1;
	echo ""
	echo -e "\e[1;32m		-=[ALL IN ONE TOOL-BOX $aiover]=-\e[0m"
	echo "[1] LMK & VM Tuner $lmk_vm_mod_ver"
	echo "[2] Resolution Adjustment"
	echo "[3] Periodic Cache Flushing"
	echo "[4] Crap Cleaner"
	echo "[5] Scheduling Tuner"
	echo "[6] Flag Tuner"
	echo "[7] FPS Unlocker"
	echo "[8] Battery Booster - VM Hack & Media Server Killing"
	echo "[9] TCP & DNS Optimizer"
	echo "[10] RW Tuner"
	echo "[11] Android 5.0 Boot Anim Mem Leak Fix & LMK Perm Fix"
	echo "[12] System Information"
	echo "[E] Exit"
	echo ""
	echo -n "> "
	sleep 1;
	read selection_opt
	case $selection_opt in
		1 ) $cls && lmk_vm_mod;;
		2 ) $cls && res_mod;;
		3 ) $cls && cache_flusher_mod;;
		4 ) $cls && cuc_mod;;
		5 ) $cls && sched_mod;;
		6 ) $cls && flag_mod;;
		7 ) $cls && fps_unlock_mod;;
		8 ) $cls && battery_mod;;
		9 ) $cls && tcp_mod;;
		10 ) $cls && rw_mod;;
		11 ) $cls && mem_fix;;
		12 ) $cls && sysinfo;;
		e|E ) $cls && echo "bye :P" && exit;;
		* ) echo && echo "Error, please enter a value between $selection_values" && selection_menu;;
	esac
}

lmk_vm_mod(){
	#based upon rtrm

	lmk_vm_mod_selection_menu(){
		busybox chmod 644 /sys/module/lowmemorykiller/parameters/minfree;
		#fixes the 5.0+ (moto) bug where the minfree file dosnt have correct permissions to be read.
		clear
		echo -e "\e[1;32m-=[LMK TUNER $lmk_mod_ver]=-\e[0m"
		sleep 1;
		echo "LMK Tuner $lmk_vm_mod_ver Menu:"
		echo "[1] Apply Balanced Profile"
		echo "[2] Apply Gaming Profile"
		echo "[3] Apply Custom ($custom_opt_avail_values) Profile"
		echo "[M] Exit to Main Menu"
		echo -n "> "
		sleep 1;
		read opt
		case $opt in
			1 ) lmk_vm_balanced;;
			2 ) lmk_vm_gaming;;
			3 ) lmk_vm_custom;;
			m|M ) selection_menu;;
			* ) echo "Error, please enter a value between $lmk_vm_mod_selection_values";;
			esac
	}

	lmk_vm_balanced(){
		clear
		sleep 1;
		#thanks to luca for the cm fix.
		if [ $rom=userdebug ]; then
			mkdir -p /system/etc/init.d
			touch /system/etc/init.d/95lmk_vm_tuner
			chmod 755 /system/etc/init.d/95lmk_vm_tuner
			echo -ne "" > /system/etc/init.d/95lmk_vm_tuner
			#updated minfrees, never seen before, highly tuned, no more ui lag as seen with supermultitasking minfrees from rtrm.
cat >> /system/etc/init.d/95lmk_vm_tuner <<EOF
#!/system/bin/sh
#LMK & VM Tuner $lmk_vm_mod_ver Balanced Profile

if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then 
	echo "2048,3072,4096,28342,31041,33740" > /sys/module/lowmemorykiller/parameters/minfree
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
echo "" >> /system/etc/init.qcom.post_boot.sh #motorola specific file, probably wont work on other devices.
echo "LMK & VM Tuner $lmk_vm_mod_ver Balanced Profile" >> /system/etc/init.qcom.post_boot.sh
echo "" >> /system/etc/init.qcom.post_boot.sh
echo "if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
	echo "2048,3072,4096,28342,31041,33740" > /sys/module/lowmemorykiller/parameters/minfree
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
			echo "Profile applied. Please reboot asap."
			sleep 1;
			lmk_vm_mod_selection_menu #return to top
	}

	lmk_vm_gaming(){
		clear
		sleep 1;
		#thanks to luca for the cm fix.
		if [ $rom=userdebug ]; then
			mkdir -p /system/etc/init.d
			touch /system/etc/init.d/95lmk_vm_tuner
			chmod 755 /system/etc/init.d/95lmk_vm_tuner
			echo -ne "" > /system/etc/init.d/95lmk_vm_tuner
cat >> /system/etc/init.d/95lmk_vm_tuner <<EOF
#!/system/bin/sh
#LMK & VM Tuner $lmk_vm_mod_ver Gaming Profile

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
echo "" >> /system/etc/init.qcom.post_boot.sh #motorola specific file, probably wont work on other devices.
echo "LMK & VM Tuner $lmk_vm_mod_ver Gaming Profile" >> /system/etc/init.qcom.post_boot.sh
echo "" >> /system/etc/init.qcom.post_boot.sh
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
			echo "Profile applied. Please reboot asap."
			sleep 1;
			lmk_vm_mod_selection_menu #return to top
	}

	lmk_vm_custom(){
		#pages to mb translation
		#((page * 4)/ 1024) = mb
		#((mb / 4)* 1024) = page

		echo "Welcome to the custom profile entry!"
		echo "I will guide you through inputting good LMK & Swap values."
		sleep 3;
		clear

		#lmk
		echo "LMK Input"
		sleep 1; 
		echo ""
		echo "LMK Example Array (In MB):"
		echo "6,8,16,20,22,24"
		sleep 1;
		echo ""
		echo "Please enter your array here exactly like the above"
		echo "example but with your own values (no quotations, just commas)"
		echo "If you dont know what to input, just input the above array"
		echo "its the balanced profile, and its good enough!"
		sleep 3;
		echo -n "> "
		sleep 1;
		read lmk_array
		echo ""
		echo "Sweet!"
		clear

		#swappiness
		echo "Swappiness Input"
		sleep 1; 
		echo ""
		echo "Swappiness Example (In %):"
		echo "80" #we have flash storage, so high frequency swapping is good.
		sleep 1;
		echo ""
		echo "Please enter your swappiness value below:"
		echo "(just digits, no quotations or commas)"
		echo "If you dont know what to input, just input the above value"
		echo "its the balanced profiles default and its good since we have flash storage!"
		sleep 3;
		echo -n "> "
		sleep 1;
		read swap_val
		echo ""
		echo "Mint!"
		clear

		clear
		sleep 1;
		#thanks to luca for the cm fix.
		if [ $rom=userdebug ]; then
			mkdir -p /system/etc/init.d
			touch /system/etc/init.d/95lmk_vm_tuner
			chmod 755 /system/etc/init.d/95lmk_vm_tuner
			echo -ne "" > /system/etc/init.d/95lmk_vm_tuner
cat >> /system/etc/init.d/95lmk_vm_tuner <<EOF
#!/system/bin/sh
#LMK & VM Tuner $lmk_vm_mod_ver Custom Profile

if [ -e /sys/module/lowmemorykiller/parameters/minfree ]; then
	echo "$lmk_array" > /sys/module/lowmemorykiller/parameters/minfree
fi

if [ -e /proc/sys/vm/swappiness ]; then
	echo "$swap_val" > /proc/sys/vm/swappiness
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
echo "" >> /system/etc/init.qcom.post_boot.sh #motorola specific file, probably wont work on other devices.
echo "LMK & VM Tuner $lmk_vm_mod_ver Gaming Profile" >> /system/etc/init.qcom.post_boot.sh
echo "" >> /system/etc/init.qcom.post_boot.sh
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
			echo "Profile applied. Please reboot asap."
			sleep 1;
			lmk_vm_mod_selection_menu #return to top
	}

	#lmk_vm_mod parser
	lmk_vm_mod_selection_menu
}

res_mod(){
	#wip
}

cache_flusher_mod(){
	#temp
}

cuc_mod(){
	#temp
}

sched_mod(){
	#temp
}

flag_mod(){
	#temp
}

fps_unlock_mod(){
	#temp
}

battery_mod(){
	#temp
}

tcp_mod(){
	#temp
}

rw_mod(){
	#temp
}

mem_fix(){
	#temp
}

#session behaviour
#declare varaibles
vars
#2 stage checks
bb_check
su_check
toll #combined check with args check
if [[ "$toll_pass" = 1 ]]; then
	selection_menu #display menu
else
	echo "You are either missing busybox or not rooted and running as su..." && exit; #error msg
fi

#email: diamond.nigel75@gmail.com
#src: https://github.com/pizza-dox