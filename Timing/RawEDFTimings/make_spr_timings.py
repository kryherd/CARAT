# import packages
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
# CHANGE THIS to point to message report data files
data1 = "./SPR1_pilot%s.txt" % (args.subj)
data2 = "./SPR2_pilot%s.txt" % (args.subj)

def create_timing(data):
	df=pd.read_table(data)
	# remove all practice trials
	# does this by looking for trials where the start time is after when the scanner pulse started
	df = df.query('TRIAL_START_TIME > ScannerPulseTime')
	df.is_copy = False
	# Create variable called "TrialStart", time from when the scanner started (in seconds)
	df['TrialStart'] = (df['TRIAL_START_TIME'] - df['ScannerPulseTime'])/1000
	# Find when each video started
	df_starts = df.loc[df['CURRENT_MSG_TEXT'].str.match("^Frame to be displayed 1$"),:]
	df_starts = df_starts.reset_index()
	vs = df_starts['TrialStart'] + df_starts['CURRENT_MSG_TIME']/1000
	emotion = df_starts['emotion']
	type = df_starts['type']
	# find when each video ended
	df_ends = df[df['CURRENT_MSG_TEXT'].str.match("^CONDITIONAL$")]
	df_ends = df_ends.reset_index()
	ve = df_ends['TrialStart'] + df_ends['CURRENT_MSG_TIME']/1000
	# create data frame with relevant columns
	dict = {'Emotion':emotion, 'Type':type, 'VidStart':vs, 'VidEnd':ve}
	rel_df = pd.DataFrame(data=dict)
	# calculate video duration
	rel_df['VidDur'] = rel_df['VidEnd'] - rel_df['VidStart']
	# create column with timing information in the format AFNI needs
	rel_df.loc[:,'timing'] = rel_df['VidStart'].astype(str) + ":" + rel_df['VidDur'].astype(str)
	return rel_df;

run1 = create_timing(data1)
run2 = create_timing(data2)


#create 1D files for each relevant task variable
for emot in run1['Emotion'].unique():
	emo1 = run1[run1['Emotion'] == emot]
	emo2 = run2[run2['Emotion'] == emot]
	emo1 = emo1.reset_index()
	emo2 = emo2.reset_index()
	for ttype in emo1['Type'].unique():
		type1 = emo1[emo1['Type'] == ttype]
		type2 = emo2[emo2['Type'] == ttype]
		if type1.shape[0]>0:
			times_r1 = pd.DataFrame(type1['timing']).T
			times_r2 = pd.DataFrame(type2['timing']).T
			times_all = times_r1.append(times_r2)
			times_all.to_csv('sub' + args.subj + "-" + str(ttype) + str(emot) + '.1D', index=False, header=False, sep='\t')


