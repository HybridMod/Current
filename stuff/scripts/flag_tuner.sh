#flag_tuner.sh
 
#~info~#
#busybox & su required
#
#custom overlays by oems like samsung, sony, lg & htc apply several
#(so it wont work on cm or aosp based roms because they dont include these settings)
#(actually... some report it works great, so go ahead and at least give it a try!)
#custom build settings to control how the ui and multitasking works
#by disabling most bad ones via the build.prop settings you can smoothen up
#overall transitional events on your device, in return "smoothening" up the ui.
#
#idea by pizza_dox
#inspired by hoholees sched_tuner.sh
 
#vars
ver=1.1
installed_status=0 #reset on runtime

mountdirs(){ #ondemand mounting
        sync;
        busybox mount -o remount,rw /system;
        busybox mount -o remount,rw /sdcard;
}

install_script(){
        echo "installed!" && sleep 2;
        cp /system/build.prop /sdcard/build.prop.backup
echo "# flag_tuner
ENFORCE_PROCESS_LIMIT=false
MAX_SERVICE_INACTIVITY=false
MIN_HIDDEN_APPS=false
MAX_HIDDEN_APPS=false
CONTENT_APP_IDLE_OFFSET=false
EMPTY_APP_IDLE_OFFSET=false
MAX_ACTIVITIES=false
ACTIVITY_INACTIVITY_RESET_TIME=false
MAX_RECENT_TASKS=false
MIN_RECENT_TASKS=false
APP_SWITCH_DELAY_TIME=false
MAX_PROCESSES=false
PROC_START_TIMEOUT=false
CPU_MIN_CHECK_DURATION=false
GC_TIMEOUT=false
SERVICE_TIMEOUT=false
MIN_CRASH_INTERVAL=false" >> /system/build.prop
        sync;
        echo "3" > /proc/sys/vm/drop_caches;
        echo "please reboot asap..."
}

mountdirs #mounting directories
while true;
do
clear

echo -n "flag_tuner $ver "
if [ "`grep flag_tuner /system/build.prop`" ]; then
        echo -n -e 'is: \e[1;32minstalled\e[0m'
        installed_status=1
else
        echo -n -e 'is: \e[1;31mnot installed\e[0m'
        installed_status=0
fi
 
echo
if [ $installed_status -eq 0 ]; then
        echo "install now? [Y/N]"
        echo -n "> "
        read ins_now_opt;
        case $ins_now_opt in
                y|Y) install_script;;
                n|N) echo "cool with me...";;
                *) echo "you had one job..."
        esac
        sleep 1;
fi
if [ $installed_status -eq 1 ]; then
        echo 
        echo "current flags:"
        sleep 1;
fi

if [ "`grep ENFORCE_PROCESS_LIMIT=false /system/build.prop`" ]; then
        echo -e 'ENFORCE_PROCESS_LIMIT=\e[1;32mfalse\e[0m'
fi
if [ "`grep MAX_SERVICE_INACTIVITY=false /system/build.prop`" ]; then
        echo -e 'MAX_SERVICE_INACTIVITY=\e[1;32mfalse\e[0m'
fi
if [ "`grep MAX_HIDDEN_APPS=false /system/build.prop`" ]; then
        echo -e 'MAX_HIDDEN_APPS=\e[1;32mfalse\e[0m'
fi
if [ "`grep MIN_HIDDEN_APPS=false /system/build.prop`" ]; then
        echo -e 'MIN_HIDDEN_APPS=\e[1;32mfalse\e[0m'
fi
if [ "`grep CONTENT_APP_IDLE_OFFSET=false /system/build.prop`" ]; then
        echo -e 'CONTENT_APP_IDLE_OFFSET=\e[1;32mfalse\e[0m'
fi
if [ "`grep EMPTY_APP_IDLE_OFFSET=false /system/build.prop`" ]; then
        echo -e 'EMPTY_APP_IDLE_OFFSET=\e[1;32mfalse\e[0m'
fi
if [ "`grep MAX_ACTIVITIES=false /system/build.prop`" ]; then
        echo -e 'MAX_ACTIVITIES=\e[1;32mfalse\e[0m'
fi
if [ "`grep ACTIVITY_INACTIVITY_RESET_TIME=false /system/build.prop`" ]; then
        echo -e 'ACTIVITY_INACTIVITY_RESET_TIME=\e[1;32mfalse\e[0m'
fi
if [ "`grep MAX_RECENT_TASKS=false /system/build.prop`" ]; then
        echo -e 'MAX_RECENT_TASKS=\e[1;32mfalse\e[0m'
fi
if [ "`grep MIN_RECENT_TASKS=false /system/build.prop`" ]; then
        echo -e 'MIN_RECENT_TASKS=\e[1;32mfalse\e[0m'
fi
if [ "`grep APP_SWITCH_DELAY_TIME=false /system/build.prop`" ]; then
        echo -e 'APP_SWITCH_DELAY_TIME=\e[1;32mfalse\e[0m'
fi
if [ "`grep MAX_PROCESSES=false /system/build.prop`" ]; then
        echo -e 'MAX_PROCESSES=\e[1;32mfalse\e[0m'
fi
if [ "`grep PROC_START_TIMEOUT=false /system/build.prop`" ]; then
        echo -e 'PROC_START_TIMEOUT=\e[1;32mfalse\e[0m'
fi
if [ "`grep CPU_MIN_CHECK_DURATION=false /system/build.prop`" ]; then
        echo -e 'CPU_MIN_CHECK_DURATION=\e[1;32mfalse\e[0m'
fi
if [ "`grep GC_TIMEOUT=false /system/build.prop`" ]; then
        echo -e 'GC_TIMEOUT=\e[1;32mfalse\e[0m'
fi
if [ "`grep SERVICE_TIMEOUT=false /system/build.prop`" ]; then
        echo -e 'SERVICE_TIMEOUT=\e[1;32mfalse\e[0m'
fi
if [ "`grep MIN_CRASH_INTERVAL=false /system/build.prop`" ]; then
        echo -e 'MIN_CRASH_INTERVAL=\e[1;32mfalse\e[0m'
fi

echo
echo "[i]nstall"
echo "[r]emove"
echo "[e]xit"
echo
echo -n "> "
read opt
echo
case $opt in
        [i] )
        cp /sdcard/build.prop.backup /system/build.prop
        #restores original before making any installations
        #makes sure when using a newer script version it does not install more than once
        #and makes sure the user who spams install does not end up with a 2-3mb build.prop
        install_script
        ;;
        [r] ) echo "removed :(" && sleep 2;
        cp /sdcard/build.prop.backup /system/build.prop
        ;;
        [e] ) clear
        busybox mount -o remount,ro /system;
        echo "check out hoholees sched_tuner at xda"
        echo "it works together with this script epicly! :D"
        sleep 1;
        exit;;
        * ) echo "error!";;
esac
done
;;
 
#email: diamond.nigel75@gmail.com
#src: https://github.com/pizza-dox
