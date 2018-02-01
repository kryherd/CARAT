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

	#generate random stimulus files
	# -nt number of TRs
	# -num_stimts number of stimulus types
	# -nreps number of repetitions for stim type 1, etc.
	RSFgen \
	-nt 184 \
	-num_stimts 3 \
	-nreps 1 8 \
	-nreps 2 8 \
	-nreps 3 8 \
	-seed ${seed} -prefix rsf.${i}.

	#turn stimulus files into stim_times files
	# -nt number of TRs
	# -tr TR length (in seconds)
	make_stim_times.py \
	-files rsf.${i}.*.1D \
	-prefix stim.${i} \
	-nt 184 \
	-tr 2 \
	-nruns 1

	# test efficiency of randomly generated design
	# -nodata number of TRs TR length
	# -gltsym the contrasts you are most interested in
	## see AFNI documentation for how to write them
	3dDeconvolve \
	-nodata 184 2 \
	-polort 1 \
	-num_stimts 3 \
	-stim_times 1 stim.${i}.01.1D 'GAM' \
	-stim_label 1 'Pleasant' \
	-stim_times 2 stim.${i}.02.1D 'GAM' \
	-stim_label 2 'Neutral' \
	-stim_times 3 stim.${i}.03.1D 'GAM' \
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
