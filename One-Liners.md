## Bash One-Liners
#### Accounts with a UID greater than 999, with an interactive shell, their password expires, and their password expired before today. Print the username and how many days ago their password expired.
<sub>sudo awk -F: 'FNR==NR && ($3 > 999) && ($7 != "/sbin/nologin"){a[$1]=$1;next} ($1 in a) && ($5 != "99999") && (($3 + $5) < (systime() / 86400)){ print $1, (($3 + $5) - (systime() / 86400)) }' /etc/passwd /etc/shadow | sort -n -k2</sub>
