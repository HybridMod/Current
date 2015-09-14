# Custom settings for session behaviour
# values for all settings should either be 1 or 0.(boolean)
# run bb_apg_2 at start.
run_bb_apg_2=1
# Check Superuser.
run_as_root=1
# Use /dev/urandom for print_RANDOM_BYTE.
use_urand=1
# invert print_RANDOM_BYTE.
invert_rand=1
# launch install() at start.(ONLY FOR REFERENCE, DON'T TOUCH!)
install=0
# launch debug_shell() at start.
debug=0
# Bourne-again Shell only.
bash_only=1
# is running from source
source_only=
until [ "$1" != --debug ] && [ "$1" != --verbose ] && [ "$1" != --supass ] && [ "$1" != --bbpass ] && [ "$1" != --urand ] && [ "$1" != --invrand ] && [ "$1" != --renice ] && [ "$1" != --install ]&& [ "$1" != --source ]; do
	if [ "$1" == --source ]; then
		source_only=1
	elif [ "$1" == --debug ]; then
		if [ "$install" == 1 ]; then
			echo cannot launch two overlapping parameters at a time.
			break
		fi
		debug=1
	elif [ "$1" == --verbose ]; then
		set -x
	elif [ "$1" == --install ]; then
		if [ "$debug" == 1 ]; then
			echo cannot launch two overlapping parameters at a time.
			break
		fi
		install=1
		shift
		save_args=$@
		break
	elif [ "$1" == --supass ] && [ "$run_as_root" != 0 ]; then
		run_as_root=0
	elif [ "$1" == --bbpass ] && [ "$run_bb_apg_2" != 0 ]; then
		run_bb_apg_2=0
	elif [ "$1" == --urand ] && [ "$use_urand" != 1 ]; then
		use_urand=1
	elif [ "$1" == --invrand ] && [ "$invert_rand" != 1 ]; then
		invert_rand=1
	elif [ "$1" == --renice ]; then
		if [ ! "$(echo $2 | sed 's/[0-9]//g' | sed 's/^-//')" ]; then
			if [ "$2" -le 19 ] && [ "$2" -ge -20 ]; then
				renice $2 $$ 1>/dev/null
			else
				echo "parameter input out-of-range!"
				exit 1
			fi
		else
			echo "invalid parameter input!"
			exit 1
		fi
		shift
	fi
	shift
done
version=
if [ "$TERM_PROGRAM" == "Apple_Terminal" ]; then
	term=x1b #Apple
else
	term=e #universal
fi
BASE_NAME=$(basename $0)
NO_EXTENSION=$(echo $BASE_NAME | sed 's/\..*//')
backup_PATH=$PATH
set_PATH=$(dirname $0 | sed 's/^\.//')
set_PATH2=$(pwd)
if [ "$set_PATH" ]; then
	if [ "$(ls / | grep $(echo $set_PATH | sed 's/\//\n/g' | head -n2 | sed ':a;N;s/\n//g;ba'))" ] ; then
		export PATH=$set_PATH:$PATH
	else
		export PATH=$set_PATH2:$PATH
	fi
else
	export PATH=$set_PATH2:$PATH
fi
reg_name=$(which $BASE_NAME 2>/dev/null) # somewhat seems to be incompatible with 1.22.1-stericson.
if [ ! "$reg_name" ]; then
	echo "you are not running this program in proper location. this may cause trouble for codes that use this function: DIR_NAME"
	DIR_NAME="NULL" #'NULL' will go out instead of an actual directory name
else
	DIR_NAME=$(dirname $reg_name | sed 's/^\.//')
fi
export PATH=$backup_PATH # revert back to default
FULL_NAME=$(echo $DIR_NAME/$BASE_NAME)
print_PARTIAL_DIR_NAME(){
	echo $(echo $DIR_NAME | sed 's/\//\n/g' | head -n$(($1+1)) | sed ':a;N;s/\n/\//g;ba')
}
ROOT_DIR=$(print_PARTIAL_DIR_NAME 1)
print_RANDOM_BYTE(){
	if [ "$BASH" ]&&[ "$RANDOM" ]; then
		echo $RANDOM
	else
		bb_apg_2 -f od
		if [ "$?" == 1 ]; then
			error critical command missing. \"error code 2\"
			exit 2
		fi
		if [ "$use_urand" != 1 ]; then
			rand=$(($(od -An -N2 -i /dev/random)%32767))
		else
			rand=$(($(od -An -N2 -i /dev/urandom)%32767))
		fi
		if [ "$invert_rand" == 1 ]; then
			if [ "$rand" -lt 0 ]; then
				rand=$(($((rand*-1))-1))
			fi
		fi
		echo $rand #output
	fi
}

# Checkers 1.0
# You can type in any strings you would want it to print when called.
# It will start by checking from chk1, and its limit is up to chk20.
chk1=what?
chk2="i dont understand!"
chk3=pardon?
chk4="are you retarded?"
checkers(){
	for i in $(seq 1 20); do
		if [ ! "$(eval echo \$chk$i)" ]; then
			i=$((i-1))
			break
		fi
	done
	random=$(print_RANDOM_BYTE)
	random=$((random%i+1))
	echo -n -e "\r$(eval echo \$chk$random) "
}

debug_shell(){
	echo "welcome to the debug_shell program! type in: 'help' for more information."
	echo  -e -n "\\${term}[1;32mdebug-\\${term}[1;33m$version\\${term}[0m"
	if [ "$su_check" == 0 ]; then
		echo -n '# '
	else
		echo -n '$ '
	fi
	while eval read i; do
		case $i in
			randtest | test9) #test9 version.
				trap "echo -e \"\\${term}[2JI LOVE YOU\"; exit" 2
				while true; do
					random=$(print_RANDOM_BYTE)
					x_axis=$((random%$(($(stty size | awk '{print $2}' 2>/dev/null)-1))))
					random=$(print_RANDOM_BYTE)
					y_axis=$((random%$(stty size | awk '{print $1}' 2>/dev/null)))
					random=$(print_RANDOM_BYTE)
					color=$((random%7+31))
					echo -e -n "\\${term}[${y_axis};${x_axis}H\\${term}[${color}m0\\${term}[0m"
				done
			;;
			help)
				echo -e "this debug shell is \\${term}[1;31mONLY\\${term}[0m used for testing conditions inside this program!
you can now use '>' and '>>' for output redirection. use along with 'set -x' for debugging purposes.
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
	-any other functions built-in to this program...
you can use set command to view all the functions and variables built-in to this program.

you can also use these built-in commands in debug_shell:
	-randtest (tests if print_RANDOM_BYTE is functioning properly)
	-help (brings out this message)

debug_shell \\${term}[1;33mv$version\\${term}[0m
Copyright (C) 2013-2015 hoholee12@naver.com"
			;;
			return*)
				exit
			;;
			*)
				if [ "$(echo $i | grep '>')" ]; then
					if [ "$(echo $i | grep '>>')" ]; then
						i=$(echo $i | sed 's/>>/>/')
						if [ "$(echo $i | cut -d'>' -f1)" ]; then
							first_comm=$(echo $i | cut -d'>' -f1)
							second_comm=$(echo $i | sed 's/2>&1//' | cut -d'>' -f2)
							if [ "$(echo $i | grep '2>&1')" ]; then
								eval $first_comm >> $second_comm 2>&1
							else
								eval $first_comm >> $second_comm
							fi
						fi
					else
						if [ "$(echo $i | cut -d'>' -f1)" ]; then
							first_comm=$(echo $i | cut -d'>' -f1)
							second_comm=$(echo $i | sed 's/2>&1//' | cut -d'>' -f2)
							if [ "$(echo $i | grep '2>&1')" ]; then
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
		echo  -e -n "\\${term}[1;32mdebug-\\${term}[1;33m$version\\${term}[0m"
		if [ "$su_check" == 0 ]; then
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
	if [ "$1" == -i ]; then
		for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
			eval echo $i
		done
		return 0
	elif [ "$1" == -s ]; then
		shift
		for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
			if [ "$(eval echo $i)" == "$1" ]; then
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
			if [ "$loc" ]; then
				break
			fi
		done
	fi
	if [ ! "$loc" ]; then
		echo couldnt install, sorry. :p
		return 1
	fi
	echo -e '\rplease wait...'
	loc_DIR_NAME=$(echo $loc | sed 's/\//\n/g' | head -n2 | sed ':a;N;s/\n/\//g;ba')
	mountstat=$(mount | grep $loc_DIR_NAME | head -n1)
	availperm=$(echo $mountstat | grep 'ro\|rw')
	if [ "$availperm" ]; then #linux else unix
		if [ "$(echo $availperm | grep ro)" ]; then
			ro=1
			echo -n -e '\rmounting...'
			mount -o remount,rw $loc_DIR_NAME
		else
			ro=0
		fi
	else
		ro=0
	fi
	if [ -f "$loc/$NO_EXTENSION" ]; then
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
	echo -n -e '\rcopying files...'
	if [ "$DIR_NAME" == NULL ]; then
		cp $0 $loc/$NO_EXTENSION
	else
		cp $FULL_NAME $loc/$NO_EXTENSION
	fi
	error=$?
	chmod 755 $loc/$NO_EXTENSION
	if [ "$ro" == 1 ]; then
		mount -o remount,ro $loc_DIR_NAME
	fi
	unset loc
	if [ "$error" != 0 ]; then
		echo -e "internal error! please use '--verbose' and try again. \\${term}[1;31m\"error code $error\"\\${term}[0m"
		return 1
	else
		echo
		long_line 2
		echo install complete!
		echo type \'$NO_EXTENSION\' to run the program!
	fi
}
long_line(){
	if [ "$1" -gt 1 ]; then
		echo -n -e '\\${term}[3m'
	fi
	for i in $(seq 1 $(stty size | awk '{print $2}' 2>/dev/null)); do
		if [ "$1" -le 1 ]; then
			echo -n '_'
		else
			echo -n ' '
		fi
	done
	if [ "$i" == 1 ]; then
		echo -n -e '\r'
		for j in $(seq 1 80); do # 80 columns
			if [ "$1" -le 1 ]; then
				echo -n '_'
			else
				echo -n ' '
			fi
		done
	fi
	echo -e '\\${term}[0m'
}
part_line(){
	count=$(echo $@ | wc -c)
	for i in $(seq 1 $(($(stty size | awk '{print $2}' 2>/dev/null)-count))); do
		echo -n '_'
	done
	echo $@
}
titlemate(){
	title=$@
	if [ ! "$title" ]; then
		title=$(checkers)
	fi
	echo -n -e '\\${term}[3m'
	if [ "$(($(print_RANDOM_BYTE)%2))" == 0 ]; then
		lines=$(stty size | awk '{print $1}')
		skip=$((lines/10))
		sequence=10
		if [ "$skip" == 0 ]; then
			skip=1
			sequence=$lines
		fi
		for i in $(seq 1 $sequence); do
			echo -n -e "\\${term}[2J\\${term}[$((lines-i*skip));1H$title"
			sleep 0.1
		done
	else
		lines=$(stty size | awk '{print $2}')
		skip=$((lines/10))
		sequence=10
		if [ "$skip" == 0 ]; then
			skip=1
			sequence=$lines
		fi
		for i in $(seq 1 $sequence); do
			echo -n -e "\\${term}[2J\\${term}[1;$((lines-i*skip))H$title"
			sleep 0.1
		done
	fi
	echo -n -e "\\${term}[2J\\${term}[0;0H$title"
	echo -e "\\${term}[0m"
}
arrowkeys(){
	#http://unix.stackexchange.com/questions/179191/bashscript-to-detect-right-arrow-key-being-pressed
	#trap "stty sane; exit 0" 2
	while read -rsn1 ui; do
		case "$ui" in
		$'\x1b')
			read -rsn1 -t 0.1 tmp
			if [ "$tmp" == "[" ]; then
				read -rsn1 -t 0.1 tmp
			fi
			echo $tmp
			# Flush "stdin" with 0.1  sec timeout.
			read -rsn5 -t 0.1
			break
			;;
		*)
			echo $ui
			break;
		;;
		esac
	done
}

error(){
	message=$@
	if [ "$(echo $message | grep \")" ]; then
		echo -n $message | sed 's/".*//'
		errmsg=$(echo $message | cut -d'"' -f2)
		echo -e "\\${term}[1;31m\"$errmsg\"\\${term}[0m"
	else
		echo $message
	fi
	CUSTOM_DIR=$(echo $CUSTOM_DIR | sed 's/\/$//')
	cd /
	for i in $(echo $CUSTOM_DIR | sed 's/\//\n/g'); do
		if [ ! -d $i ]; then
			mkdir $i
			chmod 755 $i
		fi
		cd $i
	done
	if [ "$CUSTOM_DIR" ]; then
		date '+date: %m/%d/%y%ttime: %H:%M:%S ->'"$message"'' >> $CUSTOM_DIR/$NO_EXTENSION.log
	else
		date '+date: %m/%d/%y%ttime: %H:%M:%S ->'"$message"'' >> $DIR_NAME/$NO_EXTENSION.log
	fi
}

# standard.sh
#
# Copyright (C) 2013-2015  hoholee12@naver.com
#
# May be freely distributed and modified as long as copyright
# is retained.
#
# Changelogs:

set +e #error proof

# Busybox Applet Generator 2.4
# You can type in any commands you would want it to check.
# It will start by checking from cmd1, and its limit is up to cmd224.
cmd1=dirname
cmd2=basename
cmd3=ls
cmd4=grep
cmd5=head
cmd6=awk
cmd7=cat
cmd8=cut
cmd= # It notifies the generator how many cmds are available for check. Leave it as blank.

silent_mode= # enabling this will hide errors.
# This feature might not be compatible with some other multi-call binaries.
# if similar applets are found and Busybox do not have them, it will still continue but leave out some error messages regarding compatibility issues.
bb_check= # BB availability.
bb_apg_2(){
	if [ "$1" == -f ]; then
		shift
		used_fopt=1
	elif [ "$1" == -g ]; then
		shift
		used_gopt=1
	fi
	if [ "$used_fopt" == 1 ]||[ "$used_gopt" == 1 ]; then
		silent_mode=1
		if [ "$cmd" ]; then
			if [ "$cmd" -lt 0 ]; then
				cmd=0
			fi
		else
			cmd=224
		fi
		for i in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $i)
			x=$(echo $i | sed 's/^\$//')
			export $x=$v #export everything.
			if [ "$v" ]; then
				unset $x
			else
				break #reduce cycle
			fi
		done
		for j in $(seq 1 $cmd); do
			if [ ! "$1" ]; then
				break
			fi
			export cmd$j=$1
			shift
		done
		export cmd=$j #this will reduce more cycles.
	fi
	bb_check=0
	local n i busyboxloc busyboxenv fail
	if [ ! "$(busybox)" ]; then #allow non-Busybox users to continue.
		bb_check=1
		if [ "$silent_mode" != 1 ]; then
			echo "Busybox does not exist! Busybox is required for best compatibility!"
		fi
		if [ "$cmd" ]; then
			if [ "$cmd" -lt 0 ]; then
				cmd=0
			fi
		else
			cmd=224
		fi
		for i in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $i)
			x=$(echo $i | sed 's/^\$//')
			export $x=$v #export everything.
			if [ "$v" ]; then
				if [ ! "$(which $v)" ]; then
					if [ "$silent_mode" != 1 ]; then
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
			if [ "$i" == "$busyboxloc" ]; then
				busyboxenv=slot$n
			fi
		done
		if [ "$busyboxenv" != slot1 ]; then
			export PATH=$(echo -n $busyboxloc
			for i in $(seq -s ' $slot' 0 $n | sed 's/^0//'); do
				v=$(eval echo $i)
				if [ "$v" != "$busyboxloc" ]; then
					echo -n ":$v"
				fi
			done)
		fi
		if [ "$cmd" ]; then
			if [ "$cmd" -lt 0 ]; then
				cmd=0
			fi
		else
			cmd=224
		fi
		for i in $(seq -s ' $cmd' 0 $cmd | sed 's/^0//'); do
			v=$(eval echo $i)
			x=$(echo $i | sed 's/^\$//')
			export $x=$v #export everything.
			if [ "$v" ]; then
				if [ ! "$(busybox | grep "\<$v\>")" ]; then
					if [ "$silent_mode" != 1 ]; then
						echo -n "required applet: '$v' not embedded in Busybox!"
					fi
					if [ ! "$(which $v)" ]; then
						if [ "$silent_mode" != 1 ]; then
							echo "...and also does not exist!"
						fi
						fail=1 #fail later
					else
						if [ "$silent_mode" != 1 ]; then
							echo
						fi
					fi
				fi
				if [ ! -e "$busyboxloc"/"$v" ]; then
					alias $i="busybox $i"
				fi
			else
				break #reduce cycle
			fi
		done
	fi 2>/dev/null
	if [ "$used_gopt" == 1 ]&&[ "$bb_check" == 1 ]; then
		fail=1 #used_gopt is NOT recommended, unless needed for specific use.
	fi
	if [ "$fail" == 1 ]; then #the fail manager!
		if [ "$used_fopt" == 1 ]||[ "$used_gopt" == 1 ]; then
			unset used_fopt
			unset used_gopt
			return 1
		fi
		echo -e "process terminated. \\${term}[1;31m\"error code 1\"\\${term}[0m"
		return 1
	fi
}

# Check Superuser.
su_check= # root availability
as_root(){
	bb_apg_2 -f id grep sed
	if [ "$?" == 1 ]; then
		error critical command missing. run with --supass for bypassing root check. \"error code 2\"
		exit 2
	fi
	su_check=0
	if [ "$(id | sed 's/(/ /g' | sed 's/ /\n/g' | grep uid | sed 's/uid=//g')" != 0 ]; then
		su_check=1
		echo "Permission denied, are you root?"
		return 1
	fi
}

bash_check=
bash_only(){
	bash_check=0
	if [ ! "$BASH" ]; then
		bashloc=$(which bash)
		if [ "$bashloc" ]; then
			$bashloc $FULL_NAME $@
			exit $?
		fi
		bash_check=1
		error Please re-run this program with BASH. \"error code 1\" #to pass the double-quote character to the error function, you must use the inverted-slash character.
		exit 1
	fi
}

# Session behaviour
Roll_Down(){
	local return

	#first run
	if [ "$run_bb_apg_2" == 1 ]; then
		bb_apg_2
		return=$?
		if [ "$return" -ne 0 ]; then
			exit $return
		fi
	fi
	if [ "$run_as_root" == 1 ]; then
		as_root
		return=$?
		if [ "$return" -ne 0 ]; then
			exit $return
		fi
	fi
	if [ "$bash_only" == 1 ]; then
		bash_only $@
		return=$?
		if [ "$return" -ne 0 ]; then
			exit $return
		fi
	fi

	#second run
	if [ "$debug" == 1 ]; then
		debug_shell
		return=$?
		exit $return
	fi
	if [ "$install" == 1 ]; then
		install $save_args
		return=$?
		exit $return
	fi
}
Roll_Down $@

main(){
	#your script starts here!
	#Demonstration!(you can delete this.)
	case $1 in
		1337)
			leetspeak=1;;
		133+)
			leetspeak=2
	;;
	esac
	random=$(print_RANDOM_BYTE)
	color=$((random%7+31))
	if [ "$leetspeak" == 1 ]; then
		echo -e "\\${term}[${color}mh3ll0, w0rld!\\${term}[0m"
	elif [ "$leetspeak" == 2 ]; then
		echo -e "\\${term}[${color}m|-|3|_|_0, \\/\\/0|2|_|)!\\${term}[0m"
	else
		echo -e "\\${term}[${color}mHello, World!\\${term}[0m"
	fi

	exit 0 #EOF
}

if [ "$source_only" != 1 ]; then
	main $@
fi
