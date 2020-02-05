


function values = fwhm_image(image_matrix)

wid = findwid(image_matrix);
len = findlen(image_matrix);

    function len = findlen(image_matrix)

        len_width = size(image_matrix);

        length_index = find(len_width==max(len_width));
        width_index = find(len_width==min(len_width));

        len_profile = mean(image_matrix, width_index);
        len_coords = 0.04*(1:length(len_profile));

        %wid_profile = mean(image_matrix, length_index);
        %wid_coords = 0.04*(1:length(wid_profile));

        len = fwhm(len_coords, len_profile);
        %wid = fwhm(wid_coords, wid_profile);
    end

function wid = findwid(image_matrix)

        len_width = size(image_matrix);

        length_index = find(len_width==max(len_width));
        width_index = find(len_width==min(len_width));

        %len_profile = mean(image_matrix, width_index);
        %len_coords = 0.04*(1:length(len_profile));

        wid_profile = mean(image_matrix, length_index);
        wid_coords = 0.04*(1:length(wid_profile));

        %len = fwhm(len_coords, len_profile);
        wid = fwhm(wid_coords, wid_profile);
end

bootlens = [];
while isempty(bootlens)
    try
        bootlens = bootstrp(100, @findlen, image_matrix);
        stdlen = std(bootlens(~isnan(bootlens)));
    catch
    end
end
bootwids = [];
while isempty(bootwids)
    try
    bootwids = bootstrp(100, @findwid, image_matrix);
    stdwid = std(bootwids(~isnan(bootwids)));
    catch
        disp('farts')
    end
end

values.len = len;
values.wid = wid;
values.sem_len = stdlen/100;
values.sem_wid = stdwid/100;

end