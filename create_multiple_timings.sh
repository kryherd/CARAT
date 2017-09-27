# this loop runs the make_timings.py script for the subjects you specify
for i in 06 07 # change subject numbers here
do
	sub=`python make_timings.py --subj ${i}`
done