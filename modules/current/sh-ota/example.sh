#example.sh v1.1 by Deic & Diamond Bond

# This is your script, the below snippet of code is the code that you want to be at top of your script

check_update(){
	cloudurl=https://www.yoursite.com/check_update #URL to download your check_update file
	
	am start -a android.intent.action.VIEW -n com.android.browser/.BrowserActivity $cloudurl
	sleep 5; #necessary for the check_update script to be downloaded first, then we close the browser activity
	am force-stop com.android.browser
	sh $EXTERNAL_STORAGE/Download/check_update #note: legacy bash does not support the $EXTERNAL_STORAGE variable
} && check_update #this is necessary to actually run the declared function, place this wherever you like

#eg
echo "grabbing update..."
check_update : '
see, we call the update function here to check for updates after some user friendly text tells the
user that they are about to see the browser pop up.
'