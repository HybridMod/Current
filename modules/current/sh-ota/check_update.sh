#check_update.sh v1.2 By Deic and Diamond Bond

var(){
  name="example" #Name of your script - refer to example.sh within this tree
  version="1.0"
  local_location="/system/xbin/$name"
  cloud_location="https://www.yourpage.com/$name-1.1.sh" #notice how the cloud script is .1 ahead of the locally running one 
  check="$EXTERNAL_STORAGE/Download/check_update"
  script="$EXTERNAL_STORAGE/Download/$name"
}

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