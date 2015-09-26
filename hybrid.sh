#!/system/bin/sh
#hybrid.sh created and maintained by DiamondBond, Deic & hoholee12

if [[ "$1" == --install_standard ]]; then
    if [[ ! -f standard.sh ]]; then
        echo standard.sh not on same directory!
        exit 1
    fi
    ./standard.sh --bbpass --install $@ #install standard.sh
fi
if [[ ! -f /usr/bin/standard ]]; then
    echo standard.sh not installed!
    exit 1
fi
source standard --bbpass --source $@ #init library

version="2.4"

SH-OTA(){ #v2.0 By Deic, DiamondBond & hoholee12

    #Edit values
    cloud="https://github.com/DeicPro/Download/releases/download/hybrid/version.sh"

    #Dont edit
    base_name=`basename $0`

    #Mount
    mount -o remount,rw rootfs
    mount -o remount,rw /system
    mount -o remount,rw /data

    #Create dirs
    mkdir -p /tmp/
    chmod 755 /tmp/

    if [ ! -f /system/xbin/curl ]; then
        clear
        echo "Curl binaries not found."
        sleep 1.5
        clear
        echo "Downloading curl binaries..."
        am start -a android.intent.action.VIEW -n com.android.browser/.BrowserActivity https://github.com/DeicPro/Download/releases/download/curl/curl.zip >/dev/null 2>&1
        sleep 10
        curl="1"
    fi

    if [ "$curl" == 1 ]; then
        while true; do
            if [ -f $EXTERNAL_STORAGE/download/curl.zip ]; then
                kill -9 $(pgrep com.android.browser)
                clear
                echo "Installing..."
                unzip -oq $EXTERNAL_STORAGE/download/curl.zip -d /tmp/
                break
            fi
        done

        while true; do
            if [ -f /tmp/curl ] && [ -f /tmp/openssl ] && [ -f /tmp/openssl.cnf ] && [ -f /tmp/ca-bundle.crt ]; then
                #Create dirs
                mkdir /data/local/ssl/
                mkdir /data/local/ssl/certs/
                #Copy binaries / scripts
                cp -f /tmp/curl /system/xbin/
                cp -f /tmp/openssl /system/xbin/
                cp -f /tmp/openssl.cnf /data/local/ssl/
                cp -f /tmp/ca-bundle.crt /data/local/ssl/certs/
                sleep 2
                chmod -R 755 /system/xbin/
                chmod -R 755 /data/local/ssl/
                #Cleanup
                rm -f $EXTERNAL_STORAGE/download/curl.zip
                break
            fi
        done

        while true; do
            if [ -f /system/xbin/curl ] && [ -f /system/xbin/openssl ] && [ -f /data/local/ssl/openssl.cnf ] && [ -f /data/local/ssl/certs/ca-bundle.crt ]; then
                clear
                echo "Installed."
                sleep 1.5
                break
            fi
        done
    fi

    clear
    echo "Checking for updates..."
    curl -k -L -o /tmp/version.sh $cloud 2>/dev/null

    while true; do
        if [ -f /tmp/version.sh ]; then
            if [ "`grep $version /tmp/version.sh 2>/dev/null`" ]; then
                clear
                echo "You have the latest version."
                sleep 1.5
                install="0"
                break
            else
                clear
                echo "A new version of the script was found..."
                echo
                echo "Would you like to install it? (Y/N)"
                echo
                echo -n "> "
                read install_opt
                case $install_opt in
                    y|Y )
                        install="1"
                        break
                    ;;
                    n|N )
                        install="0"
                        break
                    ;;
                    * )
                        echo "Invalid option, please enter either Y/N"
                        sleep 1.5
                    ;;
                esac
            fi
        fi
    done

    if [ "$install"  == 1 ]; then
        clear
        echo "Downloading..."

        for script_cloud in $(grep cloud /tmp/version.sh | awk '{print $2}' ); do
            curl -k -L -o /tmp/$base_name $script_cloud 2>/dev/null
        done
    fi

    while true; do
        if [ "$install" == 0 ]; then
            clear
            break
        fi

        if [ -f /tmp/$base_name ]; then
            clear
            echo "Installing..."
            cp -f /tmp/$base_name $0
            sleep 2
            chmod 755 $0
            clear
            echo "Installed."
            sleep 1.5
            $SHELL -c $0
            clear
            exit
        fi
    done
}

#hashtag in SH-OTA function to testing hybrid.sh
#SH-OTA

#Internal version
revision="2.4.0"

#SizeOf
FILENAME=$(dirname $0)/$(basename $0)
FILESIZE=$(wc -c "$FILENAME" 2>/dev/null | awk '{print $1}') #this only works when installed to any exec enabled parts. it is intended.

#options
initd=$(if [ -d $initd_dir ]; then echo 1; fi)
zram=$(if [ -d /dev/block/zram* ]; then echo 1; fi)
kcal=$(if [ -d /sys/devices/platform/kcal_ctrl.0 ]; then echo 1; fi)

#symlinks
hybrid_dir=/data/local/HybridMod/
permanent_cfg=$hybrid_dir/permanent.cfg
interval_time_cfg=$hybrid_dir/interval_time.cfg
vm_conf=$hybrid_dir/sysctl_vm.conf
net_conf=$hybrid_dir/sysctl_net.conf
initd_dir=/system/etc/init.d/
tmp_dir=data/local/tmp/
xbin_sql=/system/xbin/sqlite3
bin_sql=/system/bin/sqlite3
sbin_sql=/sbin/sqlite3

#color control
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
cyan='\033[0;36m'
white='\033[0;97m'

#format control
bld='\033[0;1m'
blnk='\033[0;5m'
nc='\033[0m'

#directory to throw error logs in (it will force-create when the directory is non-existant)
LOG_DIR=/data/log

#leave this out for compatibility
error(){
    message=$@
    if [[ "$(echo $message | grep \")" ]]; then
        echo -n $message | sed 's/".*//'
        errmsg=$(echo $message | cut -d'"' -f2)
        echo -e "${red}\"$errmsg\"${nc}"
    else
        echo $message
    fi
    LOG_DIR=$(echo $LOG_DIR | sed 's/\/$//')
    cd /
    for count in $(echo $LOG_DIR | sed 's/\//\n/g'); do
        if [[ ! -d $count ]]; then
            mkdir $count
            chmod 755 $count
        fi
        cd $count
    done
    if [[ "$LOG_DIR" ]]; then
        date '+date: %m/%d/%y%ttime: %H:%M:%S ->'"$message"'' >> $LOG_DIR/$NO_EXTENSION.log
    else
        date '+date: %m/%d/%y%ttime: %H:%M:%S ->'"$message"'' >> $LOG_NAME/$NO_EXTENSION.log
    fi
}

# Checkers 1.0
# You can type in any strings you would want it to print when called.
# It will start by checking from chk1, and its limit is up to chk20.
chk1="what?"
chk2="i dont understand!"
chk3="pardon?"
chk4="are you retarded?"
chk5="I no understand enchiladas"
chk6="U WOT M8?!"
#checkers is already embedded in standard.sh

title(){
    while true; do
        clear

        if [ -f $permanent_cfg ]; then
            echo "${cyan}[-=Hybrid-Mod=-]${nc}"
            echo

            body
        else
            sleep 1
            echo "${cyan}The${nc}"
            sleep 1
            echo "${cyan}          Hybrid${nc}"
            sleep 1
            echo "${cyan}                      Mod${nc}"
            sleep 1
            echo "                                                :)"
            sleep 3

            install_settings
        fi
    done
}

body(){
    echo "${yellow}Menu:${nc}"
    echo " 1|Clean up my Crap"
    echo " 2|Optimize my Memory"
    echo " 3|Optimize my Network"
    echo " 4|Optimize my Databases"
    echo " 5|Optimize my Nandroid"
    echo " 6|RAM Profiles"
    echo " 7|Kernel Kontrol"
    echo " 8|Game Booster"
    echo " 9|More"
    echo
    echo " O|Options"
    echo " A|About"
    echo
    echo " R|Reboot"
    echo " E|Exit"
    echo 
    echo -n "> "
    read selection_opt
    case $selection_opt in
        1 )
            clean_up
        ;;
        2 )
            vm_tune
        ;;
        3 )
            network_tune
        ;;
        4 )
            sql_optimize
        ;;
        5 )
            trim_nand
        ;;
        6 )
            lmk_tune
        ;;
        7 )
            kernel_kontrol
        ;;
        8 )
            game_booster
        ;;
        9 )
            more_tweaks
        ;;
        o|O )
            options
        ;;
        a|A )
            about_info
        ;;
        r|R )
            custom_reboot
        ;;
        e|E )
            safe_exit
        ;;
        * )
            checkers
        ;;
    esac
}

tweak_setup(){
    if [ "$(grep 1 $permanent_cfg)" ] && [ "$initd" == 1 ]; then
        tweak_dir=$initd_dir
    else
        tweak_dir=$tmp_dir
    fi
    if [ ! -f /tmp_mksh/tmp_mksh ]; then
        mkdir -p /sqlite_stmt_journals
        chmod 755 /sqlite_stmt_journals/
        #mkdir /tmp_mksh
        #ln -s /system/bin/mksh /tmp_mksh/tmp_mksh
    fi
    if [ -z "$(grep "sleep 20" /system/etc/init.d/00set_initd 2>/dev/null)" ]; then
        mv /system/etc/init.d/00set_initd /system/etc/init.d/00set_initd_backup 2>/dev/null # Who know...
        cat > /system/etc/init.d/00set_initd <<-EOF
#!/system/bin/sh
# Set permissions to /system/etc/init.d directory

sleep 20
mount -w -o remount /system
chmod -R 755 /system/etc/init.d
mount -r -o remount /system
date "+%d/%m/%y %H:%M:%S Init.d works" > /data/test_initd
EOF
        chmod 755 /system/etc/init.d/00set_initd
    fi
}

key_exit(){
    echo
    echo -n "Press any key to exit..."
    stty cbreak -echo
    dd bs=1 count=1 2>/dev/null
    stty -cbreak echo
}

clean_up(){
    clear
    echo "${yellow}Cleaning up...${nc}"
    sleep 1
    tweak_setup
    tweak=$tweak_dir/99clean_up
    cat > $tweak <<-EOF
#!/system/bin/sh

rm -f /tmp/*
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
rm -f /data/log/*
rm -f /data/local/*.apk
rm -f /data/local/*.log
rm -fr /data/local/tmp/*
rm -f /data/last_alog/*
rm -f /data/last_kmsg/*
rm -f /data/mlog/*
rm -fr /data/tombstones/*
rm -f /data/system/dropbox/*
rm -fr /data/system/usagestats/*
rm -f $EXTERNAL_STORAGE/LOST.DIR/*
EOF
    chmod 755 $tweak
    $tweak
    clear
    echo "${yellow}Clean up complete!${nc}"
    sleep 1
}

vm_tune(){
    clear
    echo "${yellow}Optimizing Memory...${nc}"
    sleep 1
    tweak_setup
    tweak=$tweak_dir/75vm
    cat > $vm_conf <<-EOF
# /init.d/75vm

vm.dirty_background_ratio=70
vm.dirty_expire_centisecs=3000
vm.dirty_ratio=90
vm.dirty_writeback_centisecs=500
vm.drop_caches=3
vm.min_free_kbytes=4096
vm.oom_kill_allocating_task=1
vm.overcommit_memory=1
vm.overcommit_ratio=150
vm.swappiness=80
vm.vfs_cache_pressure=10
EOF
    cat > $tweak <<-EOF
#!/system/bin/sh

sysctl -p -q $vm_conf
for i in /sys/devices/virtual/bdi/*/read_ahead_kb; do
    echo "2048" > replace
done
EOF
    chmod 755 $vm_conf
    chmod 755 $tweak
    sed -i 's/replace/$i/' $tweak
    $tweak
    clear
    echo "${yellow}Memory Optimized!${nc}"
    sleep 1
}

network_tune(){
    clear
    echo "${yellow}Optimizing Network...${nc}"
    sleep 1
    tweak_setup
    tweak=$tweak_dir/56net
    cat > $net_conf <<-EOF
# /init.d/56net

## TCP
net.core.wmem_max=2097152
net.core.rmem_max=2097152
net.core.optmem_max=20480
net.ipv4.tcp_moderate_rcvbuf=1
net.ipv4.udp_rmem_min=6144
net.ipv4.udp_wmem_min=6144
net.ipv4.tcp_timestamps=0
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_tw_recycle=1
net.ipv4.tcp_sack=1
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_keepalive_probes=5
net.ipv4.tcp_keepalive_intvl=156
net.ipv4.tcp_fin_timeout=30
net.ipv4.tcp_ecn=0
net.ipv4.tcp_max_tw_buckets=360000
net.ipv4.tcp_synack_retries=2
net.ipv4.route.flush=1
net.ipv4.icmp_echo_ignore_all=1
net.core.wmem_max=524288
net.core.rmem_max=524288
net.core.rmem_default=110592
net.core.wmem_default=110592

##IPv4
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.send_redirects=0
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.icmp_ignore_bogus_error_responses=1
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.default.accept_source_route=0
net.ipv4.conf.all.log_martians=1
net.ipv4.conf.default.log_martians=1
net.ipv4.tcp_rmem=6144 87380 2097152
net.ipv4.tcp_wmem=6144 87380 2097152
EOF
    cat > $tweak <<-EOF
#!/system/bin/sh

sysctl -p -q $net_conf
EOF
    chmod 755 $net_conf
    chmod 755 $tweak
    $tweak
    clear
    echo "${yellow}Network Optimized!${nc}"
    sleep 1
}

sql_optimize(){
    clear
    echo "${yellow}Checking Databases...${nc}
"
    if [ -f $xbin_sql ]; then
        chmod 755 $xbin_sql
        sql_loc=$xbin_sql
    elif [ -f $bin_sql ]; then
        chmod 755 $bin_sql
        sql_loc=$bin_sql
    elif [ -f $sbin_sql ]; then
        chmod 755 $sbin_sql
        sql_loc=$sbin_sql
    else
        error You do not have sqlite3 binary on your device. \"Fatal error!\"
        return 1
    fi
    for i in $(find / -iname "*.db" 2>/dev/null); do
        echo "${yellow}Optimizing${nc} $i..."
        $sql_loc $i 'VACUUM;' 2>/dev/null
        $sql_loc $i 'REINDEX;' 2>/dev/null
        echo "Done.
"
    done
    echo "${yellow}Database optimizations complete!${nc}"

    key_exit
}

trim_nand(){
    clear
    echo Trimming /system...
    fstrim -v /system
    echo Trimming /data...
    fstrim -v /data
    echo Trimming /cache...
    fstrim -v /cache

    key_exit
}

lmk_tune(){
    while true; do
        clear
        echo "${yellow}RAM Profiles${nc}

${yellow}Profiles available:${nc}
 1|Balanced
 2|Multitasking
 3|Gaming

 B|ack"
part_line

echo -n "> "
        read lmk_tune_opt
        case $lmk_tune_opt in
            1 )
                minfree_array='1024,2048,4096,8192,12288,16384'
                lmk_apply
                break
            ;;
            2 )
                minfree_array='1536,2048,4096,5120,5632,6144'
                lmk_apply
                break
            ;;
            3 )
                minfree_array='10393,14105,18188,27468,31552,37120'
                lmk_apply
                break
            ;;
            b|B )
                break
            ;;
            * )
                checkers
            ;;
         esac
     done
}

lmk_apply(){
    clear
    echo "${yellow}Applying Profile...${nc}"
    sleep 1
    tweak_setup
    tweak=$tweak_dir/95lmk
    cat > $tweak <<-EOF
#!/system/bin/sh

echo "$minfree_array" > /sys/module/lowmemorykiller/parameters/minfree
EOF
    chmod 755 $tweak
    $tweak
    clear
    echo "${yellow}Profile Applied!${nc}"
    sleep 1
}

kernel_kontrol(){
    while true; do
        clear
        echo "${yellow}Kernel Kontrol${nc}
 1|Set CPU Freq
 2|Set CPU Gov
 3|Set I/O Sched"
        if [ "$kcal" == "1" ]; then
            echo " 4|View KCal Values"
        fi

        echo "
 B|ack"
part_line
echo -n "
> "
        read kernel_kontrol_opt
        case $kernel_kontrol_opt in
            1)
                set_cpu_freq
            ;;
            2)
                set_gov
            ;;
            3)
                set_io_sched
            ;;
            4)
                kcal
            ;;
            b|B)
                break
            ;;
            * )
                checkers
            ;;
        esac
     done
}

set_cpu_freq(){
    clear
    max_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq)
    min_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq)
    cur_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
    list_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies)
    echo -n "${yellow}CPU Control${nc}

${bld}Max Freq:${nc} $max_freq
${bld}Min Freq:${nc} $min_freq
${bld}Current Freq:${nc} $cur_freq

${bld}Available Freq's:${nc}
$list_freq

New Max Freq: "
    read new_max_freq
    echo -n "New Min Freq: "
    read new_min_freq
    tweak_setup
    tweak=$tweak_dir/69cpu_freq
    cat > $tweak <<-EOF
#!/system/bin/sh

echo "$new_max_freq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "$new_min_freq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
EOF
    chmod 755 $tweak
    $tweak
    clear
    echo "${yellow}New Freq's applied!${nc}"
    sleep 1
}

set_gov(){
    clear
    cur_gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    list_gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)
    echo -n "${yellow}Governor Control${nc}

${bld}Current Governor:${nc} $cur_gov

${bld}Available Governors:${nc}
$list_gov

New Governor: "
    read new_gov
    tweak_setup
    tweak=$tweak_dir/70cpu_gov
    cat > $tweak <<-EOF
#!/system/bin/sh

echo "$new_gov" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
EOF
    chmod 755 $tweak
    $tweak
    clear
    echo "${yellow}New Governor applied!${nc}"
    sleep 1
}


set_io_sched(){
    clear
    cur_io_sched=$(cat /sys/block/mmcblk0/queue/scheduler | sed 's/.*\[\([a-zA-Z0-9_]*\)\].*/\1/')
    list_io_sched=$(cat /sys/block/mmcblk0/queue/scheduler | tr -s "[[:blank:]]" "\n" | sed 's/\[\([a-zA-Z0-9_]*\)\]/\1/')
    echo -n "${yellow}I/O Schedulder Control${nc}

${bld}Current I/O Scheduler:${nc} $cur_io_sched

${bld}Available I/O Schedulers:${nc}
$list_io_sched

New Scheduler: "
    read new_io_sched
    tweak_setup
    tweak=$tweak_dir/71io_sched
    cat > $tweak <<-EOF
#!/system/bin/sh

for io_sched in /sys/block/*/queue/scheduler; do
    echo "$new_io_sched" > dir
done
EOF
    chmod 755 $tweak
    sed -i 's/dir/$io_sched/' $tweak
    $tweak
    clear
    echo "${yellow}New I/O Scheduler applied!${nc}"
    sleep 1
}

kcal(){
    if [ "$kcal" == 1 ]; then
        clear
        rgb=$(cat /sys/devices/platform/kcal_ctrl.0/kcal)
        sat=$(cat /sys/devices/platform/kcal_ctrl.0/kcal_sat)
        cont=$(cat /sys/devices/platform/kcal_ctrl.0/kcal_cont)
        hue=$(cat /sys/devices/platform/kcal_ctrl.0/kcal_hue)
        gamma=$(cat /sys/devices/platform/kcal_ctrl.0/kcal_val)
        echo "${yellow}Current KCal Values:${nc}
rgb: $rgb, sat: $sat, cont: $cont, hue: $hue, gamma: $gamma"
        
        key_exit
    else
             checkers
     fi
}

game_booster(){
    unset i
    while clear; do
        if [ "$i" == s ] || [ "$i" == S ]; then
            unset i
            break
        elif [ "$i" == e ] || [ "$i" == E ]; then
            unset i
            exit
        else
            echo "${yellow}Game Booster${nc}
 [ENTER] = Manual boost
 S|Stop
 E|Exit"
            part_line
            echo "
RAM is boosted every $(cat $interval_time_cfg) second/s if do not close this terminal tab

Total RAM: $(grep MemTotal /proc/meminfo | awk '{print $2}') KB
Free RAM (before): $(grep MemFree /proc/meminfo | awk '{print $2}') KB"
            echo 3 > /proc/sys/vm/drop_caches
            am kill-all 2>&1 >/dev/null
            echo -n "Free RAM (now): $(grep MemFree /proc/meminfo | awk '{print $2}') KB

> "
            read -t $(cat $interval_time_cfg) i
        fi
    done
}

more_tweaks(){
    while true; do
        clear
        echo "${yellow}More${nc}"
        echo
        echo " 1|Sensor fix"
        echo " 2|Entropy tweak"
        echo
        echo " B|Back"
        echo
        echo -n "> "
        read more_tweaks_opt
        case $more_tweaks_opt in
            1 )
                sensor_fix
            ;;
            2 )
                entropy_tweak
            ;;
            b|B )
                break
            ;;
            * )
                checkers
            ;;
        esac
    done
}

sensor_fix(){
    while true; do
        clear
        
        echo "Wipe sensor data? [Y/N]"
        echo
        echo -n "> "
        read sensor_fix_opt
        case $sensor_fix_opt in
            y|Y )
                rm -f -r /data/misc/sensor
                clear
                part_line Done.
                sleep 1
                break
            ;;
            n|N )
                break
            ;;
            * )
                checkers
            ;;
        esac
    done
}

entropy_tweak(){
    unset i
    while clear; do
        if [ "$i" == 1 ] || [ "$i" == 2 ]; then
            entropy_tweak_apply
        elif [ "$i" == b ] || [ "$i" == B ]; then
            unset i
            break
        else
            echo "${yellow}Entropy tweak methods:${nc}
Entropy: $(cat /proc/sys/kernel/random/entropy_avail)/$(cat /proc/sys/kernel/random/poolsize)

 1|Normal
 2|Better (risky)

 B|Back"
            part_line
echo -n "> "
            read -t 1 i
        fi
    done
}

entropy_tweak_apply(){
    tweak_setup
    tweak=$tweak_dir/99entropy_tweak

    if [ "$i" == "2" ]; then
cat > $tweak <<-EOF
#!/system/bin/sh

rm -f /dev/random
ln -s /dev/urandom /dev/random
EOF
    else
cat > $tweak <<-EOF
#!/system/bin/sh
EOF
    fi
    
cat >> $tweak <<-EOF
sysctl -w -q kernel.random.read_wakeup_threshold=1366
sysctl -w -q kernel.random.write_wakeup_threshold=2048
EOF

    chmod 755 $tweak

    $tweak

    echo Done.
    sleep 1
}

options(){
    while true; do
        clear
        echo "${yellow}Options${nc}"
        echo " 1|Debug Shell"
        echo " 2|Output Logs"
        echo " 3|Init.d Support"
        echo " 4|Install Settings"
        echo " 5|Game Booster Settings"
        
        if [ "$zram" == "1" ]; then
            echo " 6|zRAM Settings"
        fi
        
        echo
        echo " B|Back"
        echo
        echo -n "> "
        read options_opt
        case $options_opt in
            1 )
                debug_shell
            ;;
            2 )
                log_out
            ;;
            3 )
                initd_support
            ;;
            4 )
                install_settings
            ;;
            5 )
                game_booster_settings
            ;;
            6 )
                zram_settings
            ;;
            b|B )
                break
            ;;
            * )
                checkers
            ;;
        esac
    done
}

replace_uglyroot(){ # another awesome stuff by me, only need setup the cloud to download supersu.apk & su binary, i'm lazy now xD
    for i in "com.kingroot.*"; do
        pm uninstall $i
        pm uninstall $i
        pm uninstall $i
    done

    cd /system/xbin

    chattr -a -i ku.sud
    chattr -a -i kugote
    chattr -a -i su
    chattr -a -i supolicy
    chattr -a -i pidof

    rm -f ku.sud
    rm -f kugote
    rm -f su
    rm -f supolicy
    rm -f pidof

    cd # <-- directory where is supersu.apk & su binary m8

    cat su > /system/xbin/su
    cat su > /system/xbin/daemonsu
    cat su > /system/xbin/sugote

    cd

    cat /system/bin/sh > /system/xbin/sugote-mksh

    cd /system/xbin

    chown 0.0 su
    chown 0.0 sugote
    chown 0.0 sugote-mksh
    chown 0.0 daemonsu

    chmod 0755 su
    chmod 0755 sugote
    chmod 0755 sugote-mksh
    chmod 0755 daemonsu

    cd

    daemonsu -d

    for i in "com.kingroot.*" ; do
        rm -f /data/app/$i
        rm -f -r /data/data/$i
        rm -f -r /data/data-lib/$i
    done

    rm -f -r /data/data-lib/king

    cd /system/bin

    chattr -a -i /.usr/.ku
    chattr -a -i rt.sh
    chattr -a -i su
    chattr -a -i ddexe-ku.bak
    chattr -a -i ddexe
    chattr -a -i ddexe_real
    chattr -a -i install-recovery.sh
    chattr -a -i install-recovery.sh-ku.bak

    rm -f /.usr/.ku
    rm -f rt.sh
    rm -f su
    rm -f ddexe-ku.bak
    rm -f ddexe
    rm -f ddexe_real
    rm -f install-recovery.sh
    rm -f install-recovery.sh-ku.bak

    cd

    pm uninstall eu.chainfire.supersu

    cd # <-- directory where is supersu.apk & su binary m8

    pm install supersu.apk

    cd /system

    chattr -a -i /usr/iku/isu
    chattr -a -i /etc/install-recovery.sh
    chattr -a -i /etc/install_recovery.sh
    chattr -a -i /etc/install-recovery.sh-ku.bak

    rm -f -r /usr/iku
    rm -f /etc/install-recovery.sh
    rm -f /etc/install_recovery.sh
    rm -f /etc/install-recovery.sh-ku.bak
    
    cd
    
    rm -f -r $EXTERNAL_STORAGE/kingroot
    # left some crap to be deleted in sd, does not important, but if can to be better will be! I'm lazy now to dat xD...
    am start -a android.intent.action.MAIN -n eu.chainfire.supersu/.MainActivity    
}

initd_support(){
    clear

    if [ "$(getprop initd_support.fail)" == '' ]; then
        echo "Checking Init.d Support..."
        sleep 1

        if [ -z "$(grep "run-parts /system/etc/init.d" /system/bin/sysinit 2>/dev/null)" ]; then
            echo "Setting up sysinit file...
"
            sleep 1

            cat >> /system/bin/sysinit <<-EOF
#!/system/bin/sh
# Init.d support

run-parts /system/etc/init.d
EOF

            chmod 755 /system/bin/sysinit

            initd_one=1

            echo "Done.
"
            sleep 1
        elif [ -z "$(grep "/system/etc/install-recovery-2.sh" /system/etc/install-recovery.sh)"]; then
            echo "Setting up install-recovery.sh file...
"
            sleep 1

            cat >> /system/etc/install-recovery.sh <<-EOF
#!/system/bin/sh
# Init.d support

/system/etc/install-recovery-2.sh
EOF

            chmod 755 /system/etc/install-recovery.sh

            initd_two=1

            echo "Done.
"
            sleep 1
        elif [ -z "$(grep "/system/bin/sysinit" /system/etc/install-recovery-2.sh 2>/dev/null)" ]; then
            echo "Setting up install-recovery-2.sh file...
"
            sleep 1

            cat >> /system/etc/install-recovery-2.sh <<-EOF
#!/system/bin/sh
# Init.d support

/system/bin/sysinit
EOF

            chmod 755 /system/etc/install-recovery-2.sh

            initd_three=1

            echo "Done.
"
            sleep 1
        elif [ ! -d /system/etc/init.d ]; then
            echo "Setting up init.d directory...
"
            sleep 1

            mkdir -p /system/etc/init.d

            cat > /system/etc/init.d/00set_initd <<-EOF
#!/system/bin/sh
# Set permissions to /system/etc/init.d directory

sleep 20
mount -w -o remount /system
chmod -R 755 /system/etc/init.d
mount -r -o remount /system
date "+%d/%m/%y %H:%M:%S Init.d works" > /data/test_initd
EOF

            chmod -R 755 /system/etc/init.d

            initd_four=1
        
            echo "Done.
"
            sleep 1
        elif [ "$initd_one" == 1 ] || [ "initd_two" == 1 ] || [ "$initd_three" == 1 ] || [ "$initd_four" == 1 ]; then
            touch /data/first_boot_initd
            echo "Done.

Need reboot to check that Init.d is working, after run HybridMod to check if was successfully.
"
            sleep 5

            custom_reboot
        else
            echo "You have Init.d Support already, do not need do nothing."

            key_exit
        fi
    else
        rm -f /data/first_boot_initd
        while clear; do
            echo -n "Init.d not works :(!!

But there is hope, a second method is waiting for you and may works :)

Want try? [Y/N] > "
            read i
            case $i in
                y|Y)
                    initd_method_two=1
                ;;
                n|N)
                    break
                ;;
                *)
                    checkers
                ;;
            esac
            
            if [ "$init_method_two" == 1 ]; then
                echo Backing up debuggerd file...
                mv /system/bin/debuggerd /system/bin/debuggerd.orig
                echo Setting debuggerd file...
                cat > /system/bin/debuggerd <<-EOF
#!/system/bin/sh
# install-recovery.sh support

if [ "$(getprop install_recovery.support)" == '' ]; then
    /system/etc/install-recovery.sh
    /system/bin/debuggerd.orig
else
    /system/bin/debuggerd.orig
fi
EOF

                chmod 755 /system/bin/debuggerd
                echo Setting up 00set_initd file...
                echo setprop install_recovery.support 1 >> /system/etc/init.d/00set_initd
                touch /data/second_boot_initd

                echo "Done.

Need reboot to check that Init.d is working, after run HybridMod to check if was successfully.
"
                sleep 5

                custom_reboot
        done
}

install_settings(){
    while true; do
        clear
        echo "${yellow}How to install tweaks?${nc}"
        echo " T|Temporary installs"
        echo " P|Permanent installs"
        echo

        if [ ! -f $permanent_cfg ]; then
            iBack="checkers"
            echo "${cyan}You can change it in Options later${nc}"
        else
            iBack="break"
            echo " B|Back"
        fi

        echo
        echo -n "> "
        read install_options_opt
        case $install_options_opt in
            t|T )
                echo 0 > $permanent_cfg
                clear
                echo "Done"
                sleep 1
                break
            ;;
            p|P )
                echo 1 > $permanent_cfg
                clear
                echo "Done"
                sleep 1
                break
            ;;
            b|B )
                $iBack
            ;;
            * )
                checkers
            ;;
        esac
    done
}

log_out(){
    clear

    if [ -f "$LOG_DIR/$NO_EXTENSION.log" ]; then
        cat $LOG_DIR/$NO_EXTENSION.log
    elif [ -f "$LOG_NAME/$NO_EXTENSION.log" ]; then
        cat $LOG_NAME/$NO_EXTENSION.log
    else
        echo "Nothing to output."
        sleep 1
        return 1
    fi

    key_exit
}

game_booster_settings(){
    clear
    echo "Current rate: $(cat $interval_time_cfg)"
    echo "60 - Every minute - Default"
    echo "3600 - Every hour"
    echo
    echo "Please enter a rate in seconds:"
    echo -n "> "
    read game_time_val
    echo $game_time_val > $interval_time_cfg
    clear
    echo "Time updated!"
    sleep 1
}

zram_settings(){
    while true; do
        if [ "$zram" == "1" ]; then
            clear

            echo "${yellow}zRAM Options:${nc}"
            echo " 1|Disable zRAM"
            echo " 2|Enable zRAM"
            echo
            echo " B|Back"
            echo
            echo -n "> "
            read zram_settings_opt
            case $zram_settings_opt in
                1 )
                    clear
                    echo "${yellow}Disabling zRAM...${nc}"
                    sleep 1
                    swapoff /dev/block/zram*
                    clear
                    echo "${yellow}zRAM disabled!${nc}"
                    sleep 1
                    break
                ;;
                2 )
                    clear
                    echo "${yellow}Enabling zRAM...${nc}"
                    sleep 1
                    swapon /dev/block/zram*
                    clear
                    echo "${yellow}zRAM enabled!${nc}"
                    sleep 1
                    break
                ;;
                b|B )
                    break
                ;;
                * )
                    checkers
                ;;
            esac
        else
            checkers
            break
        fi
    done
}

about_info(){
    while true; do
        clear
        echo "${green}About:${nc}"
        echo

        if [ "$debug" == "0" ]; then
            echo "HybridMod Version: $version"
        elif [ "$debug" == "1" ]; then
            echo "HybridMod Revision: $revision"
        fi

        echo
        echo "${yellow}INFO${nc}"
        echo "This script deals with many things apps normally do."
        echo "But this script is ${cyan}AWESOME!${nc} because its only ${bld}$FILESIZE${nc} bytes"
        echo
        echo "${yellow}CREDITS${nc}"
        echo "DiamondBond : Script creator & maintainer"
        echo "Deic/hoholee12 : Maintainers"
        echo "Wedgess/Imbawind/Luca020400 : Code ${yellow}:)${nc}"
        echo
        echo "${yellow}Links:${nc}"
        echo " 1|Forum"
        echo " 2|Source"
        echo
        echo " B|Back"
        echo
        echo -n "> "
        read about_info_opt
        case $about_info_opt in
            1 )
                am start http://forum.xda-developers.com/android/software-hacking/dev-hybridmod-t3135600 >/dev/null 2>&1
            ;;
            2 )
                am start https://github.com/HybridMod >/dev/null 2>&1
            ;;
            b|B )
                break
            ;;
            * )
                checkers
            ;;
        esac
    done
}

custom_reboot(){
    while true; do
        clear
    
        echo "Are you sure? [Y/N]"
        echo
        echo -n "> "
        read reboot_opt
        case $reboot_opt in
            y|Y )
                for i in 3 2 1; do
                    echo -e -n "\rFactory reset in $i"
                    for j in $(seq 1 $((4-i))); do
                    echo -n '.'
                    done
                    sleep 1
                done
                clear
                echo "Just kidding :] (?)"
                sleep 1
                echo 16 > /proc/sys/kernel/sysrq # 0x10 //sync
                echo s > /proc/sysrq-trigger
                echo 128 > /proc/sys/kernel/sysrq # 0x80 //reboot
                echo b > /proc/sysrq-trigger
            ;;
            n|N )
                break
            ;;
            * )
                checkers
            ;;
        esac
    done
}

safe_exit(){
    clear
    mount -r -o remount /system 2>/dev/null
    exit
}

mount -w -o remount rootfs
mount -w -o remount /system

if [ "$1" == --debug ]; then #type 'hybrid --debug' to trigger debug_shell().
    shift
    debug_shell
fi

if [ "$DIR_NAME" == NULL ]; then #if not installed on any executable directory... this is also intended.
    install -s /system/xbin
    exit
fi

if [ ! -f $interval_time_cfg ]; then
   mkdir -p $hybrid_dir
	echo 60 > $interval_time_cfg
fi

if [ ! -f /data/test_initd ] && [ -f /data/first_boot_initd ]; then
    setprop initd_support.fail 1
    initd_support
elif [ -f /data/test_initd ] && [ -f /data/first_boot_initd ]; then
    echo Init.d works! Nothing more to do :)
    sleep 3
    rm -f /data/first_boot_initd
elif [ ! -f /data/test_initd ] && [ -f /data/second_boot_initd ]; then
    echo Init.d not works :S. Nothing to do at the moment...
    sleep 3
elif [ -f /data/test_initd ] && [ -f /data/second_boot_initd ]; then
    echo Init.d works! Nothing more to do :)
    sleep 3
    rm -f /data/second_boot_initd
fi

title
