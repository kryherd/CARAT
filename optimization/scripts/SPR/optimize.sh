#!/bin/bash
#the number of iterations
N=100
echo "iteration eff seed" > results.txt
#TODO: start a loop in i from 1 to $N
for i in `seq $N`; do
	#portable method of getting a random number
	seed=`cat /dev/random|head -c 256|cksum |awk '{print $1}'`
	
# create random timings
## change -max_consec to change how many of the same stim type can come in a row.
	make_random_timing.py \
	-num_stim 5 \
	-num_runs 2 \
	-run_time 460 \
    -stim_dur 6 \
    -num_reps 4 4 4 4 8 \
    -prefix stim.${i} \
    -stim_labels Posed_plus Posed_minus Regulated_plus Regulated_minus Spontaneous \
    -tr 2.0 \
    -max_consec 2


	#TODO: 3dDeconvolve command
	#redirect the output to efficiency.${i}.txt
	3dDeconvolve \
	-nodata 460 2 \
	-polort 1 \
	-num_stimts 5 \
	-concat '1D: 0 230' \
	-stim_times 1 stim.${i}_01_Posed_plus.1D 'GAM' \
	-stim_label 1 'Posed_plus' \
	-stim_times 2 stim.${i}_02_Posed_minus.1D 'GAM' \
	-stim_label 2 'Posed_minus' \
	-stim_times 3 stim.${i}_03_Regulated_plus.1D 'GAM' \
	-stim_label 3 'Regulated_plus' \
	-stim_times 4 stim.${i}_04_Regulated_minus.1D 'GAM' \
	-stim_label 4 'Regulated_minus' \
	-stim_times 5 stim.${i}_05_Spontaneous.1D 'GAM' \
	-stim_label 5 'Spontaneous' \
	-gltsym "SYM: 0.25*Posed_plus 0.25*Posed_minus 0.25*Regulated_plus 0.25*Regulated_minus -1.0*Spontaneous" > efficiency.${i}.txt

	eff=`./efficiency_parser.py efficiency.${i}.txt`

	echo "$i $eff $seed" >> results.txt
	#end loop
done

python findLowest.py 
