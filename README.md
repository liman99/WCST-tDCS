# WCST-tDCS
This repository contains the raw data and processing code for a revised version of the WCST paradigm. Thirty-eight participants were recruited, and both tDCS stimulation and sham stimulation were applied during the experiment, aiming to investigate adaptive cognitive control.

sbject_data_all.xlsx is the raw data.  
sbject_data_proc.xlsx is the cleaned dataset prepared for statistical analysis.
loaddata.m processes the raw data and generates the dataset saved as sbject_data_proc.xlsx.  
check_acc.m evaluates participants’ accuracy across all conditions to identify and exclude those performing below chance level.  
procdata_anova.m performs the statistical analyses.
