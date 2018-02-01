#!/usr/bin/env python
import re #regex module
import numpy as np
import sys

#Usage: efficiency_parser.py out.txt
#Parse the output of 3dDeconvole -nodata stored in out.txt

#make a dictionary to store the results
results = {'Contrast': [], 'eff': []}

# read in the efficiency data from 3dDeconvolve
## this file is passed as an argument in optimize.sh
with open(sys.argv[1], 'r') as fd:
	s = fd.read()


# use regular expressions to find iteration and efficiency values
p = re.compile(r"^.+:\s+(.+)\s+.+=\s+([.0-9]+)", re.MULTILINE)

#find all of the matches in s and return an iterator in matches
matches = p.finditer(s)

#iterate through matches and copy the values to the results dictionary
#for each match, m, you get from the iterator, m.groups() is a tuple
for m in matches:
	values = m.groups()
	results['Contrast'] = results['Contrast'] + [values[0]]
	results['eff'] = results['eff'] + [float(values[1])]

#calculate the summed efficiency of all the stimulus functions and contrasts
#(i.e. sum the 'eff' key in the dictionary)

eff = np.sum(results['eff'])

#print the summed efficiency (back into optimize.sh)
print(eff)

