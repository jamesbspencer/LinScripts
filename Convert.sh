#!/bin/bash


#Convert movies to mp4
IFS=$'\n'
files=`find /data/Movies -name "*.mkv" -name "*.avi"`
for m in $files
do
echo $m
name="${m::-4}.mp4"
echo $name
if [ -e "$name" ]
then
	echo "File exists, deleting old file"
	rm -f $m
else
	echo "Converting the file"
	ffmpeg -i $m -vcodec copy -acodec copy $name
	if [ -e "$name" ]
	then
		echo "Deleting the old file"
		rm -rf $m
	fi
fi

done

unset IFS
