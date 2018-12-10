#!/bin/bash

sudo sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "select ip from bans where jail = 'sshd';" > ~/bans.txt
sort -u ~/bans.txt > bans_sorted.txt
rm -rf ~/bans.txt
for ip in `cat ~/bans_sorted.txt`
do
#echo $ip
loc=`geoiplookup -f /usr/share/GeoIP/GeoLiteCity.dat $ip | awk -F: '{print $2}'`
echo $ip $loc
echo "-------------------------------------------"
done
