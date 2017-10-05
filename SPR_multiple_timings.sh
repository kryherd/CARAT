# this loop runs the make_timings.py script for the subjects you specify
for i in 07 # change subject numbers here
do
	cp ./SPR_1/Output/SPR1_pilot${i}.txt ./
	cp ./SPR_2/Output/SPR2_pilot${i}.txt ./
	sub=`python make_spr_timings.py --subj ${i}`
	rm SPR*_pilot${i}.txt
done