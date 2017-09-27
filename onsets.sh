# create empty file
# you can change "onsets.txt" if you want a different filename
# just be sure to change it throughout this file

# this loop runs the extract_onsets.py script
# it copies the output line by line into a text file

echo "Subject Onset" > onsets.txt
for i in 04 05 06 07 #change subject numbers here
do
	line=`python extract_onset.py --subj ${i}`
	echo "$line" >> onsets.txt
done
