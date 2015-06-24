# hybrid.sh by DiamondBond, Deic & Hoholee12

#NOTES (Sign off please)
#Move notes to its own file
#res qs - https://github.com/HybridMod/Current/issues/15 (~Diamond)
#replace all single letter variables with either count if used in loops or a proper variable name. (~Diamond)
#http://explainshell.com/ (~Diamond)

#CodingStyle:
#No single letter variables
#Use tabs
#All tabs are 8 characters
#80 character line limit

#code snippets from standard.sh by hoholee12
readonly version="2.3"
readonly debug=
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

#Master version
ver_revision="2.3-staging"

#SizeOf
FILENAME=$FULL_NAME
#FILESIZE=$(stat -c%s "$FILENAME")
FILESIZE=$(wc -c "$FILENAME" | awk '{print $1}')

#options
initd=`if [ -d $init_dir ]; then echo "1"; else echo "0"; fi`
permanent=`getprop persist.hybrid.permanent`
interval_time=`getprop persist.hybrid.interval_time`

#symlinks
tmp_dir="/data/local/tmp/"
init_dir="/system/etc/init.d/"

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

#directory to put error logs in(it will force-create when directory is nonexistant)
LOG_DIR=/data/log

error(){
	message=$@
	if [[ "$(echo $message | grep \")" ]]; then
		echo -n $message | sed 's/".*//'
		errmsg=$(echo $message | cut -d'"' -f2)
		echo -e "\e[1;31m\"$errmsg\"\e[0m"
	else
		echo $message
	fi
	LOG_DIR=$(echo $LOG_DIR | sed 's/\/$//')
	cd /
	for i in $(echo $LOG_DIR | sed 's/\//\n/g'); do
		if [[ ! -d $i ]]; then
			mkdir $i
			chmod 755 $i
		fi
		cd $i
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
		for i in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $i)
			x=$(echo $i | sed 's/^\$//')
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
		for i in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $i)
			x=$(echo $i | sed 's/^\$//')
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
		for i in $(echo $PATH | sed 's/:/ /g'); do
			n=$(($n+1))
			export slot$n=$i
			if [[ "$i" == "$busyboxloc" ]]; then
				busyboxenv=slot$n
			fi
		done
		if [[ "$busyboxenv" != slot1 ]]; then
			export PATH=$(echo -n $busyboxloc
			for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
				v=$(eval echo $i)
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
		for i in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $i)
			x=$(echo $i | sed 's/^\$//')
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
					alias $i="busybox $i"
				fi
			else
				break #reduce cycle
			fi
		done
	fi 2>/dev/null
	if [[ "$used_gopt" == 1 ]]&&[[ "$bb_check" == 1 ]]; then
		fail=1 #used_gopt is NOT recommended, unless needed for specific use.
	fi
	if [[ "$fail" == 1 ]]; then #the fail manager!
		if [[ "$used_fopt" == 1 ]]||[[ "$used_gopt" == 1 ]]; then
			unset used_fopt
			unset used_gopt
			return 1
		fi
		echo -e "process terminated. \e[1;31m\"error code 1\"\e[0m"
		return 1
	fi
}
print_RANDOM_BYTE(){
	if [[ "$BASH" ]]&&[[ "$RANDOM" ]]; then
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
	echo -ne "\r$(eval echo \$chk$random)"
	sleep 1
}

# Check Superuser.
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

#Debug Shell
debug_shell(){
	echo "welcome to the debug shell! type in: 'help' for more information."
	echo  -ne "\e[1;32mdebug-\e[1;33m$version\e[0m"
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
				echo -e "this debug shell is \e[1;31mONLY\e[0m used for testing conditions inside this script!
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

debug shell \e[1;33mv$version\e[0m
Copyright (C) 2013-2015 hoholee12@naver.com"
			;;
			return*)
				exit
			;;
			*)
				if [[ "$(echo $i | grep '>')" ]]; then
					if [[ "$(echo $i | grep '>>')" ]]; then
						i=$(echo $i | sed 's/>>/>/')
						if [[ "$(echo $i | cut -d'>' -f1)" ]]; then
							first_comm=$(echo $i | cut -d'>' -f1)
							second_comm=$(echo $i | sed 's/2>&1//' | cut -d'>' -f2)
							if [[ "$(echo $i | grep '2>&1')" ]]; then
								eval $first_comm >> $second_comm 2>&1
							else
								eval $first_comm >> $second_comm
							fi
						fi
					else
						if [[ "$(echo $i | cut -d'>' -f1)" ]]; then
							first_comm=$(echo $i | cut -d'>' -f1)
							second_comm=$(echo $i | sed 's/2>&1//' | cut -d'>' -f2)
							if [[ "$(echo $i | grep '2>&1')" ]]; then
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
		echo  -e -n "\e[1;32mdebug-\e[1;33m$version\e[0m"
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
		if [[ "$error" == 1 ]]; then
			echo -e "internal error! please use '--verbose' and try again. \e[1;31m\"error code 1\"\e[0m"
			return 1
		else
			echo
			long_line 2
			echo install complete!
			echo type \'$NO_EXTENSION\' to run the program!
		fi
	fi
}

title(){
	while true; do
		clear
		if [ "$permanent" == "" ]; then
	 		sleep 1; echo "${cyan}The$nc"; sleep 1
	 		echo "$cyan          Hybrid$nc"; sleep 1
	 		echo "$cyan                      Mod$nc"; sleep 1
	 		echo "                                                :)"; sleep 3

	 		install_options
		else
	 		echo "$cyan[-=Hybrid-Mod=-]$nc"
	 		echo

			body
		fi
	done
}

body(){
	echo "${yellow}Menu:$nc"
	echo " 1|Clean up my Crap"
	echo " 2|Optimize my Memory"
	echo " 3|Optimize my Network"
	echo " 4|Optimize my Databases"
	echo " 5|RAM Profiles"
	echo " 6|Kernel Kontrol"
	if [ ! -d /dev/block/zram* ]; then
		zram="0"
		echo " 7|Game Booster"
	else
		zram="1"
		echo " 7|zRAM Settings"
		echo " 8|Game Booster"
	fi
	echo
	echo " O|Options"
	echo " A|About"
	echo
	echo " R|Reboot"
	echo " E|Exit"
	echo
	echo -n "> "
	read selection_opt; case $selection_opt in
		1 ) clean_up;;
		2 ) vm_tune;;
		3 ) network_tune;;
		4 ) sql_optimize;;
		5 ) lmk_tune;;
		6 ) kernel_kontrol;;
		7 ) zram_settings_custom;;
		8 ) game_booster_custom;;
		o|O ) options;;
		a|A ) about_info;;
		r|R ) custom_reboot;;
		e|E ) safe_exit;;
		* ) checkers; title;;
	esac
}

tweak_dir(){
if [ "$permanent" == 1 ] && [ "$initd" == 1 ]; then
tweak_dir=$init_dir
else
tweak_dir=$tmp_dir
fi
}

clean_up(){
	clear; echo "${yellow}Cleaning up...$nc"; sleep 1

	tweak_dir; tweak="$tweak_dir/99clean_up"

	touch $tweak; chmod 755 $tweak
cat > $tweak <<-EOF
#!/system/bin/sh

sleep 0

rm -f /cache/*.apk; rm -f /cache/*.tmp
rm -f /cache/recovery/*; rm -f /data/*.log
rm -f /data/*.txt; rm -f /data/anr/*.*
rm -f /data/backup/pending/*.tmp; rm -f /data/cache/*.*
rm -f /data/dalvik-cache/*.apk; rm -f /data/dalvik-cache/*.tmp
rm -f /data/log/*.*; rm -f /data/local/*.apk
rm -f /data/local/*.log; rm -f /data/local/tmp/*.*
rm -f /data/last_alog/*; rm -f /data/last_kmsg/*
rm -f /data/mlog/*; rm -f /data/tombstones/*
rm -f /data/system/dropbox/*; rm -f /data/system/usagestats/*
rm -f $EXTERNAL_STORAGE/LOST.DIR/*
EOF
	$tweak; sed -i 's/sleep 0/sleep 15/' $tweak

	clear; echo "${yellow}Clean up complete!$nc"; sleep 1

	title
}

vm_tune(){
	clear; echo "${yellow}Optimizing Memory...$nc"; sleep 1

	tweak_dir; tweak="$tweak_dir/75vm"

	touch $tweak; chmod 755 $tweak
cat > $tweak <<-EOF
#!/system/bin/sh

sysctl -wq vm.dirty_background_ratio=70 vm.dirty_expire_centisecs=3000
sysctl -wq vm.dirty_ratio=90 vm.dirty_writeback_centisecs=500
sysctl -wq vm.drop_caches=3 vm.min_free_kbytes=4096
sysctl -wq vm.oom_kill_allocating_task=1 vm.overcommit_memory=1
sysctl -wq vm.overcommit_ratio=150 vm.swappiness=80
sysctl -wq vm.vfs_cache_pressure=10
EOF
	$tweak

	clear; echo "${yellow}Memory Optimized!$nc"; sleep 1

	title
}

network_tune(){
	clear; echo "${yellow}Optimizing Network...$nc"; sleep 1

	tweak_dir; tweak="$tweak_dir/56net"

	touch $tweak; chmod 755 $tweak
cat > $tweak <<-EOF
#!/system/bin/sh

#TCP
touch /system/etc/hybrid.conf
echo net.ipv4.tcp_rmem=6144 87380 2097152 > /system/etc/hybrid.conf
echo net.ipv4.tcp_wmem=6144 87380 2097152 >> /system/etc/hybrid.conf
sysctl -pq /system/etc/hybrid.conf
sysctl -wq net.core.wmem_max=2097152 net.core.rmem_max=2097152
sysctl -wq net.core.optmem_max=20480 net.ipv4.tcp_moderate_rcvbuf=1
sysctl -wq net.ipv4.udp_rmem_min=6144 net.ipv4.udp_wmem_min=6144
sysctl -wq net.ipv4.tcp_timestamps=0 net.ipv4.tcp_tw_reuse=1
sysctl -wq net.ipv4.tcp_tw_recycle=1 net.ipv4.tcp_sack=1
sysctl -wq net.ipv4.tcp_window_scaling=1 net.ipv4.tcp_keepalive_probes=5
sysctl -wq net.ipv4.tcp_keepalive_intvl=156 net.ipv4.tcp_fin_timeout=30
sysctl -wq net.ipv4.tcp_ecn=0 net.ipv4.tcp_max_tw_buckets=360000
sysctl -wq net.ipv4.tcp_synack_retries=2 net.ipv4.route.flush=1
sysctl -wq net.ipv4.icmp_echo_ignore_all=1 net.core.wmem_max=524288
sysctl -wq net.core.rmem_max=524288 net.core.rmem_default=110592
sysctl -wq net.core.wmem_default=110592

#IPv4
sysctl -wq net.ipv4.conf.all.rp_filter=1 net.ipv4.conf.default.rp_filter=1
sysctl -wq net.ipv4.conf.all.accept_redirects=0 net.ipv4.conf.default.accept_redirects=0
sysctl -wq net.ipv4.conf.all.send_redirects=0 net.ipv4.conf.default.send_redirects=0
sysctl -wq net.ipv4.icmp_echo_ignore_broadcasts=1 net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -wq net.ipv4.conf.all.accept_source_route=0 net.ipv4.conf.default.accept_source_route=0
sysctl -wq net.ipv4.conf.all.log_martians=1 net.ipv4.conf.default.log_martians=1
EOF
	$tweak

	clear; echo "${yellow}Network Optimized!$nc"; sleep 1

	title
}

sql_optimize(){
	clear; echo "${yellow}Checking Databases...$nc"
	echo

	XSQL="/system/xbin/sqlite3"
	BSQL="/system/bin/sqlite3"
	SSQL="/sbin/sqlite3"
	if [ -f $XSQL ]; then
		chown 0.0  $XSQL; chmod 755 $XSQL; SQLOC=$XSQL
	elif [ -f $BSQL ]; then
		chown 0.0 $BSQL; chmod 755 $BSQL; SQLOC=$BSQL
	elif [ -f $SSQL ]; then
		chown 0.0 $SSQL; chmod 755 $SSQL; SQLOC=$SSQL
	fi

	for DB in `find / -iname "*.db" 2>/dev/null`; do
		$SQLOC $DB 'VACUUM;'; echo "${yellow}Optimizing$nc $DB"; $SQLOC $DB 'REINDEX;'
	done

	echo
	echo "${yellow}Database optimizations complete!$nc"

	echo
	echo "Press any key to continue..."
	stty cbreak -echo; dd bs=1 count=1 2>/dev/null; stty -cbreak echo

	title
}

lmk_tune(){
	clear; echo "${yellow}RAM Profiles$nc"
	echo
	echo "${yellow}Profiles available:$nc"
	echo " B|Balanced"
	echo " M|Multitasking|"
	echo " G|Gaming"
	echo
	echo " R|Return"
	echo
	echo -n "> "
	read lmk_tune_opt; case $lmk_tune_opt in
		b|B|m|M|g|G ) lmk_profile=$lmk_tune_opt; lmk_apply;;
		r|R ) title;;
		* ) checkers; lmk_tune;;
	esac
}

lmk_apply(){
	clear
	if [ "$lmk_profile" == b ] || [ "$lmk_profile" == B ]; then
    minfree_array='1024,2048,4096,8192,12288,16384'
	fi

	if [ "$lmk_profile" == m ] || [ "$lmk_profile" == M ]; then
    minfree_array='1536,2048,4096,5120,5632,6144'
	fi

	if [ "$lmk_profile" == g ] || [ "$lmk_profile" == G ]; then
    minfree_array='10393,14105,18188,27468,31552,37120'
	fi

	echo "${yellow}Applying Profile...$nc"; sleep 1

	tweak_dir; tweak="$tweak_dir/95lmk"

	touch $tweak; chmod 755 $tweak
cat > $tweak <<-EOF
#!/system/bin/sh

sleep 0

echo "$minfree_array" > /sys/module/lowmemorykiller/parameters/minfree
EOF
	$tweak; sed -i 's/sleep 0/sleep 15/' $tweak

	clear; echo "${yellow}Profile Applied!$nc"; sleep 1

	title
}

kernel_kontrol(){
	clear; echo "${yellow}Kernel Kontrol$nc"
	echo " 1|Set CPU Freq"
	echo " 2|Set CPU Gov"
	echo " 3|Set I/O Sched"
	if [ -d /sys/devices/platform/kcal_ctrl.0/ ]; then
		kcal=1
	 	echo " 4|View KCal Values"
	fi
	echo
	echo " B|Back"
	echo
	echo -n "> "
	read kernel_kontrol_opt; case $kernel_kontrol_opt in
		1) set_cpu_freq;;
		2) set_gov;;
		3) set_io_sched;;
		4) kcal;;
		b|B) title;;
		* ) checkers; kernel_kontrol;;
	 esac
}

set_cpu_freq(){
	clear
	#configure sub variables
	max_freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
	min_freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq`
	cur_freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
	list_freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies`

	echo "${yellow}CPU Control$nc"
	echo
	echo "${bld}Max Freq:$nc $max_freq"
	echo "${bld}Min Freq:$nc $min_freq"
	echo "${bld}Current Freq:$nc $cur_freq"
	echo
	echo "${bld}Available Freq's:$nc"
	echo "$list_freq"
	echo
	echo -n "New Max Freq: "; read new_max_freq
	echo -n "New Min Freq: "; read new_min_freq

	tweak_dir; tweak="$tweak_dir/69cpu_freq"

	touch $tweak; chmod 755 $tweak
cat > $tweak <<-EOF
#!/system/bin/sh

sleep 0

echo "$new_max_freq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "$new_min_freq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
EOF
	$tweak; sed -i 's/sleep 0/sleep 15/' $tweak

	clear; echo "${yellow}New Freq's applied!$nc"; sleep 1

	kernel_kontrol
}

set_gov(){
	clear
	#sub-variables
	cur_gov=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
	list_gov=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors`

	echo "${yellow}Governor Control$nc"
	echo
	echo "${bld}Current Governor:$nc $cur_gov"
	echo
	echo "${bld}Available Governors:$nc"
	echo "$list_gov"
	echo
	echo -n "New Governor: "; read new_gov

	tweak_dir; tweak="$tweak_dir/70cpu_gov"

	touch $tweak;chmod 755 $tweak
cat > $tweak <<-EOF
#!/system/bin/sh

sleep 0

echo "$newgov" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
EOF
	$tweak; sed -i 's/sleep 0/sleep 15/' $tweak

	clear; echo "${yellow}New Governor applied!$nc"; sleep 1

	kernel_kontrol
}


set_io_sched(){
	clear
	#sub-variables
	cur_io_sched=`cat /sys/block/mmcblk0/queue/scheduler | sed 's/.*\[\([a-zA-Z0-9_]*\)\].*/\1/'`
	list_io_sched=`cat /sys/block/mmcblk0/queue/scheduler | tr -s "[[:blank:]]" "\n" | sed 's/\[\([a-zA-Z0-9_]*\)\]/\1/'`

	echo "${yellow}I/O Schedulder Control$nc"
	echo
	echo "${bld}Current I/O Scheduler:$nc $cur_io_sched"
	echo
	echo "${bld}Available I/O Schedulers:$nc"
	echo "$list_io_sched"
	echo
	echo -n "New Scheduler: "; read new_io_sched

	tweak_dir; tweak="$tweak_dir/71io_sched"

	touch $tweak; chmod 755 $tweak
cat > $tweak <<-EOF
#!/system/bin/sh

sleep 0

for io_sched in /sys/block/*/queue/scheduler; do
	echo "$new_io_sched" > dir
done
EOF
	sed -i 's/dir/$io_sched/' $tweak; $tweak; sed -i 's/sleep 0/sleep 15/' $tweak

	clear; echo "${yellow}New I/O Scheduler applied!$nc"; sleep 1

	kernel_kontrol
}

kcal(){
	if [ "$kcal" == "" ]; then
	 	checkers; kernel_kontrol
	fi
 	clear; echo "${yellow}Current KCal Values:${nc}"
	rgb=`cat /sys/devices/platform/kcal_ctrl.0/kcal`
	sat=`cat /sys/devices/platform/kcal_ctrl.0/kcal_sat`
	cont=`cat /sys/devices/platform/kcal_ctrl.0/kcal_cont`
	hue=`cat /sys/devices/platform/kcal_ctrl.0/kcal_hue`
	gamma=`cat /sys/devices/platform/kcal_ctrl.0/kcal_val`
	echo "rgb: $rgb, sat: $sat, cont: $cont, hue: $hue, gamma: $gamma"; sleep 5

	kernel_kontrol
}

zram_settings_custom(){
	if [ "$zram" == 0 ]; then
		game_booster
	elif [ "$zram" == 1 ]; then
		zram_settings
	fi
}

zram_settings(){
	clear; echo "${yellow}zRAM Options:$nc"
	echo " 1|Disable zRAM"
	echo " 2|Enable zRAM"
	echo
	echo " B|Back"
	echo
	echo -n "> "
	read zram_settings_opt; case $zram_settings_opt in
	 	1 ) zram_disable;;
	 	2 ) zram_enable;;
	 	b|B ) title;;
	 	* ) checkers; zram_settings;;
	esac
}

zram_disable(){
	clear; echo "${yellow}Disabling zRAM...$nc"; sleep 1

	for swap_dir in `ls /dev/block/zram*`; do
		swapoff $swap_dir
	done

	clear; echo "${yellow}zRAM disabled!$nc"; sleep 1
	
	zram_settings
}

zram_enable(){
	clear; echo "${yellow}Enabling zRAM...$nc"; sleep 1

	for swap_dir in `ls /dev/block/zram*`; do
		swapon $swap_dir
	done

	clear; echo "${yellow}zRAM enabled!$nc"; sleep 1
	
	zram_settings
}

game_booster_custom(){
	if [ "$zram" == 0 ]; then
		checkers; title
	elif [ "$zram" == 1 ]; then
		game_booster
	fi
}

game_booster(){
	clear; echo "${yellow}Game Booster$nc"
	echo " [1] Boost"
	echo " [2] Options"
	echo
	echo " [B] Back"
	echo
	echo -n "> "
	read game_booster_opt; case $game_booster_opt in
		1 ) game_inject;;
		2 ) game_time_cfg;;
		b|B ) title;;
		* ) checkers; game_booster;;
	esac
}

game_inject(){
	while true; do
		clear; echo "Please leave the terminal emulator running"
		echo "This will continue to run untill close the terminal"
		echo

			sync; echo "3" > /proc/sys/vm/drop_caches; am kill-all 2>/dev/null
		for free_ram in $(grep MemFree /proc/meminfo | awk '{print $2}' ); do
			echo "Free RAM: $free_ram kB"; sleep $interval_time
		done
	done
}

game_time_cfg(){
	clear; echo "Current rate: $interval_time"
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
	
	game_booster
}

options(){
	clear; echo "${yellow}Options$nc"
	echo " I|Install options"
	echo " S|Sensor fix"
	echo
	echo " B|Back"
	echo
	echo -n "> "
	read options_opt; case $options_opt in
	 	i|I ) install_options;;
		s|S ) sensor_fix;;
	 	b|B ) title;;
		* ) checkers; options;;
	esac
}

install_options(){
	clear; echo "${yellow}How to install tweaks?$nc"
	echo " T|Temporary installs"
	echo " P|Permanent installs"
	echo
	if [ "$permanent" == "" ]; then
	 	iGo="title"; iBack="checkers; install_options"
	 	echo "${cyan}You can change it in Options later$nc"
	else
	 	iGo="options"; iBack="options"
	 	echo " B|Back"
	fi
	echo
	echo -n "> "
	read install_options_opt; case $install_options_opt in
	 	t|T ) setprop persist.hybrid.permanent 0; clear; echo "Done"; sleep 1; $iGo;;
		p|P ) setprop persist.hybrid.permanent 1; clear; echo "Done"; sleep 1; $iGo;;
	 	b|B ) $iBack;;
		* ) checkers; install_options;;
	esac
}

sensor_fix(){
	clear; echo "Wipe sensor data? [Y/N]"
	echo
	echo -n "> "
	read sensor_fix_opt; case $sensor_fix_opt in
		y|Y ) rm -rf /data/misc/sensor/; clear; echo "Done"; sleep 1; options;;
		n|N ) options;;
		* ) checkers; sensor_fix;;
	esac
}

about_info(){
	clear; echo "${green}About:$nc"
	echo
	echo "HybridMod Version: $ver_revision"
	echo
	echo "${yellow}INFO$nc"
	echo "This script deals with many things apps normally do."
	echo "But this script is ${cyan}AWESOME!$nc because its only $bld$FILESIZE$nc bytes"
	echo
	echo "${yellow}CREDITS$nc"
	echo "DiamondBond : Script creator & maintainer"
	echo "Deic : Maintainer"
	echo "Hoholee12 : Maintainer"
	echo "Wedgess/Imbawind/Luca020400 : Code $yellow:)$nc"
	echo
	echo "${yellow}Links:$nc"
	echo " F|Forum"
	echo " S|Source"
	echo
	echo " B|Back"
	echo
	echo -n "> "
	read about_info_opt; case $about_info_opt in
	 	f|F ) am start http://forum.xda-developers.com/android/software-hacking/dev-hybridmod-t3135600 >/dev/null 2>&1; about_info;;
	 	s|S ) am start https://github.com/HybridMod >/dev/null 2>&1; about_info;;
	 	b|B ) title;;
	 	* ) checkers; about_info;;
	esac
}

custom_reboot(){
	clear; echo "Factory reset in 3."; sleep 1
	clear; echo "Factory reset in 2.."; sleep 1
	clear; echo "Factory reset in 1..."; sleep 1
	clear; echo "Just kidding :] (?)"; sleep 1
	sync; reboot
}

safe_exit(){
	clear
	mount -o remount,ro /system 2>/dev/null; mount -o remount,ro /data 2>/dev/null
	exit
}

mount -o remount,rw /system; mount -o remount,rw /data

if [ "$1" == --debug ]; then #type 'hybrid --debug' to trigger debug_shell().
	shift; debug_shell
fi
if [ "$DIR_NAME" == NULL ]; then #if not installed on any executable directory...
	install
	exit 0
fi

if [ "$interval_time" == "" ]; then
	setprop persist.hybrid.interval_time 60
fi

title
