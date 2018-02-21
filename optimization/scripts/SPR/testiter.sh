#!/usr/bin/env bash

# Script use: create timing files for presentation software
# using a given iteration from optimize.sh

# how to run:
# sh testiter.sh ITERATIONNUM

# Used for CARAT - SPR

# create directory for that iteration
mkdir ./iteration$1
# copy data
cp ./stim.$1_*.1D ./iteration$1
cd ./iteration$1

#rename data
cp stim.$1_01_Posed_plus.1D Posed_plus.1D
cp stim.$1_02_Posed_minus.1D Posed_minus.1D
cp stim.$1_03_Regulated_plus.1D Regulated_plus.1D
cp stim.$1_04_Regulated_minus.1D Regulated_minus.1D
cp stim.$1_05_Spontaneous.1D Spontaneous.1D

#remove old files
rm ./stim.$1*.1D

# copy timingtotal script into this folder
cp ../timingtotal.py .

# run timingtotal script
python timingtotal.py --run 1
python timingtotal.py --run 2