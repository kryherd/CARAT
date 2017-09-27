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
data = "./SPONT1_pilot%s.txt" % (args.subj)


df=pd.read_table(data)
# remove all practice trials
# does this by looking for trials where the start time is after when the scanner pulse started
df = df.query('TRIAL_START_TIME > ScannerPulseTime')
# Create variable called "TrialStart", time from when the scanner started (in seconds)
df['TrialStart'] = (df['TRIAL_START_TIME'] - df ['ScannerPulseTime'])/1000
# Find when each video started
df_starts = df.loc[df['CURRENT_MSG_TEXT'].str.match("^Frame to be displayed 1$"),:]
df_starts = df_starts.reset_index()
vs = df_starts['TrialStart'] + df_starts['CURRENT_MSG_TIME']/1000
emotion = df_starts['emotion']
# find when each video ended
df_ends = df[df['CURRENT_MSG_TEXT'].str.match("^CONDITIONAL$")]
df_ends = df_ends.reset_index()
ve = df_ends['TrialStart'] + df_ends['CURRENT_MSG_TIME']/1000

# create data frame with relevant columns
dict = {'Emotion':emotion, 'VidStart':vs, 'VidEnd':ve}
rel_df = pd.DataFrame(data=dict)
# calculate video duration
rel_df['VidDur'] = rel_df['VidEnd'] - rel_df['VidStart']
# create column with timing information in the format AFNI needs
rel_df.loc[:,'timing'] = rel_df['VidStart'].astype(str) + ":" + rel_df['VidDur'].astype(str)
print rel_df

# create 1D files for each relevant task variable
for ttype in rel_df['Emotion'].unique():
	emo = rel_df[rel_df['Emotion'] == ttype]
	if emo.shape[0]>0:
		times = pd.DataFrame(emo['timing']).T
		times.to_csv('sub' + args.subj + "-" + str(ttype) + '.1D', index=False, header=False, sep='\t')


