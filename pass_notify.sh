#!/bin/bash
###Script by James Spencer###
###Notify of password expiration###

#This script depends on /etc/aliases populated with email addresses for user accounts.
#Don't forget to run sudo newaliases.
#Solaris 10 systems require gdate to be installed from OpenCSW's coreutils.

today=`date +%F`
host=`hostname`
test=`uname -a`
os=`echo $test | awk '{print $1}'`
ver=`echo $test | awk '{print $3}'`

users=`cat /etc/passwd | awk -F: '{print $1}'`
for user in $users
do
id=`grep -w "^$user" /etc/passwd | awk -F: '{print $3}'`
if [[ "$id" -ge "4000" && "$id" -lt "7000" ]]; then
        if [ "$os" = "Linux" ]; then
                set=`/usr/bin/sudo grep $user /etc/shadow | awk -F: '{print $3}'`
                setdate=`date +%F -d "1970-01-01 $set days"`
                exp=`/usr/bin/sudo grep $user /etc/shadow | awk -F: '{print $5}'`
                expdate=`date +%F -d "$setdate $exp days"`
                expsec=$(($(date -d $expdate +%s) - $(date -d $today +%s)))
                expdays=$(((($expsec / 60) / 60 ) / 24))
                if [[ $expdays -lt "7" && $expdays -gt "0" ]]; then
                        echo "$user, Your password on $host will expire soon in $expdays days." #| mail -s "Password Notification" $user
                fi
        elif [ "$os" = "SunOS" ]; then
                if [ "$ver" = "5.10" ]; then
                        set=`/usr/bin/sudo grep $user /etc/shadow | awk -F: '{print $3}'`
                        setdate=`/opt/csw/bin/gdate +%F -d "1970-01-01 $set days"`
                        exp=`/usr/bin/sudo grep $user /etc/shadow | awk -F: '{print $5}'`
                        expdate=`/opt/csw/bin/gdate +%F -d "$setdate $exp days"`
                        expsec=$(($(/opt/csw/bin/gdate -d $expdate +%s) - $(/opt/csw/bin/gdate -d $today +%s)))
                        expdays=$(((($expsec / 60) / 60 ) / 24))
                        if [[ $expdays -lt "7" && $expdays -gt "0" ]]; then
                                echo "$user, Your password on $host will expire soon in $expdays days." #| mail -s "Password Notification" $user
                        fi
                elif [ "$ver" = "5.11" ]; then
                        set=`/usr/bin/sudo grep $user /etc/shadow | awk -F: '{print $3}'`
                        setdate=`gdate +%F -d "1970-01-01 $set days"`
                        exp=`/usr/bin/sudo grep $user /etc/shadow | awk -F: '{print $5}'`
                        expdate=`gdate +%F -d "$setdate $exp days"`
                        expsec=$(($(gdate -d $expdate +%s) - $(gdate -d $today +%s)))
                        expdays=$(((($expsec / 60) / 60 ) / 24))
                        if [[ $expdays -lt "7" && $expdays -gt "0" ]]; then
                                echo "$user, Your password on $host will expire soon in $expdays days." #| mail -s "Password Notification" $user
                        fi

                fi
        fi
fi
done
