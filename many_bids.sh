# this loop runs the make_NIFTI_bids.sh script for the subjects you specify
for i in 7 # change subject numbers here
do
	sh make_NIFTI_bids.sh ${i}
done