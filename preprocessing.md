# Preprocessing

Before you start pre-processing, you need to make sure you have all of your data. 

## Gathering & Organizing Data
To preprocess data, you will need [timing files](./create_timing_files.md) and your MRI images.

### MRI Data
All MRI data can be downloaded from the BIRC [Neuroinformatics Database](http://psypacs.psy.uconn.edu/nidb/index.php) (NiDB). Note that you must be on campus or on the [UConn VPN](http://remoteaccess.uconn.edu/) to access the NiDB. To learn more about navigating NiDB, see the [BIRC wiki](http://birc-int.psy.uconn.edu/wiki/index.php/NiDB_User_Guide) (must be on campus or VPN to access).

This section will provide CARAT-specific information about data stored in NiDB. When you search for CARAT data, you will see something like the image below.  
 
![CARAT runs](./Images/NiDB.png)

Here are the important runs for functional analysis:  

*	**t1\_mprage\_sag\_p2\_iso** (5): T1-weighted anatomical image
*	**ep2d\_bold\_252530\_faces** (7-10): EPI functional images, runs 1-4. Runs 1-2 are SPONT and runs 3-4 are SPR.

Each subject that you download will have separate folders with the Series # as their title. This tells you which folder contains which run of data.

When you select your data to be downloaded from NiDB, use the following options.

* Download Type > Destination: Web
* Data: Imaging, Behavioral, QC
* Format: DICOM, No DICOM anonymization, Gzip files
* Directory Structure > Directory Format: Primary alternate subject ID
* Directory Structure > Series Directories: Renumber series

When you unzip the downloaded file, you will get individual folders for each of the subjects you chose to download. The folders will be labeled with the alternate ID -- this is the subject ID number that Elisa inputs at the beginning of the scan. (e.g., PILOT07CA) Rename this folder to the subject's number with no zero-padding (e.g., 7 instead of 07).

Make sure that the `make_NIFTI_bids.sh` script is in the same parent folder that your data is in. Then run one of the following commands:  

* `sh make_NIFTI_bids.sh X` - replace X with the subject number. Used for just a single subject
* `sh many_bids.sh` - change line 2 to be a list of subjects you want to organize

This step does two things. First, it creates [BIDS](http://bids.neuroimaging.io/) directory structure for your data. Each subject will have a folder with the format `sub-07` and subfolders labeled `spr`, `spont`, and `anat`. Second, this script takes the raw DICOM files downloaded from NiDB and turns them into 4D NIFTI files that can be used by AFNI.

### Timing Files
Make sure to copy the timing files you created previously into the relevant folders. Put the timing files into the BIDS-format folders created earlier (`spont` and `spr`).

* SPONT timing files
	* Pleasant
	* Unpleasant
	* Neutral 	
* SPR timing files
	* Posed_minusUnpleasant
	* Posed_plusPleasant
	* Regulated_minusUnpleasant
	* Regulated_plusPleasant
	* SpontaneousNeutral
	* SpontaneousPleasant
	* SpontanousUnpleasant

## Generating Preprocessing Scripts

In this step, we will generate the preprocessing scripts you will need to actually preprocess your data. The scripts were originally made using `uber_subject.py` from AFNI and then modified by me. These scripts will generate preprocessing scripts and put them in each subject's folder. You can either run the generation scripts individually, or use the batch generation script.

**Running Individually**: Use if you just want to preprocess one subject.  

1. Check your top directory (line 10). This should point to the folder containing all your BIDS-formatted data directories.
2. Run the following command: `sh create_afni_proc.sh 07` -- replace `07` with the subject you want to preprocess.

**Batch Preprocessing**: Use if you want to preprocess multiple subjects.  

1. Check the top directory (line 10 of `create_afni_proc.sh` as described above.
2. Change line 2 of `multiple_afni_proc.sh` to a list of the subjects you want to preprocess, separated by a space.
3. Run the following command: `sh multiple_afni_proc.sh`

## Running the Preprocessing Scripts

Now we will actually run the preprocessing. Once you generate the scripts, you should see them in each subject's folder. One cool feature of `afni_proc` is that it puts the code to run the script in the script itself. 

1. Open the generated preprocessing script in your text editor (e.g., TextWrangler). You may have to specify that the file is opened using the text editor, since by default it will be an executable file.
2. Copy the text from line 8 (not including the `#`).
3. Open Terminal.
4. Navigate to the folder containing the preprocessing script (usually `~/some_directory/sub-SUBJNUMBER/`)
5. Type `tcsh` to start the t-shell
6. Paste the text from the preprocessing script.

That's it! It will take a little while for the preprocessing script to run. Your computer will make some sounds while it runs. That's ok.

**Note:** Keep on the lookout for WARNINGS or ERRORS. OK warnings include:
  
* Warnings about obliqueness (usually AFNI can deal with the small amount of obliqueness our scanner gives)
* Dataset is already aligned in time
* Input dataset is not 3D+time
* Removing constant voxels

## Checking the Preprocessing

A first step for checking the success of your preprocessing is using @ss_review_driver. This is an interactive function created by AFNI to make sure your preprocessing went smoothly. I've also created a log file for you to keep track of your preprocessing. You will have to run the ss_review_driver script twice -- once for SPONT and once for SPR.

1. Navigate into the results directory `sub-subjnunm/sub-subjnum.spr or .spont`
2. Paste `./@ss_review_driver` into Terminal.
3. Follow the prompts.
4. In the first step, copy the average motion per TR as well as the number of TRs censored and the % of TRs into the log.
5. Indicate how good the alignment is. Use the 'o' key to toggle the overlay (functional data) on and off. Pay attention to ventricles to get a good idea of how good the alignment is.
6. Copy any regression warnings into the log.
7. For activation, you should see most of the big blobs within the brain. Some blobs will be outside of the brain, but in general the shape should match the underlying anatomy. Note this on the log.
8. Note any additional things you notice during the review drivers process.

Hopefully, most of your data will preprocess fine. I would suggest going through the review drivers process soon after you collect each subject. That way, I can help adjust the preprocessing script if there are some problems with alignment or skull stripping, etc. for a given subject.