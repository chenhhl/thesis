IM1=imread('C:\Users\Holly Chen\Dropbox (MIT)\MIT_Group_HollyChen\Holly_vein_project\Raw_Img\alex_112119.tif');
IM2=imread('C:\Users\Holly Chen\Dropbox (MIT)\MIT_Group_HollyChen\Holly_vein_project\Raw_Img\alex2_112119.tif');
IM3=imread('C:\Users\Holly Chen\Dropbox (MIT)\MIT_Group_HollyChen\Holly_vein_project\Raw_Img\alex_0430218.tiff');

% look at images
imshow(IM1);
imshowpair(IM1,IM2,'montage');

% crop image
imshowpair(IM1,IM2);
mask = getrect();
im1 = imcrop(IM1, mask);
im2 = imcrop(IM2, mask);
imshowpair(im1, im2);

[D,moving_reg] = imregdemons(im1,im2);

% segment out vessels
% options: find features (MATLAB builtin), thresholding by intensity value

im1thresh = im1;
im1thresh(im1thresh >68) = 0;
im1thresh(im1thresh <61) = 0;
imshow(im1thresh)

imshowpair(im1, imadjust(im1), 'montage')

imagesc(IM3)
max(max(IM3))
%%
imshowpair(IM3, IM3)

%%
    img = im1;
    sigma1 = 1;
    sigma2 = 10;
%     k = 15;
    
    %Process Image with DoG
%     gauss1 = fspecial('gaussian', round([k*sigma1 k*sigma1]), sigma1);
%     gauss2 = fspecial('gaussian', round([k*sigma2 k*sigma2]), sigma2);
    blur1 = imgaussfilt(double(img),sigma1);
    blur2 = imgaussfilt(double(img),sigma2);
    dogImg = blur1 - blur2;
%     imshow(uint8(dogImg))
    imagesc(dogImg); colorbar()
    imshowpair(dogImg, dogImg)
    % Filtering to get rid of speckle noise and clean image
    
    Final = medfilt2(dogImg,[4 4]);
    Final = imbinarize(Final,'adaptive','ForegroundPolarity','dark','Sensitivity',.001);
    Final = bwmorph(Final,'majority');
    Final = medfilt2(Final,[15 10]);
    imshowpair(Final, Final)
    
    FinalComplement = imcomplement(Final);
    imshow(bwmorph(FinalComplement, 'skel', Inf))
    
    J = imerode(FinalComplement, strel('square',4));
    
    