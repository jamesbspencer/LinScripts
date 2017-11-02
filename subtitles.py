#!/usr/bin/env python

#Import modules
import os
from os import path
import sys
import urllib
from xmlrpclib import ServerProxy, Error
import base64
import gzip

#Declare variables
server = ServerProxy('http://api.opensubtitles.org/xml-rpc')
username = ''
password = ''
language = 'en'
useragent = 'OSTestUserAgentTemp'
searchlang = 'eng'
moviedir = '/data/Movies'

#Login to the server
session = server.LogIn(username, password, language, useragent)

#Confirm we've logged in successfully
if session['status'] != '200 OK':
	superPrint("error", "Connection error!", session['status'])
	sys.exit(1)

for movie in os.listdir(moviedir):
	print movie	

	#Search subtitles
	searchparams = []
	searchparams.append({'sublanguageid':searchlang,'query':movie})
	subtitles = server.SearchSubtitles(session['token'], searchparams)

	#print len(subtitles['data'])
	#print subtitles

	fpo = []
	#Get only the results for foreign parts only.
	for result in subtitles['data']:
		if result['SubForeignPartsOnly'] == '1' and result['SubFormat'] == 'srt':
			fpo.append(result)

	#If fpo has content, process it.
	#print len(fpo)
	if len(fpo) >= (1):
	
		#Get the base64 encoded subtitle data
		subfileid = []
		subfileid.append(fpo[0]['IDSubtitleFile'])
		sub = server.DownloadSubtitles(session['token'],subfileid)
	
		#Convert the base64.
		b64 = sub['data'][0]['data']
		gz = base64.b64decode(b64)
		gzfile = movie + '.gz'
		gzpath = os.path.join(moviedir, movie, gzfile)
		f = open(gzpath, 'w')
		f.write(gz)
		f.close()	

		#Convert the gzip to text and write the file.
		srt = gzip.open(gzpath, 'rb')
		srtout =  srt.read()
		srtfile = movie + '.srt'
		srtpath = os.path.join(moviedir, movie, srtfile)
		f = open(srtpath, 'w')
		f.write(srtout)
		f.close()
	
		#Remove the gzip file
		os.remove(gzpath)

#Be nice and log off when we're done
server.LogOut(session['token'])

