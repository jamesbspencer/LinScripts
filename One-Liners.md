## Bash One-Liners
#### Account expiration days and date
###### grep "$(awk -F: '($3 > 999) && ($7 != "/sbin/nologin") {print $1}' /etc/passwd)" /etc/shadow | awk -F: '$2 != "!!" { printf "%s %.0f %s \n", $1, (($3 + $5) - (systime() / 86400)), strftime("%F",(($3 + $5) * 86400)) }' | sort -k2 -n | head -n 5
