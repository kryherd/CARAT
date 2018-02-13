#!/bin/bash
# takes raw DICOM data, converts to NIFTI, and stores in the BIDS data structure

# creates variable subj that is a zero-padded character string
subj=`printf "%02d" $1`

# creates sub-directories
for subdir in "anat" "spont" "spr"
	do
	# -p makes all the parents files as well
		mkdir -p ./sub-${subj}/${subdir}
	done
	
# ANAT
cd ./$1/5/
dcm2niix_afni ./ 

# Spont run 1
cd ../7/
dcm2niix_afni ./ 

# Spont run 2
cd ../8/
dcm2niix_afni ./ 

# SPR run 1
cd ../9/
dcm2niix_afni ./ 

# SPR run 2
cd ../10/
dcm2niix_afni ./

cd ../../

# copy and rename files
cp ./$1/5/*.nii ./sub-${subj}/anat/sub-${subj}_run-01_T1w.nii.gz
cp ./$1/5/*.json ./sub-${subj}/anat/sub-${subj}_run-01_T1w.json

cp ./$1/7/*.nii ./sub-${subj}/spont/sub-${subj}_run-01_bold.nii.gz
cp ./$1/7/*.json ./sub-${subj}/spont/sub-${subj}_run-01_bold.json

cp ./$1/8/*.nii ./sub-${subj}/spont/sub-${subj}_run-02_bold.nii.gz
cp ./$1/8/*.json ./sub-${subj}/spont/sub-${subj}_run-02_bold.json

cp ./$1/9/*.nii ./sub-${subj}/spr/sub-${subj}_run-01_bold.nii.gz
cp ./$1/9/*.json ./sub-${subj}/spr/sub-${subj}_run-01_bold.json

cp ./$1/10/*.nii ./sub-${subj}/spr/sub-${subj}_run-02_bold.nii.gz
cp ./$1/10/*.json ./sub-${subj}/spr/sub-${subj}_run-02_bold.json
