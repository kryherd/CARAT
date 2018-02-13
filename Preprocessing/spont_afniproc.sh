#!/usr/bin/env tcsh

# created by uber_subject.py: version 0.40 (March 30, 2017)
# creation date: Wed Sep 20 14:46:16 2017

subj=$1
group_id="group"

# set data directories
top_dir="/Users/Kayleigh/CARAT"
anat_dir="anat"
epi_dir="spont"

# set subject and group identifiers


# run afni_proc.py to create a single subject processing script
afni_proc.py -subj_id sub-$subj                                      \
        -script ${top_dir}/sub-${subj}/spont_preproc_subj-$subj -scr_overwrite                        \
        -out_dir ${top_dir}/sub-${subj}/sub-${subj}.spont      \
        -blocks tshift align tlrc volreg blur mask scale regress \
        -copy_anat ${top_dir}/sub-${subj}/$anat_dir/sub-${subj}_run-01_T1w.nii.gz            \
        -tcat_remove_first_trs 0                                 \
        -dsets                                                   \
            ${top_dir}/sub-${subj}/$epi_dir/sub-${subj}_run-01_bold.nii.gz                   \
            ${top_dir}/sub-${subj}/$epi_dir/sub-${subj}_run-02_bold.nii.gz                   \
        -volreg_align_to third                                   \
        -volreg_align_e2a                                        \
        -volreg_tlrc_warp                                        \
        -blur_size 4.0                                           \
        -regress_stim_times                                      \
            ${top_dir}/sub-${subj}/$epi_dir/sub${subj}-Neutral.1D                            \
            ${top_dir}/sub-${subj}/$epi_dir/sub${subj}-Pleasant.1D                           \
            ${top_dir}/sub-${subj}/$epi_dir/sub${subj}-Unpleasant.1D                         \
        -regress_stim_labels                                     \
            Neutral Pleasant Unpleasant                          \
        -regress_stim_types AM1    								 \
        -regress_basis 'dmBLOCK(1)'                              \
        -regress_censor_motion 0.3                               \
        -regress_make_ideal_sum sum_ideal.1D                     \
        -regress_est_blur_epits                                  \
        -regress_est_blur_errts

