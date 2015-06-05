#!/system/bin/sh
##############################################################################
# Copyright © 2015 @ Pizza_Dox                                               #
# Hyper Cola Standalone™ Created by Pizza_Dox                                #
# Do not Steal this Script or Any Scripts being Installed!                   #
# For more Info Please view the GPL: http://www.gnu.org/licenses/gpl-3.0.txt #
##############################################################################

#main_code
#mount required partitions
sync;
busybox mount -o remount,rw /system;
busybox mount -o remount,rw /data;

#sqlite fix by RenzkiPH
if [ ! -d "mkdir /sqlite_stmt_journals" ]; then
	sync;
	mount -o rw,remount rootfs
	mkdir /mnt/sdcard/hyper-cola
fi

while true;
do
sleep 1;
 echo " ";
clear
 echo "Hyper Cola Package Installer 1.8";
sleep 0.5;
 echo "by Pizza_Dox";
 echo " ";
sleep 2;
 echo "Options:";
sleep 0.5;
 echo "[I] = Install Hyper Cola";
sleep 0.5;
 echo "[U] = Uninstall Hyper Cola";
sleep 0.5;
 echo "[R] = Reboot";
sleep 0.5;
 echo "[E] = Exit";
sleep 0.5;
 echo -n "What would ya like to do?: ";	
read input
case $input in
i|I)
clear
sleep 0.5;
 echo "Installing Hyper Cola..."
sleep 1;
 echo " ";
#script
if [ ! -d "/mnt/sdcard/hyper-cola" ]; then
mkdir /mnt/sdcard/hyper-cola
fi
rm /mnt/sdcard/hyper-cola/hyper.sh 2>/dev/null;
rm /system/xbin/hyper 2>/dev/null;
rm /mnt/sdcard/hyper-cola/cola_engine_starter.sh 2>/dev/null;
rm /mnt/sdcard/hyper-cola/cola_engine.sh 2>/dev/null;
rm /mnt/sdcard/hyper-cola/readme.html 2>/dev/null;
cat >> /mnt/sdcard/hyper-cola/hyper.sh <<EOF
# Hyper Cola 3.4 by Pizza_Dox.
# This script works on all linux devices with busybox installed.
# Please reboot after gaming to preserve battery life and to avoid FC's and errors.

#mount required partitions
sync; busybox mount -o remount,rw /
sync; busybox mount -o remount,rw rootfs
sync; busybox mount -o remount,rw /system
sync; busybox mount -o remount,rw /data

#initialize log
LOGX=/mnt/sdcard/hyper-cola/hc_log.txt
#print sys info
echo "Hyper Cola Started

sys-info:
vendor   : $( getprop ro.product.brand )
model    : $( getprop ro.product.model )
ROM      : $( getprop ro.build.display.id )

running the script...

started at:
$( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOGX

#code
clear
sleep 1;
 echo " ";
 echo "Hyper Cola";
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
echo "render_ui = 16b" | tee -a $LOGX
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
# Entropy to the MAX
echo 1000 > /proc/sys/vm/dirty_expire_centisecs
echo 500 > /proc/sys/vm/dirty_writeback_centisecs
echo 1024 > /proc/sys/kernel/random/write_wakeup_threshold
echo 256 > /proc/sys/kernel/random/read_wakeup_threshold
sleep 3
sync;
sleep 0.5
echo "3" > /proc/sys/vm/drop_caches;
sleep 0.5
sync;
echo "1" > /proc/sys/vm/drop_caches;
sleep 0.5
sync;
echo "entropy = max" | tee -a $LOGX
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
echo "chances = 0" | tee -a $LOGX
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
echo "crap = 0" | tee -a $LOGX
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
 echo "cola_engine_started = $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOGX
EOF
chown 0.0 /mnt/sdcard/hyper-cola/cola_engine_starter.sh
chmod 777 /mnt/sdcard/hyper-cola/cola_engine_starter.sh
#cola_engine
cat >> /mnt/sdcard/hyper-cola/cola_engine.sh <<EOF
# Cola Engine
sync;
echo 3 > /proc/sys/vm/drop_caches;
sleep 60;
echo "cola_engine_executed = $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOGX
EOF
chown 0.0 /mnt/sdcard/hyper-cola/cola_engine.sh
chmod 777 /mnt/sdcard/hyper-cola/cola_engine.sh
#readme
cat >> /mnt/sdcard/hyper-cola/readme.html <<EOF
<br>
Hyper Cola<br>
Copyright © 2014 @ Pizza_Dox<br>
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
 echo "To run hyper cola, type this into a shell:";
 echo "su -c hyper";
sleep 5
;;
u|U)
clear
sleep 0.5
 echo "Uninstalling Hyper Cola";
rm /system/xbin/hyper 2>/dev/null;
sleep 2;
 echo "Done!, Enjoy lagy games again! :P";
;;
r|R)
sleep 0.5
 echo "Time to go ham!";
sleep 0.5
reboot;
;;
e|E)
clear
sleep 0.5
 echo "Bye, Bye, :)";
sleep 0.5
exit 0
;;
*)
sleep 0.5
 echo "You know swiftkey is on discount at the moment, get it while you can you typo maniac!";
sleep 0.5
esac
done
;;
echo "";
# Email: diamond.nigel75@Gmail.com
# Sourcecode: https://github.com/Pizza-Dox/
