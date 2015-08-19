# hybrid.sh created and maintained by DiamondBond, Deic & hoholee12

#!/system/bin/sh

#code snippets from standard.sh by hoholee12
readonly version="2.4"
readonly debug=0 #if blank, it will not show an error.
readonly BASE_NAME=$(basename $0)
readonly NO_EXTENSION=$(echo $BASE_NAME | sed 's/\..*//')
readonly backup_PATH=$PATH
readonly set_PATH=$(dirname $0 | sed 's/^\.//')
readonly set_PATH2=$(pwd)
if [[ "$set_PATH" ]]; then
	if [[ "$(ls / | grep $(echo $set_PATH | sed 's/\//\n/g' | head -n2 | sed ':a;N;s/\n//g;ba'))" ]] ; then
		export PATH=$set_PATH:$PATH
	else
		export PATH=$set_PATH2:$PATH
	fi
else
	export PATH=$set_PATH2:$PATH
fi
reg_name=$(which $BASE_NAME 2>/dev/null) # somewhat seems to be incompatible with 1.22.1-stericson.
if [[ ! "$reg_name" ]]; then
	if [[ "$debug" == 1 ]]; then
		echo "you are not running this program in the required location, this may cause trouble for code that uses the DIR_NAME function."
	fi
	readonly DIR_NAME="NULL" #'NULL' will go out instead of an actual directory name
else
	readonly DIR_NAME=$(dirname $reg_name | sed 's/^\.//')
fi
export PATH=$backup_PATH # revert back to default
readonly FULL_NAME=$(echo $DIR_NAME/$BASE_NAME)
print_PARTIAL_DIR_NAME(){
	echo $(echo $DIR_NAME | sed 's/\//\n/g' | head -n$(($1+1)) | sed ':a;N;s/\n/\//g;ba')
}

readonly ROOT_DIR=$(print_PARTIAL_DIR_NAME 1)

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
FILENAME=$FULL_NAME
FILESIZE=$(wc -c "$FILENAME" 2>/dev/null | awk '{print $1}') #this only works when installed to any exec enabled parts. it is intended.

#options
initd=`if [ -d "$initd_dir" ]; then echo "1"; fi`
zram=`if [ -d /dev/block/zram* ]; then echo "1"; fi`
kcal=`if [ -d /sys/devices/platform/kcal_ctrl.0/ ]; then echo "1"; fi`
permanent=`getprop persist.hybrid.permanent`
interval_time=`getprop persist.hybrid.interval_time`

#symlinks
initd_dir="/system/etc/init.d/"
net_conf="/system/etc/56net.conf"
XSQL="/system/xbin/sqlite3"
BSQL="/system/bin/sqlite3"
SSQL="/sbin/sqlite3"

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

# Use /dev/urandom for print_RANDOM_BYTE.
use_urand=1
# invert print_RANDOM_BYTE.
invert_rand=1

# Busybox Applet Generator 2.4
# You can type in any commands you would want it to check.
# It will start by checking from cmd1, and its limit is up to cmd224.
#cmd1=dirname
#cmd2=basename
#cmd3=ls
#cmd4=grep
#cmd5=head
#cmd6=awk
#cmd7=cat
#cmd8=pgrep
#cmd9=ps
#cmd10=cp
#cmd11=cut
cmd=0 # It notifies the generator how many cmds are available for check. Leave it as blank.

silent_mode=1 # enabling this will hide errors.
# This feature might not be compatible with some other multi-call binaries.
# if similar applets are found and Busybox do not have them, it will still continue but leave out some error messages regarding compatibility issues.
bb_check= # BB availability.

bb_apg_2(){
	if [[ "$1" == -f ]]; then
		shift
		used_fopt=1
	elif [[ "$1" == -g ]]; then
		shift
		used_gopt=1
	fi
	if [[ "$used_fopt" == 1 ]]||[[ "$used_gopt" == 1 ]]; then
		silent_mode=1
		if [[ "$cmd" ]]; then
			if [[ "$cmd" -lt 0 ]]; then
				cmd=0
			fi
		else
			cmd=224
		fi
		for count in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $count)
			x=$(echo $count | sed 's/^\$//')
			export $x=$v #export everything.
			if [[ "$v" ]]; then
				unset $x
			else
				break #reduce cycle
			fi
		done
		for j in $(seq 1 $cmd); do
			if [[ ! "$1" ]]; then
				break
			fi
			export cmd$j=$1
			shift
		done
		export cmd=$j #this will reduce more cycles.
	fi
	bb_check=0
	local n i busyboxloc busyboxenv fail
	if [[ ! "$(busybox)" ]]; then #allow non-Busybox users to continue.
		bb_check=1
		if [[ "$silent_mode" != 1 ]]; then
			echo "Busybox does not exist! Busybox is required for best compatibility!"
		fi
		if [[ "$cmd" ]]; then
			if [[ "$cmd" -lt 0 ]]; then
				cmd=0
			fi
		else
			cmd=224
		fi
		for count in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $count)
			x=$(echo $count | sed 's/^\$//')
			export $x=$v #export everything.
			if [[ "$v" ]]; then
				if [[ ! "$(which $v)" ]]; then
					if [[ "$silent_mode" != 1 ]]; then
						echo "required applet: '$v' does not exist!"
					fi
					fail=1 #fail later
				fi
			else
				break #reduce cycle
			fi
		done
	else
		busyboxloc=$(dirname $(which busybox))
		n=0
		for count in $(echo $PATH | sed 's/:/ /g'); do
			n=$(($n+1))
			export slot$n=$count
			if [[ "$count" == "$busyboxloc" ]]; then
				busyboxenv=slot$n
			fi
		done
		if [[ "$busyboxenv" != slot1 ]]; then
			export PATH=$(echo -n $busyboxloc
			for count in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
				v=$(eval echo $count)
				if [[ "$v" != "$busyboxloc" ]]; then
					echo -n ":$v"
				fi
			done)
		fi
		if [[ "$cmd" ]]; then
			if [[ "$cmd" -lt 0 ]]; then
				cmd=0
			fi
		else
			cmd=224
		fi
		for count in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $count)
			x=$(echo $count | sed 's/^\$//')
			export $x=$v #export everything.
			if [[ "$v" ]]; then
				if [[ ! "$(busybox | grep "\<$v\>")" ]]; then
					if [[ "$silent_mode" != 1 ]]; then
						echo -n "required applet: '$v' not embedded in Busybox!"
					fi
					if [[ ! "$(which $v)" ]]; then
						if [[ "$silent_mode" != 1 ]]; then
							echo "...and also does not exist!"
						fi
						fail=1 #fail later
					else
						if [[ "$silent_mode" != 1 ]]; then
							echo
						fi
					fi
				fi
				if [[ ! -e "$busyboxloc"/"$v" ]]; then
					alias $count="busybox $count"
				fi
			else
				break #reduce cycle
			fi
		done
	fi 2>/dev/null
	if [[ "$used_gopt" == 1 ]] && [[ "$bb_check" == 1 ]]; then
		fail=1 #used_gopt is NOT recommended, unless needed for specific use.
	fi
	if [[ "$fail" == 1 ]]; then #the fail manager!
		if [[ "$used_fopt" == 1 ]] || [[ "$used_gopt" == 1 ]]; then
			unset used_fopt
			unset used_gopt
			return 1
		fi
		echo -e "process terminated. ${red}error code 1${nc}"
		return 1
	fi
}

print_RANDOM_BYTE(){
	if [[ "$BASH" ]] && [[ "$RANDOM" ]]; then
		echo $RANDOM
	else
		bb_apg_2 -f od
		if [[ "$?" == 1 ]]; then
			error critical command missing. \"error code 2\"
			exit 2
		fi
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
		echo $rand #output
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

checkers(){
	for i in $(seq 1 20); do
		if [[ ! "$(eval echo \$chk$i)" ]]; then
			i=$((i-1))
			break
		fi
	done
	random=$(print_RANDOM_BYTE)
	random=$((random%i+1))
	echo -n -e "\r$(eval echo \$chk$random) "
	sleep 1
}

# Checks for Superuser 
su_check= # root availability

as_root_lite(){
	bb_apg_2 -f id grep sed
	if [[ "$?" == 1 ]]; then
		error critical command missing. run with --supass for bypassing root check. \"error code 2\"
		exit 2
	fi
	su_check=0
	if [[ "$(id | sed 's/(/ /g' | sed 's/ /\n/g' | grep uid | sed 's/uid=//g')" != 0 ]]; then
		su_check=1
	fi
}

as_root_lite #modified version of as_root, required for debug_shell

long_line(){
	if [[ "$1" -gt 1 ]]; then
		echo -n -e '\e[3m'
	fi
	for i in $(seq 1 $(stty size | awk '{print $2}' 2>/dev/null)); do
		if [[ "$1" -le 1 ]]; then
			echo -n '_'
		else
			echo -n ' '
		fi
	done
	if [[ "$i" == 1 ]]; then
		echo -n -e '\r'
		for j in $(seq 1 80); do # 80 columns
			if [[ "$1" -le 1 ]]; then
				echo -n '_'
			else
				echo -n ' '
			fi
		done
	fi
	echo -e '\e[0m'
}
part_line(){
	count=$(echo $@ | wc -c)
	for i in $(seq 1 $(($(stty size | awk '{print $2}' 2>/dev/null)-count))); do
		echo -n '_'
	done
	echo $@
}

#Debug Shell
debug_shell(){
	echo "welcome to the debug shell! type in: 'help' for more information."
	echo  -ne "${green}debug-${yellow}$version${nc}"
	if [[ "$su_check" == 0 ]]; then
		echo -n '# '
	else
		echo -n '$ '
	fi
	while eval read i; do
		case $i in
			randtest | test9) #test9 version.
				trap "echo -e \"\e[2JI LOVE YOU\"; exit" 2
				while true; do
					random=$(print_RANDOM_BYTE)
					x_axis=$((random%$(($(stty size | awk '{print $2}' 2>/dev/null)-1))))
					random=$(print_RANDOM_BYTE)
					y_axis=$((random%$(stty size | awk '{print $1}' 2>/dev/null)))
					random=$(print_RANDOM_BYTE)
					color=$((random%7+31))
					echo -ne "\e[${y_axis};${x_axis}H\e[${color}m0\e[0m"
				done
			;;
			help)
				echo -e "this debug shell is ${red}ONLY${nc} used for testing conditions inside this script!
you can now use '>' and '>>' for output redirection, use along with 'set -x' for debugging purposes.
use 'export' if you want to declare a variable.
such includes:
	-functions
	-variables
	-built-in sh or bash commands

instead, you can use these commands built-in to this program:
	-print_PARTIAL_DIR_NAME
	-print_RANDOM_BYTE
	-bb_apg_2
	-as_root
	-or any other functions built-in to this program...
you can use the set command to view all the functions and variables built-in to this program.

you can also use these built-in commands in this debug shell:
	-randtest (tests if print_RANDOM_BYTE is functioning properly)
	-help (prints this message)

debug shell ${yellow}v$version${nc}
Copyright (C) 2013-2015 hoholee12@naver.com"
			;;
			return*)
				exit
			;;
			*)
				if [[ "$(echo $count | grep '>')" ]]; then
					if [[ "$(echo $count | grep '>>')" ]]; then
						i=$(echo $count | sed 's/>>/>/')
						if [[ "$(echo $count | cut -d'>' -f1)" ]]; then
							first_comm=$(echo $count | cut -d'>' -f1)
							second_comm=$(echo $count | sed 's/2>&1//' | cut -d'>' -f2)
							if [[ "$(echo $count | grep '2>&1')" ]]; then
								eval $first_comm >> $second_comm 2>&1
							else
								eval $first_comm >> $second_comm
							fi
						fi
					else
						if [[ "$(echo $count | cut -d'>' -f1)" ]]; then
							first_comm=$(echo $count | cut -d'>' -f1)
							second_comm=$(echo $count | sed 's/2>&1//' | cut -d'>' -f2)
							if [[ "$(echo $count | grep '2>&1')" ]]; then
								eval $first_comm > $second_comm 2>&1
							else
								eval $first_comm > $second_comm
							fi
						fi
					fi
				else
					$i
				fi
			;;
		esac
		echo  -e -n "${green}debug-${yellow}$version${nc}"
		if [[ "$su_check" == 0 ]]; then
			echo -n '# '
		else
			echo -n '$ '
		fi
	done
}

install(){
	local loc # prevent breaks
	n=0
	for i in $(echo $PATH | sed 's/:/ /g'); do
		n=$(($n+1))
		export slot$n=$i
	done
	if [[ "$1" == -i ]]; then
		for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
			eval echo $i
		done
		return 0
	elif [[ "$1" == -s ]]; then
		shift
		for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
			if [[ "$(eval echo $i)" == "$1" ]]; then
				echo found it!
				loc=$1
				break
			fi
		done
	else
		echo $n hits.
		for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
			v=$(eval echo $i)
			echo -n -e "\rwould you like to install it in $v? (y/n) "
			while true; do
				stty cbreak -echo
				f=$(dd bs=1 count=1 2>/dev/null)
				stty -cbreak echo
				echo $f
				case $f in
					y* | Y*)
						loc=$v
						break
					;;
					n* | N*)
						break
					;;
					q* | Q*)
						echo canceled.
						return 0
					;;
					*)
						checkers
					;;
				esac
				echo -n press \'q\' to quit.
			done
			if [[ "$loc" ]]; then
				break
			fi
		done
	fi
	if [[ ! "$loc" ]]; then
		echo couldnt install, sorry. :p
		return 1
	fi
	echo -e '\rplease wait...'
	loc_DIR_NAME=$(echo $loc | sed 's/\//\n/g' | head -n2 | sed ':a;N;s/\n/\//g;ba')
	mountstat=$(mount | grep $loc_DIR_NAME | head -n1)
	availperm=$(echo $mountstat | grep 'ro\|rw')
	if [[ "$availperm" ]]; then #linux else unix
		if [[ "$(echo $mountstat | grep ro)" ]]; then
			ro=1
			echo -n -e '\rmounting...'
			mount -o remount,rw $loc_DIR_NAME
		fi
	else
		ro=0
	fi
	if [[ -f "$loc/$NO_EXTENSION" ]]; then
		echo -n 'program file already exists. overwrite? (y/n) '
		while true; do
			stty cbreak -echo
			f=$(dd bs=1 count=1 2>/dev/null)
			stty -cbreak echo
			echo $f
			case $f in
				y* | Y*)
					break
				;;
				n* | N* | q* | Q*)
					echo canceled.
					return 0
				;;
				*)
					checkers
				;;
			esac
		done
	fi
	if [[ "$(echo $mountstat | grep rw)" ]]; then
		echo -n -e '\rcopying files...'
		cp $0 $loc/$NO_EXTENSION
		if [[ "$?" != 0 ]]; then
			return 1
		fi
		chmod 755 $loc/$NO_EXTENSION
		if [[ "$ro" == 1 ]]; then
			mount -o remount,ro $loc_DIR_NAME
		fi
	else
		if [[ ! "$availperm" ]]; then
			echo -n -e '\rcopying files...'
			cp $0 $loc/$NO_EXTENSION
			if [[ "$?" != 0 ]]; then
				return 1
			fi
			chmod 755 $loc/$NO_EXTENSION
		else
			error=1
		fi
	fi
	unset loc
	if [[ "$error" == 1 ]]; then
		echo -e "internal error! please use '--verbose' and try again. \e[1;31m\"error code 1\"\e[0m"
		return 1
	else
		echo
		long_line 2
		echo install complete!
		echo type \'$NO_EXTENSION\' to run the program!
	fi
}

# Task Killer 1.0 by hoholee12@naver.com
# this program includes:
# target_killer - reads 'exclude_target' and kills the desired ones.
# check_launcher - use this to exclude launcher pid
# debug_space - use this to log details
# task_killer - main program. launch this to start.

exclude_target='^-16\|^-12\|^0\|^1' # exclude target adj
target_killer(){
	for i in $(pgrep -l '' | grep '\<org\.\|\<app\.\|\<com\.\|\<android\.' | grep -v -e ':remote' | awk '{print $1}' | grep -v -e $launcher_pid); do
		if [[ $(grep -v -e $exclude_target /proc/$i/oom_adj) ]]; then
			kill -9 $i
		fi
	done
}

check_launcher(){ # code snippets from boostdemo.sh
	unset launcher_pid
	while true; do
		for launcher in $(grep "<h\>" /data/system/appwidgets.xml | sed 's/ /\n/g' | grep pkg | sed 's/^pkg="//; s/"$//'); do
			launcher_pid=$(pgrep $launcher)
			if [[ "$launcher_pid" ]]; then
				break
			fi
		done
		if [[ "$launcher_pid" ]]; then
			break
		fi
		sleep 1
	done
}

debug_space(){
	space=0
	for i in $(grep -i -e 'memfree\|buffers\|^cached' /proc/meminfo | awk '{print $2}'); do
		space=$((space+i))
	done
	if [[ "$1" == -i ]]; then
		if [[ "$prev_space" ]]; then
			freed=$((space-prev_space))
			if [[ "$freed" -lt 0 ]]; then
				freed=0
			fi
			error freed "$freed"KB of memory.
		fi
		prev_space=$space
	fi
}

task_killer(){
	backuplmk=$(cat /sys/module/lowmemorykiller/parameters/minfree)
	echo "0,0,0,0,0,0" > /sys/module/lowmemorykiller/parameters/minfree
	trap "echo "$backuplmk" > /sys/module/lowmemorykiller/parameters/minfree; exit" EXIT INT TERM
	debug=$1
	if [[ "$debug" == -i ]]; then
		shift
	else
		unset debug
	fi
	sleep=$1
	if [[ ! "$sleep" ]]; then
		sleep=10 #dumpsys refresh time is 10 secs.
	fi
	memlimit=$2
	if [[ ! "$memlimit" ]]; then
		memlimit=$(($(grep -i -e memtotal /proc/meminfo | awk '{print $2}')/2))
	else
		memlimit=$((memlimit*1024))
	fi
	renice 19 $$
	check_launcher
	debug_space
	while true; do
		if [[ "$no_wakelock" == 1 ]]; then
			until [[ "$(cat /sys/class/graphics/fb0/show_blank_event)" == "panel_power_on = 1" ]]; do
				sleep 10
			done
		else
			awake=$(cat /sys/power/wait_for_fb_wake)
		fi
		if [[ "$space" -lt "$memlimit" ]]; then
			target_killer
			if [[ ! "$(pgrep '' | grep "\<$launcher_pid\>")" ]]; then
				check_launcher
			fi
			if [[ "$debug" ]]; then
				debug_space -i
			else
				debug_space
			fi
		else
			debug_space
		fi
		sleep $sleep
	done
}

title(){
	while true; do
		clear

		if [ "$permanent" == 1 ]; then
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

			install_options
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

tweak_dir(){
	if [ "$permanent" == 1 ] && [ "$initd" == 1 ]; then
		tweak_dir=$initd_dir
	else
		tweak_dir="/tmp/"
		mkdir -p /tmp/
		chmod 755 /tmp/
	fi
}

clean_up(){
	clear
	echo "${yellow}Cleaning up...${nc}"
	sleep 1

	tweak_dir
	tweak="$tweak_dir/99clean_up"

	touch $tweak
	chmod 755 $tweak

cat > $tweak <<-EOF
#!/system/bin/sh

sleep 0

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
rm -f /data/local/tmp/*
rm -f /data/last_alog/*
rm -f /data/last_kmsg/*
rm -f /data/mlog/*
rm -f /data/tombstones/*
rm -f /data/system/dropbox/*
rm -f /data/system/usagestats/*
rm -f $EXTERNAL_STORAGE/LOST.DIR/*
EOF

	$tweak
	sed -i 's/sleep 0/sleep 15/' $tweak

	clear
	echo "${yellow}Clean up complete!${nc}"
	sleep 1
}

vm_tune(){
	clear
	echo "${yellow}Optimizing Memory...${nc}"
	sleep 1

	tweak_dir
	tweak="$tweak_dir/75vm"

	touch $tweak
	chmod 755 $tweak

cat > $tweak <<-EOF
#!/system/bin/sh

sysctl -wq vm.dirty_background_ratio=70
sysctl -wq vm.dirty_expire_centisecs=3000
sysctl -wq vm.dirty_ratio=90
sysctl -wq vm.dirty_writeback_centisecs=500
sysctl -wq vm.drop_caches=3
sysctl -wq vm.min_free_kbytes=4096
sysctl -wq vm.oom_kill_allocating_task=1
sysctl -wq vm.overcommit_memory=1
sysctl -wq vm.overcommit_ratio=150
sysctl -wq vm.swappiness=80
sysctl -wq vm.vfs_cache_pressure=10

for i in /sys/devices/virtual/bdi/*/read_ahead_kb; do
	echo "2048" > replace
done
EOF

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

	tweak_dir
	tweak="$tweak_dir/56net"

	touch $tweak
	chmod 755 $tweak

cat > $tweak <<-EOF
#!/system/bin/sh

#TCP
sysctl -pq $net_conf
sysctl -wq net.core.wmem_max=2097152
sysctl -wq net.core.rmem_max=2097152
sysctl -wq net.core.optmem_max=20480
sysctl -wq net.ipv4.tcp_moderate_rcvbuf=1
sysctl -wq net.ipv4.udp_rmem_min=6144
sysctl -wq net.ipv4.udp_wmem_min=6144
sysctl -wq net.ipv4.tcp_timestamps=0
sysctl -wq net.ipv4.tcp_tw_reuse=1
sysctl -wq net.ipv4.tcp_tw_recycle=1
sysctl -wq net.ipv4.tcp_sack=1
sysctl -wq net.ipv4.tcp_window_scaling=1
sysctl -wq net.ipv4.tcp_keepalive_probes=5
sysctl -wq net.ipv4.tcp_keepalive_intvl=156
sysctl -wq net.ipv4.tcp_fin_timeout=30
sysctl -wq net.ipv4.tcp_ecn=0
sysctl -wq net.ipv4.tcp_max_tw_buckets=360000
sysctl -wq net.ipv4.tcp_synack_retries=2
sysctl -wq net.ipv4.route.flush=1
sysctl -wq net.ipv4.icmp_echo_ignore_all=1
sysctl -wq net.core.wmem_max=524288
sysctl -wq net.core.rmem_max=524288
sysctl -wq net.core.rmem_default=110592
sysctl -wq net.core.wmem_default=110592

#IPv4
sysctl -wq net.ipv4.conf.all.rp_filter=1
sysctl -wq net.ipv4.conf.default.rp_filter=1
sysctl -wq net.ipv4.conf.all.accept_redirects=0
sysctl -wq net.ipv4.conf.default.accept_redirects=0
sysctl -wq net.ipv4.conf.all.send_redirects=0
sysctl -wq net.ipv4.conf.default.send_redirects=0
sysctl -wq net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -wq net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -wq net.ipv4.conf.all.accept_source_route=0
sysctl -wq net.ipv4.conf.default.accept_source_route=0
sysctl -wq net.ipv4.conf.all.log_martians=1
sysctl -wq net.ipv4.conf.default.log_martians=1
EOF

	touch $net_conf
	chmod 755 $net_conf
	echo "net.ipv4.tcp_rmem=6144 87380 2097152" > $net_conf
	echo "net.ipv4.tcp_wmem=6144 87380 2097152" >> $net_conf
	$tweak

	clear
	echo "${yellow}Network Optimized!${nc}"
	sleep 1
}

sql_optimize(){
	clear
	echo "${yellow}Checking Databases...${nc}"
	echo

	if [ -f $XSQL ]; then
		chown 0.0  $XSQL
		chmod 755 $XSQL
		SQLOC=$XSQL
	elif [ -f $BSQL ]; then
		chown 0.0 $BSQL
		chmod 755 $BSQL
		SQLOC=$BSQL
	elif [ -f $SSQL ]; then
		chown 0.0 $SSQL
		chmod 755 $SSQL
		SQLOC=$SSQL
	else
		error You do not have sqlite3 binary on your device. \"Fatal error!\" # we need to use error function for debugging. passing the \" char will automatically print the next char in color red.
		return 1
	fi

	for DB in `find / -iname "*.db" 2>/dev/null`; do
		$SQLOC $DB 'VACUUM;'
		echo "${yellow}Optimizing${nc} $DB"
		$SQLOC $DB 'REINDEX;'
	done

	echo
	echo "${yellow}Database optimizations complete!${nc}"

	echo
	echo -n "Press any key to exit..."
	stty cbreak -echo
	dd bs=1 count=1 2>/dev/null
	stty -cbreak echo
}

trim_nand(){
	fstrim -v /cache
	fstrim -v /data
	fstrim -v /system
	
	sleep 1
}

lmk_tune(){
	while true; do
		clear
		echo "${yellow}RAM Profiles${nc}"
		echo
		echo "${yellow}Profiles available:${nc}"
		echo " 1|Balanced"
		echo " 2|Multitasking|"
		echo " 3|Gaming"
		echo
		echo " B|Back"
		echo
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

	tweak_dir
	tweak="$tweak_dir/95lmk"

	touch $tweak
	chmod 755 $tweak

cat > $tweak <<-EOF
#!/system/bin/sh

sleep 0

echo "$minfree_array" > /sys/module/lowmemorykiller/parameters/minfree
EOF

	$tweak
	sed -i 's/sleep 0/sleep 15/' $tweak

	clear
	echo "${yellow}Profile Applied!${nc}"
	sleep 1
}

kernel_kontrol(){
	while true; do
		clear

		echo "${yellow}Kernel Kontrol${nc}"
		echo " 1|Set CPU Freq"
		echo " 2|Set CPU Gov"
		echo " 3|Set I/O Sched"

		if [ "$kcal" == 1 ]; then
			echo " 4|View KCal Values"
		fi

		echo
		echo " B|Back"
		echo
		echo -n "> "
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

	max_freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
	min_freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
	cur_freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
	list_freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies`

	echo "${yellow}CPU Control${nc}"
	echo
	echo "${bld}Max Freq:${nc} $max_freq"
	echo "${bld}Min Freq:${nc} $min_freq"
	echo "${bld}Current Freq:${nc} $cur_freq"
	echo
	echo "${bld}Available Freq's:${nc}"
	echo "$list_freq"
	echo
	echo -n "New Max Freq: "
	read new_max_freq
	echo -n "New Min Freq: "
	read new_min_freq

	tweak_dir
	tweak="$tweak_dir/69cpu_freq"

	touch $tweak
	chmod 755 $tweak

cat > $tweak <<-EOF
#!/system/bin/sh

sleep 0

echo "$new_max_freq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "$new_min_freq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
EOF

	$tweak
	sed -i 's/sleep 0/sleep 20/' $tweak

	clear
	echo "${yellow}New Freq's applied!${nc}"
	sleep 1
}

set_gov(){
	clear

	cur_gov=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
	list_gov=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors`

	echo "${yellow}Governor Control${nc}"
	echo
	echo "${bld}Current Governor:${nc} $cur_gov"
	echo
	echo "${bld}Available Governors:${nc}"
	echo "$list_gov"
	echo
	echo -n "New Governor: "
	read new_gov

	tweak_dir
	tweak="$tweak_dir/70cpu_gov"

	touch $tweak
	chmod 755 $tweak

cat > $tweak <<-EOF
#!/system/bin/sh

sleep 0

echo "$new_gov" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
EOF

	$tweak
	sed -i 's/sleep 0/sleep 20/' $tweak

	clear
	echo "${yellow}New Governor applied!${nc}"
	sleep 1
}


set_io_sched(){
	clear

	cur_io_sched=`cat /sys/block/mmcblk0/queue/scheduler | sed 's/.*\[\([a-zA-Z0-9_]*\)\].*/\1/'`
	list_io_sched=`cat /sys/block/mmcblk0/queue/scheduler | tr -s "[[:blank:]]" "\n" | sed 's/\[\([a-zA-Z0-9_]*\)\]/\1/'`

	echo "${yellow}I/O Schedulder Control${nc}"
	echo
	echo "${bld}Current I/O Scheduler:${nc} $cur_io_sched"
	echo
	echo "${bld}Available I/O Schedulers:${nc}"
	echo "$list_io_sched"
	echo
	echo -n "New Scheduler: "
	read new_io_sched

	tweak_dir
	tweak="$tweak_dir/71io_sched"

	touch $tweak
	chmod 755 $tweak

cat > $tweak <<-EOF
#!/system/bin/sh

sleep 0

for io_sched in /sys/block/*/queue/scheduler; do
	echo "$new_io_sched" > dir
done
EOF

	sed -i 's/dir/$io_sched/' $tweak
	$tweak
	sed -i 's/sleep 0/sleep 20/' $tweak

	clear
	echo "${yellow}New I/O Scheduler applied!${nc}"
	sleep 1
}

kcal(){
 	clear

	if [ "$kcal" == 1 ]; then
		echo "${yellow}Current KCal Values:${nc}"
		rgb=`cat /sys/devices/platform/kcal_ctrl.0/kcal`
		sat=`cat /sys/devices/platform/kcal_ctrl.0/kcal_sat`
		cont=`cat /sys/devices/platform/kcal_ctrl.0/kcal_cont`
		hue=`cat /sys/devices/platform/kcal_ctrl.0/kcal_hue`
		gamma=`cat /sys/devices/platform/kcal_ctrl.0/kcal_val`
		echo "rgb: $rgb, sat: $sat, cont: $cont, hue: $hue, gamma: $gamma"
		echo
		echo -n "Press any key to exit..."
		stty cbreak -echo
		dd bs=1 count=1 2>/dev/null
		stty -cbreak echo
	else
         	checkers
 	fi
}

game_booster(){
	while true; do
		clear
		echo "${yellow}Game Booster${nc}"
		echo " 1|Boost"
		echo " 2|Options"
		echo
		echo " B|Back"
		echo
		echo -n "> "
		read game_booster_opt
		case $game_booster_opt in
			1 )
				game_inject
				break
			;;
			2 )
				game_time_cfg
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

game_inject(){
	while true; do
		clear

		echo "Please leave the terminal emulator running"
		echo "This will continue to run untill close the terminal"
		echo

		sync
		echo "3" > /proc/sys/vm/drop_caches
		am kill-all 2>/dev/null

		free_ram=$(grep MemFree /proc/meminfo | awk '{print $2}')
		echo "Free RAM: $free_ram KB"
		
		stty cbreak -echo
		dd bs=1 count=1 2>/dev/null
		stty -cbreak echo
		read -t 1 game_inject_stop
		case $game_inject_stop in
			* )
				break
			;;
		esac
	
	sleep $interval_time
	done
}

game_time_cfg(){
	clear
	echo "Current rate: $interval_time"
	echo "60 - Every minute - Default"
	echo "3600 - Every hour"
	echo
	echo "Please enter a rate in seconds:"
	echo -n "> "
	read game_time_val
	setprop persist.hybrid.interval_time $game_time_val
	clear
	echo "Time updated!"
	sleep 1
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
	while true; do
		clear
		
		echo "${yellow}Entropy tweak methods:${nc}"
		echo
		entropy_info=$(cat /proc/sys/kernel/random/entropy_avail)
		poolsize_info=$(cat /proc/sys/kernel/random/poolsize)
		echo "Entropy: $entropy_info/$poolsize_info"
		echo
		echo " 1|Normal"
		echo " 2|Experimental (risky)"
		echo
		echo " B|Back"
		echo
		echo -n "> "
		read -t 1 entropy_tweak_opt
		case $entropy_tweak_opt in
			1|2 )
				entropy_tweak_apply
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

entropy_tweak_apply(){
	tweak_dir
	tweak="$tweak_dir/99entropy_tweak"

	touch $tweak
	chmod 0755 $tweak

	if [[ "$entropy_tweak_opt" == "2" ]]; then
cat > $tweak <<-EOF
#!/system/bin/sh

sleep 0

rm -f /dev/random
ln -s /dev/urandom /dev/random
EOF
	else
cat > $tweak <<-EOF
#!/system/bin/sh

sleep 0
EOF
	fi
	
cat >> $tweak <<-EOF
sysctl -w kernel.random.read_wakeup_threshold=1366
sysctl -w kernel.random.write_wakeup_threshold=2048
EOF

	$tweak
	sed -i 's/sleep 0/sleep 15/' $tweak

	part_line Done.
	sleep 1

	break
}

options(){
	while true; do
		clear
		echo "${yellow}Options${nc}"
		echo " 1|Install options"
		echo " 2|Output Logs"
		echo " 3|zRam Settings"
		echo
		echo " B|Back"
		echo
		echo -n "> "
		read options_opt
		case $options_opt in
			1 )
				install_options
			;;
			2 )
				log_out
			;;
			3 )
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

install_options(){
	while true; do
		clear
		echo "${yellow}How to install tweaks?${nc}"
		echo " T|Temporary installs"
		echo " P|Permanent installs"
		echo

		if [[ "$permanent" == "" ]]; then
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
				setprop persist.hybrid.permanent 0
				clear
				echo "Done"
				sleep 1
				break
			;;
			p|P )
				setprop persist.hybrid.permanent 1
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

	if [[ "$LOG_DIR" ]]; then
		cat $LOG_DIR/$NO_EXTENSION.log
	elif [[ "$LOG_NAME" ]]; then # not sure of this
		cat $LOG_NAME/$NO_EXTENSION.log
	else
		echo "Nothing to output."
		return 1
	fi

	echo
	echo -n "Press any key to exit..."
	stty cbreak -echo
	dd bs=1 count=1 2>/dev/null
	stty -cbreak echo
}

zram_settings(){
	while true; do
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
				swapoff -a
				clear
				echo "${yellow}zRAM disabled!${nc}"
				sleep 1
				break
			;;
			2 )
				clear
				echo "${yellow}Enabling zRAM...${nc}"
				sleep 1
				swapon -a
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
	done
}

about_info(){
	while true; do
		clear
		echo "${green}About:${nc}"
		echo

		if [[ "$debug" == "0" ]]; then
			echo "HybridMod Version: $version"
		elif [[ "$debug" == "1" ]]; then
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
	clear
	for i in 3 2 1; do
		echo -n -e "\rFactory reset in $i"
		for j in $(seq 1 $((4-i))); do
			echo -n '.'
		done
		sleep 1
	done
	clear
	echo "Just kidding :] (?)"
	sleep 1
	echo 16 > /proc/sys/kernel/sysrq #0x10 //sync
	echo s > /proc/sysrq-trigger
	echo 128 > /proc/sys/kernel/sysrq #0x80 //reboot
	echo b > /proc/sysrq-trigger
}

safe_exit(){
	clear
	mount -r -o remount /system 2>/dev/null
	exit
}

mount -w -o remount rootfs
mount -w -o remount /system
mount -w -o remount /data

# Previous versions of Android 4.3+ its mksh binary does not create this directory, needed to cat to file temp stdout
mkdir -p /sqlite_stmt_journals/
chmod 0755 /sqlite_stmt_journals/


if [[ "$1" == --debug ]]; then # type 'hybrid --debug' to trigger debug_shell().
	shift
	debug_shell
fi

if [[ "$DIR_NAME" == "NULL" ]]; then # if not installed on any executable directory... this is also intended.
	install -s /system/xbin
	exit
fi

if [[ "$interval_time" == "" ]]; then
	setprop persist.hybrid.interval_time 60
fi

title
