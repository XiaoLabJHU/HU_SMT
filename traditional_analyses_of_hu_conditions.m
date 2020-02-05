%% traditional analysis of HU conditions

%% 2D diff distribution
clear
cd('/Users/kbettridge/Google Drive/Bettridge_Kelsey/Data/HU_project/traditional_analyses')
load('all_hu_gtf_and_traj_strucs.mat')

n = 1;
t = 0.00674;

hu_ezrdm_twoD_diff_results = twoD_diff_2popu(traj_hu_ezrdm, n, 0.1, t);
hu_rif_twoD_diff_results = twoD_diff_2popu(traj_hu_rif, n, 0.1, t);
hu_chlor_twoD_diff_results = twoD_diff_2popu(traj_hu_chlor, n, 0.1, t);
hu_dREP325_twoD_diff_results = twoD_diff_2popu(traj_hu_dREP325, n, 0.1, t);
hu_3KA_twoD_diff_results = twoD_diff_2popu(traj_hu_3KA, n, 0.160, t);
hu_P63A_twoD_diff_results = twoD_diff_2popu(traj_hu_P63A, n, 0.001, t);
dhupB_huPCh_twoD_diff_results = twoD_diff_2popu(traj_dhupB_huPCh, n, 0.001, t);
dhupB_3KA_twoD_diff_results = twoD_diff_2popu(traj_dhupB_3KA, n, 0.001, t);
dhupB_P63A_twoD_diff_results = twoD_diff_2popu(traj_dhupB_P63A, n, 0.001, t);

all_results = who('*twoD_diff_results');
for ii = 1:length(all_results)
    if ii == 1
        save('all_twoD_diff_results.mat', all_results{ii});
    else
        save('all_twoD_diff_results.mat', all_results{ii}, '-append');
    end
end

%% CDF distribution and fit

clear
cd('/Users/kbettridge/Google Drive/Bettridge_Kelsey/Data/HU_project/traditional_analyses')
load('all_hu_gtf_and_traj_strucs.mat')

n = 1;
t = 0.00674;

hu_ezrdm_CDF_results = CDF_2popu_dist(hu_ezrdm_gtf, t, 0.1, n);
hu_rif_CDF_results = CDF_2popu_dist(hu_rif_gtf, t, 0.1, n);
hu_chlor_CDF_results = CDF_2popu_dist(hu_chlor_gtf, t, 0.1, n);
hu_dREP325_CDF_results = CDF_2popu_dist(hu_dREP325_gtf, t, 0.1, n);
hu_3KA_CDF_results = CDF_2popu_dist(hu_3KA_gtf, t, 0.16, n);
hu_P63A_CDF_results = CDF_2popu_dist(hu_P63A_gtf, t, 0.16, n);
dhupB_huPCh_CDF_results = CDF_2popu_dist(dhupB_huPCh_gtf, t, 0.16, n);
dhupB_3KA_CDF_results = CDF_2popu_dist(dhupB_3KA_gtf, t, 0.16, n);
dhupB_P63A_CDF_results = CDF_2popu_dist(dhupB_P63A_gtf, t, 0.16, n);

all_results = who('*CDF_results');
for ii = 1:length(all_results)
    if ii == 1
        save('all_CDF_results.mat', all_results{ii});
    else
        save('all_CDF_results.mat', all_results{ii}, '-append');
    end
end

%% oneD Gaussian distribution and fit

clear
cd('/Users/kbettridge/Google Drive/Bettridge_Kelsey/Data/HU_project/traditional_analyses')
load('all_hu_gtf_and_traj_strucs.mat')

n = 1;
t = 0.00674;

hu_ezrdm_oneD_gauss_results = oneD_displacement_Gauss_2popu(traj_hu_ezrdm, 0.1, t);
hu_rif_oneD_gauss_results = oneD_displacement_Gauss_2popu(traj_hu_rif, 0.1, t);
hu_chlor_oneD_gauss_results = oneD_displacement_Gauss_2popu(traj_hu_chlor, 0.1, t);
hu_dREP325_oneD_gauss_results = oneD_displacement_Gauss_2popu(traj_hu_dREP325, 0.1, t);
hu_3KA_oneD_gauss_results = oneD_displacement_Gauss_2popu(traj_hu_3KA, 0.16, t);
hu_P63A_oneD_gauss_results = oneD_displacement_Gauss_2popu(traj_hu_P63A, 0.001, t);
dhupB_huPCh_oneD_gauss_results = oneD_displacement_Gauss_2popu(traj_dhupB_huPCh, 0.001, t);
dhupB_3KA_oneD_gauss_results = oneD_displacement_Gauss_2popu(traj_dhupB_3KA, 0.001, t);
dhupB_P63A_oneD_gauss_results = oneD_displacement_Gauss_2popu(traj_dhupB_P63A, 0.001, t);

all_results = who('*gauss_results');
for ii = 1:length(all_results)
    if ii == 1
        save('all_oneD_gauss_results.mat', all_results{ii});
    else
        save('all_oneD_gauss_results.mat', all_results{ii}, '-append');
    end
end