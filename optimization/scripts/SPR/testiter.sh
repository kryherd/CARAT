#!/usr/bin/env bash

# Script use: create timing files for presentation software
# using a given iteration from optimize.sh

# how to run:
# sh testiter.sh ITERATIONNUM

# Used for CARAT - SPR

# create directory for that iteration
mkdir ./iteration$1
# copy data
cp ../stim.$1.*.1D ./iteration$1
cd ./iteration$1

#rename data
cp stim.$1.01.1D Posed_minus.1D
cp stim.$1.02.1D Posed_plus.1D
cp stim.$1.03.1D Regulated_minus.1D
cp stim.$1.04.1D Regulated_plus.1D
cp stim.$1.05.1D Spontaneous.1D

#remove old files
rm ./stim.$1*.1D

# copy timingtotal script into this folder
cp ../timingtotal.py .

# run timingtotal script
python timingtotal.py