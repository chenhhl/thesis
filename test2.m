IM1=imread('C:\Users\Holly Chen\Dropbox (MIT)\MIT_Group_HollyChen\Holly_vein_project\Raw_Img\112619\whole850.tif');
IM2=imread('C:\Users\Holly Chen\Dropbox (MIT)\MIT_Group_HollyChen\Holly_vein_project\Raw_Img\112619\whole940.tif');
% IM3=imread('C:\Users\Holly Chen\Dropbox (MIT)\MIT_Group_HollyChen\Holly_vein_project\Raw_Img\alex_0430218.tiff');

% look at images
% imshow(IM1);
imshowpair(IM1,IM2,'montage');

% crop image
% imshowpair(IM1,IM2);
imshow(IM1);
mask1=getrect();
imshow(IM2);
mask2 = getrect();
im1 = imcrop(IM1, mask1);
im2 = imcrop(IM2, mask2);
imshowpair(im1, im2,'montage');

[D,moving_reg] = imregdemons(im1,im2);

% segment out vessels
% options: find features (MATLAB builtin), thresholding by intensity value

figure;
im1thresh = im1;
im1thresh(im1thresh >115) = 0;
im1thresh(im1thresh <50) = 0;
imshow(im1thresh)

imshowpair(im1, imadjust(im1), 'montage')

imagesc(IM3)
max(max(IM3))

figure;
[~,threshold] = edge(vein,'sobel');
fudgeFactor = 0.5;
BWs = edge(vein,'sobel',threshold * fudgeFactor);
imshowpair(BWs, vein);

figure;
[~,threshold2] = edge(amb,'sobel');
fudgeFactor = 0.5;
BWs2 = edge(amb,'sobel',threshold2 * fudgeFactor);
imshowpair(BWs2, amb);


%%
imshowpair(IM3, IM3)

im2_imadjust = imadjust(im2);
im2_histeq = histeq(im2);
im2_adapthisteq = adapthisteq(im2);
montage({im2,im2_imadjust,im2_histeq,im2_adapthisteq},'Size',[1 4])
title("Original Image and Enhanced Images using imadjust, histeq, and adapthisteq")

    img = im4;
    sigma1 = 1;
    sigma2 = 50;
%     k = 15;
    
    %Process Image with DoG
%     gauss1 = fspecial('gaussian', round([k*sigma1 k*sigma1]), sigma1);
%     gauss2 = fspecial('gaussian', round([k*sigma2 k*sigma2]), sigma2);
    blur1 = imgaussfilt(double(img),sigma1);
    blur2 = imgaussfilt(double(img),sigma2);
    dogImg = blur1 - blur2;
%     imshow(uint8(dogImg))
%     figure;
%     subplot(3,1,1);
%     imagesc(dogImg); colorbar()
%     subplot(3,1,2);
    imshowpair(dogImg, dogImg)
    % Filtering to get rid of speckle noise and clean image
    
    Final = medfilt2(dogImg,[4 4]);
%     Final = medfilt2(dogImg,'indexed');
    Final = imbinarize(Final,'adaptive','ForegroundPolarity','dark','Sensitivity',.1);
    Final = bwmorph(Final,'majority');
%     Final = medfilt2(dogImg,'indexed');
    Final = medfilt2(Final,[10 10]);
%     subplot(3,1,3);
    imshowpair(Final, Final)
    
    figure;
    FinalComplement = imcomplement(Final);
    imshow(bwmorph(FinalComplement, 'skel', Inf))
    
    J = imerode(FinalComplement, strel('square',4));
    
    