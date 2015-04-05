if [ $usagetype == 0 ]; then
  #temp
fi

if [ $usagetype == 1 ]; then
  if [ $initd == 1 ]; then
    $sysrw
    mkdir -p /system/etc/init.d
    touch /system/etc/init.d/#temp
    chmod 755 /system/etc/init.d/#temp
    echo -ne "" > /system/etc/init.d/#temp
cat >> /system/etc/init.d/#temp <<EOF
#!/system/bin/sh
sleep #temp;

#temp

EOF
  fi

  echo "${yellow}Installed!${nc}"

fi

$sysro
