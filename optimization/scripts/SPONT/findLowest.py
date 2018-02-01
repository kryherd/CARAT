#!/usr/bin/env python
# -*- coding: utf8 -*-
import os, sys, re

# open the results document
file = open("results.txt", "r+").read()

#create empty lists
listEff = []
iteration = []

# use regular expressions to find all iterations and efficiency values
p = re.compile(r"(\d){1,3}\s(\d\.\d+)",re.MULTILINE)

# add these matches to the empty lists
matches = p.finditer(file)
for m in matches:
	values = m.groups()
	iteration += [values[0]]
	listEff += [values[1]]

# find the minimum efficiency value
minEff = str(min(listEff))
indexOfMinEff = str(listEff.index(min(listEff))+1)

# write the minimum efficiency value to results.txt
file = open("results.txt", "a")
file.write("\n")
file.write("Lowest Stim Value "+minEff+" in iteration "+indexOfMinEff)
file.close()
