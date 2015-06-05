#SH-OTA v1.1 By Deic and Diamond Bond

#Variables
name="script.sh" #Name of your script
version="1.0_stable" #Version of your script
locallocation="/system/xbin/" #Location of your script on device
cloudlocation="https://www.yourpage.com/script.sh" #Location of your new script in the cloud
check="$EXTERNAL_STORAGE/Download/check.update"
script="$EXTERNAL_STORAGE/Download/$name"

check_update(){ #to be edited past this point
  echo
  echo "Checking updates..."
  sleep 1
  if [ "`grep $version $source/$name`" ]; then
  clear
  rm -f -r $check
  echo
  echo "You have the latest version."
  sleep 1
  safe_exit
  else
  install_update
  fi
}

install_update(){
  echo
  echo "A new version of the script was found..."
  echo
  echo "Want install it? (Y/N)"
  echo
  echo -ne "> "
  read install_update_opt
  case $install_update_opt in
  y|Y) install_update_apply;;
  n|N) safe_exit;;
  *) echo "Write Y or N and press enter..." && install_update;;
  esac
}

install_update_apply(){
  clear
  echo
  echo "Downloading..."
  sleep 1
  am start -a android.intent.action.VIEW -n com.android.browser/.BrowserActivity $download
  sleep 3
  am force-stop com.android.browser
  echo
  echo "Installing..."
  sleep 1
  cp -f -r $script $source
  sleep 2
  chmod 777 $source/$name
  chown 0:0 $source/$name
  echo
  echo "Done."
  sleep 1
  safe_exit
}

safe_exit(){
  rm -f -r $check
  rm -f -r $script
  mount -o remount ro /system
  clear
  exit
}

#start
clear
mount -o remount rw /system
check_update