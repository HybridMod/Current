#sh-ota-framework v1.2 By Deic and Diamond Bond

var(){
  name="example" #Name of your script - refer to example.sh within this tree
  version="1.0"
  local_location="/system/xbin/"
  cloud_location="https://www.yourpage.com/$name-1.1.sh" #notice how the cloud script is .1 ahead of the locally running one 
  check="$EXTERNAL_STORAGE/Download/check_update"
  script="$EXTERNAL_STORAGE/Download/$name"
}

dl(){
  am start -a android.intent.action.VIEW -n com.android.browser/.BrowserActivity 
}

check_update(){ #to be edited past this point
  echo
  echo "Checking updates..."
  sleep 1
  if [ "`grep $version $local_location/$name`" ]; then
    clear
    rm -f $check
    echo
    echo "You have the latest version."
    safe_exit
  else
    install_update
  fi
}

install_update(){
  echo
  echo "A new version of the script was found..."
  echo
  echo "Would you like to install it? (Y/N)"
  echo
  echo -ne "> "
  read install_update_opt
  case $install_update_opt in
    y|Y) install_update_apply;;
    n|N) safe_exit;;
    *) echo "Y/N" && install_update;;
  esac
}

install_update_apply(){
  clear
  echo
  echo "Downloading..."
  sleep 1
  dl $cloud_location
  sleep 5; #necessary
  am force-stop com.android.browser
  echo
  echo "Installing..."
  sleep 1
  cp -f $script $local_location
  sleep 2
  chmod 777 $local_location/$name
  chown 0:0 $local_location/$name #note to future me: double check these permissions
  echo
  echo "Done."
  sleep 1
  safe_exit
}

safe_exit(){
  rm -f $check
  rm -f $script
  mount -o remount ro /system
  clear
  exit
}

#session behaviour
clear
var
mount -o remount rw /system
check_update