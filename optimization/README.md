# Design Optimization

This repository folder contains a few scripts for both SPONT and SPR.

You should start by creating a folder for each and copying the relevant scripts into that folder.

Navigate to either the SPONT or SPR folder. Then, run the optimize script:  
`sh optimize.sh`

The optimize script randomly generates a bunch of timing files based on the length of your experiment, the TR length, the number of stimulus types, and the number of trials per stimulus type. It then calculates the efficiency of each iteration of these timing files.

This should give you a file called `results.txt`. The columns in results include `iteration`, `eff`, and `seed`. Iteration is the index for the iteration in that row. Eff refers to efficiency -- lower numbers indicate a more efficient (better) design. Seed is the randomly-generated number used to randomize and generate the stimulus timing files.

`results.txt` automatically has a line at the bottom indicating which iteration is the most efficient. However, you can also open `results.txt` in Excel and sort by `eff` to see which designs are the most efficient. This might be neccessary if the most efficient design doesn't have the most optimal stimulus order (e.g., lots of the same stimulus type in a row).

Once you've run `optimize.sh` and looked at `results.txt`, you can use `testiter.sh` to create timing files for a given iteration suitable for experimental presentation software.

To run, `testiter.sh`, type the command and  then the iteration number you'd like to generate the timing file for.    

* E.g., `sh testiter.sh 35`

This wil create a file (`SPONT_timings.csv` or `SPR_timings.csv`) that has onset times and stimulus types for a given iteration. You should present a stimulus with the type indicated in TrialType at each Onset Time.
