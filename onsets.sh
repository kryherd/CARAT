#!/usr/bin/env bash

for expRun in SPONT_2 # change runs here
do
	# this loop runs the next loop for each run that you specify
	cp ./${expRun}/${expRun}.res/Session_Data/*Session_Data.txt ./
	echo "Subject Onset" > ${expRun}-onsets.txt
	for i in 07 #change subject numbers here
	do
		# this loop runs the extract_onsets.py script
		# it copies the output line by line into a text file
		line=`python extract_onset.py --subj ${i}`
		echo "$line" >> ${expRun}-onsets.txt
	done
	rm *_Session_Data.txt
done