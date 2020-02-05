# HU_SMT
single molecule tracking data and code from our paper tracking the bacterial nucleoid-associated protein HU: https://www.biorxiv.org/content/10.1101/2019.12.31.725226v1

%------------------------------------------------------------------------------
DATA COLLECTED:

Single molecule trajectories are MATLAB .mat files with the following format:

1 x N struct with the fields:
     frames: 1 x M double 
     intensity: 1 x M double (in arbitrary units)
     coordinates: 2 x M double (in microns, assuming the middle of the cell is the origin)
     mol_id: the original trajectory # before initial data processing
     data_id: the original folder where the data originated from

Averaged SIM images for each condition are saved as .mat files in the form of matrices

%%-----------------------------------------------------------------------------
CUSTOM IN-HOUSE CODE:

Source code for analysis are all .m files

traditional_analyses_of_hu_conditions.m --> custom in-house code that calculates the 2D diffusion distribution, single frame displacement CDF distribution, and x-axis single frame displacement Gaussian distribution. Relies on these functions:
      twoD_diff_2popu.m
      CDF_2popu_dist.m
      oneD_displacment_Gauss_2popu.m
