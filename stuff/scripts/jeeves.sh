#!/system/bin/sh
#jeeves

#vars
ver=0.1

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