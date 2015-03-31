#!/system/bin/sh
#
#Cola Vending Machine™
#Copyright 2015 Pizza_Dox @ xda
#

#vars
ver=0.12
hyp_ver=3.5
cus_ver=1.1
cus=/mnt/sdcard/hyper-cola/custom.sh
custmp=/data/local/tmp/custmp.sh

logo()
{
	clear
	echo "================================================"
	echo "| The Cola Vending Machine $ver...             |"
	echo "|                        ...by -=Pizza_Dox=-   |"
	echo "================================================"
	sleep 1;
}

menu_install()
{
	clear
	echo "================================================"
	echo "| The Cola Vending Machine $ver...             |"
	echo "|                        ...by -=Pizza_Dox=-   |"
	echo "================================================"
	echo "|                                              |"
	echo "|  Install:                                    |"
	echo "| 1. Hyper Cola (Gaming)                       |"
	echo "| 2. Chill Cola (Normal)                       |"
	echo "| 3. Create-A-Cola (Custom)                    |"
	echo "| O. Options                                   |"
	echo "| E. Exit                                      |"
	echo "|                                    ____      |"
	echo "| COLA ==>                          |____|     |"
	echo "|                                              |"
	echo "================================================"
	echo -n "|                            INSERT COIN ==>| "
	sleep 1;
	read opt
    case $opt in
        [1] ) gamer_install;;
		[2] ) normal_install;;
		[3] ) custom_install;;
		[O] ) menu_options;;
        [E] ) clear && exit;;
        * ) echo "| No Fake Coins!                               |";;
    esac
}

menu_options()
{
	clear
	echo "================================================"
	echo "| The Cola Vending Machine $ver...             |"
	echo "|                        ...by -=Pizza_Dox=-   |"
	echo "================================================"
	echo "|                                              |"
	echo "|  Options:                                    |"
	echo "| 1. Start/Stop Hyper Cola Engine              |"
	echo "| 2. Start/Stop Custom Cola                    |"
	echo "| 3. Remove Cola's                             |"
	echo "| R. Reboot                                    |"
	echo "| B. Back                                      |"
	echo "| E. Exit                                      |"
	echo "|                                    ____      |"
	echo "| COLA ==>                          |____|     |"
	echo "|                                              |"
	echo "================================================"
	echo -n "|                            INSERT COIN ==>| "
	sleep 1;
	read opt
    case $opt in
        [1] ) hyp_cola_toggle;;
		[2] ) ccola_toggle;;
		[3] ) unwise;;
		[R] ) reboot;;
		[B] ) menu_install;;
        [E] ) clear && exit;;
        * ) echo "| No Fake Coins!                               |";;
    esac
}

hyp_cola_toggle()
{
	clear
	echo "================================================"
	echo "| The Cola Vending Machine $ver...             |"
	echo "|                        ...by -=Pizza_Dox=-   |"
	echo "================================================"
	echo "|                                              |"
	echo "|  Hyper Cola Options:                         |"
	echo "| 1. Start Cola Engine (main)                  |"
	echo "| 2. Stop Cola Engine (main)                   |"
	echo "| 3. Start Hyper Cola (all)                    |"
	echo "| 4. Stop Hyper Cola (all)                     |"
	echo "| B. Back                                      |"
	echo "|                                    ____      |"
	echo "| COLA ==>                          |____|     |"
	echo "|                                              |"
	echo "================================================"
	echo -n "|                            INSERT COIN ==>| "
	sleep 1;
	read opt
    case $opt in
        [1] ) hyp_cola_engine_start;;
		[2] ) hyp_cola_engine_stop;;
		[3] ) hyp_cola_start;;
		[4] ) hyp_cola_stop;;
        [B] ) menu_options;;
        * ) echo "| No Fake Coins!                               |";;
    esac
}

hyp_cola_engine_start()
{
	clear
	cd /data/local/tmp/
	./cola_engine_starter.sh
	echo "Done!";

#show_menu
clear
logo
menu_options
}

hyp_cola_engine_stop()
{
	clear
	rm /data/local/tmp/cola_engine.sh 2>/dev/null;
	rm /data/local/tmp/cola_engine_starter.sh 2>/dev/null;
	echo "Done!";

	#install engine
	cp /mnt/sdcard/hyper-cola/cola_engine.sh /data/local/tmp/cola_engine.sh
	chmod 0777 /data/local/tmp/cola_engine.sh

	#install starter
	cp /mnt/sdcard/hyper-cola/cola_engine_starter.sh /data/local/tmp/cola_engine_starter.sh
	chmod 0777 /data/local/tmp/cola_engine_starter.sh

#show_menu
clear
logo
menu_options
}

hyp_cola_start()
{
	clear
	cd /system/xbin/
	./hyper
	echo "Done!"
}

hyp_cola_stop()
{
	clear
	#temp
	echo "WIP..."
}


ccola_toggle()
{
	clear
	echo "================================================"
	echo "| The Cola Vending Machine $ver...             |"
	echo "|                        ...by -=Pizza_Dox=-   |"
	echo "================================================"
	echo "|                                              |"
	echo "|  Custom Cola Options:                        |"
	echo "| 1. Start CCola                               |"
	echo "| 2. Stop CCola                                |"
	echo "| B. Back                                      |"
	echo "|                                    ____      |"
	echo "| COLA ==>                          |____|     |"
	echo "|                                              |"
	echo "================================================"
	echo -n "|                            INSERT COIN ==>| "
	sleep 1;
	read opt
    case $opt in
		[1] ) ccola_start;;
		[2] ) ccola_stop;;
        [B] ) menu_options;;
        * ) echo "| No Fake Coins!                               |";;
    esac
}


ccola_start()
{
	clear
	cd /system/xbin/
	./ccola
	echo "Done!"
}

ccola_stop()
{
	clear
	#temp
	echo "WIP..."
}


gamer_install()
{

#mounting
sync;
busybox mount -o remount,rw /system;
busybox mount -o remount,rw /data;

clear
echo "Installing Hyper Cola $hyp_ver..."
sleep 1;
echo " ";

#dir creation
if [ ! -d "/mnt/sdcard/hyper-cola" ]; then
mkdir /mnt/sdcard/hyper-cola
fi

#cleanup
rm /mnt/sdcard/hyper-cola/hyper.sh 2>/dev/null;
rm /system/xbin/hyper 2>/dev/null;
rm /mnt/sdcard/hyper-cola/cola_engine_starter.sh 2>/dev/null;
rm /mnt/sdcard/hyper-cola/cola_engine.sh 2>/dev/null;
rm /mnt/sdcard/hyper-cola/readme.html 2>/dev/null;

cat >> /mnt/sdcard/hyper-cola/hyper.sh <<EOF
# Hyper Cola 3.5 by Pizza_Dox.
# This script works on all linux devices with busybox installed.
# Please reboot after gaming to preserve battery life and to avoid FC's and errors.

#mount required partitions
sync; busybox mount -o remount,rw /
sync; busybox mount -o remount,rw rootfs
sync; busybox mount -o remount,rw /system
sync; busybox mount -o remount,rw /data

#initialize log
LOGFILE=/mnt/sdcard/hyper-cola/log.txt

#log start time
echo "~ Hyper Cola Started @ $( date +"%m-%d-%Y %H:%M:%S" )" >>$LOGFILE

clear
sleep 1;
 echo " ";
 echo "Hyper Cola $hyp_ver";
sleep 0.5;
 echo "by Pizza_Dox";
 echo " ";
sleep 1;
# FPS Booster
sleep 0.6;
 echo "Uncapping FPS...";
setprop persist.sys.NV_FPSLIMIT 60
setprop persist.sys.NV_POWERMODE 1
setprop persist.sys.NV_PROFVER 15
setprop persist.sys.NV_STEREOCTRL 0
setprop persist.sys.NV_STEREOSEPCHG 0
setprop persist.sys.NV_STEREOSEP 20
# 3D render optimizations
sleep 0.6;
 echo "Rendering games with full GPU power...";
setprop hw3d.force 1
setprop hw2d.force 1
setprop debug.performance.tuning 1
setprop debug.gr.numframebuffers 3
setprop debug.sf.hw 1
setprop video.accelerate.hw 1
setprop persist.sys.use_16bpp_alpha 1
# RAM optimizations
sleep 0.6;
 echo "Freeing up RAM & Patching RAM leaks";
setprop ro.media.enc.jpeg.quality 10
setprop persist.sys.purgeable_assets 1
setprop dalvik.vm.verify-bytecode false
setprop ENFORCE_PROCESS_LIMIT false
setprop CONTENT_APP_IDLE_OFFSET false
# Boost Online Gaming
sleep 0.6;
 echo "Speeding up 3G and WiFi speeds...";
# Network speed Tweaks
busybox echo "0" >> /proc/sys/net/ipv4/ip_dynaddr 2>/dev/null
busybox echo "0" >> /proc/sys/net/ipv4/ip_no_pmtu_disc 2>/dev/null
busybox echo "0" >> /proc/sys/net/ipv4/tcp_ecn 2>/dev/null
busybox echo "1" >> /proc/sys/net/ipv4/tcp_fack 2>/dev/null
busybox echo "4096" >> /proc/sys/net/ipv4/tcp_max_syn_backlog 2>/dev/null
busybox echo "1" >> /proc/sys/net/ipv4/tcp_moderate_rcvbuf 2>/dev/null
busybox echo "187000 187000 187000" >> /proc/sys/net/ipv4/tcp_rmem 2>/dev/null
busybox echo "1" >> /proc/sys/net/ipv4/tcp_rfc1337 2>/dev/null
busybox echo "1" >> /proc/sys/net/ipv4/tcp_sack 2>/dev/null
busybox echo "1" >> /proc/sys/net/ipv4/tcp_timestamps 2>/dev/null
busybox echo "1" >> /proc/sys/net/ipv4/tcp_window_scaling 2>/dev/null
busybox echo "1" >> /proc/sys/net/ipv4/tcp_no_metrics_save 2>/dev/null
sleep 0.6;
 echo "Entropy to the Max..."
# Entropy to the MAX
echo 1000 > /proc/sys/vm/dirty_expire_centisecs
echo 500 > /proc/sys/vm/dirty_writeback_centisecs
echo 1024 > /proc/sys/kernel/random/write_wakeup_threshold
echo 256 > /proc/sys/kernel/random/read_wakeup_threshold
sleep 3
 echo "Quick cache drop..."
sync;
 echo "3" > /proc/sys/vm/drop_caches;
sleep 2
# WiFi Deep Sleep
iptables -tnat -A natctrl_nat_POSTROUTING -s 192.168.0.0/16 -o rmnet0 -j MASQUERADE 2>/dev/null
# Wireless Speed Tweaks
setprop net.rmnet0.dns1 8.8.8.8;
setprop net.rmnet0.dns2 8.8.4.4;
setprop net.dns1 8.8.8.8;
setprop net.dns2 8.8.4.4;
setprop net.tcp.buffersize.wifi 4096,87380,256960,4096,16384,256960;
setprop net.tcp.buffersize.edge 4096,87380,256960,4096,16384,256960;
setprop net.tcp.buffersize.umts 4096,87380,256960,4096,16384,256960;
setprop net.tcp.buffersize.gprs 4096,87380,256960,4096,16384,256960;
setprop net.tcp.buffersize.default 4096,87380,256960,4096,16384,256960;
# Liquid Smooth UI
sleep 0.6;
 echo "Glazing UI with butter...";
setprop persist.service.lgospd.enable 0
setprop persist.service.pcsync.enable 0
setprop windowsmgr.max_events_per_sec 90
setprop touch.presure.scale 0.001
# Hyper I/O
sleep 0.6;
 echo "Boosting I/O read & write speeds...";
echo vr > /sys/block/mmcblk0/queue/scheduler
echo 512 > /sys/devices/virtual/bdi/default/read_ahead_kb
echo 10 > /proc/sys/fs/lease-break-time
# VM Optimization
sleep 0.6;
 echo "Optimizing VM...";
setprop ro.vold.umsdirtyratio 20
echo 1 > /proc/sys/vm/oom_kill_allocating_task
echo 20 > /proc/sys/vm/swappiness
echo 300 > /proc/sys/vm/vfs_cache_pressure
echo 3000 > /proc/sys/vm/dirty_expire_centisecs
echo 500 > /proc/sys/vm/dirty_writeback_centisecs
echo 15 > /proc/sys/vm/dirty_ratio
echo 3 > /proc/sys/vm/dirty_background_ratio
echo 1 >/proc/sys/vm/overcommit_memory;
# Hard rock stabilizer 
sleep 0.6;
 echo "Reducing chances of random reboots...";
echo 0 > /proc/sys/vm/panic_on_oom
echo 0 > /proc/sys/kernel/panic
echo 0 > /proc/sys/kernel/panic_on_oops
# Resource Cleaner
sleep 0.6;
 echo "Refreshing caches...";
sync;
echo 1 > /proc/sys/vm/drop_caches;
sync;
echo 10 > /proc/sys/vm/swappiness
sleep 1;
sync;
echo 1 > /proc/sys/vm/drop_caches;
sync;
echo 0 > /proc/sys/vm/swappiness
sleep 1;
sync;
echo 1 > /proc/sys/vm/drop_caches;
sync;
echo 20 > /proc/sys/vm/swappiness
# Crap Cleaner
sleep 0.6;
 echo "Cleaning rubbish...";
rm -f /data/local/*.apk 2>/dev/null
rm -f /data/local/tmp/*.apk 2>/dev/null 
rm -f /data/*.log 2>/dev/null 
rm -f /data/log/*.log 2>/dev/null
rm -f /cache/*.apk 2>/dev/null
rm -f /cache/*.tmp 2>/dev/null 
rm -f /cache/recovery/* 2>/dev/null 
rm -f /data/system/dropbox/*.txt 2>/dev/null 
rm -f /data/system/usagestats/* 2>/dev/null 
rm -f /data/backup/pending/*.tmp 2>/dev/null 
rm -f /data/tombstones/* 2>/dev/null 
rm -f /sdcard/LOST.DIR/* 2>/dev/null
# Media Server Manager
sleep 0.6;
 echo "Killing media server...";
killall -9 `pidof android.process.media`
# Audio Service Manager
sleep 0.6;
 echo "Disabling HiQuality audio to reduce cpu cycles...";
setprop htc.audio.alt.enable 0
setprop htc.audio.hac.enable 0
setprop af.resampler.quality "255";
setprop af.resample "48000";
setprop ro.audio.samplerate "48000";
setprop ro.audio.pcm.samplerate "48000";
# Ultra Gamer ADJ
sleep 0.6;
 echo "Fixing RAM management for games...";
setprop ro.FOREGROUND_APP_ADJ 8
setprop ro.VISIBLE_APP_ADJ 14
setprop ro.SECONDARY_SERVER_ADJ 40
setprop ro.HIDDEN_APP_MIN_ADJ 50
setprop ro.CONTENT_PROVIDER_ADJ 60
setprop ro.EMPTY_APP_ADJ 75
# Network & Ram Mediator
sleep 0.6;
 echo "Improving networking and RAM priority...";
echo 1048576 > /proc/sys/net/core/wmem_max
echo 1048576 > /proc/sys/net/core/rmem_max
# Cola Engine 7
sleep 0.6;
 echo "Starting Cola Engine...";
cp /mnt/sdcard/hyper-cola/cola_engine_starter.sh /data/local/tmp/cola_engine_starter.sh
chmod 0777 /data/local/tmp/cola_engine_starter.sh
cp /mnt/sdcard/hyper-cola/cola_engine.sh /data/local/tmp/cola_engine.sh
chmod 0777 /data/local/tmp/cola_engine.sh
cd /data/local/tmp/
./cola_engine_starter.sh
echo "Done!";
# Email: diamond.nigel75@Gmail.com
# Sourcecode: https://github.com/Pizza-Dox/
EOF
cp /mnt/sdcard/hyper-cola/hyper.sh /system/xbin/hyper
chown 0.0 /system/xbin/hyper
chmod 777 /system/xbin/hyper
sleep 2;
#cola_engine_starter
cat >> /mnt/sdcard/hyper-cola/cola_engine_starter.sh <<EOF
# Cola Engine Starter
sleep 0.6;
./cola_engine.sh > /dev/null 2>&1 &
EOF
chown 0.0 /mnt/sdcard/hyper-cola/cola_engine_starter.sh
chmod 777 /mnt/sdcard/hyper-cola/cola_engine_starter.sh
#cola_engine
cat >> /mnt/sdcard/hyper-cola/cola_engine.sh <<EOF
# Cola Engine
sync;
echo 3 > /proc/sys/vm/drop_caches;
sleep 60;
echo "#ce_cycle_complete" >>$LOGFILE
EOF
chown 0.0 /mnt/sdcard/hyper-cola/cola_engine.sh
chmod 777 /mnt/sdcard/hyper-cola/cola_engine.sh
#readme
cat >> /mnt/sdcard/hyper-cola/readme.html <<EOF
<br>
Hyper Cola<br>
Copyright © 2015 @ Pizza_Dox<br>
<br>
This script fixes all lag in games and improves FPS greatly!<br>
<br>
Note: Do not delete anything in this folder or havok will be let loose! :)<br>
<br>
email: diamond.nigel75@Gmail.com
<br>
src: https://github.com/Pizza-Dox/
<br>
EOF
 echo "Yay, Installation was successful!";
 echo "To run hyper cola";
 echo "select Start/Stop HC Engine or Hyper Cola from options menu";
sleep 2

#show_menu
clear
logo
menu_options
}

custom_install()
{

#mounting
sync;
busybox mount -o remount,rw /system;
busybox mount -o remount,rw /data;

clear
echo "Welcome to the custom installer $cus_ver..."
sleep 1;
echo " ";

#dir creation
if [ ! -d "/mnt/sdcard/hyper-cola" ]; then
mkdir /mnt/sdcard/hyper-cola
fi

echo "Whats your name?"
echo -n "> "
read $user_name

cat >> /mnt/sdcard/hyper-cola/custom.sh <<EOF
# CCola $cus_ver created by $user_name & Pizza_Dox

#mount required partitions
sync; busybox mount -o remount,rw /
sync; busybox mount -o remount,rw rootfs
sync; busybox mount -o remount,rw /system
sync; busybox mount -o remount,rw /data

#initialize log
LOGFILE=/mnt/sdcard/hyper-cola/clog.txt

#log start time
echo "~ Custom Cola Started @ $( date +"%m-%d-%Y %H:%M:%S" )" >>$LOGFILE

#begin user selected applets
EOF

#call applet menu
custom_install_applet_menu
}

custom_install_applet_menu()
{
sleep 1;
clear
echo ""
echo "Cola applets: "
echo ""
echo "Standard:"
echo "[1] - 1GB RAM management"
echo ""
echo "Imported:"
echo "- Hyper Cola:"
echo "	[2] - Uncap FPS"
echo "	[3] - Render UI with GPU in 16bit mode"
echo "	[4] - Patch RAM leaks"
echo "	[5] - Speed up 3G"
echo "	[6] - Max Entropy"
echo "	[7] - Quick Cache Drop"
echo "	[8] - Enable WiFi Deep Sleep"
echo "	[9] - Speed up WiFi"
echo "	[10] - Improve Touch response"
echo "	[11] - Hyper I/O"
echo "	[12] - Optimize VM"
echo "	[13] - Stabilize Kernel"
echo "	[14] - Clean rubbish"
echo "	[15] - Disable Hi Quality Audio"
echo "	[16] - Enable Ultra Gamer ADJ"
echo "	[17] - Append higher priority to networking"
echo "	[18] - Cola Engine"
echo ""
echo " [D] - Done Selecting, now install!"
echo " [B] - Back"
echo " [E] - Exit"
sleep 4;
read custom_option
    case $custom_option in
        [1] ) spacee && ram_fix_1gb && custom_install_applet_menu;;
		[2] ) spacee && uncap_fps && custom_install_applet_menu;;
		[3] ) gpu_ui;;
		[4] ) ram_patch;;
		[D] ) done_lel;;
		[B] ) menu_install;;
        [E] ) clear && exit;;
        * ) echo " No Fake Coins!";;
    esac
}

done_lel()
{
cp $cus /system/xbin/ccola
chown 0.0 /system/xbin/ccola
chmod 777 /system/xbin/ccola
sleep 2;

echo "";
echo " Yay, Installation was successful!";
echo " To run your CCola";
echo " select Start/Stop CCola from options menu";
sleep 2;

#show_menu
clear
logo
menu_options
}

spacee()
{
	cat $cus >> $custmp
	echo '' >> $custmp
	cp $custmp $cus
}

ram_fix_1gb()
{
	cat $cus >> $custmp
	echo '1gb ram fix' >> $custmp
	cp $custmp $cus
}

uncap_fps()
{
	cat $cus >> $custmp
	echo 'uncap fps' >> $custmp
	cp $custmp $cus
}

#script parser
logo
if [ -e /mnt/sdcard/hyper-cola/readme.html ]; then
	menu_options
fi
menu_install

#email: diamond.nigel75@Gmail.com
#src: https://github.com/Pizza-Dox/
