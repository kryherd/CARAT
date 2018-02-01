#!/bin/bash
### OPTIMIZE SCRIPT FOR SPR - CARAT
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
	-nt 230 \
	-num_stimts 5 \
	-nreps 1 4 \
	-nreps 2 4 \
	-nreps 3 4 \
	-nreps 4 4 \
	-nreps 5 8 \
	-seed ${seed} -prefix rsf.${i}.

	#turn stimulus files into stim_times files
	# -nt number of TRs
	# -tr TR length (in seconds)
	make_stim_times.py \
	-files rsf.${i}.*.1D \
	-prefix stim.${i} \
	-nt 230 \
	-tr 2 \
	-nruns 1

	# test efficiency of randomly generated design
	# -nodata number of TRs TR length
	# -gltsym the contrasts you are most interested in
	## see AFNI documentation for how to write them
	3dDeconvolve \
	-nodata 230 2 \
	-polort 1 \
	-num_stimts 5 \
	-stim_times 1 stim.${i}.01.1D 'GAM' \
	-stim_label 1 'Posed_plus' \
	-stim_times 2 stim.${i}.02.1D 'GAM' \
	-stim_label 2 'Posed_minus' \
	-stim_times 3 stim.${i}.03.1D 'GAM' \
	-stim_label 3 'Regulated_plus' \
	-stim_times 4 stim.${i}.04.1D 'GAM' \
	-stim_label 4 'Regulated_minus' \
	-stim_times 5 stim.${i}.05.1D 'GAM' \
	-stim_label 5 'Spontaneous' \
	-gltsym "SYM: 0.25*Posed_plus 0.25*Posed_minus 0.25*Regulated_plus 0.25*Regulated_minus -1.0*Spontaneous" > efficiency.${i}.txt

	# use efficiency parser script to put efficiency into results.txt
	eff=`./efficiency_parser.py efficiency.${i}.txt`

# use findLowest script to put a line at the end of the script
# that indicates the lowest efficiency (most efficient) iteration
	echo "$i $eff $seed" >> results.txt
	#end loop
done

python findLowest.py 
