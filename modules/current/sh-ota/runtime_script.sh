# This goes to the top of your script / check_update function
am start -a android.intent.action.VIEW -n com.android.browser/.BrowserActivity https://www.yoursite.com/check.update #URL to download your check.update file
sleep 3 #not necessary
am force-stop com.android.browser
sleep 2 #not necessary
sh $EXTERNAL_STORAGE/Download/check.update #legacy bash does not support the $EXTERNAL_STORAGE variable