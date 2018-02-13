import sys
import argparse
import subprocess
import re
import numpy as np
import pandas as pd

# set up argument parser
parser = argparse.ArgumentParser()
parser.add_argument('--subj', action='store', type=str, help="Subject number")
args=parser.parse_args()

# load in data files
# CHANGE THIS to point to trial report data files
data1 = "./SPONT1_sub%s.txt" % (args.subj)
data2 = "./SPONT2_sub%s.txt" % (args.subj)

def create_timing(data):
	df=pd.read_table(data)
	# remove all practice trials
	df_real = df[df['imagetype'].str.match("Spontaneous")].copy()
	# Create variable called "TrialStart", time from when the video started (in seconds) 
	df_real['TrialStart'] = df_real['VIDEO_ELAPSED_TIME_FROM_PULSE'].copy()/1000
	# Create variable called "TrialEnd", time from when the video ended and response started (in seconds) 
	df_real['TrialEnd'] = df_real['RESPONSE_ELAPSED_TIME_FROM_PULSE'].copy()/1000
	# Create variable called "TrialDur", duration of trial (in seconds) 
	df_real['TrialDur'] = df_real['TrialEnd'].copy() - df_real.loc[:,'TrialStart'].copy()
	# create column with timing information in the format AFNI needs
	df_real['timing'] = df_real['TrialStart'].astype(str).copy() + ":" + df_real.loc[:,'TrialDur'].astype(str).copy()
	return(df_real);


run1 = create_timing(data1)
run2 = create_timing(data2)

#create 1D files for each relevant task variable

for ttype in run1['emotion'].unique():
	emo1 = run1[run1['emotion'] == ttype]
	emo2 = run2[run2['emotion'] == ttype]
	emo1 = emo1.reset_index()
	emo2 = emo2.reset_index()
	if emo1.shape[0]>0:
		times_r1 = pd.DataFrame(emo1['timing']).T
		times_r2 = pd.DataFrame(emo2['timing']).T
		times_all = times_r1.append(times_r2)
		times_all.to_csv('sub' + "01" + "-" + str(ttype) + '.1D', index=False, header=False, sep='\t')

