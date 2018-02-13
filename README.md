# CARAT

Welcome to the github repository for the CARAT project. Here you will find scripts and documentation to help you process and analyze fMRI data.

Here is a list of the documentation that is available:

1. **Creating timing files**  
There are two ways to create timing files. You can use user-defined variables (the default) or you can pull the timing straight from the raw eyetracker output (good for spot-checking). Timing files are necessary to run the preprocessing and first-level statistical analysis.
	1. **[User-Defined Variables](./Timing/UserDefinedTimings)**  
This section will tell you how to create timing files from the user-defined variables contained in the CARAT ExperimentBuilder scripts.
	2. **[Raw Output](./Timing/RawEDFTimings)**  
This section will tell you how to create timing files from raw EDF (eyetracker) output. 
3. **[Checking Timing Files](./Timing/SpotChecks)**  
From time to time, it is important to make sure that the two methods for extracting timing line up. This will ensure that the user-defined variables are working as expected. This section will explain how to check for that.
4. **[Preprocessing](./Preprocessing/)**  
Preprocessing takes your raw imaging data (DICOM format) and timing information and creates subject-level statistical maps that can be used for the second-level analysis. Here, you will learn how to gather/organize your data, how to generate preprocessing scripts, and how to run the preprocessing scripts.
5. **[Optimization](./optimization/)**  
Optimization refers to organizing your experimental stimuli so that you have the most power to estimate each condition. This folder contains information and scripts to optimize SPR and SPONT.

#### Additional Resources

1. [Command Line Tutorial](https://www.codecademy.com/learn/learn-the-command-line) from CodeAcademy. A lot of this documentation assumes that you know how to use the command line to run shell scripts and navigate through directory structures. If you haven't used Terminal before, I would suggest that you complete sections 1 and 2 of this tutorial.
2. [S-R Support Forums](https://www.sr-support.com/forums/). DataViewer gets updated a lot, so things change. S-R is really good at responding to questions and concerns related to their software, so if you're having trouble with DataViewer, this forum is a great resource.



Contact information: Kayleigh Ryherd, [kayleigh.ryherd@uconn.edu](mailto:kayleigh.ryherd@uconn.edu)