function [BB, mask] = seg2(img)
    img_red = img(:,:,1);
%     figure; imshow(img);
    img_gr = rgb2gray(img);
%     img_bw = edge(img_gr);
    sub_img = img_red - img_gr;
    sub_img=medfilt2(sub_img,[13,13]);
    BB = zeros(1,4, 'uint16');
    mask = imbinarize(sub_img, 'adaptive');
    image_morph=bwareaopen(mask,300);
    

%     figure; imshow(image_morph);
    
    stats = regionprops('table',image_morph,'Centroid','MajorAxisLength','MinorAxisLength', 'BoundingBox', 'FilledImage');
    centers = stats.Centroid;
    diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    radii = diameters/2;
    [max_rad,i] = max(radii);
    BB = stats.BoundingBox(i, :);
    
    BB = uint16(BB);
    mask = zeros(size(img_gr), 'logical');
    filled_img = stats.FilledImage(i);
    filled_img = filled_img{1, 1};
    [w, h] = size(filled_img);
    mask(BB(2):BB(2)+w-1, BB(1):BB(1)+h-1) = filled_img;
    BB = uint16(BB);

end