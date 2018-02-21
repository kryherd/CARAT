#!/bin/bash
### OPTIMIZE SCRIPT FOR SPONT - CARAT
#the number of iterations - 100 is good, but change it if you want
N=100
# start a document called "results" that has these headers
echo "iteration eff seed" > results.txt
#start a loop in i from 1 to $N (number of iterations)
for i in `seq $N`; do
	#portable method of getting a random number
	seed=`cat /dev/random|head -c 256|cksum |awk '{print $1}'`

# create random timings
## change -max_consec to change how many of the same stim type can come in a row.
	make_random_timing.py \
	-num_stim 3 \
	-num_runs 2 \
	-run_time 368 \
    -stim_dur 6 \
    -num_reps 8 8 8 \
    -prefix stim.${i} \
    -stim_labels Pleasant Neutral Unpleasant \
    -tr 2.0 \
    -max_consec 2

	# test efficiency of randomly generated design
	# -nodata number of TRs TR length
	# -gltsym the contrasts you are most interested in
	## see AFNI documentation for how to write them
	3dDeconvolve \
	-nodata 368 2 \
	-polort 1 \
	-num_stimts 3 \
	-concat '1D: 0 184' \
	-stim_times 1 stim.${i}_01_Pleasant.1D 'GAM' \
	-stim_label 1 'Pleasant' \
	-stim_times 2 stim.${i}_02_Neutral.1D 'GAM' \
	-stim_label 2 'Neutral' \
	-stim_times 3 stim.${i}_03_Unpleasant.1D 'GAM' \
	-stim_label 3 'Unpleasant' \
	-gltsym "SYM: Pleasant -Neutral" \
	-gltsym "SYM: Unpleasant -Neutral" > efficiency.${i}.txt

	# use efficiency parser script to put efficiency into results.txt
	eff=`./efficiency_parser.py efficiency.${i}.txt`
	
	# save results
	echo "$i $eff $seed" >> results.txt
	#end loop
done

# use findLowest script to put a line at the end of the script
# that indicates the lowest efficiency (most efficient) iteration
python findLowest.py 
