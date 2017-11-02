#!/bin/bash

#Download youtube playlists
#The config file is located at /etc/youtube-dl.conf


#The application
ytdl='/usr/local/bin/youtube-dl'



#playlists
pls=()
#Rock
pls+=('https://www.youtube.com/playlist?list=PLis9bth3kzr1c_qvfBuUzTRjOvR45pU3v')

#Check for updates
$ytdl -U

for pl in $pls; do
	$ytdl -w $pl --playlist-random --max-downloads 10
done
