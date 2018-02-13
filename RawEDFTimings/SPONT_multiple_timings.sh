# this loop runs the make_timings.py script for the subjects you specify
for i in 07 # change subject numbers here
do
	cp ./SPONT_1/Output/SPONT1_pilot${i}.txt ./
	cp ./SPONT_2/Output/SPONT2_pilot${i}.txt ./
	sub=`python make_spont_timings.py --subj ${i}`
	rm SPONT*_pilot${i}.txt
done