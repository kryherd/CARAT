#!/usr/bin/env bash

# Script use: create timing files for presentation software
# using a given iteration from optimize.sh

# how to run:
# sh testiter.sh ITERATIONNUM

# Used for CARAT - SPONT

# create directory for that iteration
mkdir ./iteration$1
# copy data
cp ./stim.$1*.1D ./iteration$1
cd ./iteration$1

#rename data
cp stim.$1_01_Pleasant.1D Pleasant.1D
cp stim.$1_02_Neutral.1D Neutral.1D
cp stim.$1_03_Unpleasant.1D Unpleasant.1D

#remove old files
rm ./stim.$1*.1D

# copy timingtotal script into this folder
cp ../timingtotal.py .

# run timingtotal script
python timingtotal.py --run 1
python timingtotal.py --run 2