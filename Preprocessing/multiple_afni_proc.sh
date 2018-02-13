# this loop runs the create_afni_proc.sh script for the subjects you specify
for i in 07 # change subject numbers here
do
	echo "Subject ${i}"
	sh spr_afniproc.sh ${i}
	sh spont_afniproc.sh ${i}
done