#!/usr/bin/env python
import re
import numpy as np 
import sys
import argparse

# passes the subject number into python as a variable
parser = argparse.ArgumentParser()
parser.add_argument('--subj', action='store', type=str, help="Subject Number")
args=parser.parse_args()

# creates a variable that is the filename
# you might need to change this line if the SessionData files have a different naming structure
file = "pilot%s_Session_Data.txt" % (args.subj)

# open session data file
with open(file, 'r') as f:
	s = f.read()

# find onsets: multi-digit number before EXP_INSTR_KEYBOARD
onset = re.compile(r"(\d{3,})\s\d\sINSTR_KEYBOARD", re.MULTILINE)
match = onset.findall(s)
# this picks the last match, because in the SPR blocks, there are 2 instances of INSTR_KEYBOARD
on = match[-1]

print("%s %s" %(args.subj, on))