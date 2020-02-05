function  plot_nucleoid_image2(prot_coords, image_matrix, dna_pxSize, FontSize, LUT)

%[xx yy] = meshgrid(size(image_matrix,2), size(image_matrix,1));

xx = -2050:100:2050;
yy = -800:100:800;
test = hist3(prot_coords*1000, 'edges', {xx,yy});

test2 = imresize(image_matrix, dna_pxSize/100);
test2 = test2';
addx = ceil(abs(size(test2,2)-size(test,2))/2);
addy = ceil(abs(size(test2,1)-size(test,1))/2);
test3 = padarray(test2, [addy, addx], 'both');

%test3 = test3(1:size(test,1), 1:size(test,2));
dna_rescaled = test3*max(max(test));
testx = -(size(dna_rescaled,1)/2)*100+50:100:(size(dna_rescaled,1)/2)*100-50;
testy = -(size(dna_rescaled,2)/2)*100+50:100:(size(dna_rescaled,2)/2)*100-50;
surf(testx, testy, dna_rescaled')
colormap(LUT)
set(gcf, 'renderer', 'opengl');
set(get(gca,'child'), 'FaceColor', 'flat', 'CDataMode', 'auto','edgecolor','none');
view(2)
axis equal
grid off
colorbar
daspect ([1 1 1]);
axis([-2000 2000 -750 750])
set(gca,'FontSize',FontSize,'FontName', 'Arial')
NumTicks = 3;
set(gca,'YTick',linspace(-750,750,NumTicks))
NumTicks = 5;
set(gca,'XTick',linspace(-2000,2000,NumTicks))
xlabel('distance (nm)') % x-axis label
ylabel('distance (nm)') % y-axis label



end