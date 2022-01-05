function [BB, mask] = seg3(img)
    [mask, BB] = dip_find_cap(img);

    mask = logical(mask);
    BB = uint16(BB);
end



function [filter,box_edges] = dip_find_cap(img)
img = dip_normalize_rgb_img(img);
[cap_h, cap_s, cap_v] = dip_rgb2hsv(img(:,:,1), img(:,:,2), img(:,:,3));
cap_h_filt = zeros(size(cap_h));
cap_s_filt = zeros(size(cap_s));
cap_v_filt = zeros(size(cap_v));
cap_h_filt((cap_h >= 0.75) & (cap_h <= 1)) = 1;
cap_s_filt((cap_s >= 0.7) & (cap_s <= 1)) = 1;
cap_v_filt((cap_v >= 0) & (cap_v < 1)) = 1;

filter = cap_h_filt .* cap_s_filt .* cap_v_filt;
filter = medfilt2(filter, [3 3]);
filter = medfilt2(filter, [3 3]);



[x,y] = meshgrid(1:size(filter,2), 1:size(filter,1));
min_x = min(x(filter == 1));
max_x = max(x(filter == 1));
min_y = min(y(filter == 1));
max_y = max(y(filter == 1));


box_edges = [min_x min_y max_x-min_x max_y-min_y];


end

function [h, s, v] = dip_rgb2hsv(r, g, b)
%according to the equations stated in:
% https://www.rapidtables.com/convert/color/rgb-to-hsv.html
[C_max, I_max] = max(cat(3, r, g, b), [], 3);
C_min = min(cat(3, r, g, b), [], 3);
delta = C_max - C_min;
mask = (C_max ~= 0);
s = zeros(size(C_max));
s(mask) = delta(mask) ./ C_max(mask);
s(isnan(s)) = 0;

h = zeros(size(C_max));
r_mask = (I_max == 1);
h(r_mask) = mod( (g(r_mask)-b(r_mask)) ./ (delta(r_mask)), 6);
g_mask = (I_max == 2);
h(g_mask) =  2 + ((b(g_mask)-r(g_mask)) ./ (delta(g_mask)));
b_mask = (I_max == 3);
h(b_mask) =  4 + ((r(b_mask)-g(b_mask)) ./ (delta(b_mask)));
h(isnan(h)) = 0;
h = h/6;
v = C_max;
end

function [norm_img, r, g, b] = dip_normalize_rgb_img(rgb_img)
r = dip_normalize_img(rgb_img(:,:,1));
g = dip_normalize_img(rgb_img(:,:,2));
b = dip_normalize_img(rgb_img(:,:,3));
norm_img = cat(3, r, g, b);
end

function [norm_img] = dip_normalize_img(img)
%normalize according to the equation given in the ex1 pdf
norm_img = (img - min(img(:)))./ (max(img(:)) - min(img(:)));
end
