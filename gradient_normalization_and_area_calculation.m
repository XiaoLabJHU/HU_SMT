% using the images that are all the same height? does that matter???


%%

% attempt at normalizing using gradients?

clear
cd('/Users/kbettridge/Google Drive/Bettridge_Kelsey/Data/HU_project/SIM_imaging/new_analysis')
%load('all_averaged_cells_190903.mat')
load('cropped_cells_190903.mat')

allvars = who;

%template = hu_ezrdm_averaged_cell;
template = hu_ezrdm_cropped_avg_cell;

% for ii = 1:length(allvars)
%     currimage = eval(allvars{ii});
%     currimage = uint16(currimage*256+1);
%     imwrite(currimage, strcat(allvars{ii}, '.tif'));
% end
%%

for ii = 1:length(allvars)
    currimage = eval(allvars{ii});
    output = gradient_normalization(currimage, template, 'gradient');
    output = uint16(output);
    imwrite(output, strcat(allvars{ii}, 'hot', '_gradient_normalized.tif'));
    new_images.(allvars{ii}) = double(output);
end

% for ii = 1:length(allvars)
%     currimage = eval(allvars{ii});
%     new_images.(allvars{ii}) = imhistmatch(currimage, template, 256);
% end
%%
close all
dna_areas = [];

% normalize to EZRDM one???

%test = hu_ezrdm_cropped_avg_cell/max(hu_ezrdm_cropped_avg_cell(:));
%[ostuthres, effectiveness] = graythresh(test);

for ii = 1:length(allvars)
    test = new_images.(allvars{ii});
    varname = strsplit(allvars{ii}, '_cropped_avg_cell');
    varname = varname{1};
    %hist(test(:),256)
    %waitforbuttonpress
    %close()
    test = test/max(max(test));
    [otsuthres, effectiveness] = graythresh(test);
    %otsuthres = 0.25;
    temp = length(find(test>otsuthres))*(0.04*0.04);
    dna_areas.(varname).area = temp;
    bstrp_darea = bootstrp(100, @(x) length(find(x>graythresh(x)))*(0.04*0.04), test);
    std_darea = std(bstrp_darea);
    dna_areas.(varname).stdarea = std_darea;
    dna_areas.(varname).means = bstrp_darea;
    dna_areas.(varname).otsuthresh = otsuthres;
    dna_areas.(varname).otsueffect = effectiveness;
    %surf(double(test>otsuthres))
    %grid off
    %view(2)
    %colormap hot
    test2 = double(test>otsuthres);
    figure('Name', allvars{ii})
    montage({test, test2})
    colormap hot
    title(allvars{ii})
    waitforbuttonpress
    close()
end

%%

figure
hold on
% MG1655
bar(1, dna_areas.MG1655.area, 'FaceColor', colors('blue gray'))
errorbar(1, dna_areas.MG1655.area, dna_areas.MG1655.stdarea, 'ok')
% EZRDM
bar(2, dna_areas.hu_ezrdm.area, 'FaceColor', colors('blue (munsell)'))
errorbar(2, dna_areas.hu_ezrdm.area, dna_areas.hu_ezrdm.stdarea, 'ok')
% triKA
bar(3, dna_areas.hu_triKA.area, 'FaceColor', colors('gray'))
errorbar(3, dna_areas.hu_triKA.area, dna_areas.hu_triKA.stdarea, 'ok')

% P63A
bar(4, dna_areas.hu_P63A.area, 'FaceColor', colors('orange-red'))
errorbar(4, dna_areas.hu_P63A.area, dna_areas.hu_P63A.stdarea, 'ok')

% dREP325
bar(5, dna_areas.dREP325.area, 'FaceColor', colors('goldenrod'))
errorbar(5, dna_areas.dREP325.area, dna_areas.dREP325.stdarea, 'ok')

% rif
bar(6, dna_areas.hu_rif.area, 'FaceColor', colors('lava'))
errorbar(6, dna_areas.hu_rif.area, dna_areas.hu_rif.stdarea, 'ok')

% chlor 
bar(7, dna_areas.hu_chlor.area, 'FaceColor', colors('dollar bill'))
errorbar(7, dna_areas.hu_chlor.area, dna_areas.hu_chlor.stdarea, 'ok')

% dhupB hupA
bar(8, dna_areas.dhupB_huPCh.area, 'FaceColor', colors('olive'))
errorbar(8, dna_areas.dhupB_huPCh.area, dna_areas.dhupB_huPCh.stdarea, 'ok')

% dhupB P63A
bar(9, dna_areas.dhupB_P63A.area, 'FaceColor', colors('dark lavender'))
errorbar(9, dna_areas.dhupB_P63A.area, dna_areas.dhupB_P63A.stdarea, 'ok')

% dhupB triKA
bar(10, dna_areas.dhupB_triKA.area, 'FaceColor', colors('carnation pink'))
errorbar(10, dna_areas.dhupB_triKA.area, dna_areas.dhupB_triKA.stdarea, 'ok')

% dhupA
bar(11, dna_areas.dhupA.area, 'FaceColor', colors('otter brown'))
errorbar(11, dna_areas.dhupA.area, dna_areas.dhupA.stdarea, 'ok')

% dhupA dhupB
bar(12, dna_areas.dhupA_dhupB.area, 'FaceColor', colors('teal'))
errorbar(12, dna_areas.dhupA_dhupB.area, dna_areas.dhupA_dhupB.stdarea, 'ok')

axis([0.5 12.5 0 3.2])
set(gca, 'FontSize', 18, 'FontName', 'Helvetica', 'XTick', [], 'XTickLabel', {})
ylabel('nucleoid area (\mum^2)', 'FontSize', 18, 'FontName', 'Helvetica')

%%

% make a matrix of the means

allmeans = zeros(100, 12);

allmeans(:,1) = dna_areas.MG1655.means;
group{1} = 'MG1655';
allmeans(:,2) = dna_areas.hu_ezrdm.means;
group{2} = 'EZRDM';
allmeans(:,3) = dna_areas.hu_triKA.means;
group{3} = 'triKA';
allmeans(:,4) = dna_areas.hu_P63A.means;
group{4} = 'huP63A';
allmeans(:,5) = dna_areas.dhupB_huPCh.means;
group{5} = 'dhupB_huPCh';
allmeans(:,6) = dna_areas.dhupB_triKA.means;
group{6} = 'dhupB_triKA';
allmeans(:,7) = dna_areas.dhupB_P63A.means;
group{7} = 'dhupB_P63A';
allmeans(:,8) = dna_areas.dREP325.means;
group{8} = 'dREP325';
allmeans(:,9) = dna_areas.hu_rif.means;
group{9} = 'hu_rif';
allmeans(:,10) = dna_areas.hu_chlor.means;
group{10} = 'hu_chlor';
allmeans(:,11) = dna_areas.dhupA.means;
group{11} = 'dhupA';
allmeans(:,12) = dna_areas.dhupA_dhupB.means;
group{12} = 'dhupB_dhupA';

% for ii = 1:length(allvars)
%     varname = strsplit(allvars{ii}, '_cropped_avg_cell');
%     varname = varname{1};
%     group{ii} = varname;
%     allmeans(:,ii) = dna_areas.(varname).means;
% end

[p,tbl,stats] = anova1(allmeans, group);

mstats = multcompare(stats);

ptbl = zeros(12,12);

for idx = 1:size(mstats,1)
    ii = mstats(idx,1);
    jj = mstats(idx,2);
    pval = mstats(idx,6);
    ptbl(ii,jj) = pval;
    ptbl(jj,ii) = pval;
end

for ii = 1:12
    ptbl(ii,ii) = 1;
end

%%
% what about comparing the profiles...? i think that might be too
% difficult?