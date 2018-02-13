#! /bin/bash
for i in 01 # change subject numbers here
do
	sub=`python spont_timings.py --subj ${i}`
done